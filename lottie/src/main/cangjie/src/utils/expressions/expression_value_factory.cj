/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

class ExpressionPropertyInterface<T, E> <: ExpressionInterface where T <: ToString, E <: ToString {

    //var defaultUnidimensionalValue = { pv: 0, v: 0, mult: 1 }
    //var defaultMultidimensionalValue = { pv: [0, 0, 0], v: [0, 0, 0], mult: 1 }
    
    var property: PropertyFactory<T, E>

    public init(property: PropertyFactory<T, E>) {
        this.property = property
    }

    //TODO: 传入的参数是 Array<Keyframe<T>> ？？？ 还是处理后的 PropertyFactory<T, E> ？？？ 
    //TODO: 暂定参数 property 是 处理后的 PropertyFactory<T, E>
    public func selfCalling(): () -> ExpressionValue<T, E> {
        if (property.isNull) {
            return defaultGetter()
        } else if (property.propType == "unidimensional") {
            return unidimensionalPropertyInterface()
        }
        return multidimensionalPropertyInterface()
    }

    //TODO：尽量避免使用此 getter
    func defaultGetter(): () -> ExpressionValue<T, E> {
        func inside(): ExpressionValue<T, E> {
            let propertyEmpty: PropertyFactory<T, E> = PropertyFactory<T, E>(property.data, 0.0, property.container, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())
            propertyEmpty.isNull = true
            //return defaultUnidimensionalValue
            propertyEmpty.pv = [0.0]
            propertyEmpty.v = [0.0]
            propertyEmpty.mult = 1.0
            //TODO: 返回值类型不匹配.
            //return this.property
            return ExpressionValue<T, E>(propertyEmpty)
        }
        return inside
    }

    //TODO: 传入的 property 参数，数据类型是 Array<Keyframe<T>> ？？？ 还是处理后的 PropertyFactory<T, E>
    func completeProperty(expressionValue: ExpressionValue<T, E>, types: String) {
        //TODO: 在开发此函数--20240830
        //Object.defineProperty(expressionValue, "velocity", {
        //  get: function () {
        //    return property.getVelocityAtTime(property.comp.currentFrame)
        //  },
        //})
        //TODO: 没有在 BaseRenderer 中找到 currentFrame，property数据类型需要再确认。
        //expressionValue.velocity = return property.getVelocityAtTime(property.comp.currentFrame)

        expressionValue.numKeys = property.keyframes.size

        func inside(pos: Int64): ValueProp<E> {
            if (expressionValue.numKeys == 0) {
                //return 0
                return ValueProp<E>(types)
            }
            var value: Option<E> = None
            var hasValue: Bool = false
            if (property.keyframes.size > (pos - 1)) {
                if (let Some(v) <- property.keyframes[pos - 1].s) {
                    value = v
                    hasValue = true
                }
            } else if (!hasValue && property.keyframes.size > (pos - 2)) {
                if (let Some(v) <- property.keyframes[pos - 2].e) {
                    value = v
                    hasValue = true
                }
            } else if (!hasValue) {
                value = property.keyframes[pos - 2].s
            }
            //使用 Object.assign({}, obj) 将 obj 对象的属性复制到一个空对象中，从而实现了对 obj 的浅拷贝，即生成了一个 obj 的副本
            //TODO: 特定情况下 value 是 Number 数据类型，types === "unidimensional" ? new Number(value)
            //var valueProp = types === "unidimensional" ? new Number(value) : Object.assign({}, value) // eslint-disable-line no-new-wrappers
            //TODO：自定义一个 valueProp 数据类型。
            //TODO：和 expressionValue.key 中比较，此处应该 valueProp 数据类型应该是 Float64 ？？？
            //TODO：对象和 Float64 冲突了。----------------------------------------------------------------------------------2024.09.05
            var valueProp: ValueProp<E> = ValueProp<E>(types)
            if (types == "unidimensional") {//TODO：此情况下 value 是 Number 数据类型。
                //TODO：怎么替代 Number(value) ？？？
                //valueProp = ValueProp<E>(value)
                valueProp.value = value
                if (value is Array<Float64>) {
                    //TODO: type == 'unidimensional' 时用成员变量 val； 否则用成员变量 value。
                    valueProp.val = (value as Array<Float64>).getOrThrow()[0]
                }
            } else {
                //使用 Object.assign({}, obj) 将 obj 对象的属性复制到一个空对象中，从而实现了对 obj 的浅拷贝，即生成了一个 obj 的副本
                //TODO: 对象拷贝，注意基础数据类型没有 clone 函数。
                //TODO：Array<Keyframe<E>> 中 E 是非 基础数据类型 的，需要实现 clone 函数。
                //valueProp = ValueProp<E>(value.getOrThrow().clone())
                valueProp.value = value
            }

            //TODO: elem.globalData 和 elem.comp.globalData 区别？？？
            //valueProp.time = property.keyframes[pos - 1].t / property.elem.comp.globalData.frameRate
            valueProp.time = property.keyframes[pos - 1].t / property.elemGlobalData.frameRate

            //TODO: 单元素当做一维数组处理。
            //TODO: 此时 value 是泛型，没有办法直接拿到 value[0]，所以将 types 存入，后续获取 valueProp.value，根据 types 确定是拿value[0]还是整个value。
            //valueProp.value = types == "unidimensional" ? value[0] : value
            return valueProp
        }
        //TODO：keyType代表要调用的 key 函数的区别。keyType：0-空；1-调用 key；2-调用 keyInSide
        expressionValue.keyType = 2
        expressionValue.keyInSide = inside
        expressionValue.valueAtTime = property.getValueAtTime
        expressionValue.speedAtTime = property.getSpeedAtTime
        expressionValue.velocityAtTime = property.getVelocityAtTime
        //TODO: ExpressionValue 中暂未拿到 PropertyFactory.propertyGroup 数据类型。
        //expressionValue.propertyGroup = property.propertyGroup
    }


    //TODO: 传入的 property 参数，数据类型是 Array<Keyframe<T>> ？？？ 还是处理后的 PropertyFactory<T, E>
    func unidimensionalPropertyInterface(): () -> ExpressionValue<T, E> {
        //TODO: property.pv ???
        if (property.isNull || property.pv.size == 0) {
            //property = defaultUnidimensionalValue
            property.pv = [0.0]
            property.v = [0.0]
            property.mult = 1.0
        }
        let mult: Float64 = 1.0 / property.mult
        var val: Float64 = property.pv[0] * mult

        //var expressionValue: Float64 = val
        //TODO: 初始化传入的 val 和 expressionValue.value = val，此处是单数值，后面是数组。单数值改为长度为 1 的数组。
        //var expressionValue: ExpressionValue = ExpressionValue([val]) // eslint-disable-line no-new-wrappers
        let expressionValue: ExpressionValue<T, E> = ExpressionValue<T, E>(property, [val])
        expressionValue.value = [val]

        //TODO：暂未实现
        completeProperty(expressionValue, "unidimensional")

        func insideFunction(): ExpressionValue<T, E> {
            if (property.k) {
                property.getValue()
            }
            var vals: Float64 = property.v[0] * mult
            if (expressionValue.value[0] != vals) {
                let expressionValues: ExpressionValue<T, E> = ExpressionValue<T, E>(property, [vals])   // eslint-disable-line no-new-wrappers
                expressionValues.value[0] = vals
                //TODO：暂未实现
                completeProperty(expressionValues, "unidimensional")
                return expressionValues
            }
            return expressionValue
        }
        return insideFunction
    }

    //TODO: 传入的 property 参数，数据类型是 Array<Keyframe<T>> ？？？ 还是处理后的 PropertyFactory<T, E>
    func multidimensionalPropertyInterface(): () -> ExpressionValue<T, E> {
        //TODO: property.pv ???
        if (property.isNull || property.pv.size == 0) {
            //property = defaultMultidimensionalValue
            property.pv = [0.0, 0.0, 0.0]
            property.v = [0.0, 0.0, 0.0]
            property.mult = 1.0
        }
        let mult: Float64 = 1.0 / property.mult

        //var len = (property.data && property.data.l) || property.pv.size
        let len: Int64 = property.pv.size
        //TODO：property.data 是泛型 T，怎么拿到可能存在的 property.data.l ？？？-----------------------------------------------2024.09.06
        //if (property.data && property.data.l != 0) {
        //    len = property.data.l
        //}
        
        let expressionValue: ExpressionValue<T, E> = ExpressionValue<T, E>(property, Array<Float64>(len, item: 0.0))
        let arrValue: Array<Float64> = Array<Float64>(len, item: 0.0)
        expressionValue.value = arrValue
        completeProperty(expressionValue, "multidimensional")

        func insideFunction(): ExpressionValue<T, E> {
            if (property.k) {
                property.getValue()
            }
            for (i in 0..len) {
                arrValue[i] = property.v[i] * mult
                //TODO: 增加成员变量 val，为了能直接给 expressionValue[i] 赋值。
                expressionValue.val[i] = arrValue[i]
            }
            return expressionValue
        }
        return insideFunction
    }

}
