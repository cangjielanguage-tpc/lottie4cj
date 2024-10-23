/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GlobalData structure.
 */
package lottie.global_data

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.hilog.*


internal import lottie.model.*
internal import lottie.utils.*
internal import lottie.utils.helpers.*
internal import lottie.bezier.*


import std.collection.*

public class CompSize {
    public let w: Float64                          // 0 = width       // View width
    public let h: Float64                          // 1 = height      // View height

    public init(w!: Float64 = 0.0, h!: Float64 = 0.0){
        this.w = w
        this.h = h
    }
}

public class TransformCanvas {
    public var w: Float64 = 0.0
    public var h: Float64 = 0.0
    public var sx: Float64 = 0.0
    public var sy: Float64 = 0.0
    public var tx: Float64 = 0.0
    public var ty: Float64 = 0.0
    
    public var props: Array<Float64> = Array<Float64>()

    public init(){}

    public init(w!: Float64, h!: Float64, sx!: Float64, sy!: Float64, tx!: Float64, ty!: Float64){
        this.w = w
        this.h = h
        this.sx = sx
        this.sy = sy
        this.tx = tx
        this.ty = ty
    }
}


public class CanvasContext {

    public var globalCompositeOperation: String = ""

    public var filter: String = ""

    public func clearRect(x: Int64, y: Int64, w: Int64, h: Int64) {
        //TODO
    }

    public func restoreLayer() {
        //TODO
    }

    public func beginPath() {
        //TODO
    }
    
    public func fill(r: Int64) {
        //TODO
    }
}

public class RenderConfig {
    //编译使用
    public var hideOnTransparent: Bool = false
    public var clearCanvas: Bool
    //TODO: 未确认数据类型 context  //public var context: Option<context>
    public var progressiveLoad: Bool
    public var preserveAspectRatio: String
    public var imagePreserveAspectRatio: String
    public var contentVisibility: String
    public var className: String
    public var id: String
    public var runExpressions: Bool

    public var dpr: Float64 = 1.0

    public init(
        clearCanvas!: Bool = true,
        //TODO: 未确认数据类型 context  //context!: Option<context> = None,
        progressiveLoad!: Bool = false,
        preserveAspectRatio!: String = "xMidYMid meet",
        imagePreserveAspectRatio!: String = "xMidYMid slice",
        contentVisibility!: String = "visible",
        className!: String = "",
        id!: String = "",
        runExpressions!: Bool = true,
        dpr!: Float64 = 1.0
    ){
        this.clearCanvas = clearCanvas
        //TODO: 未确认数据类型 context  //this.context = context
        this.progressiveLoad = progressiveLoad
        this.preserveAspectRatio = preserveAspectRatio
        this.imagePreserveAspectRatio = imagePreserveAspectRatio
        this.contentVisibility = contentVisibility
        this.className = className
        this.id = id
        this.runExpressions = runExpressions
        this.dpr = dpr
    }
}

//TODO: 未完全实现
public class GlobalData {

    //TODO: 未实现 ProjectInterface  //public var projectInterface: ProjectInterface = ProjectInterface()
    public var frameNum: Float64 = -1.0
    public var _mdf: Bool = false
    public var renderConfig: RenderConfig= RenderConfig()
    public var currentGlobalAlpha: Int64 = -1
    
    //TODO： 数据类型需要再确认 //public var blendMode: Int64 = 0
    public var blendMode: String = ""
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //public var canvasContext: Option<CanvasRenderingContext2D>
    //TODO：未完全实现 CanvasRendererBase  //public var renderer: CanvasRendererBase =
    public var isDashed: Bool = false

    //public var canvasContext: CanvasContext = CanvasContext()
    //TODO: 初始化一个空的 CanvasRenderingContext2D 编译用。
//    private var renderingSettings: RenderingContextSettings = unsafe{zeroValue<RenderingContextSettings>()}
    public var canvasContext: LottieCanvasRenderingContext2D = unsafe{zeroValue<LottieCanvasRenderingContext2D>()}
    public var hasCanvasRenderingContext2D: Bool = false

    public var transformCanvas: TransformCanvas = TransformCanvas()

    public var frameId: Int64 = 0
    public var frameRate: Float64 = 0.0
    public var nm: String = ""
    public var compSize: CompSize = CompSize()
    
    public var progressiveLoad: Bool = false

    public var fontManager: FontManager = FontManager()

    public var defs: CreateNS = CreateNS("")

    //BaseRenderer.setupGlobalData 中给函数型成员变量赋值。
    public var getAssetData: (String) -> Asset = { m => return Asset("", Array<Layer>(), 0, 0, "", "", 0) }
    public var getAssetsPath: (Asset) -> String = { m => return "" }
    public var imageLoader: ImagePreloader = ImagePreloader()
    //TODO：循环依赖。AudioControllerFactory 和 GlobalData 大循环依赖。
    //public var audioController: AudioControllerFactory = AudioControllerFactory()

    //TODO: 解构 renderer 和 globalData。
    //this.globalData.renderer.save(forceRealStack);
    //this.globalData.renderer.ctxTransform(this.finalTransform.mat.props);
    //this.globalData.renderer.ctxOpacity(this.finalTransform.mProp.o.v);
    //this.globalData.renderer.restore(true);
    public var save: (Bool) -> Unit = { m => () }
    public var ctxTransform: (Array<Float64>) -> Unit = { m => () }
    public var ctxOpacity: (Int64) -> Unit = { m => () }
    public var restore: (Bool) -> Unit = { m => () }
    public var hasRenderer: Bool = false

    //TODO: 初始化后，传入 BaseRenderer.buildAllItems() 函数。
    public var buildAllItemsElement: (Array<Layer>) -> Unit = { m => ()}
    //TODO: 初始化后，传入 BaseRenderer.checkLayers(num: Float64) 函数。
    public var checkLayers: (Float64) -> Unit = { m => ()}
    //TODO: 循环引用。
    //public var createItem: (Layer) -> BaseElement = { m => return BaseElement(Layer(), GlobalData(), isNull: true) }

    public var isNull: Bool = false

    public init(){
        this.isNull = true
    }
    public init(canvasContext: LottieCanvasRenderingContext2D){
        this.canvasContext = canvasContext
    }
    
    public init(frameNum!: Float64, _mdf!: Bool, renderConfig!: RenderConfig, currentGlobalAlpha!: Int64,
        canvasContext!: LottieCanvasRenderingContext2D
        //save!: (Bool) -> Unit = { m => () },
        //ctxTransform!: (Array<Float64>) -> Unit = { m => () },
        //ctxOpacity!: (Int64) -> Unit = { m => () },
        //restore!: (Bool) -> Unit = { m => () },
        //hasRenderer!: Bool = false
    ) {
        this.frameNum = frameNum
        this._mdf = _mdf
        this.renderConfig = renderConfig
        this.currentGlobalAlpha = currentGlobalAlpha
        this.canvasContext = canvasContext
        //this.save = save
        //this.ctxTransform = ctxTransform
        //this.ctxOpacity = ctxOpacity
        //this.restore = restore
        //this.hasRenderer = hasRenderer
    }

    //public func getAssetsPath(assetData: Asset): String { return "" }

}

/*
public class FinalTransform {

    public var mProp: Mprop
    public var _matMdf: Bool
    public var _opMdf: Bool
    public var mat: Matrix

    public init(mProp!: Mprop = Mprop(), _matMdf!: Bool= false, _opMdf!: Bool= false, mat!: Matrix= Matrix()) {
        this.mProp = mProp
        this._matMdf = _matMdf
        this._opMdf = _opMdf
        this.mat = mat
    }
}*/

public class Mprop {
    public var o: Mpropo = Mpropo()
    public var v: Matrix = Matrix()
    public var autoOriented: Bool = false
    public var _opMdf: Bool = false
    public var _mdf: Bool = false
}
public class Mpropo {
    public var v: Int64 = 0
    public var _opMdf: Bool = false
    public var _mdf: Bool = false
}

public func indexOf<T>(referenceNode: T, arr: ArrayList<T>): Int64 where T <: Object {
    var index: Int64 = 0
    for (createNS in arr) {
        if (refEq(createNS, referenceNode)) {
            return index
        }
        index++
    }
    return -1
}
