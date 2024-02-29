/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class CharsData <: ToString {
    public var shapes: ArrayList<ContentModel> = ArrayList<ContentModel>()

    init(){}
    init(shapes: ArrayList<ContentModel>){
        this.shapes = shapes
    }

    public func toString(): String {
        "CharsData: {\n shapes.size = ${shapes.size},\n shapes = ${shapes}\n }\n"
    }
}

public class FontCharacter <: Hashable & ToString {

    private static let CHARS_HASH_DEFAULT: Int64 = 31

    public static func hashFor(ch: String, fFamily: String, style: String): Int64 {
        /*
         * Instead of calling hashcode directly,
         * ch converts it to characters and then calculates the corresponding ASCII value
         * var result: Int64 = Int64(UInt32(ch))
         */
        var result: Int64 = ch.hashCode()
        result = CHARS_HASH_DEFAULT * result + fFamily.hashCode()
        result = CHARS_HASH_DEFAULT * result + style.hashCode()
        return result
    }

    private var ch: String = ""
    private var size: Float64 = 0.0
    private var w: Float64 = 0.0
    private var style: String = ""
    private var fFamily: String = ""

    public var data: CharsData = CharsData()
    
    init(){}

    public init(data: CharsData, ch: String, size: Float64, w: Float64, style: String, fFamily: String) {
        this.data = data
        this.ch = ch
        this.size = size
        this.w = w
        this.style = style
        this.fFamily = fFamily
    }

    public func hashCode(): Int64 {
        return hashFor(ch, fFamily, style)
    }

    public func toString(): String {
        "FontCharacter: {\n" +
        "ch = ${ch}\n" +
        "size = ${size}\n" +
        "w = ${w}\n" +
        "style = ${style}\n" +
        "fFamily = ${fFamily}\n" +
        "data = ${data}\n" +
        "}\n"
    }
}
