/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

internal import lottie.model.*

var blendModeEnums: HashMap<Int64, String> = HashMap<Int64, String>([
    (0, "source-over"),
    (1, "multiply"),
    (2, "screen"),
    (3, "overlay"),
    (4, "darken"),
    (5, "lighten"),
    (6, "color-dodge"),
    (7, "color-burn"),
    (8, "hard-light"),
    (9, "soft-light"),
    (10, "difference"),
    (11, "exclusion"),
    (12, "hue"),
    (13, "saturation"),
    (14, "color"),
    (15, "luminosity")
])

func getBlendMode(mode: Int64): String {
    if (blendModeEnums.contains(mode)) {
        return blendModeEnums[mode]
    }else {
        ""
    }
}

public class Data {

    public var masksProperties: ?ArrayList<Mask> = None

    public var shapes: ArrayList<Object> = ArrayList<Object>()

    public var tt: Int64 = 0

    public  var bm: Int64 = 0

    public var td: Int64 = 0

    public var hd: Bool = false

    public  var ty: Int64 = 0

    public var layers: ArrayList<Object> = ArrayList<Object>()
}


