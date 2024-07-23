/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is CanvasRendererBase.
 */
package lottie4cj.renderers


public open class CanvasRendererBase <: BaseRenderer {

    /**
     * 数据类型推测路线：
     * this.canvasContext = this.renderConfig.context
     * this.canvasContext = this.animationItem.wrapper
     * [AnimationItem] this.wrapper = params.wrapper || params.container ( params <=> loadAnimation(params) )
     *   =>  CanvasRenderingContext2D = this.canvasContext = this.renderConfig.context
     */
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //public var canvasContext: CanvasRenderingContext2D = None

    public var data: AnimationData = AnimationData()
    public var transformCanvas: TransformCanvas = TransformCanvas()
    public var renderedFrame: Int64 = -1
    public var contextData = CvContextData()
 
    public var transformMat: Matrix = Matrix()
    public var rendererType: String = "canvas"
    public var destroyed: Bool = false
    
    
    public var animationItem: AnimationItem
    public var renderConfig: RenderConfig
    //TODO：是否将 GlobalDataCanvas 和 GlobalData 进行合并

    /**
     * Create a CanvasRendererBase instance based on parameters.
     *
     * @param animationItem - Type of AnimationItem.
     * @param config - Type of Option<RenderConfig>.
     */
    public init(animationItem: AnimationItem, config: Option<RenderConfig>) {
        this.animationItem = animationItem
    
        this.renderConfig = RenderConfig()
        if (let Some(v) <- config) {
            this.renderConfig.clearCanvas = v.clearCanvas

            //TODO: 未确认数据类型 context  //context = v.context
            this.renderConfig.progressiveLoad = v.progressiveLoad
            this.renderConfig.preserveAspectRatio = v.preserveAspectRatio
            this.renderConfig.imagePreserveAspectRatio = v.imagePreserveAspectRatio
            this.renderConfig.contentVisibility = v.contentVisibility
            this.renderConfig.className = v.className
            this.renderConfig.id = v.id
            this.renderConfig.dpr = v.dpr
        }

        this.globalData = GlobalData(
            frameNum: -1,
            _mdf: false,
            renderConfig: this.renderConfig,
            currentGlobalAlpha: -1
        )
    }

    //TODO：拆分多继承问题 -- extendPrototype([BaseRenderer], CanvasRendererBase)

    //TODO: 未实现 BaseElement 子类 CvShapeData  //public func createShape(data: Layer): CvShapeData { return CvShapeData(data, this.globalData, this) }
    public func createShape(data: Layer): BaseElement { 
        return BaseElement(data, globalData)
    }
    
    //TODO: 未实现 BaseElement 子类 CvTextElement  //public func createText(data: Layer): CvTextElement { return CvTextElement(data, this.globalData, this) }
    public func createText(data: Layer): BaseElement { 
        return BaseElement(data, globalData)
    }
    
    //TODO: 未实现 BaseElement 子类 CvImageElement  //public func createImage(data: Layer): CvImageElement { return CvImageElement(data, this.globalData, this) }
    public func createImage(data: Layer): BaseElement { 
        return BaseElement(data, globalData)
    }
    
    
    //TODO: 未实现 BaseElement 子类 CvSolidElement  //public func createSolid(data: Layer): CvSolidElement { return CvSolidElement(data, this.globalData, this) }
    public func createSolid(data: Layer): BaseElement { 
        return BaseElement(data, globalData)
    }

    /**
     * Create Null Element.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @return Type of NullElement.
     */
    public func createNull(data: Layer): NullElement {
        //TODO: 需要解构互调用  //return NullElement(data, this.globalData, this)
        return NullElement(data, this.globalData)
    }

    /**
     * ctx transform.
     *
     * @param props - Type of Array<Float64>.
     */
    public func ctxTransform(props: Array<Float64>): Unit {
        if (props[0] == 1.0 && props[1] == 0.0 && props[4] == 0.0 && props[5] == 1.0 && props[12] == 0.0 && props[13] == 0.0) {
            return
        }
        if (!this.renderConfig.clearCanvas) {//canvasContext 是画布组件中的 CanvasRenderingContext2D
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            //this.canvasContext.transform(props[0], props[1], props[4], props[5], props[12], props[13])
            return
        }
        //将画布变换矩阵重置为新的变换
        this.transformMat.cloneFromProps(props)
        //从存储的转换堆栈中获取最后一个转换值
        var currentTransform = this.contextData.getTransform()
        var cProps = currentTransform.props
        //在新变换之后应用最后一个变换值，以尊重变换的顺序
        this.transformMat.transform(
            cProps[0], cProps[1], cProps[2], cProps[3], cProps[4], cProps[5], cProps[6], cProps[7], cProps[8],
            cProps[9], cProps[10], cProps[11], cProps[12], cProps[13], cProps[14], cProps[15]
        )
        //在存储的转换中存储新的转换值
        currentTransform.cloneFromProps(this.transformMat.props)
        var trProps = currentTransform.props
        //在画布上应用新的变换
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        //this.canvasContext.setTransform(trProps[0], trProps[1], trProps[4], trProps[5], trProps[12], trProps[13])
    }

    /**
     * ctx opacity.
     *
     * @param op - Type of Int64.
     */
    public func ctxOpacity(op: Int64): Unit {
        var currentOpacity = this.contextData.getOpacity()
        if (!this.renderConfig.clearCanvas) {
            if (op < 0) {
                //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
                //this.canvasContext.globalAlpha *= 0
            } else {
                //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
                //this.canvasContext.globalAlpha *= op
            }

            this.globalData.currentGlobalAlpha = currentOpacity
            return
        }

        if (op < 0) {
            currentOpacity *= 0
        } else {
            currentOpacity *= op
        }

        this.contextData.setOpacity(currentOpacity)
        //设置当前画布的透明度，防止 this.globalData.currentGlobalAlpha 不为 1 时画布被隐藏
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.canvasContext.globalAlpha = currentOpacity
        if (this.globalData.currentGlobalAlpha != currentOpacity) {
            this.globalData.currentGlobalAlpha = currentOpacity
        }
    }

    /**
     * reset.
     */
    public func reset(): Unit {
        if (!this.renderConfig.clearCanvas) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            //this.canvasContext.restore()   //canvasContext 是画布组件中的 CanvasRenderingContext2D
            return
        }
        this.contextData.reset()
    }

    /**
     * save.
     *
     * @param actionFlag - Type of Bool.
     */
    public func save(actionFlag: Bool): Unit {
        if (!this.renderConfig.clearCanvas) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.canvasContext.save()
            return
        }
        if (actionFlag) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.canvasContext.save()
        }
        this.contextData.push()
    }

    /**
     * restore.
     *
     * @param actionFlag - Type of Bool.
     */
    public func restore(actionFlag: Bool): Unit {
        if (!this.renderConfig.clearCanvas) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.canvasContext.restore()
            return
        }
        if (actionFlag) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.canvasContext.restore()
            this.globalData.blendMode = "source-over"
        }
        //TODO: this.contextData（CvContextData） 为完全开发
        /*
        var popped = this.contextData.pop()
        var transform = popped.transform
        var opacity = popped.opacity
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        this.canvasContext.setTransform(transform[0], transform[1], transform[4], transform[5], transform[12], transform[13])
        //TODO： 暂时无法获得 opacity
        if (this.globalData.currentGlobalAlpha != opacity) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            this.canvasContext.globalAlpha = opacity
            //TODO： 暂时无法获得 opacity
            this.globalData.currentGlobalAlpha = opacity
        }
        */
    }

    /**
     * Animation configuration.
     *
     * @param animData - Type of AnimationData, an instance of the json data that encapsulates the animation.
     */
    public func configAnimation(animData: AnimationData): Unit {
        //TODO：未开发 animationItem.wrapper
        /*
        if (this.animationItem.wrapper) {
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            this.canvasContext = this.animationItem.wrapper
        } else {  //canvasContext 是画布组件中的 CanvasRenderingContext2D
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            this.canvasContext = this.renderConfig.context
        }
        */

        if (this.animationItem.contentMode == "Fill") {
            this.renderConfig.preserveAspectRatio = "none"
        } else if (this.animationItem.contentMode == "Top") {
            this.renderConfig.preserveAspectRatio = "xMinYMin meet"
        } else if (this.animationItem.contentMode == "Cover") {
            this.renderConfig.preserveAspectRatio = "xMidYMid slice"
        } else if (this.animationItem.contentMode == "Buttom") {
            this.renderConfig.preserveAspectRatio = "xMaxYMax meet"
        } else if (this.animationItem.contentMode == "Contain") {
            this.renderConfig.preserveAspectRatio = "xMidYMid meet"
        }

        this.data = animData
        this.layers = animData.layers
        this.transformCanvas = TransformCanvas(
          w: animData.w,
          h: animData.h,
          sx: 0,
          sy: 0,
          tx: 0,
          ty: 0
        )
        this.setupGlobalData(animData, CreateTag(""))
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.globalData.canvasContext = this.canvasContext
        //TODO：未完全实现 CanvasRendererBase  //this.globalData.renderer = this
        this.globalData.isDashed = false
        this.globalData.progressiveLoad = this.renderConfig.progressiveLoad
        this.globalData.transformCanvas = this.transformCanvas

        //TODO: 未实现  //this.elements = Array<>(animData.layers.size, item: element)

        this.updateContainerSize(0, 0)
    }

    /**
     * Update content mode.
     *
     * @param contentMode - Type of String.
     */
    public func updateContentMode(contentMode: String): Unit {
        if (contentMode.isEmpty()){
            return
        }

        if (contentMode == "Fill") {
            this.renderConfig.preserveAspectRatio = "none"
        } else if (contentMode == "Top") {
            this.renderConfig.preserveAspectRatio = "xMinYMin meet"
        } else if (contentMode == "Cover") {
            this.renderConfig.preserveAspectRatio = "xMidYMid slice"
        } else if (contentMode == "Buttom") {
            this.renderConfig.preserveAspectRatio = "xMaxYMax meet"
        } else if (contentMode == "Contain") {
            this.renderConfig.preserveAspectRatio = "xMidYMid meet"
        }
        this.updateContainerSize(0, 0)
    }

    /**
     * Update container size.
     *
     * @param width - Type of Int64.
     * @param height - Type of Int64.
     */
    public func updateContainerSize(width: Int64, height: Int64): Unit {
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        /*
        this.canvasContext.restore()
        this.canvasContext.setTransform(1, 0, 0, 1, 0, 0) //resetting the transform
        this.canvasContext.clearRect(0, 0, this.transformCanvas.w, this.transformCanvas.h) //清空之前画布
        this.canvasContext.clearRect(0, 0, this.canvasContext.width, this.canvasContext.height) //清空之前画布
        this.canvasContext.save()
        */
        this.reset()
        var elementWidth: Int64 = 0
        var elementHeight: Int64 = 0
        if (width != 0) {
            elementWidth = width
            elementHeight = height
        } else {
            //TODO：未实现this.canvasContext。CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            //if (this.canvasContext) {
                //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //elementHeight = this.canvasContext.height  //elementWidth = this.canvasContext.width

                if (elementHeight == 0) {
                    elementHeight = 360
                }
                if (elementWidth == 0) {
                    elementWidth = 540
                }
            //}
        }

        var elementRel: Int64 = 0
        var animationRel: Int64 = 0

        if (this.renderConfig.preserveAspectRatio.contains("meet") || this.renderConfig.preserveAspectRatio.contains("slice")) {
            var par: Array<String> = this.renderConfig.preserveAspectRatio.split(" ")
            var fillType: String = "meet"
            if (par.size >= 2){
                fillType = par[1]
            }

            var pos: String = "xMidYMid"
            if (par.size >= 1){
                pos = par[0]
            }

            var xPos: String = pos[0..4]
            var yPos: String = pos.trimLeft(xPos)
            elementRel = elementWidth / elementHeight
            animationRel = this.transformCanvas.w / this.transformCanvas.h
            if ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice")) {
                this.transformCanvas.sx = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
                this.transformCanvas.sy = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
            } else {
                this.transformCanvas.sx = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
                this.transformCanvas.sy = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
            }

            if (xPos == "xMid" && ((animationRel < elementRel && fillType == "meet") || (animationRel > elementRel && fillType == "slice"))) {
                this.transformCanvas.tx = ((elementWidth - this.transformCanvas.w * (elementHeight / this.transformCanvas.h)) / 2) * this.renderConfig.dpr
            } else if (xPos == "xMax" && ((animationRel < elementRel && fillType == "meet") || (animationRel > elementRel && fillType == "slice"))) {
                this.transformCanvas.tx = (elementWidth - this.transformCanvas.w * (elementHeight / this.transformCanvas.h)) * this.renderConfig.dpr
            } else {
                this.transformCanvas.tx = 0
            }
            if (yPos == "YMid" && ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice"))) {
                this.transformCanvas.ty = ((elementHeight - this.transformCanvas.h * (elementWidth / this.transformCanvas.w)) / 2) * this.renderConfig.dpr
            } else if (yPos == "YMax" && ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice"))) {
                this.transformCanvas.ty = ((elementHeight - this.transformCanvas.h * (elementWidth / this.transformCanvas.w))) * this.renderConfig.dpr
            } else {
                this.transformCanvas.ty = 0
            }
        } else if (this.renderConfig.preserveAspectRatio == "none") {
            this.transformCanvas.sx = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
            this.transformCanvas.sy = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
            this.transformCanvas.tx = 0
            this.transformCanvas.ty = 0
        } else {
            this.transformCanvas.sx = this.renderConfig.dpr
            this.transformCanvas.sy = this.renderConfig.dpr
            this.transformCanvas.tx = 0
            this.transformCanvas.ty = 0
        }
        this.transformCanvas.props = [Float64(this.transformCanvas.sx), 0.0, 0.0, 0.0, 0.0, Float64(this.transformCanvas.sy), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, Float64(this.transformCanvas.tx), Float64(this.transformCanvas.ty), 0.0, 1.0]

        this.ctxTransform(this.transformCanvas.props)
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        /*
        this.canvasContext.beginPath()
        this.canvasContext.rect(0, 0, this.transformCanvas.w, this.transformCanvas.h)
        this.canvasContext.closePath()
        this.canvasContext.clip()
        */

        this.renderFrame(this.renderedFrame, true)
    }

    /**
     * Destroy the CanvasRendererBase.
     */
    public func destroy(): Unit {
        //TODO： animationItem 未开发
        /*
        if (this.renderConfig.clearCanvas && this.animationItem.wrapper && this.transformCanvas) {
            //TODO： animationItem 未开发
            this.animationItem.wrapper.clearRect(0, 0, this.transformCanvas.w, this.transformCanvas.h)
        }
        */
        let len: Int64 = this.layers.size
        for (i in (len - 1)..=0: -1) {
            if (this.elements.size > i) {
                this.elements[i].destroy()
            }
        }

        this.elements = Array<BaseElement>()
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        //this.globalData.canvasContext = Option<CanvasRenderingContext2D>.None
        //this.animationItem.container = Option<CanvasRenderingContext2D>.None
        this.destroyed = true
    }

    /**
     * Modify animation colors.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param endColor - Type of Array<Int64>, End color array RGBA.
     * @param layer - Type of Int64, Index value of hierarchy.
     * @param index - Type of Int64, The subscript value of elements in the corresponding hierarchy.
     */
    public func changeColor(color: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit {
        if (layer == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color, endColor)
                }
            }
        } else {
            if (this.completeLayers || this.elements.size > layer - 1) {
                this.elements[layer - 1].changeColor(color, endColor, index)
            }
        }
    }

    /**
     * Modify animation colors.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param endColor - Type of Int64.
     * @param layer - Type of Int64, Index value of hierarchy.
     * @param index - Type of Int64, The subscript value of elements in the corresponding hierarchy.
     */
    public func changeColor(color: Array<Int64>, endColor: Int64, layer: Int64, index: Int64): Unit {
        if (endColor == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || this.elements.size > i) {
                    //TODO: 函数参数不一致 //this.elements[i].changeColor(color, undefined)
                    this.elements[i].changeColor(color, 0)
                }
            }
        } else {
            if (this.completeLayers || this.elements.size > endColor - 1) {
                this.elements[endColor - 1].changeColor(color, layer, index)
            }
        }
    }

    /**
     * Modify animation colors.
     *
     * @param color - Type of Array<Int64>, Start color array RGBA.
     * @param layer - Type of Int64, Index value of hierarchy.
     * @param index - Type of Int64, The subscript value of elements in the corresponding hierarchy.
     */
    public func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                //TODO: 函数参数不一致 //this.elements[i].changeColor(color, undefined)
                this.elements[i].changeColor(color, 0)
            }
        }
    }

    /**
     * Render Frame.
     *
     * @param num - Type of Int64.
     * @param forceRender - Type of Bool, whether to force rendering..
     */
    public func renderFrame(num: Int64, forceRender: Bool): Unit {
        if ((this.renderedFrame == num && this.renderConfig.clearCanvas == true && !forceRender) || this.destroyed || num == -1) {
            return
        }
        this.renderedFrame = num
        this.globalData.frameNum = num - this.animationItem._isFirstFrame
        this.globalData.frameId += 1
        this.globalData._mdf = !this.renderConfig.clearCanvas || forceRender
        //TODO: 未实现 ProjectInterface  //this.globalData.projectInterface.currentFrame = num

        let len: Int64 = this.layers.size
        if (!this.completeLayers) {
            this.checkLayers(Float64(num))
        }
    
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                this.elements[i].prepareFrame(Float64(num) - this.layers[i].st)
            }
        }
        if (this.globalData._mdf) {
            if (this.renderConfig.clearCanvas) {
                //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
                //this.canvasContext.clearRect(0, 0, this.transformCanvas.w, this.transformCanvas.h)
            } else {
                //TODO: 函数参数不一致 //this.save()
                this.save(false)
            }
            for (i in (len - 1)..=0:-1) {
                if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].renderFrame()
                }
            }
            if (!this.renderConfig.clearCanvas) {
                //this.restore()
                this.restore(false)
            }
        }
    }

    /**
     * Build Element.
     *
     * @param pos - Type of Int64.
     */
    public func buildItem(pos: Int64): Unit {
        var elements = this.elements
        if (elements.size > pos || this.layers[pos].ty == 99) {
            return
        }
        //TODO: 函数参数不一致  //var element = this.createItem(this.layers[pos], this, this.globalData)
        var element = this.createItem(this.layers[pos])
        elements[pos] = element
        element.initExpressions()
    }

    /**
     * Check pending Elements.
     */
    public func checkPendingElements(): Unit {
        while (this.pendingElements.size != 0) {
            var element = this.pendingElements.remove(this.pendingElements.size - 1)
            //TODO: 未实现 element.checkParenting  //element.checkParenting()
        }
    }

    public func hide(): Unit {
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.animationItem.container.style.display = "none"
    }

    public func show(): Unit {
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //this.animationItem.container.style.display = "block"
    }
}
