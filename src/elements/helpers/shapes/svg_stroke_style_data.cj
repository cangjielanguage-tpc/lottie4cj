/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

//TODO DynamicPropertyContainer继承
public class SVGStrokeStyleData {
    var _isAnimated: Bool
    //调用DynamicPropertyContainer类接口
    public init(elem: Object, data: Object, styleOb: SVGStyleData) {
        this._isAnimated = false
    }
}