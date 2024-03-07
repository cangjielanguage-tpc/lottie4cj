/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimatableTextProperties structure.
 */
package model

public class AnimatableTextPropertiesA <: ToString {

    public let a: AnimatableTextProperties

    /**
     * Create a AnimatableTextPropertiesA instance based on the parameter.
     *
     * @param a - Type of AnimatableTextProperties, the value of a.
     */
    public init(a!: AnimatableTextProperties = AnimatableTextProperties()){
        this.a = a
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "AnimatableTextPropertiesA: {a = ${a}}"
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
