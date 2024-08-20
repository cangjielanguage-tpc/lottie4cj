/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.inner

internal import std.math.*

let subframeEnabled: Bool = true

var idPrefix: String = ""
public let isSafari: Bool = false

let _shouldRoundValues: Bool = false

public var defaultCurveSegments: Int64 = 150
public let degToRads: Float64 = Float64.PI / 180.0
public let roundCorner: Float64 = 0.5519

let initialDefaultFrame: Int64 = -999999

public class CreateElementID {

    static var _count: Int64 = 0

    /**
     * Create Element ID.
     *
     * @return Type of String, Element ID.
     */
    public static func createID(): String {
        _count += 1
        return idPrefix + "__lottie4cj_element_" + _count.toString()
    }

}

public func getDefaultCurveSegments(): Int64 {
     defaultCurveSegments
}
