/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is PropertyInterface.
 */
package lottie.property


public class PropertyInterface <: ExpressionInterface  {

    public var propertyGroup: (Option<Int64>) -> ExpressionInterface = { m => return ExpressionInterface() }

    public init(){
        this.isNull = true
    }
    
    public init(propertyName: String, propertyGroup: (Option<Int64>) -> ExpressionInterface) {
        this._name = propertyName
        this.propertyGroup = propertyGroup
    }

    func _propertyGroup(val: Option<Int64>): ExpressionInterface {
        var val2: Int64 = 1
        if (let Some(v) <- val) {
            val2 = v
        }
        if (val2 <= 0) {
            return this
        }
        return propertyGroup(val2 - 1)
    }

}
