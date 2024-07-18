/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is handle Font.
 */
package lottie4cj.utils

public class FontProps {
    public let style: String
    public let weight: String
    
    /**
     * Create a FontProps instance based on parameters.
     *
     * @param style - Type of String, the style value.
     * @param weight - Type of String, the style value.
     */
    public init(style: String, weight: String) {
        this.style = style
        this.weight = weight
    }
}

/**
 * Get font properties.
 *
 * @param fontData - Type of Font.
 * @return Type of FontProps.
 */
public func getFontProperties(fontData: Font): FontProps {
    var styles: Array<String> = Array<String>()
    if (!fontData.fStyle.isEmpty()) {
        styles = fontData.fStyle.split(" ")
    }

    var fWeight: String = "normal"
    var fStyle: String = "normal"
    let len: Int64 = styles.size
    var styleName: String = ""

    for (i in 0..len) {
        styleName = styles[i].toAsciiLower()
        if (styleName == "italic") {
            fStyle = "italic"
        } else if (styleName == "bold") {
            fWeight = "700"
        } else if (styleName == "black") {
            fWeight = "900"
        } else if (styleName == "medium") {
            fWeight = "500"
        } else if (styleName == "regular" || styleName == "normal") {
            fWeight = "400"
        } else if (styleName == "light" || styleName == "thin") {
            fWeight = "200"
        }
    }

    var fWeightNow: String = fontData.fWeight
    if (fWeightNow.isEmpty()) {
        fWeightNow = fWeight
    }
    return FontProps(fStyle, fWeightNow)
}


