/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a FontCharacter structure.
 */
package lottie.model

public class CharsData <: ToString {

    public var ip: Int64 = 0
    public var op: Int64 = 0
    public var st: Int64 = 0
    public var sr: Int64 = 0
    public var ks: AnimatableTransform = AnimatableTransform()

    public var refId: String = ""
    //从 animationData.assets 中找到符合条件的 Asset，条件：this.refId == Asset.id。
    //从找到符合条件的 Asset 中拿到 Asset.layers，赋值到成员变量 layers 中。
    public var layers: Array<Layer> = empty_Array_layer

    public let shapes: ArrayList<ContentModel>

    /**
     * Create a CharsData instance based on parameters.
     *
     * @param shapes - Type of Array<ContentModel>, the value of shapes.
     */
    public init(shapes!: ArrayList<ContentModel> = ArrayList<ContentModel>()){
        this.shapes = shapes
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "CharsData: {\n shapes.size = ${shapes.size},\n shapes = ${shapes}\n }"
    }
}

/* "chars" - The corresponding data type in json. */
public class FontCharacter <: Hashable & ToString {

    /* 编译用，暂时在 json 中找不到 chars[i].t。*/
    public var t: Int64 = -1

    private static let CHARS_HASH_DEFAULT: Int64 = 31

    public let ch: String
    public let size: Float64
    public let w: Float64
    public let style: String
    public let fFamily: String
    public let data: CharsData

    /**
     * Create a FontCharacter instance based on parameters.
     *
     * @param ch - Type of String, the value of ch.
     * @param size - Type of Float64, the value of size.
     * @param w - Type of Float64, the value of w.
     * @param style - Type of String, the value of style.
     * @param fFamily - Type of String, the value of fFamily.
     * @param data - Type of CharsData, the value of data.
     */
    public init(data: CharsData, ch: String, size: Float64, w: Float64, style: String, fFamily: String) {
        this.data = data
        this.ch = ch
        this.size = size
        this.w = w
        this.style = style
        this.fFamily = fFamily
    }

    /**
     * Return the FontCharacter hashCode value.
     *
     * @param ch - Type of String, the value of ch.
     * @param fFamily - Type of String, the value of fFamily.
     * @param style - Type of String, the value of style.
     * @return Type of Int64, the FontCharacter hashCode value.
     */
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

    /**
     * Return the FontCharacter hashCode value.
     *
     * @return Type of Int64, the FontCharacter hashCode value.
     */
    public func hashCode(): Int64 {
        return hashFor(ch, fFamily, style)
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
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
