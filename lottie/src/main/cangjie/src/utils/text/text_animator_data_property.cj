/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is TextAnimatorDataProperty.
 */
package lottie.utils.text


public class AnimatableTextProperty {

    public let fc: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>
    public let sc: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>
    public let sw: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    public let t: PropertyFactory<ArrayKeyframeFloat64, Float64>

    /* 
     * 未找到下方对应的 json 数据：
     * r/rx/ry/
     * sk/sa/
     * s/a/o/p/
     * fh/fs/fb
     */
    public let r: PropertyFactory<Float64, Float64>
    public let rx: PropertyFactory<Float64, Float64>
    public let ry: PropertyFactory<Float64, Float64>
    public let sk: PropertyFactory<Float64, Float64>
    public let sa: PropertyFactory<Float64, Float64>
    public let s: PropertyFactory<Float64, Float64>
    public let a: PropertyFactory<Float64, Float64>
    public let o: PropertyFactory<Float64, Float64>
    public let p: PropertyFactory<Float64, Float64>
    public let fh: PropertyFactory<Float64, Float64>
    public let fs: PropertyFactory<Float64, Float64>
    public let fb: PropertyFactory<Float64, Float64>

     public init(
        fc!: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>,
        sc!: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>,
        sw!: PropertyFactory<Array<Keyframe<Float64>>, Float64>,
        t!: PropertyFactory<ArrayKeyframeFloat64, Float64>,
        defaultData!: PropertyFactory<Float64, Float64>
     ){
        this.fc = fc
        this.sc = sc
        this.sw = sw
        this.t = t
        
        this.r = defaultData
        this.rx = defaultData
        this.ry = defaultData
        this.sk = defaultData
        this.sa = defaultData
        this.s = defaultData
        this.a = defaultData
        this.o = defaultData
        this.p = defaultData
        this.fh = defaultData
        this.fs = defaultData
        this.fb = defaultData
     }

}

/*
 * elem  =>  ITextElement
 * animatorProps  =>  this._textData.a[i]  =>  layer.t.a[i](AnimatableTextPropertiesA)
 * container  =>  TextAnimatorProperty
 */
public class TextAnimatorDataProperty {

    var elemGlobalData: GlobalData
    var elemData: Layer
    var elemTextPropertyCurrentData: DocumentData
    
    var animatorProps: AnimatableTextPropertiesA
    var container: TextAnimatorProperty
    
    var a: AnimatableTextProperty
    var s: TextSelectorPropFactory

    public init (animatorProps: AnimatableTextPropertiesA, container: TextAnimatorProperty, elemGlobalData: GlobalData, elemData: Layer, elemTextPropertyCurrentData: DocumentData, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        this.animatorProps = animatorProps
        this.container = container

        this.elemGlobalData = elemGlobalData
        this.elemData = elemData
        this.elemTextPropertyCurrentData = elemTextPropertyCurrentData

        /* 空的 PropertyFactor，为了 this.a 中数据不存在时，当做默认值使用。 */
        let defaultData = PropertyFactory<Float64, Float64>(0.0, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        /* 数据来源分析：textAnimatorAnimatables  ==  animatorProps.a  <=  this._textData.a[i].a  =>  layer.t.a[i].a(AnimatableTextProperties) */
        let textAnimatorAnimatables: AnimatableTextProperties = animatorProps.a

        var vLen: Int64 = 0

        let sw: PropertyFactory<Array<Keyframe<Float64>>, Float64>
        /* sw/sc 为空数组时，需单独处理。 */
        if (textAnimatorAnimatables.sw.size == 0) {
            sw = empty_pf_Array_Keyframe_Float64
        } else if (textAnimatorAnimatables.sw.size == 1) {//走【分支1】
            sw = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(textAnimatorAnimatables.sw, textAnimatorAnimatables.sw[0].k ?? 0.0, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        } else {//走【分支3】
            sw = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(textAnimatorAnimatables.sw, textAnimatorAnimatables.sw, 0, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        }
        let sc: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>
        /* sw/sc 为空数组时，需单独处理。 */
        if (textAnimatorAnimatables.sw.size == 0) {
            sc = empty_pf_Array_Keyframe_Array_Float64
        } else if (textAnimatorAnimatables.sw.size == 1) {//走【分支2】
            sc = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(textAnimatorAnimatables.sc, textAnimatorAnimatables.sc[0].k ?? Array<Float64>(), 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        } else {//走【分支4】
            if (textAnimatorAnimatables.sc.size > 0) { vLen = (textAnimatorAnimatables.sc[0].s ?? Array<Float64>()).size }
            sc = PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>.getProp(textAnimatorAnimatables.sc, textAnimatorAnimatables.sc, 1, 0.0, container, elemGlobalData, elemData, vLen: vLen, dynamicProperties: dynamicProperties)
        }
        
        //走【分支4】
        if (textAnimatorAnimatables.fc.k.size > 0) { vLen = (textAnimatorAnimatables.fc.k[0].s ?? Array<Float64>()).size }
        let fc: PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>> = PropertyFactory<ArrayKeyframeArrayFloat64, Array<Float64>>.getProp(textAnimatorAnimatables.fc, textAnimatorAnimatables.fc.k, 1, 0.0, container, elemGlobalData, elemData, vLen: vLen, dynamicProperties: dynamicProperties)
        //走【分支3】
        let t: PropertyFactory<ArrayKeyframeFloat64, Float64> = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(textAnimatorAnimatables.t, textAnimatorAnimatables.t.k, 0, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
    
        this.a = AnimatableTextProperty(
            sw: sw,
            sc: sc,
            fc: fc,
            t: t,
            defaultData: defaultData
        )

        /*
         * 数据来源分析：animatorProps.s  =>  this._textData.a[i].s  =>  layer.t.a[i].s(AnimatableTextPropertiesS)
         * 数据来源分析：container  =>  TextAnimatorProperty
         * TextSelectorProp.getTextSelectorProp 只用到前 2 个参数。
         */
        this.s = TextSelectorProp.getTextSelectorProp(animatorProps.s, elemGlobalData, elemData, elemTextPropertyCurrentData, dynamicProperties: dynamicProperties)
        this.s.t = animatorProps.s.t
    }
}
