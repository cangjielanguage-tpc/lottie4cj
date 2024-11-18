/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ITextElement.
 */
package lottie.elements

internal import lottie.bezier.*
internal import lottie.utils.text.*

internal import std.math.*

public open class ITextElement <: BaseElement {

    public var lettersChangedFlag: Bool = true
    public var renderType: String = ""
    
    //TODO:需要解构 ITextElement 和 TextProperty 互调用。改成 TextProperty 中只传入 ITextElement 中部分函数和值。
    public var textProperty: TextProperty
    
    public var textAnimator: TextAnimatorProperty

    /**
     * Create a ITextElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.textProperty = TextProperty(data.t, globalData)
        this.textAnimator = TextAnimatorProperty(data.t, this.renderType, globalData, data, this.textProperty.currentData, dynamicProperties: this.dynamicProperties)
    }
 
    //TODO: 未实现，编译用。
    public func addDynamicProperty(tp: TextProperty): Unit {}

    public func initElement(data: Layer, globalData: GlobalData) {
        this.lettersChangedFlag = true
        this.initFrame()
        //设置改图层参数
        this.initBaseData(data, globalData)
        /*
         * 数据来源分析：data.t == LayerT  <=  data == layer
         * 文本属性
         * TODO：TextProperty初始化只接收到2个参数，未传入的 this.dynamicProperties 后续根据实际应用情况再做处理。
         */
        this.textProperty = TextProperty(data.t, globalData)
        //文本动画属性
        this.textAnimator = TextAnimatorProperty(data.t, this.renderType, globalData, data, this.textProperty.currentData, dynamicProperties: this.dynamicProperties)
        //获取transform（layer.ks）相关的数据
        this.initTransform(data, globalData) 
        this.initHierarchy()
        this.initRenderable()
        this.initRendererElement()
        //创建一个会包含子元素的g元素，并根据前面初始化的参与，设置g元素的属性（transform、filter、蒙层、id等）
        this.createContainerElements()
        this.createRenderableComponents()
        this.createContent()
        this.hide()
        //TODO: TextAnimatorProperty.searchProperties() 是无参的，未传入的 this.dynamicProperties 后续根据实际应用情况再做处理。
        this.textAnimator.searchProperties()
    }

    //TODO: 编译用，具体实现在子类 CVTextElement.buildNewText
    public open func buildNewText(): Unit {}

    /**
     * Prepare frame.
     *
     * @param num - Type of Float64.
     */
    public func prepareFrame(num: Float64): Unit {
        this._mdf = false
        this.prepareRenderableFrame(num)
        this.prepareProperties(num, this.isInRange)
        if (this.textProperty._mdf || this.textProperty._isFirstFrame) {
            //TODO: buildNewText => CVTextElement.buildNewText  
            this.buildNewText()
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
        var pathNodes: ShapeData = ShapeData()
        var shapeStr: String = ""
        var sp: ShapePath = ShapePath()
        for (j in 0..jLen) {
            //数据来源分析： "layers"."shapes".{"ty": "sh"} = ShapePathParser
            if (shapes[j].ty == "sh") {
                //数据来源分析： ks.k  ==>  ShapeData ==> pathNodes = shapes[j].ks.k
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
    //数据来源分析：lineNumber => documentData.l[i].line
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
    //数据来源分析：colorData => documentData.fc
    public func buildColor(colorData: Array<Float64>): Color {
        return Color(UInt8(round(colorData[0] * 255.0)), UInt8(round(colorData[1] * 255.0)), UInt8(round(colorData[2] * 255.0)))
    }
    
    /**
     * Get a empty LetterProps.
     *
     * @return Type of LetterProps.
     */
    public func emptyProp(): LetterProps {
        return LetterProps()
    }
    
    public open func destroy() { }

}
