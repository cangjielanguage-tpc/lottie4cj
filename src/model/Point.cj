/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class PointF <: ToString {

    public let x: Float64
    public let y: Float64
    public let types: Int64 = 2

    public init(x!: Float64 = 0.0, y!: Float64 = 0.0) {
        this.x = x
        this.y = y
    }

    public func toString(): String {
        return "PointF: {x='${x}', y='${y}'}"
    }
}
