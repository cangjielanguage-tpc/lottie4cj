/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a FillStroke structure.
 */
package lottie.model

//兼容(arr[i].ty === 'fl'/'st'/'gf'/'gs') 
public open class FillStroke <: ContentModel {

    /**
     * 兼容以下 4 种类型：
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStroke
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStroke
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFill
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFill
     */

    public var g: ContentModelP = ContentModelP()                                          //1 = {points, color}  //ContentModelP
    //指向的是已经处理的 c，即 "fl"/"st" 的 c_k
    public var c: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()    //1 = color

    public var o: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>()                        //2 = opacity
    public var s: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()      //4 = startPoint
    public var e: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()      //5 = endPoint
    public var w: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()                    //6 = width
    //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  =>  Array<ContentModelD>
    public var d: Array<ContentModelD> = Array<ContentModelD>()                            //11 = lineDashPattern  //Array<ContentModelD>
    //TODO: h 成员变量暂时是空的。
    public var a: AK = AK()                                                                //12 = mn

    public var lc: Int64 = -1                          //7 = capType
    public var lj: Int64 = -1                          //8 = joinType
    public var ml: Float64 = -1.0                      //9 = miterLimit
    public var r: Int64 = 0

    public var t: Int64 = 0

    //public init(){ }

}
