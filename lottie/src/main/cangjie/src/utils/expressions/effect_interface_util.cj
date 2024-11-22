/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions


/*
 * ty: Int8 (EffectsExpressionInterface 中调用的3个函数的返回值类型，自定义。)
 * ty = 0: EffectsInterfaceFunction         <=  createValueInterface
 * ty = 1: EffectsInterfaceFunctionGroup    <=  createGroupInterface
 * ty = 2: EffectsInterfaceFunctionEffects  <=  createEffectsInterface
 */
public open class EffectsInterfaceFunction <: ExpressionInterface {

    var enabled: Bool = false
    var active: Bool = false
    public var selfCalling: (Int64, String, Bool) -> ExpressionInterface = { m,n,b => return ExpressionInterface() }

    public init(){}

    public open mut prop numProperties: Int64 {
        get() { -1 }
        set(value) {
            _numProperties = -1
        }
    }

    /**
     * Obtain the type of EffectsInterfaceFunction.
     */
    public open prop ty: Int8 {
        get() { 0 }
    }
}

public class EffectsInterfaceFunctionGroup <: EffectsInterfaceFunction {

    var effectElements: ArrayList<EffectsInterfaceFunction>
    var propertyGroup: (Option<Int64>) -> ExpressionInterface = { m => return ExpressionInterface() }

    var data: LayerEF

    init(data: LayerEF, effectElements: ArrayList<EffectsInterfaceFunction>, isNull!: Bool = false){
        this.data = data
        this.effectElements = effectElements
        this.isNull = isNull
    }

    public mut prop numProperties: Int64 {
        get() { this.data.np }
        set(value) {
            _numProperties = value
        }
    }

    /**
     * Obtain the type of EffectsInterfaceFunctionGroup/createGroupInterface.
     */
    public open prop ty: Int8 {
        get() { 1 }
    }

}

public class EffectsInterfaceFunctionEffects <: EffectsInterfaceFunction {

    var effects: Array<LayerEF>

    init(effects: Array<LayerEF>, isNull!: Bool = false){
        this.effects = effects
        this.isNull = isNull
    }

    /**
     * Obtain the type of EffectsInterfaceFunctionEffects.
     */
    public open prop ty: Int8 {
        get() { 2 }
    }

    public mut prop numProperties: Int64 {
        get() { this.effects.size }
        set(value) {
            _numProperties = value
        }
    }

}
