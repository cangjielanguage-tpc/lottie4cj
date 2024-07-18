/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTextProperties structure.
 */
package lottie4cj.model

public class AK <: ToString {
    public let a: Int64
    public let k: Int64
    public init(a!: Int64 = 0, k!: Int64 = 0) {
        this.a = a
        this.k = k
    }
    public func toString(): String {
        return "AK: {a = ${a}, k = ${k}}"
    }
}

public class AnimatableTextPropertiesS <: ToString {
    public let t: Int64
    public let xe: AK
    public let ne: AK
    public let a: AK
    public let b: Int64
    public let rn: Int64
    public let sh: Int64
    public let r: Int64

    public var totalChars: Int64 = 0

    public init(t!: Int64 = 0,
        xe!: AK = AK(), ne!: AK = AK(), a!: AK = AK(),
        b!: Int64 = 0, rn!: Int64 = 0, sh!: Int64 = 0, r!: Int64 = 0
    ) {
        this.t = t
        this.xe = xe
        this.ne = ne
        this.a = a
        this.b = b
        this.rn = rn
        this.sh = sh
        this.r = r
    }

    public func toString(): String {
        return "AnimatableTextPropertiesS-s: {\n" +
               "t  = ${t },\n" +
               "xe = ${xe},\n" +
               "ne = ${ne},\n" +
               "a  = ${a },\n" +
               "b  = ${b },\n" +
               "rn = ${rn},\n" +
               "sh = ${sh},\n" +
               "r  = ${r }\n}"
    }
}

public class AnimatableTextPropertiesA <: ToString {

    public let a: AnimatableTextProperties

    public let s: AnimatableTextPropertiesS

    /**
     * Create a AnimatableTextPropertiesA instance based on the parameter.
     *
     * @param a - Type of AnimatableTextProperties, the value of a.
     */
    public init(a!: AnimatableTextProperties = AnimatableTextProperties(),
        s!: AnimatableTextPropertiesS = AnimatableTextPropertiesS()
    ){
        this.a = a
        this.s = s
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableTextPropertiesA: {a = ${a}, s = ${s}}"
    }
}

public class AnimatableTextProperties <: ToString {

    public let fc: ArrayKeyframeArrayFloat64             //0 = color
    private let _sc: Array<Keyframe<Array<Float64>>>     //1 = stroke
    private let _sw: Array<Keyframe<Float64>>            //2 = strokeWidth
    public let t: ArrayKeyframeFloat64                   //3 = tracking

    /**
     * Create a AnimatableTextProperties instance based on parameters.
     *
     * @param fc - Type of ArrayKeyframeArrayFloat64, the value of fc.
     * @param sc - Type of Array<Keyframe<Array<Float64>>>, the value of sc.
     * @param sw - Type of Array<Keyframe<Float64>>, the value of sw.
     * @param t - Type of ArrayKeyframeFloat64, the value of t.
     */
    public init(
        fc!: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64(),
        sc!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        sw!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        t!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
    ){
        this.fc = fc
        this._sc = sc
        this._sw = sw
        this.t = t
    }

    /**
     * Obtain the sc of AnimatableTextProperties.
     */
    public prop sc: Array<Keyframe<Array<Float64>>> {
        get() { this._sc.clone() }
    }

    /**
     * Obtain the sw of AnimatableTextProperties.
     */
    public prop sw: Array<Keyframe<Float64>> {
        get() { this._sw.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableTextProperties: {\n" +
               "fc = ${fc},\n" +
               "sc = ${_sc},\n" +
               "sw = ${_sw},\n" +
               "t = ${t}\n}"
    }
}
