/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is LayerExpressionInterface.
 */
package lottie.utils.expressions

internal import lottie.model.*
internal import lottie.elements.*
internal import lottie.bezier.*
internal import lottie.*

public class LayerExpressionInterface <: ExpressionInterface {

    //TODO：未实现 ShapeExpressionInterface  //var shapeInterface: ShapeExpressionInterface
    //TODO：未实现 TextExpressionInterface   //var textInterface: TextExpressionInterface


    var mask: Option<MaskManagerInterface> = None

    //TODO: 未实现 TransformExpressionInterface //var transformInterface = TransformExpressionInterface(elem.finalTransform.mProp) //var anchorPointDescriptor = transformInterface.anchorPoint
    //TODO: 未实现 Object.defineProperties
    //TODO: 未实现 rotation/scale/positionopacity
    //TODO: 未实现 anchorPoint/anchor_point
    //TODO: element各个子类型中，sourceRectAtTime 函数返回值类型是不一样的 //var sourceRectAtTime: () -> (可变类型) = elem.sourceRectAtTime
    public var sourceRectAtTime: () -> SourceRect = { => return SourceRect() }

    public var startTime: Float64 = 0.0
    public var index: Int64 = 0
    public var source: String = ""
    public var height: Float64 = 0.0
    public var width: Float64 = 0.0
    public var inPoint: String = ""
    public var outPoint: String = ""
    //父类中已有  //public var _name: String = ""

    //TODO: 未实现 registerMaskInterface/registerEffectsInterface


    /*
     * 初始化后需要传入2个函数：
     * 1. isInRangeInElem(): Bool => 间接获取 this.elem.isInRange 可变的当时的值。
     * 2. renderedFrameInElemComp() => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
     */
    //TODO: 解构 BaseElement 和 LayerExpressionInterface
    var elemData: Layer
    var elemGlobalData: GlobalData
    var isInRangeInElem: () -> Bool = { => return false }
    //TODO：未实现 elem.hierarchy
    var invertPoint: (Matrix, Array<Float64>) -> Array<Float64> = { m, n => return n}
    var applyPoint: (Matrix, Array<Float64>) -> Array<Float64> = { m, n => return n}
    var fromComp: (Array<Float64>) -> Array<Float64> = { n => return n}
    //TODO：未实现 elem.hierarchy 
    public var hasParent: () -> Int64 = { => 0 }  //等于 this.elemHierarchy.size
    //TODO：初始化受阻。
    //public var parent: () -> LayerExpressionInterface = { => this }

    /**
     * Create a LayerExpressionInterface instance based on the parameter.
     *
     * @param elemData - Type of Layer.
     */
    public init(elemData: Layer, elemGlobalData: GlobalData) {
        this.elemData = elemData
        this.elemGlobalData = elemGlobalData
        //this.elemHierarchy = elemHierarchy  //, elemHierarchy: ArrayList<HierarchyElement>

        this.startTime = elemData.st
        this.index = elemData.ind
        this.source = elemData.refId

        this.height = 100.0
        if (elemData.ty == 0) {
            this.height = elemData.h
        }

        this.width = 100.0
        if (elemData.ty == 0) {
            this.width = elemData.w
        }
        //TODO: 未完全实现 elem.comp (RendererBase / CanvasRendererBase) 
        //this.inPoint = elemData.ip / elemGlobalData.frameRate 
        //this.outPoint = elemData.op / elemGlobalData.frameRate
        this._name = elemData.nm
    }
    
    //TODO：未实现 TransformExpressionInterface //public prop transform: TransformExpressionInterface { get() { transformInterface } }
    
    /**
     * Obtain the isInRange value of Layer in BaseElement.
     */
    public prop active: Bool {
        get() { isInRangeInElem() }
    }


    //TODO: 未实现 EffectsExpressionInterface //func registerEffectsInterface(effects: EffectsExpressionInterface): Unit { this.effect = effects }

    /**
     * Internal self calling function.
     *
     * @param name - Type of String.
     * @param num - Type of Int64.
     * @return Type of Option<ExpressionInterface>.
     */
    //TODO: 返回值类型需要再确认 - 此行函数名称 inside-2，函数类型为 (name) -> Option<>

    /**
     * Internal self calling function.
     *
     * @param name - Type of String.
     * @param num - Type of Int64.
     * @return Type of Option<ExpressionInterface>.
     */
    //TODO: 返回值类型需要再确认 - 此行函数名称 inside-2，函数类型为 (name) -> Option<>
    public func selfCalling(num: Option<Int64>): ExpressionInterface {
        this.selfCalling("", num ?? 0, false)
    }
    public func selfCalling(name: String, num: Int64, isString: Bool): ExpressionInterface {
        if (name == "ADBE Root Vectors Group" || name == "Contents" || num == 2) {
            //TODO：未实现 ShapeExpressionInterface 
            //return _thisLayerFunction.shapeInterface
        }
        if (num == 1 || num == 6 || name == "Transform" || name == "transform" || name == "ADBE Transform Group") {
            //TODO: 未实现 TransformExpressionInterface 
            //return transformInterface
        }
        if (num == 4 || name == "ADBE Effect Parade" || name == "effects" || name == "Effects") {
            //TODO: 未实现 EffectsExpressionInterface 
            //return _thisLayerFunction.effect
        }
        if (name == "ADBE Text Properties") {
            //TODO：未实现 TextExpressionInterface  
            //return _thisLayerFunction.textInterface
        }
        return this
    }

    public func getMatrix(time: Option<Float64>): Matrix {
        let toWorldMat = Matrix()
        if (let Some(v) <- time) {
            //TODO：未实现 this._elem.finalTransform //var propMatrix = this._elem.finalTransform.mProp.getValueAtTime(v) //propMatrix.clone(toWorldMat)
        } else {
            //TODO：未实现 this._elem.finalTransform //var transformMat = this._elem.finalTransform.mProp //transformMat.applyToMatrix(toWorldMat)
        }
        return toWorldMat
    }

    func toWorldVec(arr: Array<Float64>, time: Option<Float64>): Array<Float64> {
        let toWorldMat: Matrix = this.getMatrix(time)
        toWorldMat.props[12] = 0.0
        toWorldMat.props[13] = 0.0
        toWorldMat.props[14] = 0.0
        return this.applyPoint(toWorldMat, arr)
    }

    public func toWorld(arr: Array<Float64>, time: Option<Float64>): Array<Float64> {
        let toWorldMat: Matrix = this.getMatrix(time)
        return this.applyPoint(toWorldMat, arr)
    }

    public func fromWorldVec(arr: Array<Float64>, time: Option<Float64>): Array<Float64> {
        let toWorldMat: Matrix = this.getMatrix(time)
        toWorldMat.props[12] = 0.0
        toWorldMat.props[13] = 0.0
        toWorldMat.props[14] = 0.0
        return this.invertPoint(toWorldMat, arr)
    }

    public func fromWorld(arr: Array<Float64>, time: Option<Float64>): Array<Float64> {
        let toWorldMat: Matrix = this.getMatrix(time)
        return this.invertPoint(toWorldMat, arr)
    }

    public func sampleImage(): Array<Float64> {
        return [1.0, 1.0, 1.0, 1.0]
    }

    //TODO: 结构 MaskElement 和 MaskManagerInterface/LayerExpressionInterface 关联关系。
    //public func registerMaskInterface(maskManager: MaskElement): Unit { this.mask = MaskManagerInterface(maskManager) }
    public func registerMaskInterface(viewData: Array<ViewData>, masksProperties: Array<Mask>): Unit {
        this.mask = MaskManagerInterface(viewData, masksProperties)
    }

    //TODO: 未实现 EffectsExpressionInterface //func registerEffectsInterface(effects: EffectsExpressionInterface): Unit { this.effect = effects }

}
