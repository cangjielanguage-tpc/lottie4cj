/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
//package lottie.utils.shapes
package lottie.property

func default_Bool_to_Unit(flag: Bool): Unit {}

public open class ShapeModifier <: DynamicPropertyContainer {

    //TODO：拆分多继承问题 -- extendPrototype([DynamicPropertyContainer], ShapeModifier)
    
    //TODO: 暂未确定数据类型，自定义数据类型 ShapeDataShapeModifiers。
    var shapes: ArrayList<ShapeDataShapeModifiers> = ArrayList<ShapeDataShapeModifiers>()
    var frameId: Int64 = initialDefaultFrame
    public var closed: Bool = false
    var k: Bool = false
    
    //var elem: IShapeElement
    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    //在父类DynamicPropertyContainer中有elemGlobalData  //var elemGlobalData: GlobalData = GlobalData()
    //在父类DynamicPropertyContainer中有elemData        //var elemData: Layer = Layer()
    
    // 只在 CvShapeElement/SVGShapeElement 中调用， elem = CvShapeElement/SVGShapeElement，data = ContentModel
    // data类型：tm/rd/pb/zz/op / rp /ms
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
        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        sm.initDynamicPropertyContainer(elemGlobalData, elemData)
        //TODO: 直接调用的 DynamicPropertyContainer.initModifierProperties。
        sm.initModifierProperties(data, elemGlobalData, elemData)

        //TODO：调用父类 DynamicPropertyContainer.dynamicProperties
        if (sm.dynamicProperties.size > 0) {
            sm.k = true
        } else {
            sm.getValue(true)
        }
        return sm
    }

    public open func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): Unit {}

    public open func addShapeToModifier(shapeData: ShapeDataShapeModifiers): Unit {}

    //数据来源分析：data => CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来--【都继承于 ContentModelElement】
    //TODO: 暂时都是canvas渲染，直接用 CvShapeData，暂时不抽象父类。
    public func addShape(data: CvShapeData): Unit {
        if (!this.closed) {
            //为动态特性添加形状。它涵盖了形状没有应用效果的情况，在每个滴答声中重置其_mdf状态。
            //TODO: 暂未确认 addDynamicProperty 调用的是 BaseElement 哪一级的？？？
            data.sh.addDynamicProperty(data.sh)
            //将 shapeCollectionPool.newShapeCollection() 改为 ShapeCollection()
            var shapeData: ShapeDataShapeModifiers = ShapeDataShapeModifiers(shape: data.sh, data: data, localShapeCollection: ShapeCollection())
            this.shapes.append(shapeData)
            this.addShapeToModifier(shapeData)
            //TODO：调用父类 DynamicPropertyContainer._isAnimated
            if (this._isAnimated) {
                //数据来源分析：data => CVShapeData/SVGShapeData
                data.setAsAnimated()
            }
        }
    }

    public open func processKeys(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        //TODO：调用父类 DynamicPropertyContainer.iterateDynamicProperties
        this.iterateDynamicProperties()
    }

    //TODO：用于 IShapeElement 编译，isAnimatedWithShape 未找到原函数。
    public open func isAnimatedWithShape(data: Layer): Bool { return true }
    public open func processShapes(flag: Bool): Bool { return false }

}
