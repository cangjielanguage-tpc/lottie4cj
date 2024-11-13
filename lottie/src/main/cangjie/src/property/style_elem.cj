/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a ShapeFill structure.
 */
//package lottie.shape_items
package lottie.property

internal import ohos.base.Color
internal import ohos.component.CanvasGradient


//(arr[i].ty === 'fl'/'st'/'gf'/'gs')
public class StyleElem {
    protected var data: ContentModel
    protected var types: String
    protected var preTransforms: Sequence
    protected var transforms: ArrayList<AnimatableTransformElement>
    public var elements: ArrayList<StyledShape>
    protected var closed: Bool

    //protected var co: String = ""
    //UI组件中： Color(red: UInt8, green: UInt8, blue: UInt8, alpha!: Float32 = 1.0)
    public var co: Color = Color(0, 0, 0, alpha: 1.0)
    //CVShapeElement.drawLayer 中编译用
    public var grd: Option<CanvasGradient> = None
    public var hasgrd: Bool = false

    protected var fl: String = ""
    protected var wi: Float64 = 0.0
    protected var coOp: Float64 = 0.0
    protected var r: String = ""
    protected var da: Array<Float64> = empty_Array_Float64
    public var dos: Float64 = 0.0
    public var ml: Float64 = 0.0
    public var lc: String = ""
    public var lj: String = ""
    
    public var isNull: Bool = false

    public init(data!: ContentModel = ContentModel(), types!: String = "", preTransforms!: Sequence = Sequence(), 
                transforms!: ArrayList<AnimatableTransformElement> = ArrayList<AnimatableTransformElement>(),
                elements!: ArrayList<StyledShape> = ArrayList<StyledShape>(), closed!: Bool = false, isNull!: Bool = false
    ) {
        this.data = data
        this.types = types
        this.preTransforms = preTransforms
        this.transforms = transforms
        this.elements = elements
        this.closed = closed
        this.isNull = isNull
    }
}

//已完成：
//(arr[i].ty === 'fl'/'st'/'gf'/'gs') -- FillStrokeElement
//(arr[i].ty === 'gr')  -- ShapeGroupElement
//(arr[i].ty === 'tr')  -- AnimatableTransformElement
//(arr[i].ty === 'sh'/'rc'/'el'/'sr') -- CVShapeData
//(arr[i].ty === 'tm'/'rd'/'pb'/'zz'/'op')-- ShapeModifiers.getModifier--【ShapeModifier子类】
//(arr[i].ty === 'rp')--RepeaterModifier--【ShapeModifier子类】

