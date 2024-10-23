/**
 * Created on 2024/10/11
 */
package lottie.elements
/*

 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.

 */

public class EffectsManager {

    public var effectElements: ArrayList<GroupEffect>

    public init(data: Layer, element: GlobalData, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        let effects = data.ef
        this.effectElements = ArrayList<GroupEffect>()
        let len = effects.size
        var effectItem: GroupEffect
        for (i in 0..len) {
            effectItem = GroupEffect(effects[i], element, data, dynamicProperties: dynamicProperties)
            this.effectElements.append(effectItem)
        }
    }
}

public class GroupEffect <: DynamicPropertyContainer {

    public var effectElements: ArrayList<NoValueEffect>
    public var data: LayerEF

    public init(data: LayerEF, element: GlobalData, datas: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(element, datas, dynamicProperties: dynamicProperties)
        this.data = data
        this.effectElements = ArrayList<NoValueEffect>()
        this.initDynamicPropertyContainer(element, datas)
        let len = data.ef.size
        var eff: ?NoValueEffect
        let effects = data.ef
        for (i in 0..len) {
            eff = None
            match (effects[i].ty) {
                case 0 => eff = SliderEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 1 => eff = AngleEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 2 => eff = ColorEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 3 => eff = PointEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 4 => eff = CheckboxEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 7 => eff = CheckboxEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 10 => eff = LayerIndexEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                case 11 => eff = MaskIndexEffect(effects[i], element, datas, this, dynamicProperties: dynamicProperties)
                //未实现，编译用
                //  case 5 =>
                //     eff = EffectsManager(effects[i],element,datas, this);
                case _ => eff = NoValueEffect(effects[i], element, datas, this)
            }

            if (let Some(v) <- eff) {
                this.effectElements.append(v)
            }
        }
    }

    public func getValue() { }
}
