/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils


public func styleDiv(element: CreateTag): Unit {
    element.style.position = 'absolute';
    element.style.top = 0;
    element.style.left = 0;
    element.style.display = 'block';
    element.style.transformOrigin = '0 0';
    element.style.webkitTransformOrigin = '0 0';
    element.style.backfaceVisibility = 'visible';
    element.style.webkitBackfaceVisibility = 'visible';
    element.style.transformStyle = 'preserve-3d';
    element.style.webkitTransformStyle = 'preserve-3d';
    element.style.mozTransformStyle = 'preserve-3d';
}
public func rgbToHex(rs: Float64, gs: Float64, bs: Float64): String {
    var r: Int64 = Int64(rs)
    var g: Int64 = Int64(gs)   
    var b: Int64 = Int64(bs)
    var colorMap = HashMap<Int64,String>()
    var hex: String = ""
    for (i in 0..256) {
        hex = i.format("#16x").trimAscii().removePrefix("0x")
        if (hex.size == 1) {
            colorMap.put(i,"0" + hex)
        } else {
            colorMap.put(i, hex)
        }
    }
    if (r < 0) {
      r = 0
    }
    if (g < 0) {
      g = 0
    }
    if (b < 0) {
      b = 0
    }
    return "#" + colorMap[r] + colorMap[g] + colorMap[b];
}