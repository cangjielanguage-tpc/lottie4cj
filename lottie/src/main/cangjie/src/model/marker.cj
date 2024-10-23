/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Marker structure.
 */
package lottie.model

public class Marker <: ToString {

    public let cm: String             // 0 = comment
    public let tm: Float64            // 1 = frame
    public let dr: Float64            // 2 = durationFrames

    /**
     * Create a Marker instance based on parameters.
     *
     * @param cm - Type of String, the value of cm.
     * @param tm - Type of Float64, the value of tm.
     * @param dr - Type of Float64, the value of dr.
     */
    public init(cm: String, tm: Float64, dr: Float64) {
        this.cm = cm
        this.tm = tm
        this.dr = dr
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Marker: {\n" +
        "cm = ${cm}\n" +
        "tm = ${tm}\n" +
        "dr = ${dr}\n}"
    }
}
