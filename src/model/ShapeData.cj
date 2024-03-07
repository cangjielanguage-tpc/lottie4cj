/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class ShapeData <: ToString {

    public let c: Bool                //0 =  closed
    private let _v: Array<PointF>     //1 =  pointsArray
    private let _i: Array<PointF>     //2 =  inTangents
    private let _o: Array<PointF>     //3 =  outTangents

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

    public prop v: Array<PointF> {
        get() { this._v.clone() }
    }

    public prop i: Array<PointF> {
        get() { this._i.clone() }
    }

    public prop o: Array<PointF> {
        get() { this._o.clone() }
    }

    public func toString(): String {
        return "ShapeData: {\n" +
               "c = ${c}\n" +
               "v = ${_v}\n" +
               "i = ${_i}\n" +
               "o = ${_o}\n}"
    }
}
