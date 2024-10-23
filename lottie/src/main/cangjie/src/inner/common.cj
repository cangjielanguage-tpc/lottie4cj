/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.inner

internal import std.math.*

var subframeEnabled: Bool = true

var idPrefix: String = ""
public let isSafari: Bool = false

let _shouldRoundValues: Bool = false

public var defaultCurveSegments: Int64 = 150
public let degToRads: Float64 = Float64.PI / 180.0
public let roundCorner: Float64 = 0.5519

let initialDefaultFrame: Int64 = -999999

public func setSubframeEnabled(flag: Bool): Unit {
    subframeEnabled = flag
}
public func getSubframeEnabled(): Bool {
    return subframeEnabled
}

public class CreateElementID {

    static var _count: Int64 = 0

    /**
     * Create Element ID.
     *
     * @return Type of String, Element ID.
     */
    public static func createID(): String {
        _count += 1
        return idPrefix + "__lottie_element_" + _count.toString()
    }
}

public func getDefaultCurveSegments(): Int64 {
     defaultCurveSegments
}

//TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
func hsvToRGB(h: Float64, s: Float64, v: Float64): Array<Float64> {
    var r: Float64 = 0.0
    var g: Float64 = 0.0
    var b: Float64 = 0.0

    let i: Float64 = floor(h * 6.0)
    let f: Float64 = h * 6.0 - i
    let p: Float64 = v * (1.0 - s)
    let q: Float64 = v * (1.0 - f * s)
    let t: Float64 = v * (1.0 - (1.0 - f) * s)
    
    let i2: Int64 = Int64(i) % 6
    if (i2 == 0) {
        r = v
        g = t
        b = p
    } else if (i2 == 1) {
        r = q
        g = v
        b = p
    } else if (i2 == 2) {
        r = p
        g = v
        b = t
    } else if (i2 == 3) {
        r = p
        g = q
        b = v
    } else if (i2 == 4) {
        r = t
        g = p
        b = v
    } else if (i2 == 5) {
        r = v
        g = p
        b = q
    }
    return [r, g, b]
}

//TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
func rgbToHSV(r: Float64, g: Float64, b: Float64): Array<Float64> {
    let maxs: Float64 = max(max(r, g), b)
    let mins: Float64 = min(min(r, g), b)
    var d: Float64 = maxs - mins
    var h: Float64 = 0.0

    var s: Float64 = 0.0
    if (maxs != 0.0) {
        s = d / maxs
    }
    let v: Float64 = maxs / 255.0

    if (maxs == mins){
        h = 0.0
    } else if (maxs == r) {
        if (g < b) {
            h = (g - b) + d * 6.0
        } else {
            h = g - b
        }
        h /= 6.0 * d
    } else if (maxs == g) {
        h = (b - r) + d * 2.0
        h /= 6.0 * d
    } else if (maxs == b) {
        h = (r - g) + d * 4.0
        h /= 6.0 * d
    }

    return [h, s, v]
}

//TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
public func addSaturationToRGB(color: Array<Float64>, offset: Float64) {
    if (color.size < 3) {
        throw IndexOutOfBoundsException("[addSaturationToRGB]: color.size = ${color.size}")
    }
    let hsv: Array<Float64> = rgbToHSV(color[0] * 255.0, color[1] * 255.0, color[2] * 255.0)
    if (hsv.size < 3) {
        throw IndexOutOfBoundsException("[addSaturationToRGB]: hsv.size = ${hsv.size}")
    }
    hsv[1] += offset
    if (hsv[1] > 1.0) {
        hsv[1] = 1.0
    } else if (hsv[1] <= 0.0) {
        hsv[1] = 0.0
    }
    return hsvToRGB(hsv[0], hsv[1], hsv[2])
}

//TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
public func addBrightnessToRGB(color: Array<Float64>, offset: Float64): Array<Float64> {
    if (color.size < 3) {
        throw IndexOutOfBoundsException("[addBrightnessToRGB]: color.size = ${color.size}")
    }

    let hsv: Array<Float64> = rgbToHSV(color[0] * 255.0, color[1] * 255.0, color[2] * 255.0)
    if (hsv.size < 3) {
        throw IndexOutOfBoundsException("[addBrightnessToRGB]: hsv.size = ${hsv.size}")
    }
    hsv[2] += offset
    if (hsv[2] > 1.0) {
        hsv[2] = 1.0
    } else if (hsv[2] < 0.0) {
        hsv[2] = 0.0
    }
    return hsvToRGB(hsv[0], hsv[1], hsv[2])
}

//TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
public func addHueToRGB(color: Array<Float64>, offset: Float64): Array<Float64> {
    if (color.size < 3) {
        throw IndexOutOfBoundsException("[addHueToRGB]: color.size = ${color.size}")
    }
    let hsv: Array<Float64> = rgbToHSV(color[0] * 255.0, color[1] * 255.0, color[2] * 255.0)
    if (hsv.size < 3) {
        throw IndexOutOfBoundsException("[addHueToRGB]: hsv.size = ${hsv.size}")
    }
    hsv[0] += offset / 360.0
    if (hsv[0] > 1.0) {
        hsv[0] -= 1.0
    } else if (hsv[0] < 0.0) {
        hsv[0] += 1.0
    }
    return hsvToRGB(hsv[0], hsv[1], hsv[2])
}
