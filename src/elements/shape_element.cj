/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is IShapeElement.
 */
package elements

import elements.helpers.shapes.*

public class IShapeElement <: BaseElement {

    //TODO: 未实现  ShapeModifiers
    var shapeModifiers: Array<ShapeModifiers> = Array<ShapeModifiers>()

    var processedElements: ArrayList<ProcessedElement> = ArrayList<ProcessedElement>()
    
    //TODO: 未实现 CVShapeData
    var shapes: Array<CVShapeData> = Array<CVShapeData>()

    var _isFirstFrame: Bool = false
    
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func addShapeToModifiers(data: Layer): Unit {
        let len: Int64 = this.shapeModifiers.size
        for (i in 0..len) {
            //TODO: 未实现
            this.shapeModifiers[i].addShape(data)
        }
    }

    public func isShapeInAnimatedModifiers(data: Layer): Bool {
        var i: Int64 = 0
        let len: Int64 = this.shapeModifiers.size
        while (i < len) {
            //TODO: 未实现
            if (this.shapeModifiers[i].isAnimatedWithShape(data)) {
                return true
            }
        }
        return false
    }

    public func renderModifiers(): Unit {
        if (this.shapeModifiers.size == 0) {
            return
        }
        //TODO: 未实现
        var len: Int64 = this.shapes.size
        for (i in 0..len) {
            //TODO: 未实现 //this.shapes[i].sh.reset()
        }

        len = this.shapeModifiers.size
        var shouldBreakProcess: Bool = false
        for (i in (len - 1)..=0:-1) {
            //TODO: 未实现
            shouldBreakProcess = this.shapeModifiers[i].processShapes(this._isFirstFrame)
            //解决中继器重置形状以使以下进程被调用两次的情况的变通方法
            //TODO:找到更好的解决方案
            if (shouldBreakProcess) {
                break
            }
        }
    }

    public func searchProcessedElement(elem: BaseElement): Int64 {
        let elements: ArrayList<ProcessedElement> = this.processedElements
        let len: Int64 = elements.size
        for (i in 0..len) {
            //TODO: 需要再确认数据类型
            if (elements[i].elem == elem) {
                return elements[i].pos
            }
        }
        return 0
    }

    public func addProcessedElement(elem: BaseElement, pos: Int64): Unit {
        let elements: ArrayList<ProcessedElement> = this.processedElements
        var i: Int64 = elements.size
        while (i != 0) {
            i -= 1
            //TODO: 需要再确认数据类型
            if (elements[i].elem == elem) {
                elements[i].pos = pos
                return
            }
        }
        //TODO: 未实现ProcessedElement
        elements.append(ProcessedElement(elem, pos))
    }
    
    public func prepareFrame(num: Float64) {
        //TODO: (问题点)仓颉的calss是单继承，调不到 RenderableElement.prepareRenderableFrame  //this.prepareRenderableFrame(num)
        //TODO: (问题点)仓颉的calss是单继承，调不到 FrameElement.prepareProperties //this.prepareProperties(num, this.isInRange)
    }

}
