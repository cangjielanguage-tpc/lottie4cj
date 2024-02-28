/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

let FONTS_EMPTY: Fonts = Fonts()
let FONT_EMPTY: Font = Font()

public class Fonts <: ToString {

    var list: Array<Font> = Array<Font>()

    init(){}
    init(list: Array<Font>){
        this.list = list
    }

    public func toString(): String {
        "Fonts: {\n list = ${list}\n }\n"
    }
}

public class Font <: ToString {

    private var fFamily: String = ""    // 0 = family
    private var fName: String = ""      // 1 = name
    private var fStyle: String = ""     // 2 = style
    private var ascent: Float64 = 0.0   // 3 = ascent

    init(){}
    init(fFamily: String, fName: String, fStyle: String, ascent: Float64){
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
        "    fName   = ${fName}\n" +
        "    fFamily = ${fFamily}\n" +
        "    fStyle  = ${fStyle}\n" +
        "    ascent  = ${ascent}\n" +
        "}\n"
    }
}
