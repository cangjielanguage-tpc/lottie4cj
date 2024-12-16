/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is TextSelectorProp.
 */
package lottie.utils.text

internal import lottie.property.*

public class TextSelectorProp {

    /*
     * 数据来源分析：data  =>  layer.t.a[i].s(AnimatableTextPropertiesS)
     * 数据来源分析：arr  <=  TextAnimatorDataProperty.container 中  =>  TextAnimatorProperty
     */
    public static func getTextSelectorProp(data: AnimatableTextPropertiesS, elemGlobalData: GlobalData, elemData: Layer, elemTextPropertyCurrentData: DocumentData, dynamicProperties!: ArrayList<DynamicPropertyContainer>): TextSelectorPropFactory {
        return TextSelectorPropFactory(data, elemGlobalData, elemData, elemTextPropertyCurrentData, dynamicProperties: dynamicProperties)
    }
}

public class TextSelectorPropFactory <: DynamicPropertyContainer {

    public var t: Int64 = 0

    var elemTextPropertyCurrentData: DocumentData = DocumentData()
    var data: AnimatableTextPropertiesS

    var _currentTextLength: Int64 = -1
    var k: Bool = false

    var finalS: Float64 = 0.0
    var finalE: Float64 = 0.0

    var xe: PropertyFactory<AK, Int64>
    var ne: PropertyFactory<AK, Int64>
    var a: PropertyFactory<AK, Int64>

    /* s/e/o/sm 在 json 中暂未找到， 是否将 s/e/o/sm 当成空的 AK  */
    var s: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>
    var e: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>
    var o: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>

    var sm: PropertyFactory<AK, Int64>

    /* 数据来源分析：data  =>  layer.t.a[i].s(AnimatableTextPropertiesS) */
    public init(data: AnimatableTextPropertiesS, elemGlobalData: GlobalData, elemData: Layer, elemTextPropertyCurrentData: DocumentData, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.elemTextPropertyCurrentData = elemTextPropertyCurrentData
        this.data = data

        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        let emptypf = PropertyFactory<AK, Int64>(AK(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        let emptypfs = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>(ArrayKeyframeArrayFloat64(),0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.s = emptypfs
        this.e = emptypfs
        this.o = emptypfs
        this.xe = emptypf
        this.ne = emptypf
        this.sm = emptypf
        this.a = emptypf

        this.initDynamicPropertyContainer(elemGlobalData, elemData)
        if (data.s.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.s = PropertyFactory<ArrayKeyframeFloat64, Array<Float64>>.getProp(data.s, data.s.k[0].k ?? Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.s.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.s.k.size > 1) { //走【分支3】
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, data.s.k, 0, 0.0, this, elemGlobalData, elemData, dataA: data.s.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.s = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.s, Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.s.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.s.container = [this]
        if (data.e.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.e = PropertyFactory<ArrayKeyframeFloat64, Array<Float64>>.getProp(data.e, data.e.k[0].k ?? Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.e.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.e.k.size > 1) { //走【分支3】
            this.e = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.e, data.e.k, 0, 0.0, this, elemGlobalData, elemData, dataA: data.e.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.e = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.e, Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.e.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
            this.e.v = [100.0]
        }
        this.e.container = [this]
        if (data.o.k.size == 1) { //获取 rotate 相关的参数  //走【分支1】
            this.o = PropertyFactory<ArrayKeyframeFloat64, Array<Float64>>.getProp(data.o, data.o.k[0].k ?? Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else if (data.o.k.size > 1) { //走【分支3】
            this.o = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.o, data.o.k, 0, 0.0, this, elemGlobalData, elemData, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        } else { //走【分支1】  =>   data.r || { k: 0 }
            this.o = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(data.o, Array<Float64>(), 0.0, this, elemGlobalData, elemData, types: 0, dataA: data.o.a, dynamicProperties: dynamicProperties, containerType: 3, compType: this.compType, renderedFrame: this.getRenderedFrame, compDataInd: this.compDataInd)
        }/*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.o.container = [this]
            
        /* "xe": {"a": 0, "k": 0} -- 走【分支1】 */
        this.xe = PropertyFactory<AK, Int64>.getProp(data.xe, data.xe.k, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.xe.containerType = 3  /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.xe.container = [this]
        /* "ne": {"a": 0, "k": 0} -- 走【分支1】 */
        this.ne = PropertyFactory<AK, Int64>.getProp(data.ne, data.ne.k, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.ne.containerType = 3  /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.ne.container = [this]
        /* "a": {"a": 0, "k": 100} -- 走【分支1】 */
        this.a = PropertyFactory<AK, Int64>.getProp(data.a, data.a.k, 0.01, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.a.containerType = 3  /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.a.container = [this]

        this.sm = PropertyFactory.getProp(AK(k: 100), 100, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.sm.containerType = 3  /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        this.sm.container = [this]

        if (this.dynamicProperties.size == 0) {
            this.getValue()
        }
    }

    public open func getMult(index: Int64, total: Int64): Float64 {
        return getMult(Float64(index))
    }

    public func getMult(ind2: Float64): Float64 {
        var ind: Float64 = ind2
        if (this._currentTextLength != this.elemTextPropertyCurrentData.l.size) {
            this.getValue()
        }
        var x1: Float64 = 0.0
        var y1: Float64 = 0.0
        var x2: Float64 = 1.0
        var y2: Float64 = 1.0
        if (this.ne.v[0] > 0.0) {
            x1 = this.ne.v[0] / 100.0
        } else {
            y1 = -this.ne.v[0] / 100.0
        }
        if (this.xe.v[0] > 0.0) {
            x2 = 1.0 - this.xe.v[0] / 100.0
        } else {
            y2 = 1.0 + this.xe.v[0] / 100.0
        }
        let easer: (Float64) -> Float64 = BezierFactory.getBezierEasing(x1, y1, x2, y2, Array<String>()).getOfBezierEasing

        var mult: Float64 = 0.0
        let s: Float64 = this.finalS
        let e: Float64 = this.finalE
        let types: Int64 = this.data.sh
        if (types == 2) {
            if (e == s) {
                mult = if (ind >= e) { 1.0 } else { 0.0 }
            } else {
                mult = max(0.0, min(0.5 / (e - s) + (ind - s) / (e - s), 1.0))
            }
            mult = easer(mult)
        } else if (types == 3) {
            if (e == s) {
                mult = if (ind >= e) { 0.0 } else { 1.0 }
            } else {
                mult = 1.0 - max(0.0, min(0.5 / (e - s) + (ind - s) / (e - s), 1.0))
            }

            mult = easer(mult)
        } else if (types == 4) {
            if (e == s) {
                mult = 0.0
            } else {
                mult = max(0.0, min(0.5 / (e - s) + (ind - s) / (e - s), 1.0))
                if (mult < 0.5) {
                    mult *= 2.0
                } else {
                    mult = 1.0 - 2.0 * (mult - 0.5)
                }
            }
            mult = easer(mult)
        } else if (types == 5) {
            if (e == s) {
                mult = 0.0
            } else {
                let tot: Float64 = e - s

                ind = min(max(0.0, ind + 0.5 - s), e - s)
                let x: Float64 = -tot / 2.0 + ind
                let a: Float64 = tot / 2.0
                mult = sqrt(1.0 - (x * x) / (a * a))
            }
            mult = easer(mult)
        } else if (types == 6) {
            if (e == s) {
                mult = 0.0
            } else {
                ind = min(max(0.0, ind + 0.5 - s), e - s)
                mult = (1.0 + (cos((Float64.PI + Float64.PI * 2.0 * (ind) / (e - s))))) / 2.0   /*  eslint-disable-line  */
            }
            mult = easer(mult)
        } else {
            if (ind >= floor(s)) {
                if (ind - s < 0.0) {
                    mult = max(0.0, min(min(e, 1.0) - (s - ind), 1.0))
                } else {
                    mult = max(0.0, min(e - ind, 1.0))
                }
            }
            mult = easer(mult)
        }

        /*
         * 平稳实施。
         * 平滑度表示原始[01]范围的缩小范围。
         * 如果平滑度为25%，则新范围将为[0.375 0.625]
         * 步骤如下：
         * -找到新范围的较低值（阈值）
         * -如果乘数小于该值，则将其降至0
         * -如果它更大，
         * -减去阈值
         * -将其除以平滑度（这将使范围返回到[0 1]）
         * 注意：如果它在某些情况下不起作用，请考虑在easer之前应用它。
         */
        if (this.sm.v[0] != 100.0) {
            var smoothness: Float64 = this.sm.v[0] * 0.01
            if (smoothness == 0.0) {
                smoothness = 0.00000001
            }
            let threshold: Float64 = 0.5 - smoothness * 0.5
            if (mult < threshold) {
                mult = 0.0
            } else {
                mult = (mult - threshold) / smoothness
                if (mult > 1.0) {
                    mult = 1.0
                }
            }
        }
        return mult * this.a.v[0]
    }

    public func getValue(): Unit {
        this.getValue(false)
    }

    public func getValue(newCharsFlag: Bool) {
        this.iterateDynamicProperties()
        this._mdf = newCharsFlag || this._mdf
        this._currentTextLength = this.elemTextPropertyCurrentData.l.size
        if (newCharsFlag && this.data.r == 2) {
            /*  s/e 在 json 中暂未找到 */
            this.e.v = [ Float64(this._currentTextLength) ]
        }

        var divisor: Float64 = 1.0
        if (this.data.r != 2) {
            divisor = Float64(100) / Float64(this.data.totalChars)
        }

        let o: Float64 = this.o.v[0] / divisor
        var s: Float64 = this.s.v[0] / divisor + o
        var e: Float64 = (this.e.v[0] / divisor) + o
        if (s > e) {
            let _s: Float64 = s
            s = e
            e = _s
        }
        this.finalS = s
        this.finalE = e
    }
}
