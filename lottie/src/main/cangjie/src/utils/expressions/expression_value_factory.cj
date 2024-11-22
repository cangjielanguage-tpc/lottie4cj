/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

class ExpressionPropertyInterface<T, E> <: ExpressionInterface where T <: ToString, E <: ToString {

    var property: PropertyFactory<T, E>

    public init(property: PropertyFactory<T, E>) {
        this.property = property
    }

    public func selfCalling(): () -> ExpressionValue<T, E> {
        if (property.isNull) {
            return defaultGetter()
        } else if (property.propType == "unidimensional") {
            return unidimensionalPropertyInterface()
        }
        return multidimensionalPropertyInterface()
    }

    func defaultGetter(): () -> ExpressionValue<T, E> {
        func inside(): ExpressionValue<T, E> {
            let propertyEmpty: PropertyFactory<T, E> = PropertyFactory<T, E>(property.data, 0.0, property.container[0], GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())
            propertyEmpty.isNull = true
            propertyEmpty.pv = [0.0]
            propertyEmpty.v = [0.0]
            propertyEmpty.mult = 1.0
            return ExpressionValue<T, E>(propertyEmpty)
        }
        return inside
    }

    func completeProperty(expressionValue: ExpressionValue<T, E>, types: String) {
        expressionValue.numKeys = property.keyframes.size

        func inside(pos: Int64): ValueProp<E> {
            if (expressionValue.numKeys == 0) {
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
            /* 使用 Object.assign({}, obj) 将 obj 对象的属性复制到一个空对象中，从而实现了对 obj 的浅拷贝，即生成了一个 obj 的副本 */
            var valueProp: ValueProp<E> = ValueProp<E>(types)
            if (types == "unidimensional") {
                valueProp.value = value
                if (value is Array<Float64>) {
                    valueProp.val = (value as Array<Float64>).getOrThrow()[0]
                }
            } else {
                /* 使用 Object.assign({}, obj) 将 obj 对象的属性复制到一个空对象中，从而实现了对 obj 的浅拷贝，即生成了一个 obj 的副本 */
                valueProp.value = value
            }

            valueProp.time = property.keyframes[pos - 1].t / property.elemGlobalData.frameRate

            return valueProp
        }
        /* keyType代表要调用的 key 函数的区别。keyType：0-空；1-调用 key；2-调用 keyInSide */
        expressionValue.keyType = 2
        expressionValue.keyInSide = inside
        expressionValue.valueAtTime = property.getValueAtTime
        expressionValue.speedAtTime = property.getSpeedAtTime
        expressionValue.velocityAtTime = property.getVelocityAtTime
    }

    func unidimensionalPropertyInterface(): () -> ExpressionValue<T, E> {
        if (property.isNull || property.pv.size == 0) {
            property.pv = [0.0]
            property.v = [0.0]
            property.mult = 1.0
        }
        let mult: Float64 = 1.0 / property.mult
        var val: Float64 = property.pv[0] * mult

        let expressionValue: ExpressionValue<T, E> = ExpressionValue<T, E>(property, [val])
        expressionValue.value = [val]

        completeProperty(expressionValue, "unidimensional")

        func insideFunction(): ExpressionValue<T, E> {
            if (property.k) {
                property.getValue()
            }
            var vals: Float64 = property.v[0] * mult
            if (expressionValue.value[0] != vals) {
                let expressionValues: ExpressionValue<T, E> = ExpressionValue<T, E>(property, [vals])   /* eslint-disable-line no-new-wrappers */
                expressionValues.value[0] = vals
                completeProperty(expressionValues, "unidimensional")
                return expressionValues
            }
            return expressionValue
        }
        return insideFunction
    }

    func multidimensionalPropertyInterface(): () -> ExpressionValue<T, E> {
        if (property.isNull || property.pv.size == 0) {
            property.pv = [0.0, 0.0, 0.0]
            property.v = [0.0, 0.0, 0.0]
            property.mult = 1.0
        }
        let mult: Float64 = 1.0 / property.mult

        let len: Int64 = property.pv.size
        
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
                expressionValue.val[i] = arrValue[i]
            }
            return expressionValue
        }
        return insideFunction
    }

}
