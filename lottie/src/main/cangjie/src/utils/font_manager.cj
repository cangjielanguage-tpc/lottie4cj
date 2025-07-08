/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is FontManager.
 */
package lottie.utils

internal import lottie.model.*
internal import lottie.utils.helpers.*
internal import lottie.model.Font as LottieFont
internal import lottie.model.Fonts as LottieFonts

internal import std.convert.*
internal import std.collection.{ArrayList, HashMap}

public type CreateTag = CreateNS

public class FontManager {

    var maxWaitingTime: Int32 = 5000
    /* json中的"chars"部分 */
    var emptyChar: FontCharacter = FontCharacter(CharsData(), "", 0.0, 0.0, "", "")

    /* Hindi characters */
    public static let combinedCharacters: Array<UInt32> = [2304, 2305, 2306, 2307, 2362, 2363, 2364, 2364, 2366,
      2367, 2368, 2369, 2370, 2371, 2372, 2373, 2374, 2375, 2376, 2377, 2378, 2379,
      2380, 2381, 2382, 2383, 2387, 2388, 2389, 2390, 2391, 2402, 2403]

    public static let surrogateModifiers: Array<String> = [
      "d83cdffb",
      "d83cdffc",
      "d83cdffd",
      "d83cdffe",
      "d83cdfff"
    ]

    public static let zeroWidthJoiner: Array<UInt32> = [65039, 8205]

    public var fonts: Array<LottieFont> = Array<LottieFont>()
    public var chars: ArrayList<FontCharacter> = ArrayList<FontCharacter>()
    var typekitLoaded: Int64 = 0
    public var isLoaded: Bool = false
    var _warned: Bool = false
    var initTime: Int64 = 0

    /* BaseRenderer 中成员变量，用于辨别是否是 "canvas" */
    public var rendererType: String = ""

    /**
     * Create a FontManager instance.
     */
    public init() { }

    /* /数据来源分析：fontData == animData.fonts == Fonts */
    public func addFonts(fontData: LottieFonts, defs: CreateTag): Unit {
        if (fontData.isEmpty()) {
            this.isLoaded = true
            return
        }
        if (this.chars.size > 0) {
            this.isLoaded = true
            this.fonts = fontData.list
            return
        }
        /* 非 canvas 部分暂未实现。【适配 HTML 和 svg】 */
        if (rendererType != "canvas") {
            return
        }
    }

    /* 数据来源分析：fchars == animData.chars == Array<FontCharacter> */
    public func addChars(fchars: Array<FontCharacter>): Unit {
        if (fchars.size <= 0) {
            return
        }
        if (this.chars.size <= 0) {
            this.chars.clear()
        }

        let len: Int64 = fchars.size
        var j: Int64 = 0
        var jLen = this.chars.size
        var found: Bool = false

        for (i in 0..len) {
            j = 0
            found = false
            while (j < jLen) {
                if (this.chars[j].style == fchars[i].style && this.chars[j].fFamily == fchars[i].fFamily && this.chars[j].ch == fchars[i].ch) {
                    found = true
                }
                j += 1
            }
            if (!found) {
                this.chars.add(fchars[i])
                jLen += 1
            }
        }
    }

    /**
     * Get Font by name.
     *
     * @param name - Type of String.
     * @return Type of Font, result value.
     */
    public func getFontByName(name: String): LottieFont {
        if (this.fonts.size == 0){
            throw IndexOutOfBoundsException("this.fonts.size = ${this.fonts.size}")
        }
        let len: Int64 = this.fonts.size
        for (i in 0..len) {
            if (this.fonts[i].fName == name) {
                return this.fonts[i]
            }
        }
        return this.fonts[0]
    }

    /**
     * Get char data.
     *
     * @param char - Type of String.
     * @param style - Type of String.
     * @param font - Type of String.
     * @return Type of FontCharacter, result value.
     */
    public func getCharData(char: String, style: String, font: String): FontCharacter {
        let len: Int64 = this.chars.size
        for (i in 0..len) {
            if (this.chars[i].ch == char && this.chars[i].style == style && this.chars[i].fFamily == font) {
                return this.chars[i]
            }
        }
        if (char[0] != 13 && !this._warned) {
            this._warned = true
        }
        return emptyChar
    }

    /**
     * Determine if it is a modifier.
     *
     * @param firstCharCode - Type of UInt32, the first char code.
     * @param secondCharCode - Type of UInt32, the second char code.
     * @return Type of Bool, result value.
     */
    public static func isModifier(firstCharCode: UInt32, secondCharCode: UInt32): Bool {
        let sum: String = firstCharCode.format("x") + secondCharCode.format("x")
        return surrogateModifiers.contains(sum)
    }

    /**
     * Determine if it is a zero width Joiner.
     *
     * @param firstCharCode - Type of UInt32, the first char code.
     * @param secondCharCode - Type of UInt32, the second char code.
     * @return Type of Bool, result value.
     */
    public static func isZeroWidthJoiner(firstCharCode: UInt32, secondCharCode: UInt32): Bool {
        if (secondCharCode == 0) {
            return firstCharCode == zeroWidthJoiner[1]
        }
        return firstCharCode == zeroWidthJoiner[0] && secondCharCode == zeroWidthJoiner[1]
    }

    /**
     * Determine if it is a combination character.
     *
     * @param char - Type of UInt32, determine if the char is a combination character.
     * @return Type of Bool, result value.
     */
    public static func isCombinedCharacter(char: UInt32): Bool {
        return combinedCharacters.contains(char)
    }

}
