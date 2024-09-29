/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is TransformProperty.
 */
package lottie4cj.property

public class TransformPropertyFactory {

    public static func getTransformProperty(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer): TransformProperty {
        return TransformProperty(data, elemGlobalData, elemData)
    }
}

/*
 * 初始化后需要传入1个函数：
 * 1. addDynamicPropertyInElem() => 间接调用 this.elem.addDynamicProperty 函数。
 */
public class TransformProperty <: DynamicPropertyContainer {

    //TODO：初始化后传入 this.elem.addDynamicProperty 中的这个函数；（在TransformElement.init传入编译失败，只能init之后传入。）
    public var addDynamicPropertyInElem: (DynamicPropertyContainer) -> Unit = { m => ()}

    var defaultVector: Array<Float64> = [0.0, 0.0]

    public var autoOriented: Bool = false
    public var frameId: Int64 = -1

    public var v: Matrix = Matrix()
    //具有非动画属性的预计算矩阵
    public var pre: Matrix = Matrix()
    public var appliedTransformations: Int64 = 0
    
    public var _isDirty: Bool = true

    //TODO: p 和 px/py/pz 两者存其一, has_data_p_s = false 表示 p 存在，px/py/pz 为空。
    var has_data_p_s: Bool = false
    public var p: PropertyFactory<AnimatableSplitDimensionPathValue, PointF>
    //TODO: 未在 AnimatableTransform 中找到 data.p.s  =>  has_data_p_s = false，暂无 this.px/this.py/this.px。设置成空的。
    public var px: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var py: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var pz: PropertyFactory<Array<Keyframe<Float64>>, Float64>

    public var r: PropertyFactory<ArrayKeyframeFloat64, Float64>
    //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or

    public var sk: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var sa: PropertyFactory<ArrayKeyframeFloat64, Float64>
    
    public var a: PropertyFactory<ArrayKeyframePointF, PointF>
    public var s: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>
    
    public var o: PropertyFactory<ArrayKeyframeInt64, Int64>

    public var data: AnimatableTransform

    
    //TODO: 未在 AnimatableTransform 中找到 rx 。设置成空的。
    public var rx: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var ry: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var rz: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var or: PropertyFactory<Array<Keyframe<Float64>>, Float64>

    /*
     * 数据来源分析：
     *  elem      => TransformElement/CVShapeElement/SVGShapeElement/elem
     *  container => TransformElement/CVShapeElement/SVGShapeElement/RepeaterModifier
     *  data      => layer.ks => AnimatableTransform
     *  data      => layer.shapes[i] => Array<ContentModel>[i] => "layers"."shapes".{"ty": "tr"} = AnimatableTransform
     */
    public init(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer) {
        super(elemGlobalData, elemData)
        this.propType = "transform"
        this.data = data
        
        //TODO：为实现初始化，编译用。
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>(AnimatableSplitDimensionPathValue(), 0.0, dp, elemGlobalData, elemData)
        this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        
        this.rx = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        this.ry = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        this.rz = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)
        this.or = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData)


        this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData)

        this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData)
        this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData)
        this.a = PropertyFactory<ArrayKeyframePointF, PointF>(ArrayKeyframePointF(), 0.0, dp, elemGlobalData, elemData)
        this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>(ArrayKeyframeArrayFloat64(), 0.0, dp, elemGlobalData, elemData)
        this.o = PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, dp, elemGlobalData, elemData)

        //直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        this.initDynamicPropertyContainer(elemGlobalData, elemData)

        //TODO: 未在 AnimatableTransform 中找到 data.p.s  =>  has_data_p_s = false，暂无 this.px/this.py/this.px。设置成空的。
        //p => [position位置]
        if (this.has_data_p_s) { //获取 translate 相关的参数
            this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.x, data.p.x, 0, 0.0, this, elemGlobalData, elemData)
            this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.y, data.p.y, 0, 0.0, this, elemGlobalData, elemData)
            if (data.p.z.size > 0) {
                this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.z, data.p.z, 0, 0.0, this, elemGlobalData, elemData)
            }
        } else {
            if (data.p.k.size == 1) {//走【分支2】
                let point: PointF = data.p.k[0].k ?? PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData)
            } else if (data.p.k.size > 1) {//走【分支4】
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, this, elemGlobalData, elemData)
            } else {//走【分支2】  =>   data.p || { k: [0, 0, 0] }
                let point: PointF = PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData)
            }
        }

        // r/rz => [rotation旋转]
        // "r": {"a": 0, "k": 0, "ix": 6}  // || { k: 0 }
        if (data.r.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData)
        } else if (data.r.k.size > 1) { //走【分支3】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k, 0, degToRads, this, elemGlobalData, elemData)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, 0.0, degToRads, this, elemGlobalData, elemData)
        }
        //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
        
        if (data.sk.k.size > 0) { //获取 skew 相关的参数
            if (data.sk.k.size == 1) {//走【分支1】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData)
            } else if (data.sk.k.size > 1) {//走【分支3】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k, 0, degToRads, this, elemGlobalData, elemData)
            }

            if (data.sa.k.size == 1) {//走【分支1】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData)
            } else if (data.sa.k.size > 1) {//走【分支3】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k, 0, degToRads, this, elemGlobalData, elemData)
            }
        }

        //"a": {"a": 0, "k": [0, 0], "ix": 1}  // || { k: [0, 0, 0] }
        if (data.a.k.size == 1) { //获取 translate 相关的参数 => [anchor锚点]  //走【分支2】
            let point: PointF = data.a.k[0].k ?? PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData)
        } else if (data.a.k.size > 1) {//走【分支4】
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, data.a.k, 1, 0.0, this, elemGlobalData, elemData)
        } else {//走【分支2】  =>   data.a || { k: [0, 0, 0] }
            let point: PointF = PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData)
        }

        //"s": {"a": 0, "k": [100, 100], "ix": 3}  // || { k: [100, 100, 100] }
        if (data.s.k.size == 1) {//获取 skew 相关的参数 => [scale縮放]   //走【分支2】
            let point: Array<Float64> = data.s.k[0].k ?? [100.0, 100.0, 100.0]
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, point, 0.01, this, elemGlobalData, elemData)
        } else if (data.s.k.size > 1) {//走【分支4】
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, data.s.k, 1, 0.01, this, elemGlobalData, elemData)
        } else {//走【分支2】  =>   data.s || { k: [100, 100, 100] }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, [100.0, 100.0, 100.0], 0.01, this, elemGlobalData, elemData)
        }

        //不透明度不是变换属性的一部分，这就是它不会使用this.dynamicProperties的原因。这样，如果不透明度发生变化，变换就不会更新。
        //"o": {"a": 0, "k": 100, "ix": 7 }
        if (data.o.k.size == 1) { // 透明度 => [opacity不透明度]   //走【分支1】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k[0].k ?? 0, 0.01, this, elemGlobalData, elemData)
        } else if (data.o.k.size > 1) {//走【分支3】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k, 0, 0.01, this, elemGlobalData, elemData)
        } else {
            this.o._mdf = false
            this.o.v = [1.0]
        }
        
        this._isDirty = true
        if (this.dynamicProperties.size == 0) {
            this.getValue(true)
        }
    }

    //-------------------------------------- TransformPropertyFactory 中 -------------------------------------

    public func applyToMatrix(mat: Matrix) {
        var _mdf = this._mdf
        //TODO: 是 DynamicPropertyContainer.iterateDynamicProperties ???
        this.iterateDynamicProperties()
        this._mdf = this._mdf || _mdf
        
        if (!this.a.isNull) {
            mat.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
        }
        if (!this.s.isNull) {
            mat.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
        }
        if (!this.sk.isNull) {
            mat.skewFromAxis(-this.sk.v[0], this.sa.v[0])
        }
        if (!this.r.isNull) {
            mat.rotate(-this.r.v[0])
        } else {
            //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
        }
        
        //TODO: 未在 AnimatableTransform 中找到 .p.s
        mat.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
        if (this.has_data_p_s) {
            if (this.data.p.z.size > 0) {
                mat.translate(this.px.v[0], this.py.v[0], tz: -this.pz.v[0])
            } else {
                mat.translate(this.px.v[0], this.py.v[0], tz: 0.0)
            }
        } else {
            mat.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
        }
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

        //TODO: 是 DynamicPropertyContainer.iterateDynamicProperties ???
        this.iterateDynamicProperties()

        if (this._mdf || forceRender) {
            var frameRate: Float64 = 0.0
            this.v.cloneFromProps(this.pre.props)
            
            if (this.appliedTransformations < 1) {
                this.v.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
            }
            if (this.appliedTransformations < 2) {
                this.v.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
            }
            if (!this.sk.isNull && this.appliedTransformations < 3) {
                this.v.skewFromAxis(-this.sk.v[0], this.sa.v[0])
            }
            if (!this.r.isNull && this.appliedTransformations < 4) {
                this.v.rotate(-this.r.v[0])
            } else if (this.r.isNull && this.appliedTransformations < 4) {
                //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
            }
            //TODO:不确定数据类型，暂定未Bool
            if (this.autoOriented) {
                var v1: Array<Float64> = Array<Float64>(2, repeat: 0.0)
                var v2: Array<Float64> = Array<Float64>(2, repeat: 0.0)
                frameRate = this.elemGlobalData.frameRate
                //TODO: 暂未实现 getValueAtTime。在扩展中实现？？？
                if (!this.p.isNull && this.p.keyframes.size > 0 && this.p.hasGetValueAtTime) {
                    if (Float64(this.p._caching.lastFrame) + this.p.offsetTime <= this.p.keyframes[0].t) {
                        v1 = this.p.getValueAtTime((this.p.keyframes[0].t + 0.01) / frameRate, 0.0)
                        v2 = this.p.getValueAtTime(this.p.keyframes[0].t / frameRate, 0.0)
                    } else if (Float64(this.p._caching.lastFrame) + this.p.offsetTime >= this.p.keyframes[this.p.keyframes.size - 1].t) {
                        v1 = this.p.getValueAtTime((this.p.keyframes[this.p.keyframes.size - 1].t / frameRate), 0.0)
                        v2 = this.p.getValueAtTime((this.p.keyframes[this.p.keyframes.size - 1].t - 0.05) / frameRate, 0.0)
                    } else {
                        v1 = this.p.pv
                        v2 = this.p.getValueAtTime((Float64(this.p._caching.lastFrame) + this.p.offsetTime - 0.01) / frameRate, this.p.offsetTime)
                    }
                } else if (this.has_data_p_s && !this.px.isNull && this.px.keyframes.size > 0 && this.py.keyframes.size > 0 && this.px.hasGetValueAtTime && this.py.hasGetValueAtTime) {
                    //TODO: 未在 AnimatableTransform 中找到 .p.s  => 暂无 this.px/this.py/this.px
                    let px = this.px
                    let py = this.py
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
                } else {
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
            //TODO: 未在 AnimatableTransform 中找到 .p.s  => 暂无 this.px/this.py/this.px
            if (!this.data.p.isNull() && this.has_data_p_s) {
                if (this.data.p.z.size > 0) {
                    this.v.translate(this.px.v[0], this.py.v[0], tz: -this.pz.v[0])
                } else {
                    this.v.translate(this.px.v[0], this.py.v[0], tz: 0.0)
                }
            } else {
                this.v.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
            }
            this.v.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
        }
        this.frameId = this.elemGlobalData.frameId
    }

    public func precalculateMatrix(): Unit {
        if (!this.a.k) {
            this.pre.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
            this.appliedTransformations = 1
        } else {
            return
        }
        if (this.s.effectsSequence.size == 0) {
            this.pre.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
            this.appliedTransformations = 2
        } else {
            return
        }
        if (!this.sk.isNull) {
            if (this.sk.effectsSequence.size == 0 && this.sa.effectsSequence.size == 0) {
                this.pre.skewFromAxis(-this.sk.v[0], this.sa.v[0])
                this.appliedTransformations = 3
            } else {
                return
            }
        }
        if (!this.r.isNull) {
            if (this.r.effectsSequence.size == 0) {
                this.pre.rotate(-this.r.v[0])
                this.appliedTransformations = 4
            }
        }
        //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
    }

    public open func autoOrient(): Unit { }

    public func addDynamicProperty(props: DynamicPropertyContainer): Unit {
        this._addDynamicProperty(props)
        //TODO: this.elem.addDynamicProperty 未实现。需要后续再确认一下 this.elem 的数据类型。
        this.addDynamicPropertyInElem(props)
        this._isDirty = true
    }

    public func _addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
        super.addDynamicProperty(dpc)
    }

}
