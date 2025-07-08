/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is getFontProperties.
 */
package lottie.utils



public class FontProps {
    public let style: String
    public let weight: String
    public init(style!: String, weight!: String) {
        this.style = style
        this.weight = weight
    }
}

public func getFontProperties(fontData: LottieFont): FontProps {
    var styles: Array<String> = Array<String>()
    if (!fontData.fStyle.isEmpty()) {
        fontData.fStyle.split(" ")
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
    return FontProps(style: fStyle, weight: fWeightNow)
}
