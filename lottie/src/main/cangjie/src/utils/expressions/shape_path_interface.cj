/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

/* 6. [ShapePath] = "layers"."shapes".{"ty": "sh"} = ShapePathParser */
public class ShapePathInterface <: ToString {

    var _shape: ShapePath
    var view: ContentModel
    var propertyGroup: LayerExpressionInterface

    var _name: String
    var ix: Int64 = 0
    var propertyIndex: Int64 = 0
    var mn: String = ""

    var props: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())

    public init(shape: ShapePath, view: ContentModel, propertyGroup: LayerExpressionInterface) {
        this._shape = shape
        this.view = view
        this.propertyGroup = propertyGroup

        this._name = shape.nm
        this.props.isNull = true
    }

    func selfCalling(val: String): ShapePropertyFactory {
        if (val == "Shape" || val == "shape" || val == "Path" || val == "path" || val == "ADBE Vector Shape") {
            return this.path
        }
        let spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())
        spf.isNull = true
        return spf
    }

    func selfCalling(val: Int64): ShapePropertyFactory {
        if (val == 2) {
            return this.path
        }
        let spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())
        spf.isNull = true
        return spf
    }

    public prop path: ShapePropertyFactory {
        get() {
            if (props.k) {
                props.getValue()
            }
            return props
        }
    }
    public prop shape: ShapePropertyFactory {
        get() {
            if (props.k) {
                props.getValue()
            }
            return props
        }
    }

    public func toString(): String{return ""}

}
