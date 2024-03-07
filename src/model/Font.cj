/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Fonts structure.
 */
package model

public class Fonts <: ToString {

    private let _list: Array<Font>

    /**
     * Create a Fonts instance based on the parameter.
     *
     * @param list - Type of Array<Font>, the value of list.
     */
    public init(list!: Array<Font> = Array<Font>()){
        this._list = list
    }

    /**
     * Obtain the list of Fonts.
     */
    public prop list: Array<Font> {
        get() { this._list.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Fonts: {\n list = ${_list}\n }"
    }
}

public class Font <: ToString {

    public let fFamily: String           // 0 = family
    public let fName: String             // 1 = name
    public let fStyle: String            // 2 = style
    public let ascent: Float64           // 3 = ascent

    /**
     * Create a Font instance based on parameters.
     *
     * @param fFamily - Type of String, the value of fFamily.
     * @param fName - Type of String, the value of fName.
     * @param fStyle - Type of String, the value of fStyle.
     * @param ascent - Type of Float64, the value of ascent.
     */
    public init(fFamily: String, fName: String, fStyle: String, ascent: Float64){
        this.fFamily = fFamily
        this.fName = fName
        this.fStyle = fStyle
        this.ascent = ascent
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
        "ascent  = ${ascent}\n}"
    }
}
