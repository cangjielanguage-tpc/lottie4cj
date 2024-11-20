/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is propertyGroupFactory.
 */
package lottie.utils.expressions
//public func propertyGroupFactory(interfaceFunction: ExpressionInterface, parentPropertyGroup: (Option<Int64>) -> LayerExpressionInterface): (Option<Int64>) -> ExpressionInterface {
public func propertyGroupFactory(interfaceFunction: ExpressionInterface, parentPropertyGroup: (Option<Int64>) -> ExpressionInterface): (Option<Int64>) -> ExpressionInterface {
    func inside(val: Option<Int64>): ExpressionInterface {
        var val2: Int64 = 1
        if (let Some(v) <- val) {
            val2 = v
        }
        if (val2 <= 0) {
            //TODO: 返回值类型是自定义的 ExpressionInterface
            return interfaceFunction
        }
        //TODO: 返回值类型是 LayerExpressionInterface
        return parentPropertyGroup(val2 - 1)
    }
    return inside
}
