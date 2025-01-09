/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is IImageElement.
 */
package lottie.model

public class SourceRect <: ToString {

    /* Top margin */
    public var top: Int64 = 0

    /* Left margin */
    public var left: Int64 = 0
    
    /* The width */
    public var width: Int64 = 0

    /* The height */
    public var height: Int64 = 0

    /**
     * Create a SourceRect instance.
     */
    public init(){}

    /**
     * Create a SourceRect instance based on parameters.
     *
     * @param top - Type of Int64, Top margin of SourceRect.
     * @param left - Type of Int64, Left margin of SourceRect.
     * @param width - Type of Int64, The width of SourceRect.
     * @param height - Type of Int64, The height of SourceRect.
     */
    public init(top!: Int64, left!: Int64, width!: Int64, height!: Int64) {
        this.width = width
        this.height = height
        this.top = top
        this.left = left
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "SourceRect = {(top = ${top}), (left = ${left}), (width = ${width}), (height = ${height})}"
    }
}
