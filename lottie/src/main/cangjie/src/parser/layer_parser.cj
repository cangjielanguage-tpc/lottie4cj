/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a LayerParser structure.
 */
package lottie.parser

/**
 * The layers in json are parsed into Layer objects by LayerParser.
 */
public class LayerParser {
    private static let LAYERS_EF_TY_BLUR: Int64 = 29
    private static let LAYERS_EF_TY_DROPSHADOW: Int64 = 25

    /**
     * Animate the "layers" data in the json data, parsed and encapsulated into the corresponding Layer entity class.
     *
     * @param reader - Type of JsonValue, animate json data in "layers" data.
     * @return Type of Layer, an instance of the "layers" data that encapsulates the animation.
     */
    public static func parse(reader: JsonReader): Layer {
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

        let ef = ArrayList<LayerEF>()

        var autoOrient: Int64 = 0
        var ddd: Int64 = 0
        var tdss: Int64 = 0
        var tpValue: Int64 = -1
        var matteType: Int64 = 0
        var blendMode: Int64 = 0
        var transform: AnimatableTransform = AnimatableTransform()

        /* "layers"."t" */
        var t: LayerT = LayerT()

        var timeRemapping: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()

        let masks = ArrayList<Mask>()
        let shapes = ArrayList<ContentModel>()

        var hasMask: Bool = false

        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "nm" => // 0   // Layer name
                    layerName = reader.readValue<String>()
                case "ind" => // 1   // The ID of the layer is unique
                    layerId = reader.readValue<Int64>()
                case "refId" => // 2   // Referenced resource, picture/pre-compositing layer
                    refId = reader.readValue<String>()
                case "ty" => // 3   // Layer type
                    layerType = reader.readValue<Int64>()
                case "parent" => // 4   //
                    parentId = reader.readValue<Int64>()
                case "sw" => // 5   // Layer width
                    solidWidth = reader.readValue<Int64>()
                case "sh" => // 6   // Altitude
                    solidHeight = reader.readValue<Int64>()
                case "sc" => // 7   // colour
                    solidColor = reader.readValue<String>()
                case "ks" => // 8   // Transform. Corresponding to the transform Settings in AE
                    transform = AnimatableTransformParser.parse(reader, "ks")
                case "tt" => // 9
                    matteType = reader.readValue<Int64>()
                case "masksProperties" => // 10   // mask list
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        masks.append(MaskParser.parse(reader))
                    }
                    reader.endArray()
                case "shapes" => // 11   // Shape layer
                    reader.startArray()
                    while (reader.peek() != EndArray) {
                        shapes.append(ContentModelParser.parse(reader))
                    }
                    reader.endArray()
                case "t" => // 12
                    reader.startObject()
                    var td: LayerTD = LayerTD()
                    var tda = ArrayList<AnimatableTextPropertiesA>()
                    var tm: LayerTM = LayerTM()
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "d" =>
                                let tdk: Array<Keyframe<DocumentData>> = AnimatableValueParser.parseDocumentData(reader)
                                td = LayerTD(k: tdk)
                            case "a" =>
                                reader.startArray()
                                while (reader.peek() != EndArray) {
                                    tda.append(AnimatableTextPropertiesParser.parse(reader))
                                }
                                reader.endArray()
                            case "m" => tm = handleLayerTMA(reader)
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                    t = LayerT(d: td, a: tda.toArray(), m: tm)
                case "ef" => // 13   // List of special effects
                    let effectNames = ArrayList<String>()
                    reader.startArray()

                    while (reader.peek() != EndArray) {
                        var effects: Array<Effect> = Array<Effect>()
                        var nm: String = ""
                        var mnStr: String = ""
                        var npNum: Int64 = 0
                        var enNum: Int64 = 0
                        var ixNum: Int64 = 0
                        var ty: Int64 = 0

                        reader.startObject()
                        while (reader.peek() != EndObject) {
                            match (reader.readName()) {
                                case "ty" =>
                                    ty = reader.readValue<Int64>()
                                    if (ty == LAYERS_EF_TY_BLUR) {
                                        let blurEffect: Array<Effect> = BlurEffectParser.parse(reader)
                                        effects = blurEffect
                                    } else if (ty == LAYERS_EF_TY_DROPSHADOW) {
                                        let dropShadowEffect: Array<Effect> = DropShadowEffectParser().parse(reader)
                                        effects = dropShadowEffect
                                    }
                                case "nm" =>
                                    nm = reader.readValue<String>()
                                    effectNames.append(nm)
                                case "mn" => mnStr = reader.readValue<String>()
                                case "np" => npNum = reader.readValue<Int64>()
                                case "en" => enNum = reader.readValue<Int64>()
                                case "ix" => ixNum = reader.readValue<Int64>()

                                case _ => reader.skip()
                            }
                        }
                        reader.endObject()
                        var layef = LayerEF(ty, nm, effects)
                        layef.mn = mnStr
                        layef.np = npNum
                        layef.en = enNum
                        layef.ix = ixNum
                        ef.append(layef)
                    }
                    reader.endArray()
                case "sr" => timeStretch = reader.readValue<Float64>()
                case "st" => startFrame = reader.readValue<Float64>()
                case "w" => //16
                    preCompWidth = reader.readValue<Float64>()
                case "h" => // 17
                    preCompHeight = reader.readValue<Float64>()
                case "ip" => // 18
                    inFrame = reader.readValue<Float64>()
                case "op" => // 19
                    outFrame = reader.readValue<Float64>()
                case "tm" => // 20
                    timeRemapping = AnimatableValueParser.parseFloat(reader)
                case "cl" => // 21
                    cl = reader.readValue<String>()
                case "hd" => // 22
                    hidden = reader.readValue<Bool>()
                case "ao" => // 23
                    autoOrient = reader.readValue<Int64>()
                case "bm" => // 24
                    blendMode = reader.readValue<Int64>()
                case "hasMask" => // 25
                    hasMask = reader.readValue<Bool>()
                case "ddd" => // 26
                    ddd = reader.readValue<Int64>()
                case "tp" => //27
                    tpValue = reader.readValue<Int64>()
                case "td" => //28
                    tdss = reader.readValue<Int64>()
                case v => reader.skip()
            }
        }

        reader.endObject()

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
            masksProperties: masks.toArray(),
            shapes: shapes,
            t: t,
            ef: ef.toArray(),
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
            bm: blendMode,
            hasMask: hasMask,
            ddd: ddd,
            td: tdss
        )
        layer.tp = tpValue
        return layer
    }

    //layer.t.m
    private static func handleLayerTMA(reader: JsonReader): LayerTM {
        var g: Int64 = 0
        var a: Int64 = 0
        let k = ArrayList<Int64>()
        var ix: Int64 = 0
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "g" => g = reader.readValue<Int64>()
                case "a" =>
                    reader.startObject()
                    while (reader.peek() != EndObject) {
                        match (reader.readName()) {
                            case "a" => a = reader.readValue<Int64>()
                            case "k" =>
                                reader.startArray()
                                while (reader.peek() != EndArray) {
                                    k.append(reader.readValue<Int64>())
                                }
                                reader.endArray()
                            case "ix" => ix = reader.readValue<Int64>()
                            case _ => reader.skip()
                        }
                    }
                    reader.endObject()
                case _ => reader.skip()
            }
        }
        reader.endObject()
        let tma: LayerTMA = LayerTMA(a: a, k: k.toArray(), ix: ix)
        return LayerTM(g: g, a: tma)
    }
}
