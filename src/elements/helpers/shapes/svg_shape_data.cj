/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

import std.collection.*
//TODO
public class SVGShapeData {
    public var caches: ArrayList<Object>
    public var styles: ArrayList<SVGStyleData>
    public var transformers: ArrayList<ElementData>
    public var lStr: String
    public var _isAnimated: Bool = false
    public var lvl: Int64

    //ShapePropertyFactory.getShapePro-->shape
    public init(transformers: ArrayList<ElementData>, level: Int64, shape: Object) {
        this.caches = ArrayList<Object>()
        this.styles = ArrayList<SVGStyleData>()
        this.transformers = transformers
        this.lStr = ""
        this.lvl = level
        // TODO: commenting this for now since all shapes are animated
        var i = 0
        var len = transformers.size
        while (i < len) {
            if (transformers[i].cst.size != 0) {
                this._isAnimated = true
                break
            }
            i += 1
        }
    }

    public func setAsAnimated() {
        this._isAnimated = true
    }
}