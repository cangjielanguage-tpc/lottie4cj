/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

class ValueProp<E> where E <: ToString {

    //TODO: 增加成员变量 val，在 E 是 Float64 时进行赋值。 type == 'unidimensional' 时用此成员变量。
    var val: Float64 = 0.0

    //TODO: value 是泛型，没有办法直接拿到 value[0]，所以将 types 存入，后续获取 valueProp.value，根据 types 确定是拿value[0]还是整个value。
    //TODO: type == 'unidimensional' 时用成员变量 val； 否则用成员变量 value。
    var types: String = ""

    var time: Float64 = 0.0
    var value: Option<E> = None
    
    init(types: String){
        this.types = types
    }
    init(types: String, value: Option<E>) {
        this.types = types
        this.value = value
    }

}

class ExpressionValue<T, E> <: ExpressionInterface where T <: ToString , E <: ToString {

    //TODO: 增加成员变量 val，为了能直接给 expressionValue[i] 赋值。
    var val: Array<Float64> = Array<Float64>()
    
    var value: Array<Float64> = Array<Float64>()
    var numKeys: Int64 = 0
    //TODO：keyType代表要调用的 key 函数的区别。keyType：0-空；1-调用 key；2-调用 keyInSide
    public var keyType: Int64 = 0
    public var keyInSide: (Int64) -> ValueProp<E> = { m => ValueProp<E>("") }

    //TODO: 暂未确定数据类型。
    var valueAtTime: (Float64, Float64) -> Array<Float64> = { m, n => return Array<Float64>() }
    var speedAtTime: (Float64) -> Float64 = { n => return n }
    var velocityAtTime: (Float64) -> Array<Float64> = { n => return [n] }
    //TODO: 暂未拿到 PropertyFactory.propertyGroup 数据类型。
    //var propertyGroup = elementProp.propertyGroup

    //数据来源分析：PropertyFactory.getVelocityAtTime: (Float64) -> Array<Float64>
    public prop velocity: Array<Float64> {
        get() {
            Array<Float64>()
        }
    }

    var elementProp: PropertyFactory<T, E>
    var mult: Float64 = 0.0
    var types: String = ""

    public init(elementProp: PropertyFactory<T, E>){
        this(elementProp, elementProp.mult, "")
    }

    public init(elementProp: PropertyFactory<T, E>, val: Array<Float64>){
        this(elementProp, elementProp.mult, "")
        this.val = val
    }
    public init(elementProp: PropertyFactory<T, E>, mult: Float64, types: String){
        this.elementProp = elementProp
        if (mult != 0.0) {
            this.mult = mult
        } else {
            this.mult = 1.0
        }

        if (elementProp.k) {
            elementProp.getValue()
        }

        var len: Int64 = 0
        var arrValue: Array<Float64> = Array<Float64>()
        var vals: Float64 = 0.0
        if (types != "") {
            if (types == "color") {
                len = 4
                this.val = Array<Float64>(len, item: 0.0)
                arrValue = Array<Float64>(len, item: 0.0)
                for (i in 0..len) {
                    //arrValue[i] = (i < 3) ? elementProp.v[i] * mult : 1
                    if (i < 3) {
                        arrValue[i] = elementProp.v[i] * mult
                    } else {
                        arrValue[i] = 1.0
                    }
                    this.val[i] = arrValue[i]
                }
                this.value = arrValue
            }
        } else if (elementProp.propType == "unidimensional") {
            vals = elementProp.v[0] * mult
            //TODO: 增加成员变量 val，为了能直接给 expressionValue[i] 赋值。
            this.val = [vals]   // eslint-disable-line no-new-wrappers
            this.value = [vals]
        } else {
            len = elementProp.pv.size
            //TODO: 增加成员变量 val，为了能直接给 expressionValue[i] 赋值。
            this.val = Array<Float64>(len, item: 0.0)
            arrValue = Array<Float64>(len, item: 0.0)
            for (i in 0..len) {
                arrValue[i] = elementProp.v[i] * mult
                this.val[i] = arrValue[i]
            }
            this.value = arrValue
        }

        this.numKeys = elementProp.keyframes.size

        //this.key = keyInSide
        this.valueAtTime = elementProp.getValueAtTime
        this.speedAtTime = elementProp.getSpeedAtTime
        this.velocityAtTime = elementProp.getVelocityAtTime
        //TODO: 暂未拿到 PropertyFactory.propertyGroup 数据类型。
        //this.propertyGroup = elementProp.propertyGroup
    }
    
    //func keyInSide(pos: Int64): Float64 {
    func key(pos: Int64): Float64 {
        if (this.numKeys == 0) {
            return 0.0
        }
        return elementProp.keyframes[pos - 1].t
    }

}
