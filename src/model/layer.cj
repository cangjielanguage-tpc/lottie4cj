/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Layer structure.
 */
package model

public class Layer <: ToString {

    public var hasMask: Bool = false

    //TODO: this.layers[j].id 是 Layer.ind ？？？

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
    private let _masksProperties: Array<Mask>        // 10 = masks
    private let _shapes: Array<ContentModel>         // 11 = shapes
    public let t: LayerT                             // 12 = t
    private let _ef: Array<LayerEF>                  // 13 = ef
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
    public let bm: Int64                             // 24 = blendMode

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
        bm!: Int64 = 0
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
        this._masksProperties = masksProperties
        this._shapes         = shapes
        this.t               = t
        this._ef             = ef
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
        this.bm              = bm
    }

    /**
     * Obtain the masksProperties of Layer.
     */
    public prop masksProperties: Array<Mask> {
        get() { this._masksProperties.clone() }
    }

    /**
     * Obtain the shapes of Layer.
     */
    public prop shapes: Array<ContentModel> {
        get() { this._shapes.clone() }
    }

    /**
     * Obtain the ef of Layer.
     */
    public prop ef: Array<LayerEF> {
        get() { this._ef.clone() }
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
        "masksProperties.size = ${_masksProperties.size}\n" +  // 10 = masks
        "shapes.size = ${_shapes.size}\n" +                    // 11 = shapes
        "t = ${t}\n" +                                        // 12 = t
        "ef.size = ${_ef.size}\n" +                            // 13 = ef
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
        "bm = ${bm}\n}"                 // 24 = blendMode
    }

}

public class LayerTD <: ToString {
    private let _k: Array<Keyframe<DocumentData>>

    /**
     * Create a LayerTD instance based on the parameter.
     *
     * @param k - Type of Array<Keyframe<DocumentData>>, the value of k.
     */
    public init(k!: Array<Keyframe<DocumentData>> = Array<Keyframe<DocumentData>>()){
        this._k = k
    }

    /**
     * Obtain the k of LayerTD.
     */
    public prop k: Array<Keyframe<DocumentData>> {
        get() { this._k.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "LayerTD: {\n k = ${_k}\n}"
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

    public let d: LayerTD
    private let _a: Array<AnimatableTextPropertiesA>

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
        this._a = a
        this.m = m
    }

    /**
     * Obtain the a of LayerT.
     */
    public prop a: Array<AnimatableTextPropertiesA> {
        get() { this._a.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "LayerT-t: {\n" +
               "d = ${d},\n" +
               "a = ${_a},\n" +
               "m = ${m}\n}"
    }
}

public class LayerEF <: ToString {

    public let ty: Int64
    public let nm: String
    private let _ef: Array<Effect>

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
        this._ef = ef
    }

    /**
     * Obtain the ef of LayerEF.
     */
    public prop ef: Array<Effect> {
        get() { this._ef.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "LayerEF: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "ef = ${_ef}\n}"
    }
}
