/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a PointF structure.
 */
package model

public class PointF <: ToString {

    public let x: Float64
    public let y: Float64

    /**
     * Create a PointF instance based on parameters.
     *
     * @param x - Type of Float64, the value of x.
     * @param y - Type of Float64, the value of y.
     */
    public init(x!: Float64 = 0.0, y!: Float64 = 0.0) {
        this.x = x
        this.y = y
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "PointF: {x='${x}', y='${y}'}"
    }
}
