/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class AnimatableTextPropertiesA <: ToString {

    public let a: AnimatableTextProperties

    public init(a!: AnimatableTextProperties = AnimatableTextProperties()){
        this.a = a
    }

    public func toString(): String {
        return "AnimatableTextPropertiesA: {a = ${a}}"
    }
}

public class AnimatableTextProperties <: ToString {

    public let fc: ArrayKeyframeArrayFloat64             //0 = color
    private let _sc: Array<Keyframe<Array<Float64>>>     //1 = stroke
    private let _sw: Array<Keyframe<Float64>>            //2 = strokeWidth
    public let t: ArrayKeyframeFloat64                   //3 = tracking

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

    public prop sc: Array<Keyframe<Array<Float64>>> {
        get() { this._sc.clone() }
    }
    public prop sw: Array<Keyframe<Float64>> {
        get() { this._sw.clone() }
    }

    public func toString(): String {
        return "AnimatableTextProperties: {\n" +
               "fc = ${fc},\n" +
               "sc = ${_sc},\n" +
               "sw = ${_sw},\n" +
               "t = ${t}\n}"
    }
}
