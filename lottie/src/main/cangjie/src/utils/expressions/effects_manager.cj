/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.utils.expressions


public class EffectsManager <: SuperEffect {

    public init(datas: Effect, element: GlobalData, data: Layer, container: GroupEffect, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(datas, element, data, propertyGroup, dynamicProperties: dynamicProperties)
        let effects = data.ef
        let len = effects.size
        var effectItem: GroupEffect
        for (i in 0..len) {
            effectItem = GroupEffect(effects[i], element, data, propertyGroup, dynamicProperties: dynamicProperties)
            this.effectElements.add(effectItem)
        }
    }
    
}

public open class SuperEffect <: DynamicPropertyContainer {

    public var p: PropertyFactory<ContentModelPK, Array<Float64>>
    public var propertyGroup: LayerExpressionInterface

    var effectElements: ArrayList<SuperEffect>
    var data: LayerEF
    public init(data: LayerEF, element: GlobalData, datas: Layer, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(element, datas, dynamicProperties: dynamicProperties)
        this.data = data
        this.propertyGroup = propertyGroup
        this.effectElements = ArrayList<SuperEffect>()
    
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        this.p = PropertyFactory<ContentModelPK, Array<Float64>>(ContentModelPK(), 0.0, dp, GlobalData(), Layer(), dynamicProperties: dynamicProperties)
    }
}

public class GroupEffect <: SuperEffect {

    public init(data: LayerEF, element: GlobalData, datas: Layer, propertyGroup: LayerExpressionInterface, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, element, datas, propertyGroup, dynamicProperties: dynamicProperties)
        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.dynamicProperties.clear()
        this._mdf = false
        this._isAnimated = false

        let len = data.ef.size
        
        let effects = data.ef
        for (i in 0..len) {
           var eff: Option<SuperEffect> = None
            match (effects[i].ty) {
                case 0 =>
                    eff = SliderEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 1 =>
                    eff = AngleEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 2 =>
                    eff = ColorEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 3 =>
                    eff = PointEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 4 =>
                    eff = CheckboxEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 7 =>
                    eff = CheckboxEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 10 =>
                    eff = LayerIndexEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                case 11 =>
                    eff = MaskIndexEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
                /* 未实现，编译用  case 5 => eff = EffectsManager(effects[i],element,datas, this, propertyGroup) */
                case _ =>
                    eff = NoValueEffect(effects[i],element,datas, this, propertyGroup, dynamicProperties: dynamicProperties)
            }
            if (let Some(v) <- eff) {
                this.effectElements.add(v)
            }
        }
    }
}
