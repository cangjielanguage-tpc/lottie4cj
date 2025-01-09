/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property

internal import std.collection.*

//data == arr[i].ty === 'sh'/'rc'/'el'/'sr'
public class CvShapeData <: ContentModelElement {

    public var styledShapes: ArrayList<StyledShape>
    public var tr: Array<Int64>
    public var sh: ShapePropertyFactory

    protected static let _value: Int64 = 3
    
    public var _isAnimated: Bool = false

    public prop value: Int64 {
        get() {
            return _value
        }
    }

    public init(elemGlobalData: GlobalData, elemData: Layer, data: ContentModel, styles: ArrayList<StyleElem>, 
        transformsManager: ShapeTransformManager, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ) {
        this.styledShapes = ArrayList<StyledShape>()
        this.tr = [0, 0, 0, 0, 0, 0]
        var ty: Int64 = 4
        if (data.ty == "rc") {
            ty = 5
        } else if (data.ty == "el") {
            ty = 6
        } else if (data.ty == "sr") {
            ty = 7
        }
        this.sh = ShapePropertyFactory.getShapeProp(data, ty, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)

        let len: Int64 = styles.size
        for (i in 0..len) {
            if (!styles[i].closed) {
                let styledShape: StyledShape = StyledShape(transformsManager.addTransformSequence(styles[i].transforms), ArrayList<StyledShapeTrNodes>())
                this.styledShapes.append(styledShape)
                styles[i].elements.append(styledShape)
            }
        }
    }

    public func setAsAnimated() {
        this._isAnimated = true
    }
}

public class StyledShape {
    public var transforms: Sequence
    public var trNodes: ArrayList<StyledShapeTrNodes>

    public init(transforms: Sequence, trNodes: ArrayList<StyledShapeTrNodes>) {
        this.transforms = transforms
        this.trNodes = ArrayList<StyledShapeTrNodes>()
    }
}

public class StyledShapeTrNodes {
    public var t: String
    public var p: Array<Float64>
    public var pts: Array<Float64>

    public init(t: String, p!: Array<Float64> = Array<Float64>(), pts!: Array<Float64> = Array<Float64>()) {
        this.t = t
        this.p = p
        this.pts = pts
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