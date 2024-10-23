/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
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

    //父类中已有  //var _name: String = ""
    var enabled: Bool = false
    var active: Bool = false
    //父类中已有  //public var isNull: Bool = false
    public var selfCalling: (Int64, String, Bool) -> ExpressionInterface = { m,n,b => return ExpressionInterface() }

    public init(){}
    //public init(selfCalling: (Int64, String, Bool) -> ExpressionInterface){
    //    this.selfCalling = selfCalling
    //}

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

//createGroupInterface
public class EffectsInterfaceFunctionGroup <: EffectsInterfaceFunction {

    //TODO：effectElements[i] 的数据类型未确认。暂定是自定义数据类型 EffectsInterfaceFunction。
    var effectElements: ArrayList<EffectsInterfaceFunction>
    var propertyGroup: (Option<Int64>) -> ExpressionInterface = { m => return ExpressionInterface() }

    var data: LayerEF

    init(data: LayerEF, effectElements: ArrayList<EffectsInterfaceFunction>, isNull!: Bool = false){
        //super(selfCalling)
        this.data = data
        this.effectElements = effectElements
        this.isNull = isNull
    }

    /*
    public mut prop color: Option<ExpressionInterface> {
        get() {
            //TODO: LayerEF 中增加成员变量 mn ？？？
            if (data.mn == "ADBE Color Control") {
                //TODO: 未参调用？？？少一个参数？？？
                return this.effectElements[0].selfCalling(0, "", false)
            }
            return None
        }
    }*/

    public mut prop numProperties: Int64 {
        //TODO: LayerEF 中增加成员变量 np ？？？
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

//createEffectsInterface
public class EffectsInterfaceFunctionEffects <: EffectsInterfaceFunction {

    var effects: Array<LayerEF>

    init(effects: Array<LayerEF>, isNull!: Bool = false){
        //super(selfCalling)
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
