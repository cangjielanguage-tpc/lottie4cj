/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.model

public class Size <: ToString {

    //The width
    public var width: Int64 = 0

    //The height
    public var height: Int64 = 0

    /**
     * Create a Size instance.
     */
    public init(){}

    /**
     * Create a Size instance based on parameters.
     *
     * @param width - Type of Int64.
     * @param height - Type of Int64.
     */
    public init(width!: Int64, height!: Int64) {
        this.width = width
        this.height = height
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "Size = {(width = ${width}), (height = ${height})}"
    }
}
