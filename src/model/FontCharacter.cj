/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

public class CharsData <: ToString {
    private let _shapes: Array<ContentModel>

    public init(shapes!: Array<ContentModel> = Array<ContentModel>()){
        this._shapes = shapes
    }

    public prop shapes: Array<ContentModel> {
        get() { this._shapes.clone() }
    }

    public func toString(): String {
        "CharsData: {\n shapes.size = ${_shapes.size},\n shapes = ${_shapes}\n }"
    }
}

//"chars" - The corresponding data type in json.
public class FontCharacter <: Hashable & ToString {

    private static let CHARS_HASH_DEFAULT: Int64 = 31

    public let ch: String
    public let size: Float64
    public let w: Float64
    public let style: String
    public let fFamily: String
    public let data: CharsData

    public init(data: CharsData, ch: String, size: Float64, w: Float64, style: String, fFamily: String) {
        this.data = data
        this.ch = ch
        this.size = size
        this.w = w
        this.style = style
        this.fFamily = fFamily
    }

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
        "data = ${data}\n}"
    }
}
