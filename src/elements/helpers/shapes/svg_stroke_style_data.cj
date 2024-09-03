/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

//TODO DynamicPropertyContainer继承
public class SVGStrokeStyleData <: SVGNoStyleData {
    public var _isAnimated: Bool
    //调用DynamicPropertyContainer类接口
    public init(elem: Object, data: Datas, styleOb: SVGStyleData) {
        super(elem,data,styleOb)
        this._isAnimated = false
        
    }
}