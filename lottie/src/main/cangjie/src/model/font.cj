/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Fonts structure.
 */
package lottie.model

public class Fonts <: ToString {

    public let list: Array<Font>

    /**
     * Create a Fonts instance based on the parameter.
     *
     * @param list - Type of Array<Font>, the value of list.
     */
    public init(list!: Array<Font> = Array<Font>()){
        this.list = list
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Fonts: {\n list = ${list}\n }"
    }

    /**
     * The Fonts is empty.
     *
     * @return Type of Bool, if the Fonts is empty, return true.
     */
    public func isEmpty(): Bool {
        return this.list.size <= 0
    }
}

public open class Font <: ToString {

    public var cache: ArrayList<Int64> = ArrayList<Int64>()

    public var loaded: Bool = false

    public let fFamily: String           // 0 = family
    public let fName: String             // 1 = name
    public let fStyle: String            // 2 = style
    public let ascent: Float64           // 3 = ascent

    public let fOrigin: String           // 4 = "fOrigin"
    public let origin: Int64             // 5 = "origin"
    public let fPath: String             // 6 = "fPath"
    public let fClass: String            // 7 = "fClass"
    public let fWeight: String           // 8 = "fWeight"


    /**
     * Create a Font instance based on parameters.
     *
     * @param fFamily - Type of String, the value of fFamily.
     * @param fName - Type of String, the value of fName.
     * @param fStyle - Type of String, the value of fStyle.
     * @param ascent - Type of Float64, the value of ascent.
     */
    public init(fFamily: String, fName: String, fStyle: String, ascent: Float64,
                fOrigin: String, origin: Int64, fPath: String, fClass: String, fWeight: String
    ){
        this.fFamily = fFamily
        this.fName = fName
        this.fStyle = fStyle
        this.ascent = ascent

        this.fOrigin = fOrigin
        this.origin = origin
        this.fPath = fPath
        this.fClass = fClass
        this.fWeight = fWeight
    }

    /**
     * Return the fName value.
     *
     * @return Type of String, the fName value.
     */
    public func getName(): String {
        return fName
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Font {\n" +
        "fName   = ${fName}\n" +
        "fFamily = ${fFamily}\n" +
        "fStyle  = ${fStyle}\n" +
        "ascent  = ${ascent}\n" +

        "fOrigin = ${fOrigin}\n" +
        "origin  = ${origin}\n" +
        "fPath   = ${fPath}\n" +
        "fClass  = ${fClass}\n" +
        "fWeight = ${fWeight}\n}"
    }
}
