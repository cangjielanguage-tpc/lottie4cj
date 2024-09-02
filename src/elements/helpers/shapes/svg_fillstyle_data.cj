/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

import lottie4cj.model.*
//TODO
public class SVGFillStyleData {

    var style: Object
    //elem: SVGShapeElement styleOb: SVGStyleData
    public init(elem: Object, data: Layer,styleOb: Object) {
        this.style = styleOb
    }   

}
