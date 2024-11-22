/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ContentModel structure.
 */

package lottie.property


/*
 * [this.itemsData，储存的是处理后的 Layer.shapes]，其中实际保存的数据类型为：
 * (arr[i].ty === 'fl'/'st'/'gf'/'gs') -- FillStrokeElement <: ContentModelElement 
 * (arr[i].ty === 'gr')  -- ShapeGroupElement <: ContentModelElement 
 * (arr[i].ty === 'tr')  -- AnimatableTransformElement <: ContentModelElement 
 * (arr[i].ty === 'sh'/'rc'/'el'/'sr') -- CVShapeData <: ContentModelElement 
 * (arr[i].ty === 'tm'/'rd'/'pb'/'zz'/'op')-- ShapeModifiers.getModifier--【ShapeModifier子类】 <: DynamicPropertyContainer <: ContentModelElement 
 * (arr[i].ty === 'rp')--RepeaterModifier--【ShapeModifier子类】 <: DynamicPropertyContainer <: ContentModelElement 
 *
 * 定义继承关系为：所有 itemsData[i] 直接或者间接继承 ContentModelElement。
 * 原来抽象出来的 ElementData/ElementData2，更换为 ContentModelElement。
 */

public open class ContentModelElement {
    public var ty: String = "ContentModel"
}
