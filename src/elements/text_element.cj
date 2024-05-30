/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is ITextElement.
 */
package elements

import third_party.*
import utils.shapes.*

import utils.text.*

from std import math.*

public class ITextElement <: BaseElement {

    public var lettersChangedFlag: Bool = true
    
    //TODO:需要解构 ITextElement 和 TextProperty 互调用。
    //TODO: 改成 TextProperty 中只传入 ITextElement 中部分函数和值
    public var textProperty: TextProperty
    
    //TODO: 未实现 TextAnimatorProperty    //public var textAnimator: TextAnimatorProperty

    //public var data: Layer
    //public var globalData: GlobalData
    //TODO: 未完全实现 RendererBase / CanvasRendererBase        //public var comp: RendererBase

    /**
     * Create a ITextElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        //此调用 this.initBaseData(data, globalData, comp) 等同于 BaseElement.init
        
        super(data, globalData)
        //this.data = data
        //this.globalData = globalData
        this.lettersChangedFlag = true
        
        //TODO:需要解构 ITextElement 和 TextProperty 互调用。
        //TODO: 改成 TextProperty 中只传入 ITextElement 中部分函数和值
        this.textProperty = TextProperty(this.globalData, data.t)
    }

    //TODO: 未实现
    public func addDynamicProperty(tp: TextProperty): Unit {}
    //TODO: 未完全实现
    public func initElement() {
        this.textProperty.addDynamicProperty = this.addDynamicProperty
    }

    /**
     * Prepare frame.
     *
     * @param num - Type of Float64.
     */
    public func prepareFrame(num: Float64): Unit {
        this._mdf = false
        //TODO: (问题点)仓颉的calss是单继承，调不到 RenderableElement.prepareRenderableFrame  //this.prepareRenderableFrame(num)
        //TODO: (问题点)仓颉的calss是单继承，调不到 FrameElement.prepareProperties  //this.prepareProperties(num, this.isInRange)
        if (this.textProperty._mdf || this.textProperty._isFirstFrame) {
            //TODO: buildNewText => 陈文龙开发的CVTextElement.buildNewText  //this.buildNewText()
            this.textProperty._isFirstFrame = false
            this.textProperty._mdf = false
        }
    }

    /**
     * Create path shape.
     *
     * @param matrixHelper - Type of Matrix.
     * @param shapes - Type of Array<ContentModel>, the value of shapes.
     * @return Type of String.
     */
    public func createPathShape(matrixHelper: Matrix, shapes: Array<ContentModel>): String {
        let jLen: Int64 = shapes.size
        var pathNodes: model.ShapeData = model.ShapeData()
        var shapeStr: String = ""
        var sp: ShapePath = ShapePath()
        for (j in 0..jLen) {
            // "layers"."shapes".{"ty": "sh"} = ShapePathParser
            if (shapes[j].ty == "sh") {
                // ks.k  ==>  ShapeData ==> pathNodes = shapes[j].ks.k
                sp = (shapes[j] as ShapePath) ?? sp
                pathNodes = sp.ks[0].k ?? pathNodes
                shapeStr += buildShapeString(pathNodes, pathNodes.i.size, true, matrixHelper)
            }
        }
        return shapeStr
    }

    /**
     * Update document data.
     *
     * @param newData - Type of Option<DocumentData>, the value of document data.
     * @param index - Type of Option<Int64>.
     */
    public func updateDocumentData(newData: Option<DocumentData>, index: Option<Int64>): Unit {
        this.textProperty.updateDocumentData(newData, index)
    }

    /**
     * Can resize font size.
     *
     * @param canResize - Type of Bool.
     */
    public func canResizeFont(canResize: Bool): Unit {
        this.textProperty.canResizeFont(canResize)
    }

    /**
     * Set minimum font size.
     *
     * @param fontSize - Type of Option<Float64>.
     */
    public func setMinimumFontSize(fontSize: Option<Float64>): Unit {
        this.textProperty.setMinimumFontSize(fontSize)
    }

    /**
     * Applying Text Properties to a Matrix.
     *
     * @param documentData - Type of ContentModel.
     * @param matrixHelper - Type of Matrix.
     * @param lineNumber - Type of Int64.
     * @param xPos - Type of Float64.
     * @param yPos - Type of Float64.
     */
    //lineNumber => documentData.l[i].line
    public func applyTextPropertiesToMatrix(documentData: DocumentData, matrixHelper: Matrix, lineNumber: Int64, xPos: Float64, yPos: Float64): Unit {
        if (documentData.ps.size > 0) {
            matrixHelper.translate(documentData.ps[0], documentData.ps[1] + documentData.ascent, tz: 0.0)
        }
        matrixHelper.translate(0.0, -documentData.ls, tz: 0.0)

        if (documentData.j == 1) {
            matrixHelper.translate(documentData.justifyOffset + (documentData.boxWidth[0] - documentData.lineWidths[lineNumber]), 0.0, tz: 0.0)
        } else if (documentData.j == 2) {
            matrixHelper.translate(documentData.justifyOffset + (documentData.boxWidth[0] - documentData.lineWidths[lineNumber]) / 2.0, 0.0, tz: 0.0)
        }
        matrixHelper.translate(xPos, yPos, tz: 0.0)
    }

    /**
     * Build color.
     *
     * @param colorData - Type of Array<Float64>, color data values..
     * @return Type of String.
     */
    //colorData => documentData.fc
    public func buildColor(colorData: Array<Float64>): String {
        return "rgb(" + math.round(colorData[0] * 255.0).toString() +
        "," + math.round(colorData[1] * 255.0).toString() +
        "," + math.round(colorData[2] * 255.0).toString() + ")"
    }

    /**
     * Get a empty LetterProps.
     *
     * @return Type of LetterProps.
     */
    public func emptyProp(): LetterProps {
        return LetterProps()
    }
    
    public func destroy() { }

}
