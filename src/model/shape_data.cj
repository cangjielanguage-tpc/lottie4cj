/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeData structure.
 */
package lottie4cj.model

public class ShapeData <: ToString {

    public let c: Bool                //0 =  closed
    private let _v: Array<PointF>     //1 =  pointsArray
    private let _i: Array<PointF>     //2 =  inTangents
    private let _o: Array<PointF>     //3 =  outTangents

    /**
     * Create a ShapeData instance based on parameters.
     *
     * @param c - Type of Bool, the value of c.
     * @param v - Type of Array<PointF>, the value of v.
     * @param i - Type of Array<PointF>, the value of i.
     * @param o - Type of Array<PointF>, the value of o.
     */
    public init(
        c!: Bool = false,
        v!: Array<PointF> = Array<PointF>(),
        i!: Array<PointF> = Array<PointF>(),
        o!: Array<PointF> = Array<PointF>()
    ){
        this.c = c
        this._v = v
        this._i = i
        this._o = o
    }

    /**
     * Obtain the v of ShapeData.
     */
    public prop v: Array<PointF> {
        get() { this._v.clone() }
    }

    /**
     * Obtain the i of ShapeData.
     */
    public prop i: Array<PointF> {
        get() { this._i.clone() }
    }

    /**
     * Obtain the o of ShapeData.
     */
    public prop o: Array<PointF> {
        get() { this._o.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeData: {\n" +
               "c = ${c}\n" +
               "v = ${_v}\n" +
               "i = ${_i}\n" +
               "o = ${_o}\n}"
    }
}
