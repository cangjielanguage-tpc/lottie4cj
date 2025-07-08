/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is TransformPropertyFactory.
 */
package lottie.property

internal import kit.PerformanceAnalysisKit.Hilog

public class TransformCachingAtTime {

    var v: Matrix

    var isNull: Bool

    public init(v!: Matrix = Matrix(), isNull!: Bool = false){
        this.v = v
        this.isNull =isNull
    }
}

public class TransformPropertyFactory {

    /*
     * 后续数据类型校验：
     * elem      => TransformElement/CvShapeElement/SVGShapeElement/elem
     * container => TransformElement/CvShapeElement/SVGShapeElement/RepeaterModifier
     * data      => layer.ks => AnimatableTransform
     * data      => layer.shapes[i] => Array<ContentModel>[i] => "layers"."shapes".{"ty": "tr"} = AnimatableTransform
     */
    public static func getTransformProperty(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): TransformProperty {
        return TransformProperty(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
    }
}

/*
 * 初始化后需要传入1个函数：
 * 1. addDynamicPropertyInElem() => 间接调用 this.elem.addDynamicProperty 函数。
 */
public class TransformProperty <: DynamicPropertyContainer {

    public var _transformCachingAtTime: TransformCachingAtTime = TransformCachingAtTime()

    let defaultVector: Array<Float64> = [0.0, 0.0]

    public var autoOriented: Bool = false
    public var frameId: Int64 = -1

    public var v: Matrix = Matrix()
    /* 具有非动画属性的预计算矩阵 */
    public var pre: Matrix = Matrix()
    public var appliedTransformations: Int64 = 0

    public var _isDirty: Bool = true

    public var p: Option<PropertyFactory<AnimatableSplitDimensionPathValue, PointF>> = None
    public var px: Option<PropertyFactory<Array<Keyframe<Float64>>, Float64>> = None
    public var py: Option<PropertyFactory<Array<Keyframe<Float64>>, Float64>> = None
    public var pz: Option<PropertyFactory<Array<Keyframe<Float64>>, Float64>> = None

    public var r: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>> = None

    public var sk: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>> = None
    public var sa: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>> = None

    /* this.a 是 PointF，this.a.v 数组长度只能是 2。 */
    public var a: Option<PropertyFactory<ArrayKeyframePointF, PointF>> = None
    public var s: Option<PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>> = None

    public var o: Option<PropertyFactory<ArrayKeyframeInt64, Int64>> = None

    public var data: AnimatableTransform

    public init(isNull!: Bool, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super()
        this.isNull = isNull
        this.propType = "transform"
        this.data = AnimatableTransform()
        let elemGlobalData: GlobalData = GlobalData()
        let elemData: Layer = empty_layer
    }

    /*
     * 数据来源分析：
     *  elem      => TransformElement/CvShapeElement/SVGShapeElement/elem
     *  container => TransformElement/CvShapeElement/SVGShapeElement/RepeaterModifier
     *  data      => layer.ks => AnimatableTransform
     *  data      => layer.shapes[i] => Array<ContentModel>[i] => "layers"."shapes".{"ty": "tr"} = AnimatableTransform
     */
    public init(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.compType = compType
        this.compDataInd = compDataInd
        this.getRenderedFrame = renderedFrame
        this.propType = "transform"
        this.data = data

        let dp: DynamicPropertyContainer = DynamicPropertyContainer()

        this.initDynamicPropertyContainer(elemGlobalData, elemData)

        /* PointF 类型默认，PropertyFactory.getProp走分支[4]，后续 v 长度为 2。 */
        var vLen: Int64 = 2

        //p => [position位置]
        if (!data.p.isNull() && data.p.s) { //获取 translate 相关的参数
            if (data.p.x.size == 1) {//走【分支1】
                this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.x, data.p.x[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else if (data.p.x.size > 1) {//走【分支4】
                this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.x, data.p.x, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else {
                this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
            }
            if (data.p.y.size == 1) {//走【分支1】
                this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.y, data.p.y[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else if (data.p.y.size > 1) {//走【分支4】
                this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.y, data.p.y, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else {
                this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
            }

            if (data.p.z.size > 0) {
                if (data.p.z.size == 1) {//走【分支1】
                    this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.z, data.p.z[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
                } else if (data.p.z.size > 1) {//走【分支4】
                    this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.z, data.p.z, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
                } else {
                    this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
                }
            }
        } else {
            vLen = 3
            if (data.p.k.size == 1) {//走【分支2】
                let point: PointF = data.p.k[0].k ?? PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else if (data.p.k.size > 1) {//走【分支4】
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, this, elemGlobalData, elemData, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else {//走【分支2】  =>   data.p || { k: [0, 0, 0] }
                let point: PointF = PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            }
        }

        // r/rz => [rotation旋转]
        // "r": {"a": 0, "k": 0, "ix": 6}  // || { k: 0 }
        if (data.r.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.r.k.size > 1) { //走【分支3】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        }

        if (data.sk.k.size > 0) { //获取 skew 相关的参数
            if (data.sk.k.size == 1) {//走【分支1】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.sk.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else if (data.sk.k.size > 1) {//走【分支3】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.sk.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else {
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
            }

            if (data.sa.k.size == 1) {//走【分支1】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.sa.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else if (data.sa.k.size > 1) {//走【分支3】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.sa.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            } else {
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
            }
        }

        //"a": {"a": 0, "k": [0, 0], "ix": 1}  // || { k: [0, 0, 0] }
        if (data.a.k.size == 1) { //获取 translate 相关的参数 => [anchor锚点]  //走【分支2】
            let point: PointF = data.a.k[0].k ?? PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.a.k.size > 1) {//走【分支4】
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, data.a.k, 1, 0.0, this, elemGlobalData, elemData, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else {//走【分支2】  =>   data.a || { k: [0, 0, 0] }
            let point: PointF = PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        }

        //"s": {"a": 0, "k": [100, 100], "ix": 3}  // || { k: [100, 100, 100] }
        if (data.s.k.size == 1) {//获取 skew 相关的参数 => [scale縮放]   //走【分支2】
            let point: Array<Float64> = data.s.k[0].k ?? [100.0, 100.0, 100.0]
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, point, 0.01, this, elemGlobalData, elemData, types: 1, dataA: data.s.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.s.k.size > 1) {//走【分支4】
            if (data.s.k.size > 0) { vLen = (data.s.k[0].s ?? Array<Float64>()).size }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, data.s.k, 1, 0.01, this, elemGlobalData, elemData, dataA: data.s.a, vLen: vLen, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else {//走【分支2】  =>   data.s || { k: [100, 100, 100] }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, [100.0, 100.0, 100.0], 0.01, this, elemGlobalData, elemData, types: 1, dataA: data.s.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        }

        /* 不透明度不是变换属性的一部分，这就是它不会使用this.dynamicProperties的原因。这样，如果不透明度发生变化，变换就不会更新。 */
        //"o": {"a": 0, "k": 100, "ix": 7 }
        if (data.o.k.size == 1) { // 透明度 => [opacity不透明度]   //走【分支1】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k[0].k ?? 0, 0.01, this, elemGlobalData, elemData, types: 0, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.o.k.size > 1) {//走【分支3】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k, 0, 0.01, this, elemGlobalData, elemData, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else {
            let o = PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compDataInd: this.compDataInd)
            o._mdf = false
            o.v = [1.0]
            this.o = o
        }

        this._isDirty = true
        if (this.dynamicProperties.size == 0) {
            this.getValue(true)
        }
    }

    /* [扩展中赋值]【ExpressionPropertyDecorator】TransformPropertyFactory.getTransformProperty --1-------------------------------------------------------------------------- */

    public func getValueAtTime(frameNumber: Float64, num: Float64): Matrix {
        if (this.dynamicProperties.size > 0) {
            this.getTransformValueAtTime(frameNumber)
        } else {
            this.getTransformStaticValueAtTime()
        }
    }

    func getTransformValueAtTime(time: Float64): Matrix {
        if (this._transformCachingAtTime.isNull) {
            this._transformCachingAtTime.isNull = false
        }
        let matrix: Matrix = this._transformCachingAtTime.v
        matrix.cloneFromProps(this.pre.props)
        if (this.appliedTransformations < 1) {
            if (let Some(v) <- this.a) {
                let anchor: Array<Float64> = v.getValueAtTime(time)
                matrix.translate(
                    -anchor[0] * v.mult,
                    -anchor[1] * v.mult,
                    tz: anchor[2] * v.mult
                )
            }
        }
        if (this.appliedTransformations < 2) {
            if (let Some(v) <- this.s) {
                let scale: Array<Float64> = v.getValueAtTime(time)
                matrix.scale(
                    scale[0] * v.mult,
                    scale[1] * v.mult,
                    sz: scale[2] * v.mult
                )
            }
        }
        if (let Some(v) <- this.sk) {
            if (!v.isNull && this.appliedTransformations < 3) {
                let skew: Array<Float64> = v.getValueAtTime(time)
                if (let Some(sav) <- this.sa) {
                    let skewAxis: Array<Float64> = sav.getValueAtTime(time)
                    matrix.skewFromAxis(-skew[0] * v.mult, skewAxis[0] * sav.mult)
                }
            }
        }

        if (let Some(rv) <- this.r) {
            if (!rv.isNull && this.appliedTransformations < 4) {
                let rotation: Array<Float64> = rv.getValueAtTime(time)
                matrix.rotate(-rotation[0] * rv.mult)
            } else if (rv.isNull && this.appliedTransformations < 4) {
                /* 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or */
            }
        }

        if (!this.data.p.isNull() && this.data.p.s) {
            if (let Some(pxv) <- this.px) {
                if (let Some(pyv) <- this.py) {
                    let positionX: Array<Float64> = pxv.getValueAtTime(time)
                    let positionY: Array<Float64> = pyv.getValueAtTime(time)
                    if (!this.data.p.z.size <= 0) {
                        if (let Some(pzv) <- this.pz) {
                            let positionZ: Array<Float64> = pzv.getValueAtTime(time)
                            matrix.translate(
                                positionX[0] * pxv.mult,
                                positionY[0] * pyv.mult,
                                tz: -positionZ[0] * pzv.mult
                            )
                        }
                    } else {
                        matrix.translate(positionX[0] * pxv.mult, positionY[0] * pyv.mult, tz: 0.0)
                    }
                }
            }
        } else {
            if (let Some(pv) <- this.p) {
                let position: Array<Float64> = pv.getValueAtTime(time)
                matrix.translate(
                    position[0] * pv.mult,
                    position[1] * pv.mult,
                    tz: -position[2] * pv.mult
                )
            }
        }
        return matrix
    }

    func getTransformStaticValueAtTime(): Matrix {
        return this.v.clone(Matrix())
    }

    /* [扩展中赋值]【ExpressionPropertyDecorator】TransformPropertyFactory.getTransformProperty --2--------------------- */


    /* -------------------------------------- TransformPropertyFactory 中 ------------------------------------- */

    public func applyToMatrix(mat: Matrix) {
        var _mdf = this._mdf
        this.iterateDynamicProperties()
        this._mdf = this._mdf || _mdf

        if (let Some(av) <- this.a) {
            mat.translate(-av.v[0], -av.v[1])
        }
        if (let Some(sv) <- this.s) {
            if (sv.v.size == 3) {
                mat.scale(sv.v[0], sv.v[1], sz: sv.v[2])
            } else {
                mat.scale(sv.v[0], sv.v[1])
            }
        }
        if (let Some(skv) <- this.sk) {
            mat.skewFromAxis(-skv.v[0], skv.v[0])
        }
        if (let Some(rv) <- this.r) {
            mat.rotate(-rv.v[0])
        } else {
            /* 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or */
        }

        if (let Some(pv) <- this.p) {
            mat.translate(pv.v[0], pv.v[1])
        }

        if (this.data.p.s) {
            if (let Some(pxv) <- this.px) {
                if (let Some(pyv) <- this.py) {
                    if (this.data.p.z.size > 0) {
                        if (let Some(pzv) <- this.pz) {
                            mat.translate(pxv.v[0], pyv.v[0], tz: -pzv.v[0])
                        }
                    } else {
                        mat.translate(pxv.v[0], pyv.v[0], tz: 0.0)
                    }
                }
            }
        } else {
            if (let Some(pv) <- this.p) {
                mat.translate(pv.v[0], pv.v[1])
            }
        }
    }

    public func getValue(): Unit {
        this.getValue(false)
    }

    public func getValue(forceRender: Bool): Unit {
        this.processKeys(forceRender)
    }

    func processKeys(forceRender: Bool): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        if (this._isDirty) {
            this.precalculateMatrix()
            this._isDirty = false
        }

        this.iterateDynamicProperties()

        if (this._mdf || forceRender) {
            var frameRate: Float64 = 0.0
            this.v.cloneFromProps(this.pre.props)

            if (this.appliedTransformations < 1) {
                if (let Some(av) <- this.a) {
                    this.v.translate(-av.v[0], -av.v[1])
                }
            }
            if (this.appliedTransformations < 2) {
                if (let Some(sv) <- this.s) {
                    if (sv.v.size == 3) {
                        this.v.scale(sv.v[0], sv.v[1], sz: sv.v[2])
                    } else {
                        this.v.scale(sv.v[0], sv.v[1])
                    }
                }
            }

            if (this.appliedTransformations < 3) {
                if (let Some(skv) <- this.sk) {
                    if (let Some(sav) <- this.sa) {
                        this.v.skewFromAxis(-skv.v[0], sav.v[0])
                    }
                }
            }
            if (this.appliedTransformations < 4) {
                if (let Some(rv) <- this.r) {
                    this.v.rotate(-rv.v[0])
                } else {
                    /* 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or */
                }
            }
            if (this.autoOriented) {
                var v1: Array<Float64> = Array<Float64>(2, repeat: 0.0)
                var v2: Array<Float64> = Array<Float64>(2, repeat: 0.0)
                frameRate = this.elemGlobalData.frameRate
                var pflag: Bool = false
                if (let Some(p_v) <- this.p) {
                    if (p_v.keyframes.size > 0 && p_v.hasGetValueAtTime) {
                        pflag = true
                        if (Float64(p_v._caching.lastFrame) + p_v.offsetTime <= p_v.keyframes[0].t) {
                            v1 = p_v.getValueAtTime((p_v.keyframes[0].t + 0.01) / frameRate, 0.0)
                            v2 = p_v.getValueAtTime(p_v.keyframes[0].t / frameRate, 0.0)
                        } else if (Float64(p_v._caching.lastFrame) + p_v.offsetTime >= p_v.keyframes[p_v.keyframes.size - 1].t) {
                            v1 = p_v.getValueAtTime((p_v.keyframes[p_v.keyframes.size - 1].t / frameRate), 0.0)
                            v2 = p_v.getValueAtTime((p_v.keyframes[p_v.keyframes.size - 1].t - 0.05) / frameRate, 0.0)
                        } else {
                            v1 = p_v.pv
                            v2 = p_v.getValueAtTime((Float64(p_v._caching.lastFrame) + p_v.offsetTime - 0.01) / frameRate, p_v.offsetTime)
                        }
                    }
                } else if (!pflag && this.data.p.s) {
                    if (let Some(pxv) <- this.px) {
                        if (let Some(pyv) <- this.py) {
                            let px = pxv
                            let py = pyv
                            if (this.data.p.s && !px.isNull && px.keyframes.size > 0 && py.keyframes.size > 0 && px.hasGetValueAtTime && py.hasGetValueAtTime) {
                                pflag = true
                                if (Float64(px._caching.lastFrame) + px.offsetTime <= px.keyframes[0].t) {
                                    v1[0] = px.getValueAtTime((px.keyframes[0].t + 0.01) / frameRate, 0.0)[0]
                                    v1[1] = py.getValueAtTime((py.keyframes[0].t + 0.01) / frameRate, 0.0)[0]
                                    v2[0] = px.getValueAtTime((px.keyframes[0].t) / frameRate, 0.0)[0]
                                    v2[1] = py.getValueAtTime((py.keyframes[0].t) / frameRate, 0.0)[0]
                                } else if (Float64(px._caching.lastFrame) + px.offsetTime >= px.keyframes[px.keyframes.size - 1].t) {
                                    v1[0] = px.getValueAtTime((px.keyframes[px.keyframes.size - 1].t / frameRate), 0.0)[0]
                                    v1[1] = py.getValueAtTime((py.keyframes[py.keyframes.size - 1].t / frameRate), 0.0)[0]
                                    v2[0] = px.getValueAtTime((px.keyframes[px.keyframes.size - 1].t - 0.01) / frameRate, 0.0)[0]
                                    v2[1] = py.getValueAtTime((py.keyframes[py.keyframes.size - 1].t - 0.01) / frameRate, 0.0)[0]
                                } else {
                                    v1 = [px.pv[0], py.pv[0]]
                                    v2[0] = px.getValueAtTime((Float64(px._caching.lastFrame) + px.offsetTime - 0.01) / frameRate, px.offsetTime)[0]
                                    v2[1] = py.getValueAtTime((Float64(py._caching.lastFrame) + py.offsetTime - 0.01) / frameRate, py.offsetTime)[0]
                                }
                            }
                        }
                    }
                } else if (!pflag) {
                    v2 = defaultVector
                    v1 = v2
                }

                /*
                 * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
                 * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
                 * Math.atan2(p[1], p[0]) = atan(p[1] / p[0])
                 */
                this.v.rotate(-atan((v1[1] - v2[1]) / (v1[0] - v2[0])))
            }
            /* 未在 AnimatableTransform 中找到 .p.s  => 暂无 this.px/this.py/this.px  */
            if (!this.data.p.isNull() && this.data.p.s) {
                if (let Some(pxv) <- this.px) {
                    if (let Some(pyv) <- this.py) {
                        if (this.data.p.z.size > 0) {
                            if (let Some(pzv) <- this.pz) {
                                this.v.translate(pxv.v[0], pyv.v[0], tz: -pzv.v[0])
                            }
                        } else {
                            this.v.translate(pxv.v[0], pyv.v[0], tz: 0.0)
                        }
                    }
                }
            } else {
                if (let Some(p_v) <- this.p) {
                    this.v.translate(p_v.v[0], p_v.v[1])
                }
            }

        }
        this.frameId = this.elemGlobalData.frameId
    }

    public func precalculateMatrix(): Unit {
        if (let Some(a_v) <- this.a) {
            if (!a_v.k) {
                this.pre.translate(-a_v.v[0], -a_v.v[1])
                this.appliedTransformations = 1
            } else {
                return
            }
        }
        if (let Some(sv) <- this.s) {
            if (sv.effectsSequence.size == 0) {
                if (sv.v.size == 3) {
                    this.pre.scale(sv.v[0], sv.v[1], sz: sv.v[2])
                } else {
                    this.pre.scale(sv.v[0], sv.v[1])
                }
                this.appliedTransformations = 2
            } else {
                return
            }
        } else {
            return
        }

        if (let Some(skv) <- this.sk) {
            if (let Some(sav) <- this.sa) {
                if (skv.effectsSequence.size == 0 && sav.effectsSequence.size == 0) {
                    this.pre.skewFromAxis(-skv.v[0], sav.v[0])
                    this.appliedTransformations = 3       
                } else {
                    return
                }
            }
        }
        if (let Some(rv) <- this.r) {
            if (rv.effectsSequence.size == 0) {
                this.pre.rotate(-rv.v[0])
                this.appliedTransformations = 4
            }
        }
        /* 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or */
    }

    public open func autoOrient(): Unit { }

    public func addDynamicProperty(props: DynamicPropertyContainer): Unit {
        this._addDynamicProperty(props)
        this.addDynamicPropertyInElemInTransformProperty(props)
        this._isDirty = true
    }

    public open func addDynamicPropertyInElemInTransformProperty(props: DynamicPropertyContainer): Unit {
        for (i in 0..this.dynamicPropertiesInElem.size) {
            if (refEq(props, this.dynamicPropertiesInElem[i])) {
                return
            }
        }
        this.dynamicPropertiesInElem.add(props)
    }

    public func _addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
        super.addDynamicProperty(dpc)
    }

}
