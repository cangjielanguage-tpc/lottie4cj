/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package utils.expressions

import model.*
import elements.*
import third_party.*

public class LayerExpressionInterface {

    var _elem: BaseElement

    //TODO：未实现 ShapeExpressionInterface  //var shapeInterface: ShapeExpressionInterface
    //TODO：未实现 TextExpressionInterface   //var textInterface: TextExpressionInterface

    /**
     * Create a LayerExpressionInterface instance based on the parameter.
     *
     * @param elem - Type of BaseElement, the elem value.
     */
    public init(elem: BaseElement) {
        this._elem = elem
    }

    func getMatrix(time: Option<Float64>): Matrix {
        let toWorldMat = Matrix()
        if (let Some(v) <- time) {
            //TODO：未实现 this._elem.finalTransform //var propMatrix = this._elem.finalTransform.mProp.getValueAtTime(v) //propMatrix.clone(toWorldMat)
        } else {
            //TODO：未实现 this._elem.finalTransform //var transformMat = this._elem.finalTransform.mProp //transformMat.applyToMatrix(toWorldMat)
        }
        return toWorldMat
    }

    func toWorldVec(arr: Array<Float64>, time: Option<Float64>): (Float64, Float64, Float64) {
        let toWorldMat: Matrix = this.getMatrix(time)
        toWorldMat.props[12] = 0.0
        toWorldMat.props[13] = 0.0
        toWorldMat.props[14] = 0.0
        return this.applyPoint(toWorldMat, arr)
    }

    func toWorld(arr: Array<Float64>, time: Option<Float64>): (Float64, Float64, Float64) {
        let toWorldMat: Matrix = this.getMatrix(time)
        return this.applyPoint(toWorldMat, arr)
    }

    func fromWorldVec(arr: Array<Float64>, time: Option<Float64>): (Float64, Float64, Float64) {
        let toWorldMat: Matrix = this.getMatrix(time)
        toWorldMat.props[12] = 0.0
        toWorldMat.props[13] = 0.0
        toWorldMat.props[14] = 0.0
        return this.invertPoint(toWorldMat, arr)
    }

    func fromWorld(arr: Array<Float64>, time: Option<Float64>): (Float64, Float64, Float64) {
        let toWorldMat: Matrix = this.getMatrix(time)
        return this.invertPoint(toWorldMat, arr)
    }

    func applyPoint(matrix: Matrix, arr: Array<Float64>): (Float64, Float64, Float64) {
        //TODO：未实现 elem.hierarchy
        /*
        if (this._elem.hierarchy && this._elem.hierarchy.length) {
            let len = this._elem.hierarchy.length
            for (i in 0..len) {
                this._elem.hierarchy[i].finalTransform.mProp.applyToMatrix(matrix)
            }
        }
        */
        var param2: Float64 = 0.0
        if (arr.size >= 3) {
            param2 = arr[2]
        }
        return matrix.applyToPointArray(arr[0], arr[1], param2)
    }

    func invertPoint(matrix: Matrix, arr: Array<Float64>): (Float64, Float64, Float64) {
        //TODO：未实现 elem.hierarchy
        /*
        if (this._elem.hierarchy && this._elem.hierarchy.length) {
            var len = this._elem.hierarchy.length
            for (i in 0..len) {
                this._elem.hierarchy[i].finalTransform.mProp.applyToMatrix(matrix)
            }
        }
        */
        return matrix.inversePoint(arr)
    }

    func fromComp(arr: Array<Float64>): (Float64, Float64, Float64) {
        let toWorldMat: Matrix = Matrix()
        toWorldMat.reset()
        //TODO：未实现 this._elem.finalTransform  //this._elem.finalTransform.mProp.applyToMatrix(toWorldMat)
        //TODO：未实现 elem.hierarchy
        /*
        if (this._elem.hierarchy && this._elem.hierarchy.length) {
            var len = this._elem.hierarchy.length
            for (i in 0..len) {
                this._elem.hierarchy[i].finalTransform.mProp.applyToMatrix(toWorldMat)
            }
            return toWorldMat.inversePoint(arr)
        }
        */
        return toWorldMat.inversePoint(arr)
    }

    func sampleImage(): Array<Float64> {
        return [1.0, 1.0, 1.0, 1.0]
    }

    /**
     * lottieArkTS原理：
     * 1. LayerExpressionInterface初始化自动，返回，函数 [inside-1]。     (inside-1 的函数类型为 (elem) -> (name) -> Option<>)
     * 2. 执行函数 inside-1，自动返回，函数 [inside-2]。                  (inside-2 的函数类型为 (name) -> Option<>)
     *
     * cangjie原理：
     * 1. LayerExpressionInterface初始化，再返回该实例的selfCalling函数（即函数 inside-1）
     * 2. 执行 LayerExpressionInterface.selfCalling 函数（即函数 inside-1），返回 ThisLayerFunction 类（即函数 inside-2 的类结构，具体执行时调用其selfCalling函数）
     *
     * 备注：因为 inside-2 函数的参数 name, 可以是 String 或者 Int64，适配修改为2个参数(name, num)
     */
     
    /**
     * Internal self calling function.
     *
     * @param elem - Type of BaseElement, layer element instance.
     * @return Type of ThisLayerFunctionComp.
     */
    public func selfCalling(elem: BaseElement): ThisLayerFunction {
        let _thisLayerFunction = ThisLayerFunction(elem, this)
        /**
         * 1.返回的_thisLayerFunction是函数，但同时具备对象功能。
         * 2.此处返回对象，需要执行函数时，调用ThisLayerFunction.selfCalling(name, num)
         *
         * _thisLayerFunction.selfCalling 函数，就是对应的 inside-2 函数，其函数类型为 (name:String, num:Int64) -> Option<compInterface>
         */
        return _thisLayerFunction
    }

}

public class ThisLayerFunction {

    var mask: MaskManagerInterface
    
    //TODO: 未实现 EffectsExpressionInterface  //var effect: EffectsExpressionInterface
    
    var layerExpression: LayerExpressionInterface
    var elem: BaseElement

    //TODO: 未实现 TransformExpressionInterface //var transformInterface = TransformExpressionInterface(elem.finalTransform.mProp) //var anchorPointDescriptor = transformInterface.anchorPoint

    //TODO: 未实现 Object.defineProperties

    //TODO: 未实现 rotation/scale/positionopacity
    //TODO: 未实现 anchorPoint/anchor_point

    var getMatrix: (Option<Float64>) -> Matrix
    var invertPoint: (Matrix, Array<Float64>) -> (Float64, Float64, Float64)
    var applyPoint: (Matrix, Array<Float64>) -> (Float64, Float64, Float64)
    var toWorld: (Array<Float64>, Option<Float64>) -> (Float64, Float64, Float64)
    var toWorldVec: (Array<Float64>, Option<Float64>) -> (Float64, Float64, Float64)
    var fromWorld: (Array<Float64>, Option<Float64>) -> (Float64, Float64, Float64)
    var fromWorldVec: (Array<Float64>, Option<Float64>) -> (Float64, Float64, Float64)
    var toComp: (Array<Float64>, Option<Float64>) -> (Float64, Float64, Float64)
    var fromComp: (Array<Float64>) -> (Float64, Float64, Float64)
    var sampleImage: () -> Array<Float64>

    //TODO: element各个子类型中，sourceRectAtTime 函数返回值类型是不一样的 //var sourceRectAtTime: () -> (可变类型) = elem.sourceRectAtTime
    var sourceRectAtTime: () -> Any

    var startTime: Float64 = 0.0
    var index: Int64 = 0
    var source: String = ""
    var height: Float64 = 0.0
    var width: Float64 = 0.0
    var inPoint: String = ""
    var outPoint: String = ""
    var _name: String = ""

    //TODO: 未实现 registerMaskInterface/registerEffectsInterface

    /**
     * Create a ThisLayerFunction instance based on parameters.
     *
     * @param elem - Type of BaseElement.
     * @param layerExpression - Type of LayerExpressionInterface.
     */
    public init(elem: BaseElement, layerExpression: LayerExpressionInterface) {
        this.elem = elem
        this.layerExpression = layerExpression
        
        this.startTime = elem.data.st
        this.index = elem.data.ind
        this.source = elem.data.refId

        this.height = 100.0
        if (elem.data.ty == 0) {
            this.height = elem.data.h
        }

        this.width = 100.0
        if (elem.data.ty == 0) {
            this.width = elem.data.w
        }
        //TODO: 未完全实现 elem.comp (RendererBase / CanvasRendererBase) //this.inPoint = elem.data.ip / elem.comp.globalData.frameRate //this.outPoint = elem.data.op / elem.comp.globalData.frameRate
        this._name = elem.data.nm

        this.getMatrix = layerExpression.getMatrix
        this.invertPoint = layerExpression.invertPoint
        this.applyPoint = layerExpression.applyPoint
        this.toWorld = layerExpression.toWorld
        this.toWorldVec = layerExpression.toWorldVec
        this.fromWorld = layerExpression.fromWorld
        this.fromWorldVec = layerExpression.fromWorldVec
        this.toComp = layerExpression.toWorld
        this.fromComp = layerExpression.fromComp
        this.sampleImage = layerExpression.sampleImage
        this.sourceRectAtTime = elem.sourceRectAtTime
        
        //TODO: 未实现，编译用
        this.mask = MaskManagerInterface(elem)
    }

    //TODO：未实现 elem.hierarchy //public prop hasParent: Int64 { get() { elem.hierarchy.length } }
    //TODO：未实现 elem.hierarchy //public prop parent: { get() { return elem.hierarchy[0].layerInterface } }
    
    //TODO：未实现 TransformExpressionInterface //public prop transform: TransformExpressionInterface { get() { transformInterface } }
    
    /**
     * Obtain the isInRange value of Layer in BaseElement.
     */
    public prop active: Bool {
        get() { elem.isInRange }
    }

    func registerMaskInterface(maskManager: ViewData): Unit {
        this.mask = MaskManagerInterface(maskManager, elem)
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
    public func selfCalling(name: String, num: Int64): Option<ExpressionInterface> {
        if (name == "ADBE Root Vectors Group" || name == "Contents" || num == 2) {
            //TODO：未实现 ShapeExpressionInterface //return _thisLayerFunction.shapeInterface
            return None
        }
        if (num == 1 || num == 6 || name == "Transform" || name == "transform" || name == "ADBE Transform Group") {
            //TODO: 未实现 TransformExpressionInterface //return transformInterface
            return None
        }
        if (num == 4 || name == "ADBE Effect Parade" || name == "effects" || name == "Effects") {
            //TODO: 未实现 EffectsExpressionInterface //return _thisLayerFunction.effect
            return None
        }
        if (name == "ADBE Text Properties") {
            //TODO：未实现 TextExpressionInterface //return _thisLayerFunction.textInterface
            return None
        }
        return None
    }

}
