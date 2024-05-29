/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is BezierFactory.
 */
package third_party

from std import collection.*

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

    var beziers: HashMap<String, BezierEasing> = HashMap<String, BezierEasing>(24)

    /**
     * Get the BezierEasing instance based on parameters.
     *
     * @param a - Type of Float64.
     * @param b - Type of Float64.
     * @param c - Type of Float64.
     * @param d - Type of Float64.
     * @param nm - Type of String.
     * @return Type of BezierEasing.
     */
    public func getBezierEasing(a: Float64, b: Float64, c: Float64, d: Float64, nm: String): BezierEasing {
        var str: String = nm
        if (nm.isEmpty()) {
            str = "bez_" + a.toString() + "_" + b.toString() + "_" + c.toString() + "_" + d.toString()
        }
        str = str.replace(".", "p")
        if (beziers.contains(str)) {
            return beziers[str]
        }
        let bezEasing: BezierEasing = BezierEasing([a, b, c, d])
        beziers[str] = bezEasing
        return bezEasing
    }

}
