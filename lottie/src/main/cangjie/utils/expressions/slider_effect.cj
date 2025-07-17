/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.utils.expressions

internal import lottie.global_data.*
internal import lottie.model.*
internal import lottie.property.*
internal import std.collection.*


public class SliderEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 0, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class AngleEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 0, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class ColorEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 1, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class PointEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 1, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class CheckboxEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 0, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class LayerIndexEffect <: SuperEffect {

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 0, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}

public class MaskIndexEffect <: SuperEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
        var vLen: Int64 = if (data.v.k.size > 0) { (data.v.k[0].s ?? Array<Float64>()).size } else { 0 }
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>.getProp(data.v, data.v.k, 0, 0.0, container, elem, datas, vLen: vLen, dynamicProperties: dynamicProperties)
    }

}


public class NoValueEffect <: SuperEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elem, datas, propertyGroup, dynamicProperties: dynamicProperties)
    }
}

