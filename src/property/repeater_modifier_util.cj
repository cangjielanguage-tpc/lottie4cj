/*
 * Copyright (c) Huawei Technologies Co. Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

//TODO: 仅编译用，实际数据来源和 CVShapeElement 中 应用对齐。
public open class ElementData {

    var w: Array<PropertyFactory<Array<Keyframe<Float64>>, Float64>> = Array<PropertyFactory<Array<Keyframe<Float64>>, Float64>>()
    var style: StyleElem = StyleElem()

    var it: Array<ElementData> = Array<ElementData>()
    var prevViewData: Array<ElementData> = Array<ElementData>()
    var transform: Transform = Transform()
    
    public init(elem: BaseElement) {}

}

//TODO: 仅编译用，实际数据来源和 CVShapeElement 中 应用对齐。
public class Transform {
    var opacity: Int64 =  1
    var _opMdf: Bool = false
    var op: Array<PropertyFactory<ArrayKeyframeInt64, Int64>> = Array<PropertyFactory<ArrayKeyframeInt64, Int64>>()

    public init(){}
}

//TODO: 仅编译用，实际数据来源和 CVShapeElement 中 应用对齐。
public class StyleElem {

    var data: ContentModel = ContentModel()  //(data.ty == 'fl'/'st'/'gf'/'gs')
    var types: String = ""
    var closed: Bool = false
}
