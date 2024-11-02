/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
//package lottie.utils
package lottie.property

internal import ohos.hilog.*

public class TransformCachingAtTime {

    var v: Matrix = Matrix()
    
    var isNull: Bool = true

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
     * //TODO: elem 和 container 数据类型未确认，暂定为 BaseElement
     * //TODO：是否将 BaseElement 和 DynamicPropertyContainer 进行关联？？？或者创建提取继承关系？？？--------------------------------2024.08.22
     * //TODO：是否将 CVShapeData 和 DynamicPropertyContainer 进行关联？？？或者创建提取继承关系？？？--------------------------------2024.08.22
     * //TODO: 提取的父类 ElementData：elementData是多种情况自定义结构/CVShapeData/ShapeModifier及子类
     * //TODO: ShapeModifier <: DynamicPropertyContainer，让 DynamicPropertyContainer <: ElementData ???----------------------2024.08.22
     * 
     * //TODO: BaseElement/CVShapeData/DynamicPropertyContainer/ElementData 怎么创建关联关系？？？怎么串联继承？？？-----------------------------------2024.08.22
     * //TODO: 让 BaseElement <: CVShapeData <: DynamicPropertyContainer <: ElementData ？？？----------------------------------------------------2024.08.22
     */
    public static func getTransformProperty(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<() -> Float64> = Array<() -> Float64>()
    ): TransformProperty {
        return TransformProperty(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame)
    }
}

/*
 * 初始化后需要传入1个函数：
 * 1. addDynamicPropertyInElem() => 间接调用 this.elem.addDynamicProperty 函数。
 */
public class TransformProperty <: DynamicPropertyContainer {

    public var _transformCachingAtTime: TransformCachingAtTime = TransformCachingAtTime()

    //TODO：初始化后传入 this.elem.addDynamicProperty 中的这个函数；（在TransformElement.init传入编译失败，只能init之后传入。）
    //public var addDynamicPropertyInElem: (DynamicPropertyContainer) -> Unit = { m => ()}

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
    // this.p 是 PointF，this.p.v 数组长度只能是 2。
    public var p: PropertyFactory<AnimatableSplitDimensionPathValue, PointF>
    //TODO: 未在 AnimatableTransform 中找到 data.p.s  =>  has_data_p_s = false，暂无 this.px/this.py/this.px。设置成空的。
    public var px: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var py: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public var pz: PropertyFactory<Array<Keyframe<Float64>>, Float64>

    public var r: PropertyFactory<ArrayKeyframeFloat64, Float64>
    //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or

    public var sk: PropertyFactory<ArrayKeyframeFloat64, Float64>
    public var sa: PropertyFactory<ArrayKeyframeFloat64, Float64>

    // this.a 是 PointF，this.a.v 数组长度只能是 2。
    public var a: PropertyFactory<ArrayKeyframePointF, PointF>
    public var s: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>

    public var o: PropertyFactory<ArrayKeyframeInt64, Int64>

    public var data: AnimatableTransform

    //public var isNull: Bool = false

    public init(isNull!: Bool, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super()
        this.isNull = isNull
        this.propType = "transform"
        this.data = AnimatableTransform()
        let elemGlobalData: GlobalData = GlobalData()
        let elemData: Layer = Layer()

        //TODO：为实现初始化，编译用。
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>(AnimatableSplitDimensionPathValue(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.a = PropertyFactory<ArrayKeyframePointF, PointF>(ArrayKeyframePointF(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>(ArrayKeyframeArrayFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.o = PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

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
        compType!: Int8 = 0, renderedFrame!: Array<() -> Float64> = Array<() -> Float64>()
    ) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        //this.dynamicProperties = dynamicProperties
        this.compType = compType
        this.getRenderedFrame = renderedFrame
        this.propType = "transform"
        this.data = data

        //TODO：为实现初始化，编译用。
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>(AnimatableSplitDimensionPathValue(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>(Array<Keyframe<Float64>>(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.a = PropertyFactory<ArrayKeyframePointF, PointF>(ArrayKeyframePointF(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>(ArrayKeyframeArrayFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.o = PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        //直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        this.initDynamicPropertyContainer(elemGlobalData, elemData)

        // PointF 类型默认，PropertyFactory.getProp走分支[4]，后续 v 长度为 2。
        var vLen: Int64 = 2

        //TODO: 未在 AnimatableTransform 中找到 data.p.s  =>  has_data_p_s = false，暂无 this.px/this.py/this.px。设置成空的。
        //p => [position位置]
        if (!data.p.isNull() && data.p.s) { //获取 translate 相关的参数
            if (data.p.x.size == 1) {//走【分支1】
                this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.x, data.p.x[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else if (data.p.x.size > 1) {//走【分支4】
                this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.x, data.p.x, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            }
            if (data.p.y.size == 1) {//走【分支1】
                this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.y, data.p.y[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else if (data.p.y.size > 1) {//走【分支4】
                this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.y, data.p.y, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            }

            this.px.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.px.container = [this]
            this.py.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.py.container = [this]
            if (data.p.z.size > 0) {
                if (data.p.z.size == 1) {//走【分支1】
                    this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.z, data.p.z[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, types: 0, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
                } else if (data.p.z.size > 1) {//走【分支4】
                    this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.p.z, data.p.z, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
                }

                this.pz.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
                this.pz.container = [this]
            }
        } else {
            vLen = 3
            if (data.p.k.size == 1) {//走【分支2】
                let point: PointF = data.p.k[0].k ?? PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else if (data.p.k.size > 1) {//走【分支4】
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, data.p.k, 1, 0.0, this, elemGlobalData, elemData, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else {//走【分支2】  =>   data.p || { k: [0, 0, 0] }
                let point: PointF = PointF(x: 0.0, y: 0.0)
                this.p = PropertyFactory<AnimatableSplitDimensionPathValue, PointF>.getProp(data.p, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.p.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            }
            this.p.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.p.container = [this]
        }

        // r/rz => [rotation旋转]
        // "r": {"a": 0, "k": 0, "ix": 6}  // || { k: 0 }
        if (data.r.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else if (data.r.k.size > 1) { //走【分支3】
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, data.r.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.r = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.r, 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.r.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        }
        this.r.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.r.container = [this]
        //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
        //if (data.rx) {
        //    this.rx = PropertyFactory.getProp(elem, data.rx, 0, degToRads, this)
        //    this.ry = PropertyFactory.getProp(elem, data.ry, 0, degToRads, this)
        //    this.rz = PropertyFactory.getProp(elem, data.rz, 0, degToRads, this)
        //    if (data.or.k[0].ti) {
        //        var len = data.or.k.length
        //        for (i in 0..len) {
        //            data.or.k[i].to = null
        //            data.or.k[i].ti = null
        //        }
        //    }
        //    this.or = PropertyFactory.getProp(elem, data.or, 1, degToRads, this)
        //    // sh Indicates it needs to be capped between -180 and 180
        //    this.or.sh = true
        //} else {
        //    this.r = PropertyFactory.getProp(elem, data.r || { k: 0 }, 0, degToRads, this)
        //}

        if (data.sk.k.size > 0) { //获取 skew 相关的参数
            if (data.sk.k.size == 1) {//走【分支1】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.sk.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else if (data.sk.k.size > 1) {//走【分支3】
                this.sk = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sk, data.sk.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.sk.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            }
            this.sk.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.sk.container = [this]

            if (data.sa.k.size == 1) {//走【分支1】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k[0].k ?? 0.0, degToRads, this, elemGlobalData, elemData, types: 0, dataA: data.sa.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            } else if (data.sa.k.size > 1) {//走【分支3】
                this.sa = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(data.sa, data.sa.k, 0, degToRads, this, elemGlobalData, elemData, dataA: data.sa.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
            }
            this.sa.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.sa.container = [this]
        }

        //"a": {"a": 0, "k": [0, 0], "ix": 1}  // || { k: [0, 0, 0] }
        if (data.a.k.size == 1) { //获取 translate 相关的参数 => [anchor锚点]  //走【分支2】
            let point: PointF = data.a.k[0].k ?? PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else if (data.a.k.size > 1) {//走【分支4】
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, data.a.k, 1, 0.0, this, elemGlobalData, elemData, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else {//走【分支2】  =>   data.a || { k: [0, 0, 0] }
            let point: PointF = PointF(x: 0.0, y: 0.0)
            this.a = PropertyFactory<ArrayKeyframePointF, PointF>.getProp(data.a, point, 0.0, this, elemGlobalData, elemData, types: 1, dataA: data.a.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        }
        this.a.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.a.container = [this]

        //"s": {"a": 0, "k": [100, 100], "ix": 3}  // || { k: [100, 100, 100] }
        if (data.s.k.size == 1) {//获取 skew 相关的参数 => [scale縮放]   //走【分支2】
            let point: Array<Float64> = data.s.k[0].k ?? [100.0, 100.0, 100.0]
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, point, 0.01, this, elemGlobalData, elemData, types: 1, dataA: data.s.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else if (data.s.k.size > 1) {//走【分支4】
            if (data.s.k.size > 0) { vLen = (data.s.k[0].s ?? Array<Float64>()).size }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, data.s.k, 1, 0.01, this, elemGlobalData, elemData, dataA: data.s.a, vLen: vLen, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else {//走【分支2】  =>   data.s || { k: [100, 100, 100] }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, [100.0, 100.0, 100.0], 0.01, this, elemGlobalData, elemData, types: 1, dataA: data.s.a, vLen: 3, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        }
        this.s.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.s.container = [this]

        //不透明度不是变换属性的一部分，这就是它不会使用this.dynamicProperties的原因。这样，如果不透明度发生变化，变换就不会更新。
        //"o": {"a": 0, "k": 100, "ix": 7 }
        if (data.o.k.size == 1) { // 透明度 => [opacity不透明度]   //走【分支1】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k[0].k ?? 0, 0.01, this, elemGlobalData, elemData, types: 0, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else if (data.o.k.size > 1) {//走【分支3】
            this.o = PropertyFactory<ArrayKeyframeInt64, Int64>.getProp(data.o, data.o.k, 0, 0.01, this, elemGlobalData, elemData, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 2, compType: this.compType, renderedFrame: this.getRenderedFrame)
        } else {
            this.o._mdf = false
            this.o.v = [1.0]
        }
        this.o.containerType = 2  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.o.container = [this]

        this._isDirty = true
        if (this.dynamicProperties.size == 0) {
            this.getValue(true)
        }
    }

//[扩展中赋值]【ExpressionPropertyDecorator】TransformPropertyFactory.getTransformProperty --1----------------------------------------------------------------------------------------

    public func getValueAtTime(frameNumber: Float64, num: Float64): Matrix {
        if (this.dynamicProperties.size > 0) {
            //prop.getValueAtTime = getTransformValueAtTime.bind(prop)
            this.getTransformValueAtTime(frameNumber)
        } else {
            //prop.getValueAtTime = getTransformStaticValueAtTime.bind(prop)
            this.getTransformStaticValueAtTime()
        }
    }

    //TODO：暂未实现
    //public func setGroupProperty(propertyGroup: PropertyInterface): Unit {
    //    this.propertyGroup = propertyGroup
    //}

    //TODO：TransformPropertyFactory 扩展，增加函数 getValueAtTime。
    func getTransformValueAtTime(time: Float64): Matrix {
        //TODO：TransformPropertyFactory 增加成员变量 this._transformCachingAtTime ？？？
        //TODO: 需要判空么？？？成员变量 this._transformCachingAtTime 初始化就直接打到 if 中的效果了。
        if (this._transformCachingAtTime.isNull) {
            this._transformCachingAtTime = TransformCachingAtTime(
                v: Matrix()
            )
            this._transformCachingAtTime.isNull = false
        }
        /// /
        let matrix: Matrix = this._transformCachingAtTime.v
        matrix.cloneFromProps(this.pre.props)
        if (this.appliedTransformations < 1) {
            let anchor: Array<Float64> = this.a.getValueAtTime(time)
            matrix.translate(
                -anchor[0] * this.a.mult,
                -anchor[1] * this.a.mult,
                tz: anchor[2] * this.a.mult
            )
        }
        if (this.appliedTransformations < 2) {
            let scale: Array<Float64> = this.s.getValueAtTime(time)
            matrix.scale(
                scale[0] * this.s.mult,
                scale[1] * this.s.mult,
                sz: scale[2] * this.s.mult
            )
        }
        if (!this.sk.isNull && this.appliedTransformations < 3) {
            let skew: Array<Float64> = this.sk.getValueAtTime(time)
            let skewAxis: Array<Float64> = this.sa.getValueAtTime(time)
            matrix.skewFromAxis(-skew[0] * this.sk.mult, skewAxis[0] * this.sa.mult)
        }
        if (!this.r.isNull && this.appliedTransformations < 4) {
            let rotation: Array<Float64> = this.r.getValueAtTime(time)
            matrix.rotate(-rotation[0] * this.r.mult)
        } else if (this.r.isNull && this.appliedTransformations < 4) {
            //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
            //let rotationZ: Array<Float64> = this.rz.getValueAtTime(time)
            //let rotationY: Array<Float64> = this.ry.getValueAtTime(time)
            //let rotationX: Array<Float64> = this.rx.getValueAtTime(time)
            //let orientation: Array<Float64> = this.or.getValueAtTime(time)

            //matrix.rotateZ(-rotationZ[0] * this.rz.mult)
            //.rotateY(rotationY * this.ry.mult)
            //.rotateX(rotationX * this.rx.mult)
            //.rotateZ(-orientation[2] * this.or.mult)
            //.rotateY(orientation[1] * this.or.mult)
            //.rotateX(orientation[0] * this.or.mult)
        }
        if (!this.data.p.isNull() && this.data.p.s) {
            let positionX: Array<Float64> = this.px.getValueAtTime(time)
            let positionY: Array<Float64> = this.py.getValueAtTime(time)
            if (!this.data.p.z.size <= 0) {
                let positionZ: Array<Float64> = this.pz.getValueAtTime(time)
                matrix.translate(
                    positionX[0] * this.px.mult,
                    positionY[0] * this.py.mult,
                    tz: -positionZ[0] * this.pz.mult
                )
            } else {
                matrix.translate(positionX[0] * this.px.mult, positionY[0] * this.py.mult, tz: 0.0)
            }
        } else {
            let position: Array<Float64> = this.p.getValueAtTime(time)
            matrix.translate(
                position[0] * this.p.mult,
                position[1] * this.p.mult,
                tz: -position[2] * this.p.mult
            )
        }
        return matrix
    }

    //TODO：TransformPropertyFactory 扩展，增加函数 getValueAtTime。
    func getTransformStaticValueAtTime(): Matrix {
        return this.v.clone(Matrix())
    }

//[扩展中赋值]【ExpressionPropertyDecorator】TransformPropertyFactory.getTransformProperty --2----------------------------------------------------------------------------------------


    //-------------------------------------- TransformPropertyFactory 中 -------------------------------------

    public func applyToMatrix(mat: Matrix) {
        var _mdf = this._mdf
        //TODO: 是 DynamicPropertyContainer.iterateDynamicProperties ???
        this.iterateDynamicProperties()
        this._mdf = this._mdf || _mdf
        
        if (!this.a.isNull) {
            // this.a 是 PointF，v 数组长度只能是 2。
            //mat.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
            mat.translate(-this.a.v[0], -this.a.v[1])
        }
        if (!this.s.isNull) {
            if (this.s.v.size == 3) {
                mat.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
            } else {
                mat.scale(this.s.v[0], this.s.v[1])
            }
        }
        if (!this.sk.isNull) {
            mat.skewFromAxis(-this.sk.v[0], this.sa.v[0])
        }
        if (!this.r.isNull) {
            mat.rotate(-this.r.v[0])
        } else {
            //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
            //mat.rotateZ(-this.rz.v[0]).rotateY(this.ry.v[0]).rotateX(this.rx.v[0]).rotateZ(-this.or.v[2])
            //    .rotateY(this.or.v[1])
            //    .rotateX(this.or.v[0])
        }
        
        //TODO: 未在 AnimatableTransform 中找到 .p.s
        // this.a 是 PointF，v 数组长度只能是 2。
        //mat.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
        mat.translate(this.p.v[0], this.p.v[1])
        //if (this.has_data_p_s) {
        if (this.data.p.s) {
            if (this.data.p.z.size > 0) {
                mat.translate(this.px.v[0], this.py.v[0], tz: -this.pz.v[0])
            } else {
                mat.translate(this.px.v[0], this.py.v[0], tz: 0.0)
            }
        } else {
            //mat.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
            mat.translate(this.p.v[0], this.p.v[1])
        }
    }

    public func getValue(): Unit {
        this.getValue(false)
    }

    public func getValue(forceRender: Bool): Unit {
        this.processKeys(forceRender)
    }
 
    func processKeys(forceRender: Bool): Unit {
        //Hilog.error(0, "--29--", "[processKeys]--[1]----> this.p.v = ${this.p.v}")
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
                //this.v.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
                this.v.translate(-this.a.v[0], -this.a.v[1])
            }
            if (this.appliedTransformations < 2) {
                if (this.s.v.size == 3) {
                    this.v.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
                } else {
                    this.v.scale(this.s.v[0], this.s.v[1])
                }
            }
            if (!this.sk.isNull && this.appliedTransformations < 3) {
                this.v.skewFromAxis(-this.sk.v[0], this.sa.v[0])
            }
            if (!this.r.isNull && this.appliedTransformations < 4) {
                this.v.rotate(-this.r.v[0])
            } else if (this.r.isNull && this.appliedTransformations < 4) {
                //TODO: 未在 AnimatableTransform 中找到 .rx  => 暂无 this.rx/this.ry/this.rz/this.or
                //this.v.rotateZ(-this.rz.v[0]).rotateY(this.ry.v[0]).rotateX(this.rx.v[0]).rotateZ(-this.or.v[2])
                //    .rotateY(this.or.v[1])
                //    .rotateX(this.or.v[0])
            }
            //TODO:不确定数据类型，暂定未Bool
            if (this.autoOriented) {
                var v1: Array<Float64> = Array<Float64>(2, item: 0.0)
                var v2: Array<Float64> = Array<Float64>(2, item: 0.0)
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
                //} else if (this.has_data_p_s && !this.px.isNull && this.px.keyframes.size > 0 && this.py.keyframes.size > 0 && this.px.hasGetValueAtTime && this.py.hasGetValueAtTime) {
                } else if (this.data.p.s && !this.px.isNull && this.px.keyframes.size > 0 && this.py.keyframes.size > 0 && this.px.hasGetValueAtTime && this.py.hasGetValueAtTime) {
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
            //if (!this.data.p.isNull() && this.has_data_p_s) {
            if (!this.data.p.isNull() && this.data.p.s) {
                if (this.data.p.z.size > 0) {
                    this.v.translate(this.px.v[0], this.py.v[0], tz: -this.pz.v[0])
                } else {
                    this.v.translate(this.px.v[0], this.py.v[0], tz: 0.0)
                }
            } else {
                //Hilog.error(0, "--29--", "[processKeys]--[2]----> this.p.v = ${this.p.v}")
                //this.v.translate(this.p.v[0], this.p.v[1], tz: -this.p.v[2])
                this.v.translate(this.p.v[0], this.p.v[1])
            }

        }
        this.frameId = this.elemGlobalData.frameId
    }

    public func precalculateMatrix(): Unit {
        if (!this.a.k) {
            // this.a 是 PointF，v 数组长度只能是 2。
            //this.pre.translate(-this.a.v[0], -this.a.v[1], tz: this.a.v[2])
            this.pre.translate(-this.a.v[0], -this.a.v[1])
            this.appliedTransformations = 1
        } else {
            return
        }
        if (this.s.effectsSequence.size == 0) {
            if (this.s.v.size == 3) {
                this.pre.scale(this.s.v[0], this.s.v[1], sz: this.s.v[2])
            } else {
                this.pre.scale(this.s.v[0], this.s.v[1])
            }
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
        //} else if (this.rz.effectsSequence.size == 0 && this.ry.effectsSequence.size == 0 && this.rx.effectsSequence.size == 0 && this.or.effectsSequence.size == 0) {
        //    this.pre.rotateZ(-this.rz.v[0]).rotateY(this.ry.v[0]).rotateX(this.rx.v[0]).rotateZ(-this.or.v[2])
        //        .rotateY(this.or.v[1])
        //        .rotateX(this.or.v[0])
        //    this.appliedTransformations = 4
        //}
    }

    public open func autoOrient(): Unit { }

    //TODO: 未确认 props 数据类型
    public func addDynamicProperty(props: DynamicPropertyContainer): Unit {
        this._addDynamicProperty(props)
        //TODO: this.elem.addDynamicProperty 未实现。需要后续再确认一下 this.elem 的数据类型。
        this.addDynamicPropertyInElemInTransformProperty(props)

        this._isDirty = true
    }

    public open func addDynamicPropertyInElemInTransformProperty(props: DynamicPropertyContainer): Unit {
        for (i in 0..this.dynamicPropertiesInElem.size) {
            if (refEq(props, this.dynamicPropertiesInElem[i])) {
                return
            }
        }
        this.dynamicPropertiesInElem.append(props)
    }

    //public func addDynamicPropertyInElem(props: DynamicPropertyContainer): Unit {
    //    for (i in 0..this.dynamicPropertiesInElem.size) {
    //        if (refEq(props, this.dynamicPropertiesInElem[i])) {
    //            return
    //        }
    //    }
    //    this.dynamicPropertiesInElem.append(this)
    //}

    public func _addDynamicProperty(dpc: DynamicPropertyContainer): Unit {
        super.addDynamicProperty(dpc)
    }

}
