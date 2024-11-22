/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property

func default_Bool_to_Unit(flag: Bool): Unit {}

public open class ShapeModifier <: DynamicPropertyContainer {

    var shapes: ArrayList<ShapeDataShapeModifiers> = ArrayList<ShapeDataShapeModifiers>()
    var frameId: Int64 = initialDefaultFrame
    public var closed: Bool = false
    var k: Bool = false

    /*
     * 只在 CvShapeElement/SVGShapeElement 中调用， elem = CvShapeElement/SVGShapeElement，data = ContentModel
     * data类型：tm/rd/pb/zz/op / rp /ms
     */
    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.compType = compType
        this.compDataInd = compDataInd
        this.getRenderedFrame = renderedFrame
    }
    public static func initShapeModifier(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ): ShapeModifier {
        var sm: ShapeModifier
        if(data.ty == "tm") {
            sm = TrimModifier(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        } else {
        	sm = ShapeModifier(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        }

        sm.initDynamicPropertyContainer(elemGlobalData, elemData)
        sm.initModifierProperties(data, elemGlobalData, elemData)

        if (sm.dynamicProperties.size > 0) {
            sm.k = true
        } else {
            sm.getValue(true)
        }
        return sm
    }

    public open func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): Unit {}

    public open func addShapeToModifier(shapeData: ShapeDataShapeModifiers): Unit {}

    /* 数据来源分析：data => CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来--【都继承于 ContentModelElement】 */
    public func addShape(data: CvShapeData): Unit {
        if (!this.closed) {
            /* 为动态特性添加形状。它涵盖了形状没有应用效果的情况，在每个滴答声中重置其_mdf状态。 */
            data.sh.addDynamicProperty(data.sh)
            var shapeData: ShapeDataShapeModifiers = ShapeDataShapeModifiers(shape: data.sh, data: data, localShapeCollection: ShapeCollection())
            this.shapes.append(shapeData)
            this.addShapeToModifier(shapeData)
            if (this._isAnimated) {
                /* 数据来源分析：data => CVShapeData/SVGShapeData */
                data.setAsAnimated()
            }
        }
    }

    public open func processKeys(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        this.iterateDynamicProperties()
    }

    public open func isAnimatedWithShape(data: Layer): Bool { return true }
    public open func processShapes(flag: Bool): Bool { return false }

}
