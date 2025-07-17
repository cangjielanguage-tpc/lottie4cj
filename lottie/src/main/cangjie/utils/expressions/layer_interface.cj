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

    var mask: Option<MaskManagerInterface> = None

    public var sourceRectAtTime: () -> SourceRect = { => return SourceRect() }

    public var startTime: Float64 = 0.0
    public var index: Int64 = 0
    public var source: String = ""
    public var height: Float64 = 0.0
    public var width: Float64 = 0.0
    public var inPoint: String = ""
    public var outPoint: String = ""

    /*
     * 初始化后需要传入2个函数：
     * 1. isInRangeInElem(): Bool => 间接获取 this.elem.isInRange 可变的当时的值。
     * 2. renderedFrameInElemComp() => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
     */
    var elemData: Layer
    var elemGlobalData: GlobalData
    var isInRangeInElem: () -> Bool = { => return false }
    var invertPoint: (Matrix, Array<Float64>) -> Array<Float64> = { m, n => return n}
    var applyPoint: (Matrix, Array<Float64>) -> Array<Float64> = { m, n => return n}
    var fromComp: (Array<Float64>) -> Array<Float64> = { n => return n}
    public var hasParent: () -> Int64 = { => 0 }

    /**
     * Create a LayerExpressionInterface instance based on the parameter.
     *
     * @param elemData - Type of Layer.
     */
    public init(elemData: Layer, elemGlobalData: GlobalData) {
        this.elemData = elemData
        this.elemGlobalData = elemGlobalData

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
        this._name = elemData.nm
    }

    /**
     * Obtain the isInRange value of Layer in BaseElement.
     */
    public prop active: Bool {
        get() { isInRangeInElem() }
    }

    /**
     * Internal self calling function.
     *
     * @param name - Type of String.
     * @param num - Type of Int64.
     * @return Type of Option<ExpressionInterface>.
     */
    public func selfCalling(num: Option<Int64>): ExpressionInterface {
        this.selfCalling("", num ?? 0, false)
    }
    public func selfCalling(name: String, num: Int64, isString: Bool): ExpressionInterface {
        if (name == "ADBE Root Vectors Group" || name == "Contents" || num == 2) {
            /* 待实现 ShapeExpressionInterface -- return _thisLayerFunction.shapeInterface */
        }
        if (num == 1 || num == 6 || name == "Transform" || name == "transform" || name == "ADBE Transform Group") {
            /* 待实现 TransformExpressionInterface --return transformInterface */
        }
        if (num == 4 || name == "ADBE Effect Parade" || name == "effects" || name == "Effects") {
            /* 待实现 EffectsExpressionInterface --return _thisLayerFunction.effect */
        }
        if (name == "ADBE Text Properties") {
            /* 待实现 TextExpressionInterface  --return _thisLayerFunction.textInterface */
        }
        return this
    }

    public func getMatrix(time: Option<Float64>): Matrix {
        let toWorldMat = Matrix()
        if (let Some(v) <- time) {
            /*
             * 待实现 this._elem.finalTransform 
             * var propMatrix = this._elem.finalTransform.mProp.getValueAtTime(v) 
             * propMatrix.clone(toWorldMat)
             */
        } else {
            /*
             * 待实现 this._elem.finalTransform 
             * var transformMat = this._elem.finalTransform.mProp 
             * transformMat.applyToMatrix(toWorldMat)
             */
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

    public func registerMaskInterface(viewData: Array<ViewData>, masksProperties: Array<Mask>): Unit {
        this.mask = MaskManagerInterface(viewData, masksProperties)
    }

}
