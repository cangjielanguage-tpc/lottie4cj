/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ValueParser structure.
 */
package lottie.parser

internal import ohos.base.Color

public interface ValueParser<T> {
    func parse(reader: JsonValue): T
}

public class IntegerParser <: ValueParser<Int64> {

    /**
     * Get IntegerParser instance.
     *
     * @return IntegerParser instance.
     */
    public static let INSTANCE: IntegerParser = IntegerParser()

    private init() {}

    /**
     * Animate the specified data in the json data, parsed to a numerical value.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Int64. Parse as a numerical value.
     */
    @OverflowWrapping
    public func parse(reader: JsonValue): Int64 {
        return Int64(round(JsonUtils.valueFromObject(reader)))
    }
}

public class FloatParser <: ValueParser<Float64> {

    /**
     * Get FloatParser instance.
     *
     * @return FloatParser instance.
     */
    public static let INSTANCE: FloatParser = FloatParser()

    private init() {}

    /**
     * Animate the specified data in the json data, parsed to a numerical value.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Float64. Parse as a numerical value.
     */
    public func parse(reader: JsonValue): Float64 {
        return JsonUtils.valueFromObject(reader)
    }
}

public class ArrayFloat64Parser <: ValueParser<Array<Float64>> {

    /**
     * Get ArrayFloat64Parser instance.
     *
     * @return ArrayFloat64Parser instance.
     */
    public static let INSTANCE: ArrayFloat64Parser = ArrayFloat64Parser()
    init(){}

    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonValue): Array<Float64> {

        let jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray)) {
            let ja: JsonArray = reader.asArray()
            let len: Int64 = ja.size()
            let res: Array<Float64> = Array<Float64>(len, item: 0.0)
            for (i in 0..len) {
                res[i] = ja[i].asFloat().getValue()
            }
            return res
        } else {
            let res: Array<Float64> = Array<Float64>(1, item: 0.0)
            res[0] = reader.asFloat().getValue()
            return res
        }
    }
}

public class PointFParser <: ValueParser<PointF> {
    /**
     * Get PointFParser instance.
     *
     * @return PointFParser instance.
     */
    public static let INSTANCE: PointFParser = PointFParser()

    private PointFParser() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of PointF. The parsing is encapsulated in this entity class.
     */
    public func parse(reader: JsonValue): PointF {
        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray) || equalsJsonKind(jk, JsonKind.JsObject)) {
            return JsonUtils.jsonToPoint(reader)
        } else {
            throw IllegalArgumentException("Cannot convert json to point. Next token is not array and object.")
        }
    }
}

public class DocumentDataParser <: ValueParser<DocumentData> {

    /**
     * Get DocumentDataParser instance.
     *
     * @return DocumentDataParser instance.
     */
    public static let INSTANCE: DocumentDataParser = DocumentDataParser()

    //"layers"."t"."d"
    private static let NAMES: Array<String> = [
        "t",  // 0
        "f",  // 1
        "s",  // 2
        "j",  // 3
        "tr", // 4
        "lh", // 5
        "ls", // 6
        "fc", // 7
        "sc", // 8
        "sw", // 9
        "of", // 10
        "ps", // 11
        "sz"  // 12
    ]

    private init() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of DocumentData. The parsing is encapsulated in this entity class.
     */
    public func parse(jv: JsonValue): DocumentData {
        var text: String = ""
        var fontName: String = ""
        var size: Float64 = 0.0
        var justification: Int64 = 0
        var tracking: Int64 = 0
        var lineHeight: Float64 = 0.0
        var baselineShift: Float64 = 0.0

        var fillColor: Array<Float64> = Array<Float64>()
        var strokeColor: Array<Float64> = Array<Float64>()

        var strokeWidth: Float64 = 0.0
        var strokeOverFill: Bool = false

        //var boxPosition: PointF = PointF()
        //var boxSize: PointF = PointF()
        var boxPosition: Array<Float64> = Array<Float64>()
        var boxSize: Array<Float64> = Array<Float64>()

        let reader: JsonObject = jv.asObject()
        if (let Some(v) <- reader.get(NAMES[0])) { // "t"
            text = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[1])) { // "f"
            fontName = v.asString().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[2])) { // "s"
            size = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[3])) { // "j"
            justification = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[4])) { // "tr"
            tracking = v.asInt().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[5])) { // "lh"
            lineHeight = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[6])) { // "ls"
            baselineShift = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[7])) { // "fc"
            fillColor = JsonUtils.jsonToColor(v)
        }
        if (let Some(v) <- reader.get(NAMES[8])) { // "sc"
            strokeColor = JsonUtils.jsonToColor(v)
        }
        if (let Some(v) <- reader.get(NAMES[9])) { // "sw"
            strokeWidth = v.asFloat().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[10])) { // "of"
            strokeOverFill = v.asBool().getValue()
        }
        if (let Some(v) <- reader.get(NAMES[11])) { // "ps"
            let ja: JsonArray = v.asArray()
            //var x: Float64 = ja[0].asFloat().getValue()
            //var y: Float64 = ja[1].asFloat().getValue()
            //boxPosition = PointF(x: x, y: y)

            let len: Int64 = ja.size()
            boxPosition = Array<Float64>(len, item: 0.0)
            for(i in 0..len) {
                boxPosition[i] = ja[i].asFloat().getValue()
            }
        }
        if (let Some(v) <- reader.get(NAMES[12])) { // "sz"
            let ja: JsonArray = v.asArray()
            //var x: Float64 = ja[0].asFloat().getValue()
            //var y: Float64 = ja[1].asFloat().getValue()
            //boxSize = PointF(x: x, y: y)

            let len: Int64 = ja.size()
            boxSize = Array<Float64>(len, item: 0.0)
            for(i in 0..len) {
                boxSize[i] = ja[i].asFloat().getValue()
            }
        }

        let dd: DocumentData = DocumentData(
            t: text,
            f: fontName,
            s: size,
            j: justification,
            tr: tracking,
            lh: lineHeight,
            ls: baselineShift,
            fc: fillColor,
            sc: strokeColor,
            sw: strokeWidth,
            of: strokeOverFill,
            ps: boxPosition,
            sz: boxSize
        )
        return dd
    }
}

public class ShapeDataParser <: ValueParser<ShapeData> {

    /**
     * Get ShapeDataParser instance.
     *
     * @return ShapeDataParser instance.
     */
    public static let INSTANCE: ShapeDataParser = ShapeDataParser()

    //"layers"."shapes"."ks".k   <==  "layers"."shapes".{"ty": "sh"}
    private static let NAMES: Array<String> = [
        "c",   //0
        "v",   //1
        "i",   //2
        "o"    //3
    ]

    private init() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of ShapeData. The parsing is encapsulated in this entity class.
     */
    public func parse(reader: JsonValue): ShapeData {
        var closed: Bool = false
        var pointsArray: Array<PointF> = Array<PointF>()
        var inTangents: Array<PointF> = Array<PointF>()
        var outTangents: Array<PointF> = Array<PointF>()

        var hasv: Bool = false
        var hasi: Bool = false
        var haso: Bool = false

        let jo: JsonObject = reader.asObject()
        if (let Some(v) <- jo.get(NAMES[0])) { // "c"
            closed = v.asBool().getValue()
        }
        if (let Some(v) <- jo.get(NAMES[1])) { // "v"
            pointsArray = JsonUtils.jsonToPoints(v)
            hasv = true
        }
        if (let Some(v) <- jo.get(NAMES[2])) { // "i"
            inTangents = JsonUtils.jsonToPoints(v)
            hasi = true
        }
        if (let Some(v) <- jo.get(NAMES[3])) { // "o"
            outTangents = JsonUtils.jsonToPoints(v)
            haso = true
        }

        if (!hasv || !hasi || !haso) {
            throw IllegalArgumentException("Shape data was missing information.")
        }
        if (pointsArray.isEmpty()) {
            return ShapeData()
        }

        let sd: ShapeData = ShapeData(
            c: closed,
            v: pointsArray,
            i: inTangents,
            o: outTangents
        )
        return sd
    }
}

public class PathParser <: ValueParser<PointF> {

    /**
     * Get PathParser instance.
     *
     * @return PathParser instance.
     */
    public static let INSTANCE: PathParser = PathParser()
    private init() {}

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of PointF. The parsing is encapsulated in this entity class.
     */
    public func parse(reader: JsonValue): PointF {
        return JsonUtils.jsonToPoint(reader)
    }
}

public class ScaleXYParser <: ValueParser<Array<Float64>> {

    /**
     * Get ScaleXYParser instance.
     *
     * @return ScaleXYParser instance.
     */
    public static let INSTANCE: ScaleXYParser = ScaleXYParser()
    init(){}

    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonValue): Array<Float64> {
        let ja: JsonArray = reader.asArray()
        let len: Int64 = ja.size()
        let res: Array<Float64> = Array<Float64>(len, item: 0.0)

        for (i in 0..len) {
            res[i] = ja[i].asFloat().getValue()
        }
        return res
    }

}

public class ColorParser <: ValueParser<Array<Float64>> {

    /**
     * Get ColorParser instance.
     *
     * @return ColorParser instance.
     */
    public static let INSTANCE: ColorParser = ColorParser()

    private init() {}

    /**
     * Animate the specified data in the json data, parsed into an array.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Array<Float64>. Parse as an array.
     */
    public func parse(reader: JsonValue): Array<Float64> {
        let ja: JsonArray = reader.asArray()

        let res: Array<Float64> = Array<Float64>(4, item: 1.0)

        res[0] = ja[0].asFloat().getValue()
        res[1] = ja[1].asFloat().getValue()
        res[2] = ja[2].asFloat().getValue()

        if (ja.size() >= 4) {
            res[3] = ja[3].asFloat().getValue()
        }
        return res
    }

    /**
     * The specified data in the animated json data is parsed into the corresponding entity class.
     *
     * @param reader - Type of JsonValue. Specify data in the json data of the animation.
     * @return Type of Color. The parsing is encapsulated in this entity class.
     */
    @OverflowWrapping
    public func parseColor(reader: JsonValue): Color {
        let ja: JsonArray = reader.asArray()

        var r: Float64 = ja[0].asFloat().getValue()
        var g: Float64 = ja[1].asFloat().getValue()
        var b: Float64 = ja[2].asFloat().getValue()
        var a: Float64 = 1.0

        if (ja.size() >= 4) {
            a = ja[3].asFloat().getValue()
        }

        if (r <= 1.0 && g <= 1.0 && b <= 1.0) {
            r *= 255.0
            g *= 255.0
            b *= 255.0
            if (a <= 1.0) {
                a *= 255.0
            }
        }
        //return Color(Int64(a), Int64(r), Int64(g), Int64(b))
        return Color(UInt8(r), UInt8(g), UInt8(b), alpha: Float32(a))
    }
}
