/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Color structure.
 */
package model

public class Color <: ToString {

    public let a: Int64
    public let r: Int64
    public let g: Int64
    public let b: Int64
    var isNone: Bool = true

    /**
     * Create a Color instance based on parameters.
     *
     * @param a - Type of Int64, the value of a.
     * @param r - Type of Int64, the value of r.
     * @param g - Type of Int64, the value of g.
     * @param b - Type of Int64, the value of b.
     */
    public init(a: Int64, r: Int64, g: Int64, b: Int64) {
        this.a = a
        this.r = r
        this.g = g
        this.b = b
        this.isNone = false
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "Color{a: ${a}, r: ${r}, g: ${g}, b: ${b}}"
    }

}
