/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class ShapeData <: ToString {

    var c: Bool = false                              //0 =  closed
    var v: ArrayList<PointF> = ArrayList<PointF>()   //1 =  pointsArray
    var i: ArrayList<PointF> = ArrayList<PointF>()   //2 =  inTangents
    var o: ArrayList<PointF> = ArrayList<PointF>()   //3 =  outTangents

    init(){}

    public func toString(): String {
        return "ShapeData: { \n" +
               "    c = ${c} \n" +
               "    v = ${v} \n" +
               "    i = ${i} \n" +
               "    o = ${o} \n" +
               "}"
    }
}
