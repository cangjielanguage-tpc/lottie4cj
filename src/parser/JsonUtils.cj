/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public func equalsJsonKind(left: JsonKind, right: JsonKind): Bool {
    return match ((left, right)) {
        case (JsNull, JsNull) => true
        case (JsBool, JsBool) => true
        case (JsInt, JsInt) => true
        case (JsFloat, JsFloat) => true
        case (JsString, JsString) => true
        case (JsArray, JsArray) => true
        case (JsObject, JsObject) => true
        case _ => false
    }
}

class JsonUtils {

    /**
     * [r,g,b]
     */
    static func jsonToColor(reader: JsonValue): Array<Float64> {
        let ja: JsonArray = reader.asArray()
        let len: Int64 = ja.size()
        let color: Array<Float64> = Array<Float64>(len, item: 0.0)

        for (i in 0..len) {
            color[i] = ja[i].asFloat().getValue()
        }
        return color
    }

    static func jsonToPoints(reader: JsonValue, scale: Float64): ArrayList<PointF> {
        var points: ArrayList<PointF> = ArrayList<PointF>()
        let jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray)) {
            let ja: JsonArray = reader.asArray()
            for (i in 0..ja.size()) {
                let jv: JsonValue = ja[i]
                points.append(jsonToPoint(jv, scale))
            }
        }
        return points
    }

    static func jsonToPoint(reader: JsonValue, scale: Float64): PointF {
        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsArray)) {
            return jsonArrayToPoint(reader, scale)
        } else if (equalsJsonKind(jk, JsonKind.JsObject)) {
            return jsonObjectToPoint(reader, scale)
        } else {
            throw IllegalArgumentException("Unknown point starts with JsonKind.")
        }
    }

    private static func jsonArrayToPoint(reader: JsonValue, scale: Float64): PointF {
        let ja: JsonArray = reader.asArray()

        let x: Float64 = ja[0].asFloat().getValue()
        let y: Float64 = ja[1].asFloat().getValue()

        return PointF(x * scale, y * scale)
    }

    private static let POINT_NAMES: Array<String> = ["x", "y"]

    private static func jsonObjectToPoint(reader: JsonValue, scale: Float64): PointF {
        var x: Float64 = 0.0
        var y: Float64 = 0.0

        let jo: JsonObject = reader.asObject()
        if (jo.containsKey(POINT_NAMES[0])) { // "x"
            x = valueFromObject(jo[POINT_NAMES[0]])
        }
        if (jo.containsKey(POINT_NAMES[1])) { // "y"
            y = valueFromObject(jo[POINT_NAMES[1]])
        }
        return PointF(x * scale, y * scale)
    }

    static func valueFromObject(reader: JsonValue): Float64 {

        var jk: JsonKind = reader.kind()
        if (equalsJsonKind(jk, JsonKind.JsInt) || equalsJsonKind(jk, JsonKind.JsFloat)) {
            return reader.asFloat().getValue()
        } else if (equalsJsonKind(jk, JsonKind.JsArray)) {
            let ja: JsonArray = reader.asArray()
            return ja[0].asFloat().getValue()
        } else {
            throw IllegalArgumentException("Unknown value for token of type: is not number and array.")
        }
    }
}
