/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

/**
 * The layers in json are parsed into Layer objects by LayerParser.
 */
public class LayerParser {

    private static let LAYERS_EF_TY_BLUR: Int64 = 29
    private static let LAYERS_EF_TY_DROPSHADOW: Int64 = 25

    private static let NAMES: Array<String> = [
        "nm",     // 0   // Layer name
        "ind",    // 1   // The ID of the layer is unique
        "refId",  // 2   // Referenced resource, picture/pre-compositing layer
        "ty",     // 3   // Layer type
        "parent", // 4   //
        "sw",     // 5   // Layer width
        "sh",     // 6   // Altitude
        "sc",     // 7   // colour
        "ks",     // 8   // Transform. Corresponding to the transform Settings in AE
        "tt",     // 9
        "masksProperties",       // 10   // mask list
        "shapes", // 11   // Shape layer
        "t",      // 12
        "ef",     // 13   // List of special effects
        "sr",     // 14
        "st",     // 15   // List of special effects
        "w",      // 16
        "h",      // 17
        "ip",     // 18   // This layer starts the keyframe
        "op",     // 19   // This layer ends the keyframe
        "tm",     // 20
        "cl",     // 21   // Suffix, such as.png
        "hd",     // 22
        "ao",     // 23   // Automatic tracking or not
        "bm"      // 24   // Mixed mode
    ]

    private static let TEXT_NAMES: Array<String> = [
        "d",
        "a"
    ]

    private static let EFFECTS_NAMES: Array<String> = [
        "ty",
        "nm"
    ]

    public static func parse(reader: JsonValue, composition: AnimationData): Layer {

        var layerName: String = "UNSET"
        var layerType: Int64 = 0
        var refId: String = ""
        var layerId: Int64 = 0
        var solidWidth: Int64 = 0
        var solidHeight: Int64 = 0

        var solidColor: String = "UNSET"
        var preCompWidth: Float64 = 0.0
        var preCompHeight: Float64 = 0.0
        var parentId: Int64 = -1
        var timeStretch: Float64 = 1.0
        var startFrame: Float64 = 0.0
        var inFrame: Float64 = 0.0
        var outFrame: Float64 = 0.0
        var cl: String = ""
        var hidden: Bool = false

        let ef: ArrayList<LayerEF> = ArrayList<LayerEF>()

        var autoOrient: Int64 = 0
        var matteType: Int64 = 0
        var blendMode: Int64 = 0
        var transform: AnimatableTransform = AnimatableTransform()

        /* "layers"."t" */
        var t: LayerT = LayerT()

        var timeRemapping: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

        var masks: ArrayList<Mask> = ArrayList<Mask>()
        var shapes: ArrayList<ContentModel> = ArrayList<ContentModel>()

        let jo: JsonObject = reader.asObject()

        if (jo.containsKey(NAMES[0])) {
            layerName = jo[NAMES[0]].asString().getValue()
        }
        if (jo.containsKey(NAMES[1])) {
            layerId = jo[NAMES[1]].asInt().getValue()
        }
        if (jo.containsKey(NAMES[2])) {
            refId = jo[NAMES[2]].asString().getValue()
        }
        if (jo.containsKey(NAMES[3])) {
            layerType = jo[NAMES[3]].asInt().getValue()
        }
        if (jo.containsKey(NAMES[4])) {
            parentId = jo[NAMES[4]].asInt().getValue()
        }

        // Gets system/device pixel density => let scale: Float64 = Utils.dpScale()
        let scale: Float64 = SCALE_FEFAULT

        if (jo.containsKey(NAMES[5])) {
            solidWidth = jo[NAMES[5]].asInt().getValue() * Int64(scale)
        }
        if (jo.containsKey(NAMES[6])) {
            solidHeight = jo[NAMES[6]].asInt().getValue() * Int64(scale)
        }
        if (jo.containsKey(NAMES[7])) {
            solidColor = jo[NAMES[7]].asString().getValue()
        }

        /* Layer change, animation. */
        if (jo.containsKey(NAMES[8])) {
            let jsonObject: JsonObject = jo[NAMES[8]].asObject()
            transform = AnimatableTransformParser.parse(jsonObject, composition)
        }

        if (jo.containsKey(NAMES[9])) {
            matteType = jo[NAMES[9]].asInt().getValue()
        }

        /* Mask analysis */
        if (jo.containsKey(NAMES[10])) {
            let ja: JsonArray = jo[NAMES[10]].asArray()
            for (i in 0..ja.size()) {
                let jsonObject: JsonObject = ja[i].asObject()
                masks.append(MaskParser.parse(jsonObject, composition))
            }
        }

        if (jo.containsKey(NAMES[11])) {
            let ja: JsonArray = jo[NAMES[11]].asArray()
            for (i in 0..ja.size()) {
                let jsonObject: JsonObject = ja[i].asObject()
                let shape: ContentModel = ContentModelParser.parse(jsonObject, composition)
                if (shape.types != -1) {
                    shapes.append(shape)
                }
            }
        }

        if (jo.containsKey(NAMES[12])) { //"layers"."t"
            let jsonObject: JsonObject = jo[NAMES[12]].asObject()
            if (jsonObject.containsKey(TEXT_NAMES[0])) { //"d"
                let jv: JsonValue = jsonObject[TEXT_NAMES[0]]
                let tdk: ArrayList<Keyframe<DocumentData>> = AnimatableValueParser.parseDocumentData(jv, composition)
                t.d = LayerTD(tdk)
            }
            if (jsonObject.containsKey(TEXT_NAMES[1])) { //"a"
                let ja: JsonArray = jsonObject[TEXT_NAMES[1]].asArray()
                for (i in 0..ja.size()) {
                    let jo: JsonObject = ja[i].asObject()
                    let textProperties: AnimatableTextProperties = AnimatableTextPropertiesParser.parse(jo, composition)
                    t.a.append(AnimatableTextPropertiesA(textProperties))
                }
            }
        }

        if (jo.containsKey(NAMES[13])) { //"layers"."ef"
            let effectNames: ArrayList<String> = ArrayList<String>()
            let ja: JsonArray = jo[NAMES[13]].asArray()
            for (i in 0..ja.size()) {
                let effect: LayerEF = LayerEF()
                let jsonObject: JsonObject = ja[i].asObject()

                if (jsonObject.containsKey(EFFECTS_NAMES[0])) { //"ty"
                    let types: Int64 = jsonObject[EFFECTS_NAMES[0]].asInt().getValue()
                    effect.ty = types
                    if (types == LAYERS_EF_TY_BLUR) {
                        let blurEffect: ArrayList<BlurEffect> = BlurEffectParser.parse(jsonObject, composition)
                        effect.ef = blurEffect
                    } else if (types == LAYERS_EF_TY_DROPSHADOW) {
                        let dropShadowEffect: ArrayList<DropShadowEffect> = DropShadowEffectParser().parse(jsonObject, composition)
                        effect.ef = dropShadowEffect
                    }
                }
                if (jsonObject.containsKey(EFFECTS_NAMES[1])) { //"nm"
                    let effectName: String = jsonObject[EFFECTS_NAMES[1]].asString().getValue()
                    effect.nm = effectName
                    effectNames.append(effectName)
                }
                ef.append(effect)

                composition.addWarning("Lottie doesn't support layer effects. If you are using them for " +
                    " fills, strokes, trim paths etc. then try adding them directly as contents " +
                    " in your shape. Found: " + effectNames.toString())
            }
        }

        if (jo.containsKey(NAMES[14])) {
            timeStretch = jo[NAMES[14]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[15])) {
            startFrame = jo[NAMES[15]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[16])) {
            /* preCompWidth need * Utils.dpScale()) */
            preCompWidth = jo[NAMES[16]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[17])) {
            /* preCompHeight need * Utils.dpScale()) */
            preCompHeight = jo[NAMES[17]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[18])) {
            inFrame = jo[NAMES[18]].asFloat().getValue()
        }
        if (jo.containsKey(NAMES[19])) {
            outFrame = jo[NAMES[19]].asFloat().getValue()
        }

        if (jo.containsKey(NAMES[20])) {
            timeRemapping = AnimatableValueParser.parseFloat(jo[NAMES[20]], composition, false)
        }

        if (jo.containsKey(NAMES[21])) {
            cl = jo[NAMES[21]].asString().getValue()
        }
        if (jo.containsKey(NAMES[22])) {
            hidden = jo[NAMES[22]].asBool().getValue()
        }
        if (jo.containsKey(NAMES[23])) {
            autoOrient = jo[NAMES[23]].asInt().getValue()
        }

        if (jo.containsKey(NAMES[24])) {
            blendMode = jo[NAMES[24]].asInt().getValue()
        }

        let layer: Layer = Layer()
        layer.nm = layerName
        layer.ind = layerId
        layer.refId = refId
        layer.ty = layerType
        layer.parent = parentId
        layer.sw = solidWidth
        layer.sh = solidHeight
        layer.sc = solidColor
        layer.ks = transform
        layer.tt = matteType
        layer.masksProperties = masks
        layer.shapes = shapes
        layer.t = t
        layer.ef = ef
        layer.sr = timeStretch
        layer.st = startFrame
        layer.w = preCompWidth
        layer.h = preCompHeight
        layer.ip = inFrame
        layer.op = outFrame

        layer.tm = ContentModelDK(timeRemapping)

        layer.cl = cl
        layer.hd = hidden
        layer.ao = autoOrient
        layer.bm = blendMode
        return layer
    }

}
