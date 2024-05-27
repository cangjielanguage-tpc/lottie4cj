/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is ITextElement.
 */
package utils.text

import third_party.*
import utils.shapes.*

from std import math.*

public class ITextElement <: BaseElement {

    public var lettersChangedFlag: Bool = true
    public var textProperty: Option<TextProperty> = None
    //TODO: 未实现 TextAnimatorProperty    //public var textAnimator: TextAnimatorProperty


    public var data: Layer
    public var globalData: utils.GlobalData
    //TODO: 未完全实现 RendererBase        //public var comp: RendererBase

    //TODO: 未完全实现CanvasRendererBase

    public init(data: Layer, globalData: utils.GlobalData) {
        //此调用 this.initBaseData(data, globalData, comp) 等同于 BaseElement.init
        this.data = data
        this.globalData = globalData
        this.lettersChangedFlag = true
    }

    public func initElement() {
        this.textProperty = TextProperty(this, data.t)
    }

    //TODO: initElement
    
    public func prepareFrame(num: Float64): Unit {
        this._mdf = false
        //TODO: (问题点)仓颉的calss是单继承，调不到 RenderableElement.prepareRenderableFrame  //this.prepareRenderableFrame(num)
        //TODO: (问题点)仓颉的calss是单继承，调不到 FrameElement.prepareProperties  //this.prepareProperties(num, this.isInRange)
        if (let Some(v) <- this.textProperty) {
            if (v._mdf || v._isFirstFrame) {
                //TODO: buildNewText => 陈文龙开发的CVTextElement.buildNewText  //this.buildNewText()
                v._isFirstFrame = false
                v._mdf = false
            }
        }
    }

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
    
    public func updateDocumentData(newData: Option<DocumentData>, index: Option<Int64>) {
        if (let Some(v) <- this.textProperty) {
            v.updateDocumentData(newData, index)
        }
    }
    
    public func canResizeFont(_canResize: Bool) {
        if (let Some(v) <- this.textProperty) {
            v.canResizeFont(_canResize)
        }
    }
    
    public func setMinimumFontSize(_fontSize: Option<Float64>) {
        if (let Some(v) <- this.textProperty) {
            v.setMinimumFontSize(_fontSize)
        }
    }

    //lineNumber => documentData.l[i].line
    public func applyTextPropertiesToMatrix(documentData: DocumentData, matrixHelper: Matrix, lineNumber: Int64, xPos: Float64, yPos: Float64) {
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
    
    //colorData => documentData.fc
    public func buildColor(colorData: Array<Float64>): String {
        return "rgb(" + math.round(colorData[0] * 255.0).toString() +
        "," + math.round(colorData[1] * 255.0).toString() +
        "," + math.round(colorData[2] * 255.0).toString() + ")"
    }
    
    public func emptyProp(): LetterProps {
        return LetterProps()
    }
    
    public func destroy() { }

}

