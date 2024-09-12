/*
 * Copyright (c) Huawei Technologies Co. Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

internal import std.collection.*

internal import lottie4cj.model.*

//TODO: 仅编译用，实际数据来源和 CVShapeElement 中 应用对齐。
//TODO：和 elements\helpers\shapes\svg_elements_renderer.cj 中 ElementData 命名冲突。
public open class ElementData2 {

    //createStyleElement-----------------------------------------------------------------------------------------------------------
    var style: StyleElem = StyleElem()
    
    //createGroupElement----------------------------------------------------------------------------------------------
    var it: Array<ElementData2> = Array<ElementData2>()
    var prevViewData: Array<ElementData2> = Array<ElementData2>()
    
    //createTransformElement----------------------------------------------------------------------------------------------
    public var transform: Transform = Transform()

    public init() {
        let arr: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    }

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
    //(data.ty == 'fl'/'st'/'gf'/'gs')
    var data: ContentModel = ContentModel()
    var types: String = ""
    var closed: Bool = false
}
