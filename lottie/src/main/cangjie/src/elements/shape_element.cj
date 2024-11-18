/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is IShapeElement.
 */
package lottie.elements

internal import lottie.elements.helpers.shapes.*

public open class IShapeElement <: BaseElement {

    var shapeModifiers: ArrayList<ShapeModifier> = ArrayList<ShapeModifier>()

    //TODO: 自定义数据类型 ProcessedElement。
    var processedElements: ArrayList<ProcessedElement> = ArrayList<ProcessedElement>()
    public var shapes: ArrayList<CvShapeData> = ArrayList<CvShapeData>()

    /**
     * Create a IShapeElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    /**
     * Add shape to modifiers.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.	    // data => CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来
     */
    // data => CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来
    public func addShapeToModifiers(data: CvShapeData): Unit {
        let len: Int64 = this.shapeModifiers.size
        for (i in 0..len) {
            this.shapeModifiers[i].addShape(data)
        }
    }

    /**
     * Determine if it is a shape in the animation modifier.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @return Type of Bool.
     */
    public func isShapeInAnimatedModifiers(data: Layer): Bool {
        var i: Int64 = 0
        let len: Int64 = this.shapeModifiers.size
        for (i in 0..len) {
            //TODO：在 IShapeElement 中定义函数 isAnimatedWithShape，但未找到原函数实现。
            if (this.shapeModifiers[i].isAnimatedWithShape(data)) {
                return true
            }
        }
        return false
    }

    /**
     * Render modifiers.
     */
    public func renderModifiers(): Unit {
        if (this.shapeModifiers.size == 0) {
            return
        }
        var len: Int64 = this.shapes.size
        for (i in 0..len) {
            /*
             * 数据来源分析：this.shapes  ==  CVShapeElement.shapes  == Array<CVShapeData>
             * this.shapes[i].sh  ==  ShapePropertyFactory
             * CVShapeElement.shapes.sh => CVShapeData.sh => ShapePropertyFactory.getShapeProp => KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
             *
             */
            this.shapes[i].sh.resetShape()
        }

        len = this.shapeModifiers.size
        var shouldBreakProcess: Bool = false
        for (i in (len - 1)..=0:-1) {
            shouldBreakProcess = this.shapeModifiers[i].processShapes(this._isFirstFrame)
            //解决中继器重置形状以使以下进程被调用两次的情况的变通方法
            // TODO: find a better solution for this
            if (shouldBreakProcess) {
                break
            }
        }
    }

    /**
     * Search for processed elements.
     *
     * @param elem - Type of BaseElement, search the processed elements.
     * @return Type of Int64, return the pos of the processed element.
     */
    //数据来源分析：elem == ContentModel  <= arr[i] == ContentModel  <=  arr == this.shapesData == Layer.shapes == Array<ContentModel>
    public func searchProcessedElement(elem: ContentModel): Int64 {
        let elements: ArrayList<ProcessedElement> = this.processedElements
        let len: Int64 = elements.size
        for (i in 0..len) {
            if (refEq(elements[i].elem, elem)) {
                return elements[i].pos
            }
        }
        return 0
    }

    /**
     * Add processed elements.
     *
     * @param elem - Type of BaseElement, add processed elements.
     * @param elem - Type of Int64, processed element's pos..
     */
    //数据来源分析：elem == ContentModel  <= arr[i] == ContentModel  <=  arr == this.shapesData == Layer.shapes == Array<ContentModel>
    public func addProcessedElement(elem: ContentModel, pos: Int64): Unit {
        let elements: ArrayList<ProcessedElement> = this.processedElements
        var i: Int64 = elements.size
        while (i != 0) {
            i -= 1
            if (refEq(elements[i].elem, elem)) {
                elements[i].pos = pos
                return
            }
        }
        elements.append(ProcessedElement(elem, pos))
    }
    
    public func prepareFrame(num: Float64) {
        this.prepareRenderableFrame(num)
        this.prepareProperties(num, this.isInRange)
    }
    
    //TODO: 配合 RepeaterModifier 编译用，暂未实现。
    public open func reloadShapes(): Unit {}

}
