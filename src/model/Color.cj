/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Color <: ToString {

    public let a: Int64
    public let r: Int64
    public let g: Int64
    public let b: Int64
    var isNone: Bool = true

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
