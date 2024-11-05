/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is CanvasRendererBase.
 */
package lottie.renderers

/*
 * 初始化后需要传入1个函数：
 * 1. contentModeInAnimationItem() => 间接获取 this.animationItem.contentMode 可变的当时的值。
 */
public abstract class CanvasRendererBase <: BaseRenderer {
    //TODO：拆分多继承问题 -- //extendPrototype([BaseRenderer], CanvasRendererBase)

    public var data: AnimationData = AnimationData()
    public var transformCanvas: TransformCanvas = TransformCanvas()
    public var renderedFrame: Float64 = -1.0
    public var contextData = CvContextData()
    
    public var transformMat: Matrix = Matrix()
    //public var rendererType: String = "canvas"
    public var destroyed: Bool = false

    public var renderConfig: RenderConfig

    /**
     * Create a CanvasRendererBase instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(config: Option<RenderConfig>, container: LottieCanvasRenderingContext2D) {
        super(container)
        //this.canvasContext = container
        //this.wrapperInAnimationItem = container
        this.renderConfig = RenderConfig()
        if (let Some(v) <- config) {
            this.renderConfig.clearCanvas = v.clearCanvas
            //TODO: 未确认数据类型 context
            //context = v.context
            this.renderConfig.progressiveLoad = v.progressiveLoad
            this.renderConfig.preserveAspectRatio = v.preserveAspectRatio
            this.renderConfig.imagePreserveAspectRatio = v.imagePreserveAspectRatio
            this.renderConfig.contentVisibility = v.contentVisibility
            this.renderConfig.className = v.className
            this.renderConfig.id = v.id
            this.renderConfig.dpr = v.dpr
        }
        // initRenderConfig 函数中同时处理了 dpr
        this.globalData = GlobalData(
            frameNum: -1.0,
            _mdf: false,
            renderConfig: this.renderConfig,
            currentGlobalAlpha: -1.0,
            canvasContext: container
        )
        this.globalData.hasCanvasRenderingContext2D = true
        //this.globalData.renderedFrameInComp = getRenderedFrame

        this.rendererType = "canvas"
    }

    //public func getRenderedFrame(): Float64{
    //    return this.renderedFrame
    //}

    public func createShape(data: Layer): CvShapeElement {
        //return CvShapeElement(data, this.globalData, this.buildElementParenting, ArrayList<BaseElement>())
        return CvShapeElement(data, this.globalData, this.buildElementParenting, compType: 2, getElementByIdInRender: this.getElementById)
    }

    public func createText(data: Layer): CvTextElement { 
        return CvTextElement(data, globalData, this.buildElementParenting, compType: 2, getElementByIdInRender: this.getElementById)
    }

    public func createImage(data: Layer): CvImageElement { 
        return CvImageElement(data, globalData, this.buildElementParenting, compType: 2, getElementByIdInRender: this.getElementById)
    }

    public func createSolid(data: Layer): CvSolidElement { 
        return CvSolidElement(data, globalData, this.buildElementParenting, compType: 2, getElementByIdInRender: this.getElementById)
    }

    /**
     * Create Null Element.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @return Type of NullElement.
     */
    public func createNull(data: Layer): NullElement {
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
            //this.canvasContext.transform(props[0], props[1], props[4], props[5], props[12], props[13])
            this.canvasContext.transform(props[0], props[4], props[1], props[5], props[12], props[13])
            return
        }

        ///将画布变换矩阵重置为新的变换
        this.transformMat.cloneFromProps(props)
        //从存储的转换堆栈中获取最后一个转换值
        let currentTransform: Matrix = this.contextData.getTransform()
        let cProps: Array<Float64> = currentTransform.props
        //在新变换之后应用最后一个变换值，以尊重变换的顺序
        this.transformMat.transform(
            cProps[0], cProps[1], cProps[2], cProps[3], cProps[4], cProps[5], cProps[6], cProps[7], cProps[8],
            cProps[9], cProps[10], cProps[11], cProps[12], cProps[13], cProps[14], cProps[15]
        )

        //在存储的转换中存储新的转换值
        currentTransform.cloneFromProps(this.transformMat.props)
        var trProps = currentTransform.props

        //在画布上应用新的变换
        //this.canvasContext.setTransform(trProps[0], trProps[1], trProps[4], trProps[5], trProps[12], trProps[13])
        this.canvasContext.setTransform(trProps[0], trProps[4], trProps[1], trProps[5], trProps[12], trProps[13])
    }

    /**
     * ctx opacity.
     *
     * @param op - Type of Int64.
     */
    public func ctxOpacity(op: Float64): Unit {
        var tmps = this.contextData.getTransform().props;
        //Hilog.error(0, "---1--", "[ctxOpacity]----->tmps = ${tmps}")

        var currentOpacity: Float64 = this.contextData.getOpacity()
        if (!this.renderConfig.clearCanvas) { //canvasContext 是画布组件中的 CanvasRenderingContext2D
            if (op < 0.0) {
                this.canvasContext.globalAlpha(0)
            } else {
                //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
                //TODO:怎么获取原来的透明度呢？？？
                //this.canvasContext.globalAlpha( *= op)
            }

            this.globalData.currentGlobalAlpha = currentOpacity
            return
        }

        if (op < 0.0) {
            currentOpacity = 0.0
        } else {
            currentOpacity *= op
        }

        this.contextData.setOpacity(currentOpacity)
        //设置当前画布的透明度，防止 this.globalData.currentGlobalAlpha 不为 1 时画布被隐藏
        this.canvasContext.globalAlpha(currentOpacity)
        if (this.globalData.currentGlobalAlpha != currentOpacity) {
            this.globalData.currentGlobalAlpha = currentOpacity
        }

//        var tmps2 = this.contextData.getTransform().props;
        //Hilog.error(0, "---1--", "[ctxOpacity]----->tmps2 = ${tmps2}")
    }

    /**
     * reset.
     */
    public func reset(): Unit {
        if (!this.renderConfig.clearCanvas) {
            this.canvasContext.restore()   //canvasContext 是画布组件中的 CanvasRenderingContext2D
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
        var tmps = this.contextData.getTransform().props;
        //Hilog.error(0, "---0--", "----->tmps = ${tmps}")
        if (!this.renderConfig.clearCanvas) {
            this.canvasContext.save()
            return
        }
        if (actionFlag) {
            this.canvasContext.save()
        }
        this.contextData.push()
//        var tmps2 = this.contextData.getTransform().props;
        //Hilog.error(0, "---0--", "----->tmps2 = ${tmps2}")
    }

    /**
     * restore.
     *
     * @param actionFlag - Type of Bool.
     */
    public func restore(actionFlag: Bool): Unit {
        if (!this.renderConfig.clearCanvas) {
            this.canvasContext.restore()
            return
        }
        if (actionFlag) {
            this.canvasContext.restore()
            this.globalData.blendMode.setValue("source-over")
        }

        let popped: (Array<Float64>, Float64) = this.contextData.pop()
        let transform: Array<Float64> = popped[0]
        let opacity: Float64 = popped[1]
        //this.canvasContext.setTransform(transform[0], transform[1], transform[4], transform[5], transform[12], transform[13])
        this.canvasContext.setTransform(transform[0], transform[4], transform[1], transform[5], transform[12], transform[13])

        if (this.globalData.currentGlobalAlpha != opacity) {
            this.canvasContext.globalAlpha(opacity)
            this.globalData.currentGlobalAlpha = opacity
        }
    }

    /**
     * Animation configuration.
     *
     * @param animData - Type of AnimationData, an instance of the json data that encapsulates the animation.
     */
    public func configAnimation(animData: AnimationData): Unit {
        /*
         //TODO：未开发 animationItem.wrapper
         if (this.wrapperInAnimationItem) {
           this.canvasContext = this.wrapperInAnimationItem
         } else {  //canvasContext 是画布组件中的 CanvasRenderingContext2D
           this.canvasContext = this.renderConfig.context
         }
         */


        //TODO：this.animationItem.contentMode 的值是可变的，故不能直接传值，需要通过函数【contentModeInAnimationItem】间接获取当时值。
        let contentMode: String = contentModeInAnimationItem()
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

        this.data = animData
        this.layers = animData.layers
        this.transformCanvas = TransformCanvas(
          w: Float64(animData.w),
          h: Float64(animData.h),
          sx: 0.0,
          sy: 0.0,
          tx: 0.0,
          ty: 0.0
        )

        this.setupGlobalData(animData, CreateTag(""))
        this.globalData.canvasContext = this.canvasContext
        //TODO：是都需要解构 CanvasRendererBase 和 GlobalData？？？  //this.globalData.renderer = this
        this.globalData.isDashed = false
        this.globalData.progressiveLoad = this.renderConfig.progressiveLoad
        this.globalData.transformCanvas = this.transformCanvas

        let emptyBaseElement: BaseElement = BaseElement(Layer(), globalData, isNull: true)
        //this.elements.size = 0
        this.elements = Array<BaseElement>(animData.layers.size, item: emptyBaseElement)
        //this.elements = Array<BaseElement>(animData.layers.size)
        this.updateContainerSize()

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
    public func updateContainerSize(): Unit {
        updateContainerSize(Option<Int64>.None, Option<Int64>.None)
    }
    public func updateContainerSize(width: ?Int64, height: ?Int64): Unit {

        this.canvasContext.restore()
        this.canvasContext.setTransform(1, 0, 0, 1, 0, 0) //resetting the transform
        this.canvasContext.clearRect(0.0, 0.0, this.transformCanvas.w, this.transformCanvas.h) //清空之前画布
//        //TODO:怎么获取之前的画布 width 和 height？？？
        this.canvasContext.clearRect(0, 0, 0, 0) //清空之前画布
//        //TODO:[39]- 先按照 arkts 中 数据写死 this.canvasContext.width 和 this.canvasContext.height
////        let ccw = 174.46153846153845
////        let cch = 200.0
//        this.canvasContext.clearRect(0.0, 0.0, ccw, cch) //清空之前画布
        this.canvasContext.save()

        this.reset()
        let elementWidth = 174.46153846153845
        let elementHeight = 200.0
//        var elementWidth: Float64 = if (let Some(v) <- width) {
//            Float64(v)
//        } else {
//            540.0
//        }
//        var elementHeight: Float64 = if (let Some(v) <- height) {
//            Float64(v)
//        } else {
//            360.0
//        }

        var elementRel: Float64 = 0.0
        var animationRel: Float64 = 0.0


        if (this.renderConfig.preserveAspectRatio.contains("meet") || this.renderConfig.preserveAspectRatio.contains("slice")) {
            let par: Array<String> = this.renderConfig.preserveAspectRatio.split(" ")
            var fillType: String = if (par.size >= 2){
                par[1]
            } else {
                "meet"
            }
            var pos: String = if (par.size >= 1){
                par[0]
            } else {
                "xMidYMid"
            }

            let xPos: String = pos[0..4]
            let yPos: String = pos[4..]
            //TODO: 被除数 elementHeight = 0。
            elementRel = elementWidth / elementHeight
            animationRel = Float64(this.transformCanvas.w / this.transformCanvas.h)
            if ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice")) {
                this.transformCanvas.sx = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
                this.transformCanvas.sy = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
            } else {
                this.transformCanvas.sx = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
                this.transformCanvas.sy = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
            }

            if (xPos == "xMid" && ((animationRel < elementRel && fillType == "meet") || (animationRel > elementRel && fillType == "slice"))) {
                this.transformCanvas.tx = ((elementWidth - this.transformCanvas.w * (elementHeight / this.transformCanvas.h)) / 2.0) * this.renderConfig.dpr
            } else if (xPos == "xMax" && ((animationRel < elementRel && fillType == "meet") || (animationRel > elementRel && fillType == "slice"))) {
                this.transformCanvas.tx = (elementWidth - this.transformCanvas.w * (elementHeight / this.transformCanvas.h)) * this.renderConfig.dpr
            } else {
                this.transformCanvas.tx = 0.0
            }
            if (yPos == "YMid" && ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice"))) {
                this.transformCanvas.ty = ((elementHeight - this.transformCanvas.h * (elementWidth / this.transformCanvas.w)) / 2.0) * this.renderConfig.dpr
            } else if (yPos == "YMax" && ((animationRel > elementRel && fillType == "meet") || (animationRel < elementRel && fillType == "slice"))) {
                this.transformCanvas.ty = ((elementHeight - this.transformCanvas.h * (elementWidth / this.transformCanvas.w))) * this.renderConfig.dpr
            } else {
                this.transformCanvas.ty = 0.0
            }
        } else if (this.renderConfig.preserveAspectRatio == "none") {
            this.transformCanvas.sx = elementWidth / (this.transformCanvas.w / this.renderConfig.dpr)
            this.transformCanvas.sy = elementHeight / (this.transformCanvas.h / this.renderConfig.dpr)
            this.transformCanvas.tx = 0.0
            this.transformCanvas.ty = 0.0
        } else {
            this.transformCanvas.sx = this.renderConfig.dpr
            this.transformCanvas.sy = this.renderConfig.dpr
            this.transformCanvas.tx = 0.0
            this.transformCanvas.ty = 0.0
        }

        this.transformCanvas.props = [Float64(this.transformCanvas.sx), 0.0, 0.0, 0.0, 0.0, Float64(this.transformCanvas.sy), 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, Float64(this.transformCanvas.tx), Float64(this.transformCanvas.ty), 0.0, 1.0]

        this.ctxTransform(this.transformCanvas.props)

        this.canvasContext.beginPath()
        this.canvasContext.rect(0.0, 0.0, this.transformCanvas.w, this.transformCanvas.h)
        this.canvasContext.closePath()
        this.canvasContext.clip()

        this.renderFrame(this.renderedFrame, true)
    }

    /**
     * Destroy the CanvasRendererBase.
     */
    public func destroy(): Unit {
        /*
        //TODO： animationItem 未开发
        if (this.renderConfig.clearCanvas && this.wrapperInAnimationItem && this.transformCanvas) {
            //TODO： animationItem 未开发
            this.wrapperInAnimationItem.clearRect(0, 0, this.transformCanvas.w, this.transformCanvas.h)
        }
        */
        let len: Int64 = this.layers.size
        for (i in (len - 1)..=0: -1) {
            if (this.elements.size > i && !this.elements[i].isNull) {
            //if (this.elements.size > i) {
                this.elements[i].destroy()
            }
        }

        this.elements = Array<BaseElement>()
        //this.elements.size = 0
        /*
        this.globalData.canvasContext = Option<CanvasRenderingContext2D>.None
        this.containerInAnimationItem = Option<CanvasRenderingContext2D>.None
        */
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
    public override func changeColor(color: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit {
        if (layer == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                //if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color, endColor)
                }
            }
        } else {
            if (this.completeLayers || (this.elements.size > layer - 1 && !this.elements[layer - 1].isNull)) {
            //if (this.completeLayers || this.elements.size > layer - 1) {
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
    public override func changeColor(color: Array<Int64>, endColor: Int64, layer: Int64, index: Int64): Unit {
        if (endColor == 0) {
            let len: Int64 = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                //if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color, 0)
                }
            }
        } else {
            if (this.completeLayers || (this.elements.size > endColor - 1 && !this.elements[endColor - 1].isNull)) {
            //if (this.completeLayers || this.elements.size > endColor - 1) {
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
    public override func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
            //if (this.completeLayers || this.elements.size > i) {
                this.elements[i].changeColor(color, 0)  //RenderableElement
            }
        }
    }

    /**
     * Render Frame.
     *
     * @param num - Type of Int64.
     * @param forceRender - Type of Bool, whether to force rendering..
     */
    public func renderFrame(num: Float64, forceRender: Bool): Unit {

        if ((this.renderedFrame == num && this.renderConfig.clearCanvas == true && !forceRender) || this.destroyed || num == -1.0) {
            return
        }
        this.renderedFrame = num
        this.globalData.frameNum = num - this._isFirstFrameInAnimationItem()
        this.globalData.frameId += 1
        this.globalData._mdf = !this.renderConfig.clearCanvas || forceRender
        //TODO: 未实现 ProjectInterface  //this.globalData.projectInterface.currentFrame = num

        let len: Int64 = this.layers.size
        if (!this.completeLayers) {
            this.checkLayers(num)
        }

        if (num > 89.5) {
            Hilog.error(0, "--Renderer--", "[renderFrame]--[1]----> num = ${num}")
        }


        for (i in 0..len) {
            //if (i == 18) {
            //    Hilog.error(0, "--Renderer--", "[renderFrame]--[1]----> i = ${i}")
            //}

            if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
            //if (this.completeLayers || this.elements.size > i) {
                this.elements[i].prepareFrame(num - this.layers[i].st)
            }
        }

        //TODO: this.globalData._mdf = false 为什么会是false？是之前那块赋值出错了么？？？//if (true) {
        if (this.globalData._mdf) {
            if (this.renderConfig.clearCanvas) {
                this.canvasContext.clearRect(0.0, 0.0, this.transformCanvas.w, this.transformCanvas.h)
            } else {
                this.save(false)
            }

            //TODO: 暂时不定位 CVShapeElement 的渲染逻辑。先注掉，先测试 this.elements[0] 即 CVCompElement。//this.elements[0].renderFrame()
            var index: Int64 = 0

            //todo: 测试用。后续删除。
            //var ind = 12  //红包json
            //if (this.completeLayers || (this.elements.size > ind && !this.elements[ind].isNull)) {
            //    this.elements[ind].renderFrame(false)
            //}

            for (i in (len - 1)..=0:-1) {
                index = i
                if (this.completeLayers || (this.elements.size > i && !this.elements[i].isNull)) {
                //if (this.completeLayers || this.elements.size > i) {
                    //this.elements[i].renderFrame()
                    //TODO: 暂时先将 CvBaseElement 和 BaseElement 合并。避免后面 CVXXXElement 多继承 XXXElement和 CVBaseElement。
                    //TODO：renderFrame 在 canvas元素 相关中，是带有参数的。此处直接改为带参调用。
                    this.elements[i].renderFrame(false)
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
        let elements: Array<BaseElement> = this.elements
        if ((this.elements.size > pos && !this.elements[pos].isNull) || this.layers[pos].ty == 99) {
        //if (this.elements.size > pos || this.layers[pos].ty == 99) {
            return
        }
        //TODO: 函数参数不一致，有 2 个参数暂时未传递。
        let element: BaseElement = this.createItem(this.layers[pos])
        //TODO: 【暂未处理】ArrayList 直接指定下标赋值报错。暂时改为append。 //this.elements.append(element)
        this.elements[pos] = element


        //this.elements.size++
        element.initExpressions()
    }

    /**
     * Check pending Elements.
     */
    public func checkPendingElements(): Unit {
        while (this.pendingElements.size != 0) {
            let element: BaseElement = this.pendingElements.remove(this.pendingElements.size - 1)

            //TODO[lp]: - HierarchyElement.checkParenting => element 是 HierarchyElement ？？？
            element.checkParenting()
        }
    }

    public func hide(): Unit {
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        //TODO: 不确定 this.animationItem.container数据类型暂定为 CreateNS。【对应的是html渲染的 hide/show】。
        //改为调用 【通用属性】中 显隐控制 visibility(Visibility)，达到相同的效果。控制的是 Canvas 组件。
        //this.containerInAnimationItem.style.display = "none"
    }

    public func show(): Unit {
        //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
        //TODO: 不确定 this.animationItem.container数据类型暂定为 CreateNS。【对应的是html渲染的 hide/show】。
        //改为调用 【通用属性】中 显隐控制 visibility(Visibility)，达到相同的效果。控制的是 Canvas 组件。
        //this.containerInAnimationItem.style.display = "block"
    }

}
