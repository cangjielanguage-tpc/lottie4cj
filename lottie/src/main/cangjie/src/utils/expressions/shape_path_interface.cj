/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

//6. [ShapePath] = "layers"."shapes".{"ty": "sh"} = ShapePathParser
public class ShapePathInterface <: ToString {

    var _shape: ShapePath
    var view: ContentModel
    var propertyGroup: LayerExpressionInterface

    var _name: String
    var ix: Int64 = 0
    var propertyIndex: Int64 = 0
    var mn: String = ""
    //var propertyGroup: LayerExpressionInterface

    //TODO: 暂未确认 props/view.sh 数据类型，暂定为 ShapePropertyFactory。
    //TODO: 暂未拿不到 view.sh 数据，直接初始化一个空的 ShapePropertyFactory。
    var props: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())

    public init(shape: ShapePath, view: ContentModel, propertyGroup: LayerExpressionInterface) {
        this._shape = shape
        this.view = view
        this.propertyGroup = propertyGroup
        
        //TODO: 暂未确认 props/view.sh 数据类型，暂定为 ShapePropertyFactory。
        //this.props = view.sh

        this._name = shape.nm
        //TODO:  ShapePath 中增加成员变量 ix ？？？
        //this.ix = shape.ix
        //this.propertyIndex = shape.ix
        //TODO:  ShapePath 中增加成员变量 mn ？？？
        //this.mn = shape.mn
        //this.propertyGroup = propertyGroup

        this.props.isNull = true
    }

    func selfCalling(val: String): ShapePropertyFactory {
        if (val == "Shape" || val == "shape" || val == "Path" || val == "path" || val == "ADBE Vector Shape") {
            return this.path
        }
        //return None
        let spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, GlobalData(), Layer(), dynamicProperties: ArrayList<DynamicPropertyContainer>())
        spf.isNull = true
        return spf
    }

    func selfCalling(val: Int64): ShapePropertyFactory {
        if (val == 2) {
            return this.path
        }
        //return None
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
