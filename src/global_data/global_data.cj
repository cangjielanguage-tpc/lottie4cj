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
    public var frameNum: Float64 = -1.0
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
    
    public init(frameNum!: Float64, _mdf!: Bool, renderConfig!: RenderConfig, currentGlobalAlpha!: Int64) {
        this.frameNum = frameNum
        this._mdf = _mdf
        this.renderConfig = renderConfig
        this.currentGlobalAlpha = currentGlobalAlpha
    }

    public func getAssetsPath(assetData: Asset): String { return "" }

}


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
}

public class Mprop {
    public var o: Mpropo 
    public var v: Matrix 
    public var p: Mpropp 
    public var or: MpropOr 
    public var s: Mprops 
    public var a: Mpropa 
    public var autoOriented: Bool 
    public var _opMdf: Bool 
    public var _mdf: Bool
    public var rxv: Float64 
    public var ryv: Float64
    public var rzv: Float64

    public init(o!:Mpropo = Mpropo(),v!:Matrix = Matrix(),p!:Mpropp = Mpropp(),or!:MpropOr = MpropOr(),s!:Mprops = Mprops(),a!:Mpropa = Mpropa(),autoOriented!: Bool=false ,_opMdf!: Bool =false,_mdf!: Bool=false,rxv!:Float64 = 0.0,ryv!:Float64 = 0.0,rzv!:Float64 = 0.0) {
        this.o =o
        this.v = v
        this.p = p
        this.or = or
        this.s = s
        this.a = a
        this.autoOriented = autoOriented
        this._opMdf = _opMdf
        this._mdf = _mdf
        this.rxv = rxv
        this.ryv = ryv
        this.rzv = rzv
    }
}
public class Mpropp {
    public var v: ArrayList<Float64>
    public init(v!:ArrayList<Float64> = ArrayList<Float64>()) {
        this.v = v
    }
}
public class Mprops {
    public var v: ArrayList<Float64> 
    public init(v!:ArrayList<Float64> = ArrayList<Float64>()) {
        this.v = v
    }
    
}
public class Mpropa {
    public var v: ArrayList<Float64> 
    public init(v!:ArrayList<Float64> = ArrayList<Float64>()) {
        this.v = v
    }
}
public class MpropOr {
    public var v: ArrayList<Float64>
    public init(v!:ArrayList<Float64> = ArrayList<Float64>()) {
        this.v = v
    }
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
public class Datas {
    public var ty: String = ""
    public var ml: String = ""
    public var t: Int64 = 0
    public var lj: Int64 = 0
    public var lc: Int64 = 0
    public var hd: Bool = false
    public var _render: Bool = false
    public var hasMask: Bool = false
    public var g: Datasg = Datasg()
    public var ln: String = ""
    public var cl: String = ""
    public var bm: Int64 = 0
    public var r: Int64 = 0
    public var shapes: Array<DatasShapes> = Array<DatasShapes>()
}
public class DatasShapes {
    public var it: Array<DatasShapesIt> = Array<DatasShapesIt>()
}
public class DatasShapesIt {
    public var s: ?DatasShapesIts = DatasShapesIts()
}
public class DatasShapesIts {
    public var k: ArrayList<Float64> = ArrayList<Float64>()
}

public class Datasg {
    public var p: Int64 = 0
}

let tmp_array_String = Array<String>()
public class ElementData {
   public var transform: SvgTransform = SvgTransform()
   public var transformers: Array<SvgTransforms> = Array<SvgTransforms>()
   public var style: SvgStyleElem = SvgStyleElem()
   public var c: ElementDatac = ElementDatac()
   public var o: ElementDatao = ElementDatao()
   public var d: Option<ElementDatad> = ElementDatad()
   public var w: ?ElementDataw = ElementDataw()
   public var gf: CreateNS = CreateNS("")
   public var of: CreateNS = CreateNS("")
   public var g: ElementDatag = ElementDatag()
   public var s: ElementDatas = ElementDatas()
   public var e: ElementDatae = ElementDatae()
   public var cst: Array<CreateNS> = Array<CreateNS>()
   public var ost: Array<CreateNS> = Array<CreateNS>()
   public var h: ElementDatah = ElementDatah()
   public var a: ElementDataa = ElementDataa()
   public var styles: Array<ElementDataStyle> = Array<ElementDataStyle>()
   public var lvl: Int64 = 0
   public var sh: ?ElementDataSh = None
   public var caches: Array<String> = tmp_array_String
   public var it: Array<ElementData> = Array<ElementData>()
}
public class SvgTransforms {
    public var container: CreateNS = CreateNS("")
    public var op: SvgOp = SvgOp()
    public var mProps: SvgmProps = SvgmProps()
}
public class ElementDataShPaths {
    public var _length: Int64 = 0
    public var shapes: Array<Option<ShapeData>> = Array<Option<ShapeData>>()
}
public class ElementDataSh {
    public var _mdf: Bool = false
    public var v: ElementDataShv = ElementDataShv()
    public var paths: ElementDataShPaths = ElementDataShPaths()
}

let twoarraydata = Array<Array<Float64>>()
public class ElementDataShv {
    public var _length: Int64 = 0
    public var c: Int64 = 0 
    public var v: Array<Array<Float64>> = twoarraydata
    public var i: Array<Array<Float64>> = twoarraydata
    public var o: Array<Array<Float64>> = twoarraydata
}
public class ElementDataStyle {
    public var _mdf: Bool = false
    public var v: Float64 = 0.0
    public var lvl: Int64 = 0
    public var d: String = ""
}
public class ElementDatah {
    public var _mdf: Bool = false
    public var v: Float64 = 0.0
}
public class ElementDataa {
    public var _mdf: Bool = false
    public var v: Float64 = 0.0
}

let arraydata = Array<Float64>()
public class ElementDatas {
    public var _mdf: Bool = false
    public var v: Array<Float64> = arraydata
}
public class ElementDatae {
    public var _mdf: Bool = false
    public var v: Array<Float64> = arraydata
}
public class ElementDatag {
    public var _hasOpacity: Int64 = 0
    public var _collapsable: Bool = false
    public var _cmdf: Bool = false
    public var _omdf: Bool = false
    public var c: Array<Float64> = arraydata
    public var o: Array<Float64> = arraydata
}
public class ElementDatad {
    public var _mdf: Bool = false
    public var dashStr: String = ""
    public var dashoffset: Array<String> = tmp_array_String
}

public class ElementDatac {
    public var _mdf: Bool = false
    public var v: Array<Float64> = arraydata
}

public class ElementDatao {
    public var _mdf: Bool = false
    public var v: String = ""
}

public class ElementDataw {
    public var _mdf: Bool = false
    public var v: Float64 = 0.0
    public var mult: Float64 = 0.0
    public var keyframes: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
}

public class SvgTransform {
    public var container: CreateNS = CreateNS("")
    public var op: SvgOp = SvgOp()
    public var mProps: SvgmProps = SvgmProps()
}

public class SvgOp {
    public var _mdf: Bool = false
    public var v: String = ""
}

public class SvgmProps {
    public var _mdf: Bool = false
    public var v: Matrix = Matrix()
}

public class SvgStyleElem {
    public var pElem: CreateNS = CreateNS("")
    public var msElem: Option<CreateNS> = None
}