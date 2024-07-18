/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils

internal import std.math.*


var idPrefix: String = ""
public var defaultCurveSegments = 150
public let degToRads: Float64 = Float64.PI / 180.0
public let roundCorner: Float64 = 0.5519

public let initialDefaultFrame: Int64 = -999999


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


/**
 * Obtain default curve segmentation values.
 *
 * @return Type of Int64, default curve segmentation values.
 */ //const getExpressionInterfaces: () ->  = () => expressionsInterfaces
public func getDefaultCurveSegments(): Int64 {
     defaultCurveSegments
}
