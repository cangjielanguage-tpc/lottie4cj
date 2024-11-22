/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Layer structure.
 */
package lottie.model

import lottie.utils.helpers.UnionType

public class Layer <: ToString {

    public var tp: Int64 = -1

    //ICompElement编译用。
    public var xt: Bool = false
    //当 layer.ty == 101 && isAsset == true 时，此 Layer 实际代表的是 Asset。兼容 BaseRenderer.searchExtraCompositions 中 createComp 函数应用。
    public var asset: Asset = Asset("", Array<Layer>(), 0, 0, "", "", 0)
    public var isAsset: Bool = false

    //RenderableElement编译用。
    public var textData: Size = Size()
    public var width: Int64 = 0
    public var height: Int64 = 0
    public var ddd: Int64 = 0

    public var hasMask: Bool = false
    public var td: Int64
    
    public var singleShape: Bool = false
    public var completed: Bool = false
    
    //从 animationData.assets 中找到符合条件的 Asset，条件：this.Layer.refId == Asset.id。
    //从找到符合条件的 Asset 中拿到 Asset.layers，赋值到成员变量 layers 中。
    public var layers: Array<Layer> = Array<Layer>()

    public let nm: String                            // 0 = layerName
    public let ind: Int64                            // 1 = layerId
    public let refId: String                         // 2 = refId
    public let ty: Int64                             // 3 = layerType
    public let parent: Int64                         // 4 = parentId
    public let sw: Int64                             // 5 = solidWidth
    public let sh: Int64                             // 6 = solidHeight
    public let sc: String                            // 7 = solidColor
    public let ks: AnimatableTransform               // 8 = transform
    public let tt: Int64                             // 9 = matteType
    public let masksProperties: Array<Mask>          // 10 = masks
    public let shapes: Array<ContentModel>           // 11 = shapes
    public let t: LayerT                             // 12 = t
    public let ef: Array<LayerEF>                    // 13 = ef
    public var sr: Float64                           // 14 = timeStretch
    public let st: Float64                           // 15 = startFrame
    public let w: Float64                            // 16 = preCompWidth
    public let h: Float64                            // 17 = preCompHeight
    public let ip: Float64                           // 18 = inFrame
    public let op: Float64                           // 19 = outFrame
    public let tm: ContentModelDK                    // 20 = timeRemapping
    public let cl: String                            // 21 = cl
    public let hd: Bool                              // 22 = hidden
    public let ao: Int64                             // 23 = autoOrient
    public let bm: UnionType                         // 24 = blendMode

    /**
     * Create a Layer instance based on parameters.
     *
     * @param nm - Type of String, the value of nm, layer name.
     * @param ind - Type of Int64, the value of ind, layer id.
     * @param refId - Type of String, the value of refId.
     * @param ty - Type of Int64, the value of ty, layerType.
     * @param parent - Type of Int64, the value of parent, parent id.
     * @param sw - Type of Int64, the value of sw, solid width.
     * @param sh - Type of Int64, the value of sh, solid height.
     * @param sc - Type of String, the value of sc, solid color.
     * @param ks - Type of AnimatableTransform, the value of ks.
     * @param tt - Type of Int64, the value of tt.
     * @param masksProperties - Type of Array<Mask>, the value of masksProperties.
     * @param shapes - Type of Array<ContentModel>, the value of shapes.
     * @param t - Type of LayerT, the value of t.
     * @param ef - Type of Array<LayerEF>, the value of ef.
     * @param sr - Type of Float64, the value of sr.
     * @param st - Type of Float64, the value of st.
     * @param w - Type of Float64, the value of w.
     * @param h - Type of Float64, the value of h.
     * @param ip - Type of Float64, the value of ip.
     * @param op - Type of Float64, the value of op.
     * @param tm - Type of ContentModelDK, the value of tm.
     * @param cl - Type of String, the value of cl.
     * @param hd - Type of Bool, the value of hd.
     * @param ao - Type of Int64, the value of ao.
     * @param bm - Type of Int64, the value of bm.
     */
    public init(
        nm!: String = "",
        ind!: Int64 = 0,
        refId!: String = "",
        ty!: Int64 = 0,
        parent!: Int64 = -1,
        sw!: Int64 = 0,
        sh!: Int64 = 0,
        sc!: String = "",
        ks!: AnimatableTransform = AnimatableTransform(),
        tt!: Int64 = 0,
        masksProperties!: Array<Mask> = Array<Mask>(),
        shapes!: Array<ContentModel> = Array<ContentModel>(),
        t!: LayerT = LayerT(),
        ef!: Array<LayerEF> = Array<LayerEF>(),
        sr!: Float64 = 0.0,
        st!: Float64 = 0.0,
        w!: Float64 = 0.0,
        h!: Float64 = 0.0,
        ip!: Float64 = 0.0,
        op!: Float64 = 0.0,
        tm!: ContentModelDK = ContentModelDK(),
        cl!: String = "",
        hd!: Bool = false,
        ao!: Int64 = 0,
        bm!: Int64 = 0,
        hasMask!: Bool = false,
        ddd!: Int64 = 0,
        td!: Int64 = 0
    ){
        this.nm              = nm
        this.ind             = ind
        this.refId           = refId
        this.ty              = ty
        this.parent          = parent
        this.sw              = sw
        this.sh              = sh
        this.sc              = sc
        this.ks              = ks
        this.tt              = tt
        this.masksProperties = masksProperties
        this.shapes         = shapes
        this.t               = t
        this.ef             = ef
        this.sr              = sr
        this.st              = st
        this.w               = w
        this.h               = h
        this.ip              = ip
        this.op              = op
        this.tm              = tm
        this.cl              = cl
        this.hd              = hd
        this.ao              = ao
        this.bm              = UnionType()
        this.hasMask         = hasMask
        this.ddd             = ddd
        this.td              = td
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Layer {\n" +
        "nm     = ${nm}\n" +            // 0 = layerName
        "ind    = ${ind}\n" +           // 1 = layerId
        "refId  = ${refId}\n" +         // 2 = refId
        "ty     = ${ty}\n" +            // 3 = layerType
        "parent = ${parent}\n" +        // 4 = parentId
        "sw     = ${sw}\n" +            // 5 = solidWidth
        "sh     = ${sh}\n" +            // 6 = solidHeight
        "sc     = ${sc}\n" +            // 7 = solidColor
        "ks     = ${ks}\n" +            // 8 = transform
        "tt     = ${tt}\n" +            // 9 = matteType
        "masksProperties.size = ${masksProperties.size}\n" +  // 10 = masks
        "shapes.size = ${shapes.size}\n" +                    // 11 = shapes
        "t = ${t}\n" +                                        // 12 = t
        "ef.size = ${ef.size}\n" +                            // 13 = ef
        "sr = ${sr}\n" +                // 14 = timeStretch
        "st = ${st}\n" +                // 15 = startFrame
        "w  = ${w}\n"  +                // 16 = preCompWidth
        "h  = ${h}\n"  +                // 17 = preCompHeight
        "ip = ${ip}\n" +                // 18 = inFrame
        "op = ${op}\n" +                // 19 = outFrame
        "tm = ${tm}\n" +                // 20 = timeRemapping
        "cl = ${cl}\n" +                // 21 = cl
        "hd = ${hd}\n" +                // 22 = hidden
        "ao = ${ao}\n" +                // 23 = autoOrient
        "bm = ${bm}\n}" +               // 24 = blendMode
        "ddd = ${ddd}\n}"               // 24 = blendMode
    }

}

public class LayerTD <: ToString {
    public let k: Array<Keyframe<DocumentData>>

    /**
     * Create a LayerTD instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<DocumentData>>, the value of k.
     */
    public init(k!: Array<Keyframe<DocumentData>> = Array<Keyframe<DocumentData>>()){
        this.k = k
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "LayerTD: {\n k = ${k}\n}"
    }
}

public class LayerTMA <: ToString {
    public let a: Int64
    public let k: Array<Int64>
    public let ix: Int64
    public init(a!: Int64 = 0, k!: Array<Int64> = Array<Int64>(), ix!: Int64 = 0){
        this.a = a
        this.k = k
        this.ix = ix
    }
    public func toString(): String {
        return "LayerTMA-a: {\n" +
               "a = ${a},\n" +
               "k = ${k},\n" +
               "ix = ${ix}\n}"
    }
}

public class LayerTM <: ToString {
    public let g: Int64
    public let a: LayerTMA
    public init(g!: Int64 = 0, a!: LayerTMA = LayerTMA()){
        this.g = g
        this.a = a
    }
    public func toString(): String {
        return "LayerTM-m: {\n" +
               "g = ${g},\n" +
               "a = ${a}\n}"
    }
}

public class LayerT <: ToString {

    //编译用，暂时在 json 中找不到 layer.t.p。
    public var p: String = ""

    public let d: LayerTD
    public let a: Array<AnimatableTextPropertiesA>

    public let m: LayerTM

    /**
     * Create a LayerT instance based on parameters.
     *
     * @param d - Type of LayerTD, the value of d.
     * @param a - Type of Array<AnimatableTextPropertiesA>, the value of a.
     */
    public init(d!: LayerTD = LayerTD(), a!: Array<AnimatableTextPropertiesA> = Array<AnimatableTextPropertiesA>(),
                m!: LayerTM = LayerTM()
    ){
        this.d = d
        this.a = a
        this.m = m
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "LayerT-t: {\n" +
               "d = ${d},\n" +
               "a = ${a},\n" +
               "m = ${m}\n}"
    }
}

/*
 * "layers": [
 *   "ef": [
 *     {
 *       "ty":25,
 *       "nm":"Drop Shadow2",
 *       "np":8,
 *       "mn":"ADBE Drop Shadow",
 *       "ix":1,
 *       "en":1,
 *       "ef":[...]
 *     }
 *   ]
 * ]
*/
//LayerEF 和 Effect 进行关联继承。 Effect <: LayerEF
public open class LayerEF <: ToString {

    //[EffectsExpressionInterface用到] LayerEF 中增加成员变量 mn/np/en/ix ？？？
    public var mn: String = ""
    public var np: Int64 = 0
    public var en: Int64 = 0
    public var ix: Int64 = 0
    public var isNull: Bool = false

    public let ty: Int64
    public let nm: String
    public let ef: Array<Effect>

    public init(){
        this.ty = 0
        this.nm = ""
        this.ef = Array<Effect>()
        this.isNull = true
    }

    /**
     * Create a LayerEF instance based on parameters.
     *
     * @param ty - Type of Int64, the value of ty.
     * @param nm - Type of String, the value of nm.
     * @param ef - Type of Array<Effect>, the value of ef.
     */
    public init(ty: Int64, nm: String, ef: Array<Effect>){
        this.ty = ty
        this.nm = nm
        this.ef = ef
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public open func toString(): String {
        return "LayerEF: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "ef = ${ef}\n}"
    }
}
