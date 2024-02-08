/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file
 * The file declars the LottiePlayer class.
 */
package lottie4cj

public class ShapeData {

    var c: Bool = false                              //0 //"c" =  closed
    var v: ArrayList<PointF> = ArrayList<PointF>()   //1 //"v" =  pointsArray
    var i: ArrayList<PointF> = ArrayList<PointF>()   //2 //"i" =  inTangents
    var o: ArrayList<PointF> = ArrayList<PointF>()   //3 //"o" =  outTangents

    init(){}
}
