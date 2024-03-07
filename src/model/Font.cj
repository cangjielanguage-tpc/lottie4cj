/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class Fonts <: ToString {

    private let _list: Array<Font>

    public init(list!: Array<Font> = Array<Font>()){
        this._list = list
    }

    public prop list: Array<Font> {
        get() { this._list.clone() }
    }

    public func toString(): String {
        "Fonts: {\n list = ${_list}\n }"
    }
}

public class Font <: ToString {

    public let fFamily: String           // 0 = family
    public let fName: String             // 1 = name
    public let fStyle: String            // 2 = style
    public let ascent: Float64           // 3 = ascent

    public init(fFamily: String, fName: String, fStyle: String, ascent: Float64){
        this.fFamily = fFamily
        this.fName = fName
        this.fStyle = fStyle
        this.ascent = ascent
    }

    public func getName(): String {
        return fName
    }

    public func toString(): String {
        "Font {\n" +
        "fName   = ${fName}\n" +
        "fFamily = ${fFamily}\n" +
        "fStyle  = ${fStyle}\n" +
        "ascent  = ${ascent}\n}"
    }
}
