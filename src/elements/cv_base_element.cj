/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import lottie4cj.model.*
internal import lottie4cj.global_data.*

var operationsMap: HashMap<Int64, String> = HashMap<Int64, String>([
    (1, "source-in"),
    (2, "source-out"),
    (3, "source-in"),
    (4, "source-out")

])
public class CvBaseElement <: BaseElement {
    private var buffers: ArrayList<String> = ArrayList<String>()
    public var canvasContext: ?CanvasContext = CanvasContext()
    private var transformCanvas: TransformCanvas = TransformCanvas()
    private var renderableEffectsManager: ?CvEffects = None
    private var maskManager: ?CvMaskElement = None
    private var hidden: Bool = false
    private var isTransparent: Bool = false
    private var _isFirstFrame: Bool = false

    public init(data: Layer, globalData: GlobalData) {
        super(data,globalData)
    }

    public func createElements() {
        //TODO
    }

    public func initRendererElement() {
        //TODO
    }

    public func createContainerElements() {
        this.canvasContext = this.globalData.canvasContext
        this.transformCanvas = this.globalData.transformCanvas
        this.renderableEffectsManager = CvEffects(this)
    }

    public func createContent() {
        //TODO
    }

    public func setBlendMode() {
        var globalData = this.globalData
        if (globalData.blendMode != this.data.bm.toString()) {
            globalData.blendMode = this.data.bm.toString()
            var blendModeValue = getBlendMode(this.data.bm)
            globalData.canvasContext.globalCompositeOperation = blendModeValue
        }
        
    }

    public func createRenderableComponents() {
        this.maskManager = CvMaskElement(this.data, this)
    }

    public func hideElement() {
        if (!this.hidden && (!this.isInRange || this.isTransparent)) {
            this.hidden = true
        }
    }

    public func showElement() {
        if (this.isInRange && !this.isTransparent) {
            this.hidden = false
            this._isFirstFrame = true
            //this.maskManager._isFirstFrame = true
        }
    }

    public func clearCanvas() {
        canvasContext.getOrThrow().clearRect(
            this.transformCanvas.tx,
            this.transformCanvas.ty,
            this.transformCanvas.w * this.transformCanvas.sx,
            this.transformCanvas.h * this.transformCanvas.sy
        )
    }

    public func prepareLayer() {
        if (this.data.tt >= 1) {
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
        }
    }

    public func exitLayer() {
        if (this.data.tt >= 1) {
            //恢复图层
            this.canvasContext.getOrThrow().restoreLayer()
            //将递归图层和mask动效图层进行指定混合
            this.canvasContext.getOrThrow().globalCompositeOperation = operationsMap[this.data.tt]
            //对之前的混合模式还原成默认模式
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
            //恢复图层
            this.canvasContext.getOrThrow().restoreLayer()
            this.canvasContext.getOrThrow().restoreLayer()
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
        }
    }


    public func renderFrame(forceRender: Bool) {
        if (this.hidden || this.data.hd) {
            return
        }
        if (this.data.td == 1 && !forceRender) {
            return
        }
        // this.renderTransform()
        // this.renderRenderable()
        this.setBlendMode()
        var forceRealStack = (this.data.ty == 0)
        //开始处理mask数据：包含两层layer数据，需要创建两个离屏绘制上下文
        this.prepareLayer()
        this.exitLayer()

        //恢复高斯模糊的默认值，防止非高斯模糊图层也高斯模糊
        this.canvasContext.getOrThrow().filter = "blur(0px)"

        if (this.maskManager.getOrThrow().hasMasks) {
            //this.globalData.renderer.restore(true)
        }
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }

    public func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {
        this._isFirstFrame = true
        //this.renderShapeColor(color, endColor, index)
    }
    
    public func destroy() {
        this.canvasContext = None
        this.data = Layer()
        this.maskManager.getOrThrow().destroy()
    }

    public func mHelper() {
        return Matrix()
    }

    public func hide() {
        this.hideElement()
    }

    public func show() {
        this.showElement()
    }
}

