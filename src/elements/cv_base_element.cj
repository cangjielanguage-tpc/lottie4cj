package elements

import model.*
import global_data.*

var operationsMap: HashMap<Int64, String> = HashMap<Int64, String>([
    (1, "source-in"),
    (2, "source-out"),
    (3, "source-in"),
    (4, "source-out")

])
public class CvBaseElement {

    private var data: ?Data = Data()
    private var buffers: ArrayList<String> = ArrayList<String>()
    private var canvasContext: ?CanvasContext = CanvasContext()
    private var transformCanvas: TransformCanvas = TransformCanvas()
    private var renderableEffectsManager: ?CvEffects = None
    private var globalData: ?GlobalData = GlobalData()
    private var maskManager: ?CvMaskElement = None
    private var hidden: Bool = false
    private var isInRange: Bool = false
    private var isTransparent: Bool = false
    private var _isFirstFrame: Bool = false

    public init() {
        super()
    }

    public func createElements() {
        //TODO
    }

    public func initRendererElement() {
        //TODO
    }

    public func createContainerElements() {
        this.canvasContext = this.globalData.getOrThrow().canvasContext
        this.transformCanvas = this.globalData.getOrThrow().transformCanvas
    }

    public func createContent() {
        //TODO
    }

    public func setBlendMode() {
        var globalData = this.globalData
        if (globalData.getOrThrow().blendMode != this.data.getOrThrow().bm) {
            globalData.getOrThrow().blendMode = this.data.getOrThrow().bm
            var blendModeValue = getBlendMode(this.data.getOrThrow().bm)
            globalData.getOrThrow().canvasContext.globalCompositeOperation = blendModeValue
        }
        
    }

    public func createRenderableComponents() {
        this.maskManager = CvMaskElement(this.data.getOrThrow(), this)
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
        if (this.data.getOrThrow().tt >= 1) {
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
        }
    }

    public func exitLayer() {
        if (this.data.getOrThrow().tt >= 1) {
            //恢复图层
            this.canvasContext.getOrThrow().restoreLayer()
            //将递归图层和mask动效图层进行指定混合
            this.canvasContext.getOrThrow().globalCompositeOperation = operationsMap[this.data.getOrThrow().tt]
            this.canvasContext.getOrThrow().globalCompositeOperation = "source-over"
        }
    }


    public func renderFrame(forceRender: Bool) {
        if (this.hidden || this.data.getOrThrow().hd) {
            return
        }
        if (this.data.getOrThrow().td == 1 && !forceRender) {
            return
        }

        this.setBlendMode()
        var forceRealStack = (this.data.getOrThrow().ty == 0)
        //开始处理mask数据：包含两层layer数据，需要创建两个离屏绘制上下文
        this.prepareLayer()
        this.exitLayer()

        //恢复高斯模糊的默认值，防止非高斯模糊图层也高斯模糊
        this.canvasContext.getOrThrow().filter = "blur(0px)"

        if (this.maskManager.getOrThrow().hasMasks) {
            //TODO
        }
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }

    public func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {
        //TODO
    }
    
    public func destroy() {
        this.canvasContext = None
        this.data = None
        this.globalData = None
        this.maskManager.getOrThrow().destroy()
    }
}

