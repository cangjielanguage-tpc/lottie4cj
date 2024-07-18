/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a LayerParser structure.
 */
package lottie4cj.parser

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
        "a",
        "m"
    ]

    private static let EFFECTS_NAMES: Array<String> = [
        "ty",
        "nm"
    ]

    /**
     * Animate the "layers" data in the json data, parsed and encapsulated into the corresponding Layer entity class.
     *
     * @param reader - Type of JsonValue, animate json data in "layers" data.
     * @return Type of Layer, an instance of the "layers" data that encapsulates the animation.
     */
    public static func parse(reader: JsonValue): Layer {

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

        var ef: Array<LayerEF> = Array<LayerEF>()

        var autoOrient: Int64 = 0
        var matteType: Int64 = 0
        var blendMode: Int64 = 0
        var transform: AnimatableTransform = AnimatableTransform()

        /* "layers"."t" */
        var t: LayerT = LayerT()

        var timeRemapping: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        var masks: Array<Mask> = Array<Mask>()
        var shapes: Array<ContentModel> = Array<ContentModel>()

        let jo: JsonObject = reader.asObject()

        if(let Some(v) <- jo.get(NAMES[0])) {
            layerName = v.asString().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[1])) {
            layerId = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[2])) {
            refId = v.asString().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[3])) {
            layerType = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[4])) {
            parentId = v.asInt().getValue()
        }

        if (let Some(v) <- jo.get(NAMES[5])) {
            solidWidth = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[6])) {
            solidHeight = v.asInt().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[7])) {
            solidColor = v.asString().getValue()
        }

        /* Layer change, animation. */
        if (let Some(v) <- jo.get(NAMES[8])) {
            let jsonObject: JsonObject = v.asObject()
            transform = AnimatableTransformParser.parse(jsonObject)
        }

        if (let Some(v) <- jo.get(NAMES[9])) {
            matteType = v.asInt().getValue()
        }

        /* Mask analysis */
        if (let Some(v) <- jo.get(NAMES[10])) {
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            if (len > 0) {
                let EMPTY_MASK: Mask = Mask()
                masks = Array<Mask>(len, item: EMPTY_MASK)
                for (i in 0..len) {
                    let jsonObject: JsonObject = ja[i].asObject()
                    masks[i] = MaskParser.parse(jsonObject)
                }
            }
        }

        if (let Some(v) <- jo.get(NAMES[11])) {
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            let EMPTY_CM: ContentModel = ContentModel()
            shapes = Array<ContentModel>(len, item: EMPTY_CM)
            for (i in 0..len) {
                let jsonObject: JsonObject = ja[i].asObject()
                let shape: ContentModel = ContentModelParser.parse(jsonObject)
                if (shape.types != -1) {
                    shapes[i] = shape
                }
            }
        }

        if (let Some(v) <- jo.get(NAMES[12])) { //"layers"."t"
            let jsonObject: JsonObject = v.asObject()
            var td: LayerTD = LayerTD()
            var tda: Array<AnimatableTextPropertiesA> = Array<AnimatableTextPropertiesA>()
            var tm: LayerTM = LayerTM()
            if (let Some(k) <- jsonObject.get(TEXT_NAMES[0])) { //"d"
                let tdk: Array<Keyframe<DocumentData>> = AnimatableValueParser.parseDocumentData(k)
                td = LayerTD(k: tdk)
            }
            if (let Some(k) <- jsonObject.get(TEXT_NAMES[1])) { //"a"
                let ja: JsonArray = k.asArray()
                let len: Int64 = ja.size()
                if (len > 0) {
                    let EMPTY_ATPA: AnimatableTextPropertiesA = AnimatableTextPropertiesA()
                    let a: Array<AnimatableTextPropertiesA> = Array<AnimatableTextPropertiesA>(len, item: EMPTY_ATPA)
                    for (i in 0..len) {
                        let jo: JsonObject = ja[i].asObject()
                        a[i] = AnimatableTextPropertiesParser.parse(jo)
                    }
                    tda = a
                }
            }

            if (let Some(k) <- jsonObject.get(TEXT_NAMES[2])) { //"m"
                let jsonObject: JsonObject = k.asObject()
                tm = handleLayerTMA(jsonObject)
            }

            t = LayerT(d: td, a: tda, m: tm)
        }

        if (let Some(v) <- jo.get(NAMES[13])) { //"layers"."ef"
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            if (len > 0) {
                let effectNames: Array<String> = Array<String>(len, item: "")
                let EMPTY_ARRAY_EFFECT: Array<Effect> = Array<Effect>()
                ef = Array<LayerEF>(len, item: LayerEF(0, "", EMPTY_ARRAY_EFFECT))
                for (i in 0..len) {
                    var ty: Int64 = 0
                    var nm: String = ""
                    var effects: Array<Effect> = EMPTY_ARRAY_EFFECT

                    let jsonObject: JsonObject = ja[i].asObject()
                    if (let Some(k) <- jsonObject.get(EFFECTS_NAMES[0])) { //"ty"
                        let ty: Int64 = k.asInt().getValue()
                        if (ty == LAYERS_EF_TY_BLUR) {
                            let blurEffect: Array<Effect> = BlurEffectParser.parse(jsonObject)
                            effects = blurEffect
                        } else if (ty == LAYERS_EF_TY_DROPSHADOW) {
                            let dropShadowEffect: Array<Effect> = DropShadowEffectParser().parse(jsonObject)
                            effects = dropShadowEffect
                        }
                    }
                    if (let Some(k) <- jsonObject.get(EFFECTS_NAMES[1])) { //"nm"
                        let effectName: String = k.asString().getValue()
                        nm = effectName
                        effectNames[i] = effectName
                    }
                    ef[i] = LayerEF(ty, nm, effects)

                    logger.log(LogLevel.INFO, "Lottie doesn't support layer effects. If you are using them for " +
                        " fills, strokes, trim paths etc. then try adding them directly as contents " +
                        " in your shape. Found: " + effectNames.toString())
                }
            }
        }

        if (let Some(v) <- jo.get(NAMES[14])) {
            timeStretch = v.asFloat().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[15])) {
            startFrame = v.asFloat().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[16])) {
            /* preCompWidth need * Utils.dpScale()) */
            preCompWidth = v.asFloat().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[17])) {
            /* preCompHeight need * Utils.dpScale()) */
            preCompHeight = v.asFloat().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[18])) {
            inFrame = v.asFloat().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[19])) {
            outFrame = v.asFloat().getValue()
        }

        if (let Some(v) <- jo.get(NAMES[20])) {
            timeRemapping = AnimatableValueParser.parseFloat(v)
        }

        if (let Some(v) <- jo.get(NAMES[21])) {
            cl = v.asString().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[22])) {
            hidden = v.asBool().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[23])) {
            autoOrient = v.asInt().getValue()
        }

        if (let Some(v) <- jo.get(NAMES[24])) {
            blendMode = v.asInt().getValue()
        }

        let layer: Layer = Layer(
            nm: layerName,
            ind: layerId,
            refId: refId,
            ty: layerType,
            parent: parentId,
            sw: solidWidth,
            sh: solidHeight,
            sc: solidColor,
            ks: transform,
            tt: matteType,
            masksProperties: masks,
            shapes: shapes,
            t: t,
            ef: ef,
            sr: timeStretch,
            st: startFrame,
            w: preCompWidth,
            h: preCompHeight,
            ip: inFrame,
            op: outFrame,
            tm: ContentModelDK(k: timeRemapping),
            cl: cl,
            hd: hidden,
            ao: autoOrient,
            bm: blendMode
        )
        return layer
    }

    private static let TEXT_TM_NAMES: Array<String> = [
        "g",
        "a"
    ]

    private static let TEXT_TM_A_NAMES: Array<String> = [
        "a",
        "k",
        "ix"
    ]

    //layer.t.m
    private static func handleLayerTMA(reader: JsonObject): LayerTM {
        var g: Int64 = 0
        if (let Some(v) <- reader.get(TEXT_TM_NAMES[0])) { //"g"
            g = v.asInt().getValue()
        }
        var a: Int64 = 0
        var k: Array<Int64> = Array<Int64>()
        var ix: Int64 = 0
        if (let Some(v) <- reader.get(TEXT_TM_NAMES[1])) { //"a"
            let jo: JsonObject = v.asObject()
            if (let Some(val) <- jo.get(TEXT_TM_A_NAMES[0])) { //"a"
                a = val.asInt().getValue()
            }
            if (let Some(val) <- jo.get(TEXT_TM_A_NAMES[1])) { //"k"
                let ja: JsonArray = val.asArray()
                let len: Int64 = ja.size()
                if (len > 0) {
                    k = Array<Int64>(len, item: 0)
                    for (i in 0..len) {
                        k[i] = ja[i].asInt().getValue()
                    }
                }
            }
            if (let Some(k) <- jo.get(TEXT_TM_A_NAMES[2])) { //"ix"
                ix = k.asInt().getValue()
            }
        }
        let tma: LayerTMA = LayerTMA(a: a, k: k, ix: ix)
        let m: LayerTM = LayerTM(g: g, a: tma)
        return m
    }

}
