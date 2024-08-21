/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GlobalData structure.
 */
package lottie4cj.global_data

internal import lottie4cj.model.*
internal import lottie4cj.utils.*
internal import lottie4cj.utils.helpers.*
internal import lottie4cj.bezier.*

public class CompSize {
    public let w: Float64                          // 0 = width       // View width
    public let h: Float64                          // 1 = height      // View height

    public init(w!: Float64 = 0.0, h!: Float64 = 0.0){
        this.w = w
        this.h = h
    }
}

public class TransformCanvas {
    public var w: Int64 = 0
    public var h: Int64 = 0
    public var sx: Int64 = 0
    public var sy: Int64 = 0
    public var tx: Int64 = 0
    public var ty: Int64 = 0
    
    public var props: Array<Float64> = Array<Float64>()

    public init(){}

    public init(w!: Int64, h!: Int64, sx!: Int64, sy!: Int64, tx!: Int64, ty!: Int64){
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
}

public class RenderConfig {

    public var clearCanvas: Bool
    //TODO: 未确认数据类型 context  //public var context: Option<context>
    public var progressiveLoad: Bool
    public var preserveAspectRatio: String
    public var imagePreserveAspectRatio: String
    public var contentVisibility: String
    public var className: String
    public var id: String
    public var runExpressions: Bool

    public var dpr: Int64 = 1

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
        dpr!: Int64 = 1
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
    public var frameNum: Int64 = -1
    public var _mdf: Bool = false
    public var renderConfig: RenderConfig= RenderConfig()
    public var currentGlobalAlpha: Int64 = -1
    
    //TODO： 数据类型需要再确认 //public var blendMode: Int64 = 0
    public var blendMode: String = ""
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译  //public var canvasContext: Option<CanvasRenderingContext2D>
    //TODO：未完全实现 CanvasRendererBase  //public var renderer: CanvasRendererBase =
    public var isDashed: Bool = false

    public var canvasContext: CanvasContext = CanvasContext()
    public var transformCanvas: TransformCanvas = TransformCanvas()

    public var frameId: Int64 = 0
    public var frameRate: Float64 = 0.0
    public var nm: String = ""
    public var compSize: CompSize = CompSize()
    
    public var progressiveLoad: Bool = false

    public var fontManager: FontManager = FontManager()

    public var defs: CreateNS = CreateNS("")

    public init(){}
    
    public init(frameNum!: Int64, _mdf!: Bool, renderConfig!: RenderConfig, currentGlobalAlpha!: Int64) {
        this.frameNum = frameNum
        this._mdf = _mdf
        this.renderConfig = renderConfig
        this.currentGlobalAlpha = currentGlobalAlpha
    }

    public func getAssetsPath(assetData: Asset): String { return "" }

}


public class FinalTransform {

    public var mProp: Object
    public var _matMdf: Bool
    public var _opMdf: Bool
    public var mat: Matrix

    public init(mProp: Object, _matMdf: Bool, _opMdf: Bool, mat: Matrix) {
        this.mProp = mProp
        this._matMdf = _matMdf
        this._opMdf = _opMdf
        this.mat = mat
    }
}