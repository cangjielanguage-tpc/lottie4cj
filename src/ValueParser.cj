/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file
 * The file declars the LottiePlayer class.
 */
package lottie4cj

public interface ValueParser<T> {
    func parse(reader: JsonValue, scale: Float64): T
}

public class IntegerParser <: ValueParser<Int64> {
    public static let INSTANCE: IntegerParser = IntegerParser()

    private init() {}

    @OverflowWrapping
    public func parse(reader: JsonValue, scale: Float64): Int64 {
        return Int64(round(JsonUtils.valueFromObject(reader) * scale))
    }
}

public class FloatParser <: ValueParser<Float64> {
    public static let INSTANCE: FloatParser = FloatParser()

    private init() {}

    public func parse(reader: JsonValue, scale: Float64): Float64 {
        return JsonUtils.valueFromObject(reader) * scale
    }
}

public class PointFParser <: ValueParser<PointF> {
    public static let INSTANCE: PointFParser = PointFParser()

    private PointFParser() {}

    public func parse(reader: JsonValue, scale: Float64): PointF {
        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray) || equalsJsonKind(jk, JsonKind.JsObject)) {
            return JsonUtils.jsonToPoint(reader, scale)
        } else {
            throw IllegalArgumentException("Cannot convert json to point. Next token is not array and object.")
        }
    }
}

public class DocumentDataParser <: ValueParser<DocumentData> {
    public static let INSTANCE: DocumentDataParser = DocumentDataParser()

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

    public func parse(jv: JsonValue, scale: Float64): DocumentData {
        var text: String = ""
        var fontName: String = ""
        var size: Float64 = 0.0
        var justification: Int64 = 0
        var tracking: Int64 = 0
        var lineHeight: Float64 = 0.0
        var baselineShift: Float64 = 0.0

        var fillColor: Array<Int64> = Array<Int64>()
        var strokeColor: Array<Int64> = Array<Int64>()

        var strokeWidth: Float64 = 0.0
        var strokeOverFill: Bool = false
        var boxPosition: PointF = PointF()
        var boxSize: PointF = PointF()

        let reader: JsonObject = jv.asObject()
        if (reader.containsKey(NAMES[0])) { // "t"
            text = reader[NAMES[0]].asString().getValue()
        }
        if (reader.containsKey(NAMES[1])) { // "f"
            fontName = reader[NAMES[1]].asString().getValue()
        }
        if (reader.containsKey(NAMES[2])) { // "s"
            size = reader[NAMES[2]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[3])) { // "j"
            justification = reader[NAMES[3]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[4])) { // "tr"
            tracking = reader[NAMES[4]].asInt().getValue()
        }
        if (reader.containsKey(NAMES[5])) { // "lh"
            lineHeight = reader[NAMES[5]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[6])) { // "ls"
            baselineShift = reader[NAMES[6]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[7])) { // "fc"
            fillColor = JsonUtils.jsonToColor(reader)
        }
        if (reader.containsKey(NAMES[8])) { // "sc"
            strokeColor = JsonUtils.jsonToColor(reader)
        }
        if (reader.containsKey(NAMES[9])) { // "sw"
            strokeWidth = reader[NAMES[9]].asFloat().getValue()
        }
        if (reader.containsKey(NAMES[10])) { // "of"
            strokeOverFill = reader[NAMES[10]].asBool().getValue()
        }
        if (reader.containsKey(NAMES[11])) { // "ps"
            let ja: JsonArray = reader.asArray()
            var x: Float64 = ja[0].asFloat().getValue()
            var y: Float64 = ja[1].asFloat().getValue()
            boxPosition = PointF(x * scale, y * scale)
        }
        if (reader.containsKey(NAMES[12])) { // "sz"
            let ja: JsonArray = reader.asArray()
            var x: Float64 = ja[0].asFloat().getValue()
            var y: Float64 = ja[1].asFloat().getValue()
            boxSize = PointF(x * scale, y * scale)
        }

        let dd: DocumentData = DocumentData()
        dd.t = text
        dd.f = fontName
        dd.s = size
        dd.j = justification
        dd.tr = tracking
        dd.lh = lineHeight
        dd.ls = baselineShift
        dd.fc = fillColor
        dd.sc = strokeColor
        dd.sw = strokeWidth
        dd.of = strokeOverFill
        dd.ps = boxPosition
        dd.sz = boxSize
        return dd
    }
}

public class ShapeDataParser <: ValueParser<ShapeData> {
    public static let INSTANCE: ShapeDataParser = ShapeDataParser()

    //"layers"."shapes"."ks".k   <==  "layers"."shapes".{"ty": "sh"}
    private static let NAMES: Array<String> = [
        "c",   //0
        "v",   //1
        "i",   //2
        "o"    //3
    ]

    private init() {}

    public func parse(reader: JsonValue, scale: Float64): ShapeData {
        var closed: Bool = false
        var pointsArray: ArrayList<PointF> = ArrayList<PointF>()
        var inTangents: ArrayList<PointF> = ArrayList<PointF>()
        var outTangents: ArrayList<PointF> = ArrayList<PointF>()

        var hasv: Bool = false
        var hasi: Bool = false
        var haso: Bool = false

        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(NAMES[0])) { // "c"
            closed = jo[NAMES[0]].asBool().getValue()
        }
        if (jo.containsKey(NAMES[1])) { // "v"
            let jv: JsonValue = jo[NAMES[1]]
            pointsArray = JsonUtils.jsonToPoints(jv, scale)
            hasv = true
        }
        if (jo.containsKey(NAMES[2])) { // "i"
            let jv: JsonValue = jo[NAMES[2]]
            inTangents = JsonUtils.jsonToPoints(jv, scale)
            hasi = true
        }
        if (jo.containsKey(NAMES[3])) { // "o"
            let jv: JsonValue = jo[NAMES[3]]
            outTangents = JsonUtils.jsonToPoints(jv, scale)
            haso = true
        }

        if (!hasv || !hasi || !haso) {
            throw IllegalArgumentException("Shape data was missing information.")
        }
        if (pointsArray.isEmpty()) {
            return ShapeData()
        }

        let sd: ShapeData = ShapeData()
        sd.c =  closed
        sd.v =  pointsArray
        sd.i =  inTangents
        sd.o =  outTangents
        return sd
    }
}

public class PathParser <: ValueParser<PointF> {
    public static let INSTANCE: PathParser = PathParser()
    private init() {}

    public func parse(reader: JsonValue, scale: Float64): PointF {
        return JsonUtils.jsonToPoint(reader, scale)
    }
}

public class ScaleXYParser <: ValueParser<Array<Float64>> {
    public static let INSTANCE: ScaleXYParser = ScaleXYParser()
    init(){}

    public func parse(reader: JsonValue, scale: Float64): Array<Float64> {
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
    public static let INSTANCE: ColorParser = ColorParser()

    private init() {}

    public func parse(reader: JsonValue, scale: Float64): Array<Float64> {
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

    @OverflowWrapping
    public func parseColor(reader: JsonValue, scale: Float64): Color {
        let ja: JsonArray = reader.asArray()

        var r: Int64 = Int64(ja[0].asFloat().getValue())
        var g: Int64 = Int64(ja[1].asFloat().getValue())
        var b: Int64 = Int64(ja[2].asFloat().getValue())
        var a: Int64 = 1

        if (ja.size() >= 4) {
            a = Int64(ja[3].asFloat().getValue())
        }

        if (r <= 1 && g <= 1 && b <= 1) {
            r *= Int64(255)
            g *= Int64(255)
            b *= Int64(255)
            if (a <= 1) {
                a *= Int64(255)
            }
        }
        return Color(a, r, g, b)
    }
}
