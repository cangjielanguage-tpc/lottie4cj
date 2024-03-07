/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Effect structure.
 */
package model

public class Effect <: ToString {
     public let ty: Int64
     public let nm: String
     public let v: ContentModelPK
     public let isNull: Bool

    /**
     * Create a Effect instance based on parameters.
     *
     * @param ty - Type of Int64, the value of ty.
     * @param nm - Type of String, the value of nm.
     * @param v - Type of ContentModelPK, the value of v.
     * @param isNull - Type of Bool, the value of isNull.
     */
    public init(ty!: Int64 = 0, nm!: String = "", v!: ContentModelPK = ContentModelPK(), isNull!: Bool = true){
        this.ty = ty
        this.nm = nm
        this.v = v
        this.isNull = isNull
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "Effect: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "v = ${v}\n}"
    }
}
