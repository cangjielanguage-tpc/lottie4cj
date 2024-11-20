/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a GradientStroke structure.
 */
package lottie.property

//兼容(arr[i].ty === 'fl'/'st'/'gf'/'gs') 
public class FillStrokeElement <: ContentModelElement {

    /**
     * 兼容以下 4 种类型：
     * 1. "layers"."shapes".{"ty": "st"} = ShapeStroke
     * 2. "layers"."shapes".{"ty": "gs"} = GradientStroke
     * 3. "layers"."shapes".{"ty": "fl"} = ShapeFill
     * 4. "layers"."shapes".{"ty": "gf"} = GradientFill
     */
    public var style: StyleElem
    // "g": {"p": points/Int64, "k": color/Array<Keyframe<T>>} => Array<Keyframe<Array<Float64>>>
    public var g: GradientProperty                                                      //1 = {points, color}  //ContentModelP

    //指向的是已经处理的 c，即 "fl"/"st" 的 c_k
    public var c: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>    //1 = color

    public var o: PropertyFactory<Array<Keyframe<Int64>>, Int64>                        //2 = opacity
    public var s: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>      //4 = startPoint
    public var e: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>      //5 = endPoint
    public var w: PropertyFactory<Array<Keyframe<Float64>>, Float64>                    //6 = width
    //"d": [{"n": "String", "v": Array<Keyframe<Float64>>}]  =>  Array<ContentModelD>
    public var d: DashProperty                                                          //11 = lineDashPattern  //Array<ContentModelD>
    //TODO: h 成员变量暂时是空的。
    public var a: PropertyFactory<AK, Int64>                                            //12 = mn

    //public let ty: String = "gs"

    public var isNull: Bool = false

    public init(isNull!: Bool, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        this.isNull = isNull
        this.style = empty_styleElem

        let container: DynamicPropertyContainer = DynamicPropertyContainer(GlobalData(), Layer(), dynamicProperties: dynamicProperties)
        this.g = GradientProperty(isNull: true, dynamicProperties: dynamicProperties)
        //let arr: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
        this.c = empty_pf_Array_Keyframe_Array_Float64
        this.o = empty_pf_Array_Keyframe_Int64
        this.s = empty_pf_Array_Keyframe_Array_Float64
        this.e = empty_pf_Array_Keyframe_Array_Float64
        this.w = empty_pf_Array_Keyframe_Float64
        this.d = empty_dp_Array_ContentModelD
        //TODO: h 成员变量暂时是空的。
        this.a = empty_pf_ak
    }

}
