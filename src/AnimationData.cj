/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file
 * The file declars the LottiePlayer class.
 */
package lottie4cj

public class AnimationData {

    public func addWarning(warning: String): Unit {}

}

public open class ContentModelP {
    // "g": {"p": points/Int64, "k": color/ArrayList<Keyframe<T>>}
    var p: Int64 = 0
    var k: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()

    init(p!: Int64 = 0, k!: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()){
        this.p = p
        this.k = k
    }
}

public open class ContentModelD {
    var n: String = ""
    var v: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()

    init(n!: String = "", v!: ArrayList<Keyframe<Float64>> = ArrayList<Keyframe<Float64>>()){
        this.n = n
        this.v = v
    }
}

