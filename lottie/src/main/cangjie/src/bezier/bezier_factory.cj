/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BezierFactory.
 */
package lottie.bezier
import kit.PerformanceAnalysisKit.Hilog
internal import std.collection.*

public class BezierFactory {

    /**
     * BezierEasing - use bezier curve for transition easing function
     * by Gaëtan Renaudeau 2014 - 2015 – MIT License
     *
     * Credits: is based on Firefox's nsSMILKeySpline.cpp
     * Usage:
     * var spline = BezierEasing([ 0.25, 0.1, 0.25, 1.0 ])
     * spline.get(x) => returns the easing value | x must be in [0, 1] range
     *
     */

    static var beziers: HashMap<String, BezierEasing> = HashMap<String, BezierEasing>(16)

    public static func getBezierEasing(a: Float64, b: Float64, c: Float64, d: Float64, nm: Array<String>): BezierEasing {
        var str: Array<String> = nm
        if (nm.isEmpty() || (nm.size >= 1 && nm[0] == "")) {
            str = [("bez_" + a.toString() + "_" + b.toString() + "_" + c.toString() + "_" + d.toString()).replace(".", "p")]
        }

        let sc = str.toString()
        if (beziers.contains(sc)) {
            return beziers[sc]
        }
        let bezEasing: BezierEasing = BezierEasing([a, b, c, d])
        beziers[sc] = bezEasing
        return bezEasing
    }

}
