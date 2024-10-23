/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a PointF structure.
 */
package lottie.model

public class PointF <: ToString {

    public var x: Float64
    public var y: Float64
    
    public var isNull: Bool = false

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

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    //public func isNull(): Bool {
    //    return x == 0.0 && y == 0.0
    //}
}
