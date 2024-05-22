/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeGroup structure.
 */
package model

public class ShapeGroup <: ContentModel {

    /**
     * 0. "layers"."shapes".{"ty": "gr"} = ShapeGroupParser
     */
    public let nm: String                    // 0 = name
    public let hd: Bool                      // 1 = hidden
    private let _it: Array<ContentModel>     // 2 = items

    let _ty: String = "gr"
    public open prop ty: String {
        get() { _ty }
    }

    /**
     * Create a ShapeGroup instance based on parameters.
     *
     * @param nm - Type of String, the value of nm.
     * @param it - Type of Array<ContentModel>, the value of it.
     * @param hd - Type of Bool, the value of hd.
     */
    public init(nm: String, it: Array<ContentModel>, hd: Bool) {
        this.nm = nm
        this._it = it
        this.hd = hd
    }

    /**
     * Obtain the type of ShapeGroup.
     */
    public override prop types: Int8 {
        get() { 0 }
    }

    /**
     * Obtain the it of ShapeGroup.
     */
    public prop it: Array<ContentModel> {
        get() { this._it.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeGroup[gr]: {\n" +
               "ty: ${ty},\n" +
               "nm: ${nm},\n" +
               "hd: ${hd},\n" +
               "it: ${_it}\n}"
    }
}
