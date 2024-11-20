/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions


//internal import lottie.effects.*

//public class EffectsExpressionInterface <: ExpressionInterface {
public class EffectsExpressionInterface {

    //TODO:根据 BaseElement 中调用逻辑写的
    //TODO: EffectsManager 和 BaseElement 互相引用。
    //BaseElement 中分析：elem = BaseElement；propertyGroup = LayerExpressionInterface
    public static func createEffectsInterface(elem: BaseElement, propertyGroup: LayerExpressionInterface): EffectsInterfaceFunctionEffects {
        //TODO: BaseElement 中暂未实现成员变量 effectsManager。
        //if (elem.effectsManager) {
            let effectsData: Array<LayerEF> = elem.data.ef
            //TODO: BaseElement 中暂未实现成员变量 effectsManager。
            //let len: Int64 = elem.effectsManager.effectElements.size
            let len: Int64 = 0
            let effectElements: ArrayList<EffectsInterfaceFunctionGroup> = ArrayList<EffectsInterfaceFunctionGroup>(len)
            for (i in 0..len) {
                /*
                 * TODO: EffectsManager.effectElements 中储存的 GroupEffect：
                 * TODO: GroupEffect.effectElements 中储存的是各个子 Effect：
                 * SliderEffect/AngleEffect/ColorEffect/PointEffect/CheckboxEffect/
                 * LayerIndexEffect/MaskIndexEffect/EffectsManager/NoValueEffect
                 * TODO: GroupEffect 和 9个 Effect 是有关联关系的。暂定 SuperEffect 是 9个 Effect 的父类。
                 */
                //TODO: BaseElement 中暂未实现成员变量 effectsManager。
                //effectElements.append(createGroupInterface(effectsData[i], elem.effectsManager.effectElements[i], propertyGroup, elem))
                effectElements.append(createGroupInterface(effectsData[i], SuperEffect(LayerEF(), GlobalData(), Layer(), propertyGroup, dynamicProperties: ArrayList<DynamicPropertyContainer>()), propertyGroup, elem))
            }
            let effects: Array<LayerEF> = elem.data.ef

            func selfCallingEffects(value: Int64, name: String, isString: Bool): EffectsInterfaceFunctionGroup {
                let len: Int64 = effects.size
                for (i in 0..len) {
                    //TODO: LayerEF 中增加成员变量 ix ？？？
                    if (name == effects[i].nm || name == effects[i].mn || value == effects[i].ix) {
                        return effectElements[i]
                    }
                }
                //return None
                
                return EffectsInterfaceFunctionGroup(LayerEF(), ArrayList<EffectsInterfaceFunction>(), isNull: true)
            }

            /**
             * 1.返回的groupInterface是函数，但同时具备对象功能。
             * 2.此处返回对象，需要执行函数时，调用GroupInterfaceInEffects.selfCalling(name)
             */
            let groupInterface: EffectsInterfaceFunctionEffects = EffectsInterfaceFunctionEffects(effects)

            groupInterface.selfCalling = selfCallingEffects
            return groupInterface
        //}
        //return EffectsInterfaceFunctionEffects(Array<LayerEF>(), isNull: true)
    }

    /*
     * TODO: EffectsManager.effectElements 中储存的 SuperEffect：
     * TODO: GroupEffect.effectElements 中储存的是各个 Effect：
     * SliderEffect/AngleEffect/ColorEffect/PointEffect/CheckboxEffect/
     * LayerIndexEffect/MaskIndexEffect/EffectsManager/NoValueEffect
     * TODO: GroupEffect 和 9个 Effect 是有关联关系的。暂定 SuperEffect 是 9个 Effect 的父类。
     */
    static func createGroupInterface(data: LayerEF, elements: SuperEffect, propertyGroup: LayerExpressionInterface, elem: BaseElement): EffectsInterfaceFunctionGroup {
        let len: Int64 = data.ef.size
        let effectElements: ArrayList<EffectsInterfaceFunction> = ArrayList<EffectsInterfaceFunction>(len)

        func selfCallingGroup(value: Int64, name: String, isString: Bool): ExpressionInterface {
            let effects: Array<Effect> = data.ef
            let len: Int64 = effects.size
            for (i in 0..len) {
                //TODO: LayerEF 中增加成员变量 ix ？？？
                if (name == effects[i].nm || name == effects[i].mn || value == effects[i].ix) {
                    if (effects[i].ty == 5) { //函数 createGroupInterface 的返回值 EffectsInterfaceFunctionGroup。
                        return effectElements[i]
                    }
                    //函数 createValueInterface 的返回值 EffectsInterfaceFunction，
                    //再调用 selfCalling: (Int64, String, Bool)。 得到返回值类型为: ExpressionInterface/ExpressionValue
                    return effectElements[i].selfCalling(0, "", false)
                }
            }
            throw Exception("[createGroupInterface] can not find name = ${value}/${name}.")
        }

        let groupInterface: EffectsInterfaceFunctionGroup = EffectsInterfaceFunctionGroup(data, effectElements)
        let _propertyGroup: (Option<Int64>) -> ExpressionInterface = propertyGroupFactory(groupInterface, propertyGroup.selfCalling)
        
        groupInterface._name = data.nm
        /**
         * 1.返回的groupInterface是函数，但同时具备对象功能。
         * 2.此处返回对象，需要执行函数时，调用GroupInterfaceInGroup.selfCalling(Int64, String, Bool)
         */
        groupInterface.propertyGroup = _propertyGroup
        //通常0、1等于false 、true
        groupInterface.enabled = data.en != 0
        groupInterface.active = groupInterface.enabled

        for (i in 0..len) {
            if (data.ef[i].ty == 5) {
                effectElements.append(createGroupInterface(data.ef[i], elements.effectElements[i], elements.effectElements[i].propertyGroup, elem))
            } else {
                //返回值类型为 EffectsInterfaceFunction
                effectElements.append(createValueInterface(elements.effectElements[i], data.ef[i].ty, elem, _propertyGroup))
            }
        }

        groupInterface.selfCalling = selfCallingGroup
        return groupInterface
    }

    static func createValueInterface(element: SuperEffect, types: Int64, elem: BaseElement, propertyGroup: (Option<Int64>) -> ExpressionInterface): EffectsInterfaceFunction {
        let expressionProperty: () -> ExpressionValue<ContentModelPK, Array<Float64>> = ExpressionPropertyInterface<ContentModelPK, Array<Float64>>(element.p).selfCalling()

        //TODO：返回值类型冲突。 CompExpressionInterface 和 ExpressionValue<ContentModelPK, Array<Float64>> 冲突了。
        //TODO: 将 ExpressionInterface 和 ExpressionValue 进行关联继承？？？
        func selfCallingValue(num: Int64, str: String, isString: Bool): ExpressionInterface {
            if (types == 10) {
                //TODO: 扩展里面 Expressions => animation.renderer.compInterface = CompExpressionInterface(animation.renderer)
                //TODO：未确认 elem.comp.compInterface 函数的具体实现。
                //return elem.comp.compInterface(element.p.v)
            }
            // 返回值类型为 ExpressionValue<ContentModelPK, Array<Float64>>
            return expressionProperty()
        }

        let interfaceFunction: EffectsInterfaceFunction = EffectsInterfaceFunction()

        //TODO: 暂未实现 PropertyFactory.setGroupProperty
        //if (element.p.setGroupProperty) {
        //    //TODO: 暂未实现 PropertyInterface
        //    element.p.setGroupProperty(PropertyInterface("", propertyGroup))
        //}

        interfaceFunction.selfCalling = selfCallingValue
        return interfaceFunction
    }

}
