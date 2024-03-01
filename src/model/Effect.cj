/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Effect <: ToString {
     public let ty: Int64
     public let nm: String
     public let v: ContentModelPK
     public let isNull: Bool

    public init(ty!: Int64 = 0, nm!: String = "", v!: ContentModelPK = ContentModelPK(), isNull!: Bool = true){
        this.ty = ty
        this.nm = nm
        this.v = v
        this.isNull = isNull
    }

    public func toString(): String {
        return "Effect: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "v = ${v}\n}"
    }
}
