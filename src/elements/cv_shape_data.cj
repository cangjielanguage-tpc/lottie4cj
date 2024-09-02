/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import std.collection.*
//TODO
public class CvShapeData {

    protected var styledShapes: ArrayList<Object>
    protected var tr: Array<Int64>

    public init(element: BaseElement, data: ShapeDataInCV, styles: ArrayList<StyleElem>, transformsManager: ShapeTransformManager) {
        this.styledShapes = ArrayList<Object>()
        this.tr = Array<Int64>([0, 0, 0, 0, 0, 0])
        var ty: Int64 = 4
        if (data.ty == "rc") {
            ty = 5
        } else if (data.ty == "el") {
            ty = 6
        } else if (data.ty == "sr") {
            ty = 7
        }
        var len = styles.size
        var styledShape:Object
        for (i in 0..len) {

        }
    }
}


public class ShapeDataInCV {
    public var ty: String = ""
    public var fillEnabled: Bool = false
    public var c: ShapeDatac = ShapeDatac()
    public var o: ShapeDatao = ShapeDatao()
    public var nm: String = ""
    public var _shouldRender: Bool = false
    public var it: Array<ShapeDataInCV> = Array<ShapeDataInCV>()
}

public class ShapeDatac {
    public var k: Array<Float64> = Array<Float64>()
}

public class ShapeDatao {
    public var k:Int64 = 0
}