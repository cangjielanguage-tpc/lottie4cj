/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Color <: ToString {

    var a: Int64 = 0
    var r: Int64 = 0
    var g: Int64 = 0
    var b: Int64 = 0
    var isNone: Bool = true

    public init(){}
    public init(a: Int64, r: Int64, g: Int64, b: Int64) {
        this.a = a
        this.r = r
        this.g = g
        this.b = b
        this.isNone = false
    }

    public func toString(): String {
        return "Color{a: ${a}, r: ${r}, g: ${g}, b: ${b}}"
    }

}
