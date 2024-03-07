/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Layer <: ToString {

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
    public let sr: Float64                           // 14 = timeStretch
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

    public prop masksProperties: Array<Mask> {
        get() { this._masksProperties.clone() }
    }

    public prop shapes: Array<ContentModel> {
        get() { this._shapes.clone() }
    }

    public prop ef: Array<LayerEF> {
        get() { this._ef.clone() }
    }

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

    public init(k!: Array<Keyframe<DocumentData>> = Array<Keyframe<DocumentData>>()){
        this._k = k
    }

    public prop k: Array<Keyframe<DocumentData>> {
        get() { this._k.clone() }
    }

    public func toString(): String {
        return "LayerTD: {\n k = ${_k}\n}"
    }
}

public class LayerT <: ToString {

    public let d: LayerTD
    private let _a: Array<AnimatableTextPropertiesA>

    public init(d!: LayerTD = LayerTD(), a!: Array<AnimatableTextPropertiesA> = Array<AnimatableTextPropertiesA>()){
        this.d = d
        this._a = a
    }

    public prop a: Array<AnimatableTextPropertiesA> {
        get() { this._a.clone() }
    }

    public func toString(): String {
        return "LayerT: {\n" +
               "d = ${d},\n" +
               "a = ${_a}\n}"
    }
}

public class LayerEF <: ToString {
    public let ty: Int64
    public let nm: String
    private let _ef: Array<Effect>

    public init(ty: Int64, nm: String, ef: Array<Effect>){
        this.ty = ty
        this.nm = nm
        this._ef = ef
    }

    public prop ef: Array<Effect> {
        get() { this._ef.clone() }
    }

    public func toString(): String {
        return "LayerEF: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "ef = ${_ef}\n}"
    }
}
