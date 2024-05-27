/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package utils

from std import math.*

//const getExpressionInterfaces: () ->  = () => expressionsInterfaces


var idPrefix: String = ""
public let defaultCurveSegments = 150
public let degToRads: Float64 = Float64.PI / 180.0
public let roundCorner: Float64 = 0.5519

public let initialDefaultFrame: Int64 = -999999


public class CreateElementID {

    static var _count: Int64 = 0

    public static func createID(): String {
        _count += 1
        return idPrefix + "__lottie4cj_element_" + _count.toString()
    }

}
