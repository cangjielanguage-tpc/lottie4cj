/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

internal import lottie4cj.pool.*

func default_unit_to_unit(): Unit {}

/*
 * 5个 xxxShapeProperty 都只在 ShapePropertyFactory 内部调用，对外还是直接用的 ShapePropertyFactory。
 * KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
 * 方案：
 *     1. 将 5个 xxxShapeProperty 都合并在 ShapePropertyFactory 中；
 *         -- 【不可以】- getValue 在3个XXXShapeProperty中重载了。
 *         -- 【可以】- 命名为 getValueXXXShapeProperty
 *     2. 5个 xxxShapeProperty 都是 ShapePropertyFactory 的子类、
 */
public class ShapePropertyFactory <: DynamicPropertyContainer {
    var initFrame: Int64 = -999999
    var cPoint: Float64 = roundCorner

    /*
     * ty = 3 => data == this.masksProperties[i] == Array<Mask>[i]
     * (ty === "sh"/"rc"/"el"/"sr")
     * ty = 4 => data.ty === "sh" = ShapePath
     * ty = 5 => data.ty === "rc" = RectangleShape
     * ty = 6 => data.ty === "el" = CircleShape
     * ty = 7 => data.ty === "sr" = PolystarShape
     * TODO: 将 Mask 设置成 ContentModel 的子类？？？---已设置
     */
    var types: Int64 = 0

    public var data: ContentModel
    
    var lock: Bool = false
    
    var pt_data: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
    var ks_data: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()


    //ShapeProperty增加成员变量分割线------------------------------------------------------------------------------------
    //暂时明确的 ShapeProperty.data 的数据类型 ShapePath/Mask
    public var k: Bool = false
    public var kf: Bool = false
    
    public var v: ShapeData = ShapeData()
    public var pv: ShapeData = ShapeData()

    public var localShapeCollection: ShapeCollection = ShapeCollection()
    public var paths: ShapeCollection = ShapeCollection()
    public var reset: () -> Unit = { => return () }

    public var effectsSequence: ArrayList<() -> ShapeData> = ArrayList<() -> ShapeData>()


    //KeyframedShapeProperty增加成员变量分割线----------------------------------------------------------------------------
    public var offsetTime: Float64 = 0.0
    public var keyframes: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
    public var keyframesMetadata: Array<KeyframeMetadata> = Array<KeyframeMetadata>()
    public var lastFrame: Int64 = initFrame
    public var _caching: Caching = Caching(lastFrame: initFrame, lastIndex: 0)


    //RectShapePropertyFactory增加成员变量分割线---------------------------------------------------------------------
    public var frameId: Int64 = -1
    public var d: Int64 = -1
    public var p: PropertyFactory<AnimatableSplitDimensionPathValue, PointF>
    public var s: PropertyFactory<ArrayKeyframePointF, PointF>
    public var r: PropertyFactory<ArrayKeyframeFloat64, Float64>


    //StarShapeProperty增加成员变量分割线------------------------------------------------------------------------------
    public var convertToPath: () -> Unit = { => return () }
    public var ir: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var is2: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var pt: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var or: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var os: PropertyFactory<ArrayKeyframeFloat64, Float64>

    
    public init(data: ContentModel, types: Int64, elemGlobalData: GlobalData, elemData: Layer, addEffectsSequence!: Bool = false){
        super(elemGlobalData, elemData)
        this.propType = "shape"

        this.data = data
        this.types = types

        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>(AnimatableSplitDimensionPathValue(), 0.0, dp, elemGlobalData, elemData)
        this.s = PropertyFactory<ArrayKeyframePointF, PointF>(ArrayKeyframePointF(), 0.0, dp, elemGlobalData, elemData)
        let arr: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
        this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)
        this.ir = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)
        this.is2 = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)
        this.pt = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)
        this.or = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)
        this.os = PropertyFactory<ArrayKeyframeFloat64, Float64>(arr, 0.0, dp, elemGlobalData, elemData)

        if (addEffectsSequence) {
            this.effectsSequence.append(interpolateShapeCurrentTime)
        }
    }

    /*
     * ShapePropertyFactory 是提取的父类：KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
     * data = arr[i] = ContentModel //arr = Array<ContentModel> //完整形状数据  //this.shapesData = data.shapes  => layer.shapes = Array<ContentModel>
     *
     * element == CVShapeElement/SVGShapeElement
     * [MaskElement]: element == HBaseElement/SVGBaseElement
     * [CVMaskElement]: element == CVBaseElement
     *
     * 5个 xxxShapeProperty 都只在 ShapePropertyFactory 内部调用，对外还是直接用的 ShapePropertyFactory。
     * - KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
     */
    public static func getShapeProp(data: ContentModel, types: Int64, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        var props: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData)

        if (types == 3 || types == 4) {
            var dataProp: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
            var mask_pt: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()
            var sh_ks: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>()

            if (types == 3) {
                let mask: Mask = (data as Mask).getOrThrow()
                dataProp = mask.pt
                mask_pt = mask.pt
            } else if (types == 4) {
                let sh: ShapePath = (data as ShapePath).getOrThrow()
                dataProp = sh.ks
                sh_ks = sh.ks
            }

            if (dataProp.size > 1) {          // keys 是数组 => data.pt/ks.k 是数组
                props = keyframedShapeProperty(data, types, dataProp, elemGlobalData, elemData)
            } else if (dataProp.size == 1) {  // keys 是对象 => data.pt/ks.k 是对象
                props = shapeProperty(data, types, dataProp[0], elemGlobalData, elemData)
            }
            props.pt_data = mask_pt
            props.ks_data = sh_ks
        } else if (types == 5) {
            let rc: RectangleShape = (data as RectangleShape).getOrThrow()
            props = rectShapeProperty(rc, types, elemGlobalData, elemData)
        } else if (types == 6) {
            let el: CircleShape = (data as CircleShape).getOrThrow()
            props = ellShapeProperty(el, types, elemGlobalData, elemData)
        } else if (types == 7) {
            let sr: PolystarShape = (data as PolystarShape).getOrThrow()
            props = starShapeProperty(sr, types, elemGlobalData, elemData)
        }
        if (props.k) {
            //TODO: 需要确认调用的是哪一级父类的 addDynamicProperty 函数。   //elem.addDynamicProperty(props)
        }
        return props
    }

    //TODO: 此处的返回数据类型名称，需要根据实际调用再调整。   //public func getConstructorFunction() { return ShapeProperty }

    //TODO: 此处的返回数据类型名称，需要根据实际调用再调整。 //public func getKeyframedConstructorFunction() { return KeyframedShapeProperty }


//5个 xxxShapeProperty 初始化分隔线--------------------------------------------------------------------------------------

    //暂时明确的 data 的数据类型 ShapePath/Mask
    public static func shapeProperty(data: ContentModel, types: Int64, pathData: Keyframe<ShapeData>, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        let sp: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData)

        //data.pt/ks.k 是对象 => pathData 是对象 => pathData = Mask.pt[0]/ShapePath.ks[0]  =>  直接传入 pathData(data.pt/ks.k)
        //TODO：调不到shapePool.clone，需要把 shapePool 改为对象？？？  //sp.v = shapePool.clone(pathData)
        //TODO：调不到shapePool.clone，需要把 shapePool 改为对象？？？  //sp.pv = shapePool.clone(sp.v)

        sp.paths.addShape(sp.v)
        sp.reset = sp.resetShape
        return sp
    }
    
    //TODO：暂时明确的 data 的数据类型 ShapePath/Mask
    public static func keyframedShapeProperty(data: ContentModel, types: Int64, k: Array<Keyframe<ShapeData>>, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        let sp: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData, addEffectsSequence: true)
        
        sp.offsetTime = elemData.st
        //data.pt/ks.k 是数组 => pathData 是数组 => pathData = Mask.pt/ShapePath.ks  =>  直接传入 data.pt/ks.k
        sp.keyframes = k

        if (let Some(sv) <- sp.keyframes[0].s) {
            var len: Int64 = sv.i.size

            sp.v.setPathData(sv.c, len)
        }
        //TODO：调不到shapePool.clone，需要把 shapePool 改为对象？？？  //sp.pv = shapePool.clone(sp.v)

        sp.paths.addShape(sp.v)
        sp.reset = sp.resetShape

        //在init初始化时赋值加入数组中。-- sp.effectsSequence = [interpolateShapeCurrentTime]
        return sp
    }
    
    //TODO：暂时明确的 data = RectangleShape 的数据类型 
    public static func rectShapeProperty(data: RectangleShape, types: Int64, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        let sp: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData)

        sp.v.c = true
        sp.localShapeCollection.addShape(sp.v)
        
        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        sp.initDynamicPropertyContainer(elemGlobalData, elemData)
        
        // 仔细辨别确认调用的是 PropertyFactory.getProp 哪个分支。
        if (data.p.k.size > 1) {//p: AnimatableSplitDimensionPathValue => _k: Array<Keyframe<PointF>>
            sp.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, sp, elemGlobalData, elemData)
        } else if (data.p.k.size == 1) {//走【分支2】:  dataK 是数组Array<number>   //json中："p": {"a": 0, "k": [0, 0], "ix": 3}
            let point: PointF = data.p.k[0].k ?? PointF(x: 0.0, y: 0.0)
            sp.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 1.0, sp, elemGlobalData, elemData)
        }
        
        if (data.s.k.size > 1) {//_s: Array<Keyframe<PointF>>
            sp.s = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.s, data.s.k, 1, 0.0, sp, elemGlobalData, elemData)
        } else if (data.s.k.size == 1) {//走【分支2】:  dataK 是数组Array<number>   //json中："s": {"a": 0, "k": [101.414, 91.422], "ix": 2}
            let point: PointF = data.s.k[0].k ?? PointF(x: 0.0, y: 0.0)
            sp.s = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.s, point, 0.0, sp, elemGlobalData, elemData)
        }
        
        if (data.r.k.size > 1) {//_r: Array<Keyframe<Float64>>
            sp.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k, 0, 0.0, sp, elemGlobalData, elemData)
        } else if (data.r.k.size == 1) {//走【分支1】:  dataK 是数值  //json中："r": {"a": 0, "k": 0, "ix": 4}
            sp.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, (data.r.k[0].k ?? 0.0), 0.0, sp, elemGlobalData, elemData)
        }

        if (sp.dynamicProperties.size != 0) {
            sp.k = true
        } else {
            sp.k = false
            sp.convertRectToPath()
        }
        return sp
    }

    /* 暂时明确的 data = CircleShape 的数据类型 */
    public static func ellShapeProperty(data: CircleShape, types: Int64, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        let sp: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData)
        
        sp.v.setPathData(true, 4)
        sp.localShapeCollection.addShape(sp.v)
        sp.d = data.d

        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        sp.initDynamicPropertyContainer(elemGlobalData, elemData)
        
        /* 仔细辨别确认调用的是 PropertyFactory.getProp 哪个分支。 */
        if (data.p.k.size > 1) {  //p: AnimatableSplitDimensionPathValue => _k: Array<Keyframe<PointF>>
            sp.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, sp, elemGlobalData, elemData)
        } else if (data.p.k.size == 1) { //走【分支2】:  dataK 是数组Array<number>   //json中："p": {"a": 0, "k": [0, 0], "ix": 3}
            let point: PointF = data.p.k[0].k ?? PointF(x: 0.0, y: 0.0)
            sp.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 1.0, sp, elemGlobalData, elemData)
        }
        
        if (data.s.k.size > 1) { //_s: Array<Keyframe<PointF>>
            sp.s = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.s, data.s.k, 1, 0.0, sp, elemGlobalData, elemData)
        } else if (data.s.k.size == 1) { //走【分支2】:  dataK 是数组Array<number>   //json中："s": {"a": 0, "k": [332.711, 332.711], "ix": 2}
            let point: PointF = data.s.k[0].k ?? PointF(x: 0.0, y: 0.0)
            sp.s = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.s, point, 0.0, sp, elemGlobalData, elemData)
        }

        if (sp.dynamicProperties.size != 0) {
            sp.k = true
        } else {
            sp.k = false
            sp.convertEllToPath()
        }
        return sp
    }

    /* 暂时明确的 data = PolystarShape 的数据类型 */
    public static func starShapeProperty(data: PolystarShape, types: Int64, elemGlobalData: GlobalData, elemData: Layer): ShapePropertyFactory {
        let sp: ShapePropertyFactory = ShapePropertyFactory(data, types, elemGlobalData, elemData)
        
        sp.v.setPathData(true, 0)

        sp.d = data.d
        
        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        sp.initDynamicPropertyContainer(elemGlobalData, elemData)
        if (data.sy == 1) {
            /* 仔细辨别确认调用的是 PropertyFactory.getProp 哪个分支。 */
            //"ir":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[54.99]},{"t":59,"s":[61.99]}],"ix":6}
            if (data.ir.k.size > 1) {//【分支3】
                sp.ir = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.ir, data.ir.k, 0, 0.0, sp, elemGlobalData, elemData)
            }
            
            //"is":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[0]},{"t":59,"s":[5]}],"ix":8}
            if (data.is2.k.size > 1) {//【分支3】
                sp.is2 = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.is2, data.is2.k, 0, 0.01, sp, elemGlobalData, elemData)
            }
            
            sp.convertToPath = sp.convertStarToPath
        } else {
            sp.convertToPath = sp.convertPolygonToPath
        }
        
        //"pt":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[5]},{"t":59,"s":[6]}],"ix":3}
        if (data.pt.k.size > 1) {//【分支3】 //_pt: Array<Keyframe<Float64>>
            sp.pt = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.pt, data.pt.k, 0, 0.0, sp, elemGlobalData, elemData)
        }
        
        //"p":{"a":1,"k":[{"i":{"x":0.833,"y":0.833},"o":{"x":0.167,"y":0.167},"t":0,"s":[0,0],"to":[0.833,1.333],"ti":[-0.833,-1.333]},{"t":59,"s":[5,8]}],"ix":4}
        if (data.p.k.size > 1) {//【分支4】   //p: AnimatableSplitDimensionPathValue => _k: Array<Keyframe<PointF>>
            sp.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, sp, elemGlobalData, elemData)
        }
        
        //"r":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[187.839]},{"t":59,"s":[204.839]}],"ix":5}
        if (data.r.k.size > 1) {//【分支3】   //_r: Array<Keyframe<Float64>>
            sp.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k, 0, degToRads, sp, elemGlobalData, elemData)
        }
        
        //"or":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[109.981]},{"t":59,"s":[123.981]}],"ix":7}
        if (data.or.k.size > 1) {//【分支3】  //_or: Array<Keyframe<Float64>> 
            sp.or = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.or, data.or.k, 0, 0.0, sp, elemGlobalData, elemData)
        }
        
        //"os":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"t":0,"s":[0]},{"t":59,"s":[40]}],"ix":9}
        if (data.os.k.size > 1) {//【分支3】  //_os: Array<Keyframe<Float64>>
            sp.os = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.os, data.os.k, 0, 0.01, sp, elemGlobalData, elemData)
        }
        
        sp.localShapeCollection.addShape(sp.v)
        
        if (sp.dynamicProperties.size != 0) {
            sp.k = true
        } else {
            sp.k = false
            sp.convertToPath()
        }
        return sp
    }

//[RectShapePropertyFactory]分隔线--------------------------------------------------------------------------------------

    func convertRectToPath(): Unit {
        let p0: Float64 = this.p.v[0]
        let p1: Float64 = this.p.v[1]
        let v0: Float64 = this.s.v[0] / 2.0
        let v1: Float64 = this.s.v[1] / 2.0
        var round: Float64 = min(v0, v1)
        round = min(round, this.r.v[0])
        let cPoint: Float64 = round * (1.0 - roundCorner)
        this.v._length = 0

        if (this.d == 2 || this.d == 1) {
            this.v.setTripleAt(p0 + v0, p1 - v1 + round, p0 + v0, p1 - v1 + round, p0 + v0, p1 - v1 + cPoint, 0, replace: true)
            this.v.setTripleAt(p0 + v0, p1 + v1 - round, p0 + v0, p1 + v1 - cPoint, p0 + v0, p1 + v1 - round, 1, replace: true)
            if (round != 0.0) {
                this.v.setTripleAt(p0 + v0 - round, p1 + v1, p0 + v0 - round, p1 + v1, p0 + v0 - cPoint, p1 + v1, 2, replace: true)
                this.v.setTripleAt(p0 - v0 + round, p1 + v1, p0 - v0 + cPoint, p1 + v1, p0 - v0 + round, p1 + v1, 3, replace: true)
                this.v.setTripleAt(p0 - v0, p1 + v1 - round, p0 - v0, p1 + v1 - round, p0 - v0, p1 + v1 - cPoint, 4, replace: true)
                this.v.setTripleAt(p0 - v0, p1 - v1 + round, p0 - v0, p1 - v1 + cPoint, p0 - v0, p1 - v1 + round, 5, replace: true)
                this.v.setTripleAt(p0 - v0 + round, p1 - v1, p0 - v0 + round, p1 - v1, p0 - v0 + cPoint, p1 - v1, 6, replace: true)
                this.v.setTripleAt(p0 + v0 - round, p1 - v1, p0 + v0 - cPoint, p1 - v1, p0 + v0 - round, p1 - v1, 7, replace: true)
            } else {
                this.v.setTripleAt(p0 - v0, p1 + v1, p0 - v0 + cPoint, p1 + v1, p0 - v0, p1 + v1, 2)
                this.v.setTripleAt(p0 - v0, p1 - v1, p0 - v0, p1 - v1 + cPoint, p0 - v0, p1 - v1, 3)
            }
        } else {
            this.v.setTripleAt(p0 + v0, p1 - v1 + round, p0 + v0, p1 - v1 + cPoint, p0 + v0, p1 - v1 + round, 0, replace: true)
            if (round != 0.0) {
                this.v.setTripleAt(p0 + v0 - round, p1 - v1, p0 + v0 - round, p1 - v1, p0 + v0 - cPoint, p1 - v1, 1, replace: true)
                this.v.setTripleAt(p0 - v0 + round, p1 - v1, p0 - v0 + cPoint, p1 - v1, p0 - v0 + round, p1 - v1, 2, replace: true)
                this.v.setTripleAt(p0 - v0, p1 - v1 + round, p0 - v0, p1 - v1 + round, p0 - v0, p1 - v1 + cPoint, 3, replace: true)
                this.v.setTripleAt(p0 - v0, p1 + v1 - round, p0 - v0, p1 + v1 - cPoint, p0 - v0, p1 + v1 - round, 4, replace: true)
                this.v.setTripleAt(p0 - v0 + round, p1 + v1, p0 - v0 + round, p1 + v1, p0 - v0 + cPoint, p1 + v1, 5, replace: true)
                this.v.setTripleAt(p0 + v0 - round, p1 + v1, p0 + v0 - cPoint, p1 + v1, p0 + v0 - round, p1 + v1, 6, replace: true)
                this.v.setTripleAt(p0 + v0, p1 + v1 - round, p0 + v0, p1 + v1 - round, p0 + v0, p1 + v1 - cPoint, 7, replace: true)
            } else {
                this.v.setTripleAt(p0 - v0, p1 - v1, p0 - v0 + cPoint, p1 - v1, p0 - v0, p1 - v1, 1, replace: true)
                this.v.setTripleAt(p0 - v0, p1 + v1, p0 - v0, p1 + v1 - cPoint, p0 - v0, p1 + v1, 2, replace: true)
                this.v.setTripleAt(p0 + v0, p1 + v1, p0 + v0 - cPoint, p1 + v1, p0 + v0, p1 + v1, 3, replace: true)
            }
        }
    }

    func getValueOfRect(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        //TODO：iterateDynamicProperties 调用问题。// 拆分多继承问题 -- //extendPrototype([DynamicPropertyContainer], EllShapePropertyFactory)
        this.iterateDynamicProperties()
        if (this._mdf) {
            this.convertRectToPath()
        }
    }
//[RectShapePropertyFactory]分隔线--------------------------------------------------------------------------------------


//[EllShapeProperty]分隔线----------------------------------------------------------------------------------------------

    func getValueOfEll(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        //TODO：iterateDynamicProperties 调用问题。// 拆分多继承问题 -- //extendPrototype([DynamicPropertyContainer], EllShapePropertyFactory)
        this.iterateDynamicProperties()
    
        if (this._mdf) {
            this.convertEllToPath()
        }
    }

    func convertEllToPath() {
        let p0: Float64 = this.p.v[0]
        let p1: Float64 = this.p.v[1]
        let s0: Float64 = this.s.v[0] / 2.0
        let s1: Float64 = this.s.v[1] / 2.0
        let _cw: Bool = this.d != 3
        var _v: ShapeData = this.v
        _v.v[0].x = p0
        _v.v[0].y = p1 - s1
        _v.v[1].y = p1
        _v.v[2].x = p0
        _v.v[2].y = p1 + s1
        _v.v[3].y = p1
        _v.i[0].y = p1 - s1
        _v.i[1].y = p1 - s1 * cPoint
        _v.i[2].y = p1 + s1
        _v.i[3].y = p1 + s1 * cPoint
        _v.o[0].y = p1 - s1
        _v.o[1].y = p1 + s1 * cPoint
        _v.o[2].y = p1 + s1
        _v.o[3].y = p1 - s1 * cPoint
        if (_cw) {
            _v.v[1].x = p0 + s0
            _v.v[3].x = p0 - s0 
            _v.i[0].x = p0 - s0 * cPoint 
            _v.i[1].x = p0 + s0 
            _v.i[2].x = p0 + s0 * cPoint 
            _v.i[3].x = p0 - s0 
            _v.o[0].x = p0 + s0 * cPoint 
            _v.o[1].x = p0 + s0 
            _v.o[2].x = p0 - s0 * cPoint 
            _v.o[3].x = p0 - s0 
        } else {
            _v.v[1].x = p0 - s0
            _v.v[3].x = p0 + s0
            _v.i[0].x = p0 + s0 * cPoint
            _v.i[1].x = p0 - s0
            _v.i[2].x = p0 - s0 * cPoint
            _v.i[3].x = p0 + s0
            _v.o[0].x = p0 - s0 * cPoint
            _v.o[1].x = p0 - s0
            _v.o[2].x = p0 + s0 * cPoint
            _v.o[3].x = p0 + s0
        }
    }
//[EllShapeProperty]分隔线----------------------------------------------------------------------------------------------


//[StarShapeProperty]分隔线---------------------------------------------------------------------------------------------

     func getValueOfStar(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        //TODO：iterateDynamicProperties 调用问题。// 拆分多继承问题 -- //extendPrototype([DynamicPropertyContainer], EllShapePropertyFactory)
        this.iterateDynamicProperties()
        if (this._mdf) {
            this.convertToPath()
        }
    }

    func convertStarToPath(): Unit {
        let numPts: Float64 = floor(this.pt.v[0]) * 2.0
        let angle: Float64 = (Float64.PI * 2.0) / numPts

        var longFlag: Bool = true
        let longRad: Float64 = this.or.v[0]
        let shortRad: Float64 = this.ir.v[0]
        let longRound: Float64 = this.os.v[0]
        let shortRound: Float64 = this.is2.v[0]
        let longPerimSegment: Float64 = (2.0 * Float64.PI * longRad) / (numPts * 2.0)
        let shortPerimSegment: Float64 = (2.0 * Float64.PI * shortRad) / (numPts * 2.0)

        var rad: Float64 = 0.0
        var roundness: Float64 = 0.0
        var perimSegment: Float64 = 0.0
        var currentAng: Float64 = -Float64.PI / 2.0
        currentAng += this.r.v[0]
        var dir: Float64 = 1.0
        // 初始化的时候，已经将 data.d 赋值到 this.d 中了  //var dir = this.data.d === 3 ? -1 : 1
        if (this.d == 3) {
            dir = -1.0
        }
        this.v._length = 0
        for (i in 0..Int64(numPts)) {
            if (longFlag) {
                rad = longRad 
                roundness = longRound 
                perimSegment = longPerimSegment 
            } else {
                rad = shortRad
                roundness = shortRound
                perimSegment = shortPerimSegment
            }

            var x: Float64 = rad * cos(currentAng)
            var y: Float64 = rad * sin(currentAng)

            var ox: Float64 = 0.0
            var oy: Float64 = 0.0
            if (!(x == 0.0 && y == 0.0)) {
                ox = y / sqrt(x * x + y * y)
                oy = -x / sqrt(x * x + y * y)
            }
            //TODO: 是要把 this.p.v[0] 和 this.p.v[1] 转为正数吗？   //x += +this.p.v[0]  //y += +this.p.v[1]
            x += this.p.v[0]
            y += this.p.v[1]
            this.v.setTripleAt(x, y, x - ox * perimSegment * roundness * dir, y - oy * perimSegment * roundness * dir, x + ox * perimSegment * roundness * dir, y + oy * perimSegment * roundness * dir, i, replace: true)

            longFlag = !longFlag
            currentAng += angle * dir
        }
    }

    func convertPolygonToPath(): Unit {
        let numPts: Float64 = floor(this.pt.v[0])
        let angle: Float64 = (Float64.PI * 2.0) / numPts
        let rad: Float64 = this.or.v[0]
        let roundness: Float64 = this.os.v[0]
        let perimSegment: Float64 = (2.0 * Float64.PI * rad) / (numPts * 4.0)

        var currentAng: Float64 = -Float64.PI * 0.5
        // 初始化的时候，已经将 data.d 赋值到 this.d 中了   //var dir: Float64 = this.data.d === 3 ? -1 : 1
        var dir: Float64 = 1.0
        if (this.d == 3) {
            dir = -1.0
        }
        currentAng += this.r.v[0]
        this.v._length = 0
        for (i in 0..Int64(numPts)) {
            var x: Float64 = rad * cos(currentAng)
            var y: Float64 = rad * sin(currentAng)

            var ox: Float64 = 0.0
            var oy: Float64 = 0.0
            if (!(x == 0.0 && y == 0.0)) {
                ox = y / sqrt(x * x + y * y)
                oy = -x / sqrt(x * x + y * y)
            }

            //TODO: 是要把 this.p.v[0] 和 this.p.v[1] 转为正数吗？  //x += +this.p.v[0]  //y += +this.p.v[1]
            x += this.p.v[0]
            y += this.p.v[1]
            
            this.v.setTripleAt(x, y, x - ox * perimSegment * roundness * dir, y - oy * perimSegment * roundness * dir, x + ox * perimSegment * roundness * dir, y + oy * perimSegment * roundness * dir, i, replace: true)
            currentAng += angle * dir
        }
        //TODO: 需要再确认 this.paths 数据类型，ShapeCollection 无法获取下标[0]。  //this.paths.length = 0  //this.paths[0] = this.v
        //TODO: 暂时按照 ShapeCollection 的清空和再赋值操作。
        this.paths.releaseShapes()
        this.paths.addShape(this.v)
    }
//[StarShapeProperty]分隔线---------------------------------------------------------------------------------------------


//以下为公用函数----------------------------------------------------------------------------------------------------------

    //TODO: previousValue 是 ShapeData 类型？？？
    func interpolateShape(frameNum: Float64, previousValue: ShapeData, caching: Caching): Unit {
        var iterationIndex: Int64 = caching.lastIndex
        var keyPropS: ShapeData = ShapeData()
        var keyPropE: ShapeData = ShapeData()
        var isHold: Bool = false

        var jLen: Int64 = 0
        var kLen: Int64 = 0
        var perc: Float64 = 0.0
        var kf: Array<Keyframe<ShapeData>> = this.keyframes
        if (frameNum < kf[0].t - this.offsetTime) {
            //TODO: 是否考虑把 Keyframe 中的 k/s/e 从 Option<T> 改为 Array<T>。
            keyPropS = kf[0].s.getOrThrow()
            isHold = true
            iterationIndex = 0
        } else if (frameNum >= kf[kf.size - 1].t - this.offsetTime) {
            //TODO: 是否考虑把 Keyframe 中的 k/s/e 从 Option<T> 改为 Array<T>。
            if (let Some(v) <- kf[kf.size - 1].s) {
                keyPropS = v
            } else {
                //TODO: 是否考虑把 Keyframe 中的 k/s/e 从 Option<T> 改为 Array<T>。
                keyPropS = kf[kf.size - 2].e.getOrThrow()
            }
            isHold = true
        } else {
            var i: Int64 = iterationIndex
            var len: Int64 = kf.size - 1
            var flag: Bool = true
            var keyData: Keyframe<ShapeData> = Keyframe<ShapeData>()
            var nextKeyData: Keyframe<ShapeData> = Keyframe<ShapeData>()
            var keyframeMetadata: KeyframeMetadata = KeyframeMetadata()
            while (flag) {
                keyData = kf[i]
                nextKeyData = kf[i + 1]
                if ((nextKeyData.t - this.offsetTime) > frameNum) {
                    break
                }
                if (i < len - 1) {
                    i += 1
                } else {
                    flag = false
                }
            }

            if (this.keyframesMetadata.size > i) {
                keyframeMetadata = this.keyframesMetadata[i]
            }
            isHold = keyData.h == 1
            iterationIndex = i
            if (!isHold) {
                if (frameNum >= nextKeyData.t - this.offsetTime) {
                    perc = 1.0
                } else if (frameNum < keyData.t - this.offsetTime) {
                    perc = 0.0
                } else {
                    var fnc: (Float64) -> Float64
                    if (let Some(v) <- keyframeMetadata.__fnct) {
                        fnc = v
                    } else {
                        fnc = BezierFactory.getBezierEasing(keyData.o.x, keyData.o.y, keyData.i.x, keyData.i.y, "").getOfBezierEasing
                        keyframeMetadata.__fnct = fnc
                    }
                    perc = fnc((frameNum - (keyData.t - this.offsetTime)) / ((nextKeyData.t - this.offsetTime) - (keyData.t - this.offsetTime)))
                }

                if (let Some(v) <- nextKeyData.s) {
                    keyPropE = v
                } else {
                    //TODO: 是否考虑把 Keyframe 中的 k/s/e 从 Option<T> 改为 Array<T>。
                    keyPropE = keyData.e.getOrThrow()
                }
            }
            keyPropS = keyData.s.getOrThrow()
        }

        jLen = previousValue._length
        // 此处解析后的 keyPropS.i = Array<PointF>，故 keyPropS.i[0].length = 2   //kLen = keyPropS.i[0].length
        kLen = 2
        caching.lastIndex = iterationIndex

        for (j in 0..jLen) {
            if (isHold) {
                previousValue.i[j].x = keyPropS.i[j].x
                previousValue.o[j].x = keyPropS.o[j].x
                previousValue.v[j].x = keyPropS.v[j].x
                
                previousValue.i[j].y = keyPropS.i[j].y
                previousValue.o[j].y = keyPropS.o[j].y
                previousValue.v[j].y = keyPropS.v[j].y
            } else {
                previousValue.i[j].x = keyPropS.i[j].x + (keyPropE.i[j].x - keyPropS.i[j].x) * perc
                previousValue.o[j].x = keyPropS.o[j].x + (keyPropE.o[j].x - keyPropS.o[j].x) * perc
                previousValue.v[j].x = keyPropS.v[j].x + (keyPropE.v[j].x - keyPropS.v[j].x) * perc
                
                previousValue.i[j].y = keyPropS.i[j].y + (keyPropE.i[j].y - keyPropS.i[j].y) * perc
                previousValue.o[j].y = keyPropS.o[j].y + (keyPropE.o[j].y - keyPropS.o[j].y) * perc
                previousValue.v[j].y = keyPropS.v[j].y + (keyPropE.v[j].y - keyPropS.v[j].y) * perc
            }
        }
    }

    func interpolateShapeCurrentTime(): ShapeData {
        //TODO: BaseElement 还需要确认是否有循环引用问题。  //let frameNum: Float64 = this.comp.renderedFrame - this.offsetTime
        let frameNum: Float64 = 0.0 - this.offsetTime
        let initTime: Float64 = this.keyframes[0].t - this.offsetTime
        let endTime: Float64 = this.keyframes[this.keyframes.size - 1].t - this.offsetTime
        let lastFrame: Float64 = Float64(this._caching.lastFrame)
        if (!(lastFrame != Float64(initFrame) && ((lastFrame < initTime && frameNum < initTime) || (lastFrame > endTime && frameNum > endTime)))) {
            if (lastFrame >= frameNum) {
                this._caching.lastIndex = 0
            }
            this.interpolateShape(frameNum, this.pv, this._caching)
        }
        this._caching.lastFrame = Int64(frameNum)
        return this.pv
    }

    func resetShape(): Unit {
        this.paths = this.localShapeCollection
    }

    func shapesEqual(shape1: ShapeData, shape2: ShapeData): Bool {
        if (shape1._length != shape2._length || shape1.c != shape2.c) {
            return false
        }
        let len: Int64 = shape1._length
        for (i in 0..len) {
            if (shape1.v[i].x != shape2.v[i].x
                  || shape1.v[i].y != shape2.v[i].y
                  || shape1.o[i].x != shape2.o[i].x
                  || shape1.o[i].y != shape2.o[i].y
                  || shape1.i[i].x != shape2.i[i].x
                  || shape1.i[i].y != shape2.i[i].y
            ) {
                return false
            }
        }
        return true
    }

    func setVValue(newPath: ShapeData): Unit {
        if (!shapesEqual(this.v, newPath)) {
            //TODO：调不到shapePool.clone，需要把 shapePool 改为对象？？？  //this.v = shapePool.clone(newPath)
            this.localShapeCollection.releaseShapes()
            this.localShapeCollection.addShape(this.v)
            this._mdf = true
            this.paths = this.localShapeCollection
        }
    }

    func processEffectsSequence(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        if (this.effectsSequence.size <= 0) {
            this._mdf = false
            return
        }
        if (this.lock) {
            this.setVValue(this.pv)
            return
        }
        this.lock = true
        this._mdf = false
        var finalValue: ShapeData = ShapeData()
        if (this.kf) {
            finalValue = this.pv
        } else if (this.ks_data.size > 0) {
            //TODO: 单独保存一份 data.ks.k/data.pt.k ？？？  //finalValue = this.data.ks.k
            finalValue = (this.ks_data[0].k).getOrThrow()
        } else {
            //TODO: 单独保存一份 data.ks.k/data.pt.k ？？？  //finalValue = this.data.pt.k
            finalValue = (this.pt_data[0].k).getOrThrow()
        }

        let len: Int64 = this.effectsSequence.size
        for (i in 0..len) {
            //TODO： 确认此处用法。 //finalValue = this.effectsSequence[i](finalValue)
            finalValue = this.effectsSequence[i]()
        }
        this.setVValue(finalValue)
        this.lock = false
        this.frameId = this.elemGlobalData.frameId
    }

    func addEffect(effectFunction: () -> ShapeData): Unit {
        this.effectsSequence.append(effectFunction)
        //TODO: 需要确认调用的是哪一级父类的 addDynamicProperty 函数。  //this.container.addDynamicProperty(this)
    }

}
