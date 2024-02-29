/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

type BlurEffect = Effect
type DropShadowEffect = Effect

class Effect <: ToString {
    var ty: Int64 = 0
    var nm: String = ""
    var v: ArrayList<Keyframe<Array<Float64>>> = ArrayList<Keyframe<Array<Float64>>>()
    var isNull: Bool = true

    init(){}

    init(ty: Int64, v: ArrayList<Keyframe<Array<Float64>>>, isNull: Bool){
        this.ty = ty
        this.v = v
    }

    public func toString(): String {
        return "Effect: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "v = ${v} \n}"
    }
}
