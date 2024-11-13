/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is PropertyFactory.
 */
//package lottie.utils
package lottie.property

public let empty_Array_unit_to_Float64: Array<() -> Float64> = Array<() -> Float64>()

public let empty_ContentModelElement: ContentModelElement = ContentModelElement()

//public let empty_globalData: GlobalData = GlobalData()
public let empty_dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
public let empty_dp: DynamicPropertyContainer = DynamicPropertyContainer(empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_Array_dp: Array<DynamicPropertyContainer> = Array<DynamicPropertyContainer>()

public let empty_pf_ArrayKeyframeInt64_Int64: PropertyFactory<ArrayKeyframeInt64, Int64> = PropertyFactory<ArrayKeyframeInt64, Int64>(empty_ArrayKeyframeInt64, 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_tp: TransformProperty = TransformProperty(isNull: true, dynamicProperties: empty_dynamicProperties)


public let empty_pf_Array_Keyframe_Array_Float64 = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>(empty_Array_Keyframe_Array_Float64, 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_pf_Array_Keyframe_Int64 = PropertyFactory<Array<Keyframe<Int64>>, Int64>(empty_Array_Keyframe_Int64, 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_pf_Array_Keyframe_Float64 = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_pf_ak = PropertyFactory<AK, Int64>(empty_ak, 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)
public let empty_pf_ContentModelP = PropertyFactory<ContentModelP, Array<Float64>>(empty_ContentModelP, 0.0, empty_dp, empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)

public let empty_dp_Array_ContentModelD = DashProperty(Array<ContentModelD>(), "", empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)

public let empty_spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0,  empty_globalData, empty_layer, dynamicProperties: empty_dynamicProperties)

public let empty_styleElem: StyleElem = StyleElem(isNull: true)
