/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.property

func default_Bool_to_Unit(flag: Bool): Unit {}

public open class ShapeModifier <: DynamicPropertyContainer {
    //TODO：拆分多继承问题 -- extendPrototype([DynamicPropertyContainer], ShapeModifier)
    
    //TODO: 暂未确定数据类型，自定义数据类型 ShapeDataShapeModifiers。
    var shapes: ArrayList<ShapeDataShapeModifiers> = ArrayList<ShapeDataShapeModifiers>()
    var frameId: Int64 = initialDefaultFrame
    var closed: Bool = false
    var k: Bool = false

    // 只在 CVShapeElement/SVGShapeElement 中调用， elem = CVShapeElement/SVGShapeElement，data = ContentModel
    // data类型：tm/rd/pb/zz/op / rp /ms
    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer) {
        super(elemGlobalData, elemData)
    }

    public static func initShapeModifier(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): ShapeModifier {
        let sm: ShapeModifier = ShapeModifier(data, elemGlobalData, elemData)
        //直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        sm.initDynamicPropertyContainer(elemGlobalData, elemData)
        //直接调用的 DynamicPropertyContainer.initModifierProperties。
        sm.initModifierProperties(data, elemGlobalData, elemData)

        //调用父类 DynamicPropertyContainer.dynamicProperties
        if (sm.dynamicProperties.size > 0) {
            sm.k = true
        } else {
            sm.getValue(true)
        }
        return sm
    }

    public open func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): Unit {}
    
    public open func addShapeToModifier(shapeData: ShapeDataShapeModifiers): Unit {}
    
    // data => CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来
    public func addShape(data: BaseShapeData): Unit {
        if (!this.closed) {
            //为动态特性添加形状。它涵盖了形状没有应用效果的情况，在每个滴答声中重置其_mdf状态。
            //TODO: 暂未确认 addDynamicProperty 调用的是 BaseElement 哪一级的？？？  //data.sh.container.addDynamicProperty(data.sh)
            //将 shapeCollectionPool.newShapeCollection() 改为 ShapeCollection()
            var shapeData: ShapeDataShapeModifiers = ShapeDataShapeModifiers(shape: data.sh, data: data, localShapeCollection: ShapeCollection())
            this.shapes.append(shapeData)
            this.addShapeToModifier(shapeData)
            //TODO：调用父类 DynamicPropertyContainer._isAnimated
            if (this._isAnimated) {
                //data => CVShapeData/SVGShapeData
                //TODO: 未实现CVShapeData/SVGShapeData.setAsAnimated()
                data.setAsAnimated()
            }
        }
    }

    public open func processKeys(): Unit {
        if (this.elemGlobalData.frameId == this.frameId) {
            return
        }
        this.frameId = this.elemGlobalData.frameId
        //调用父类 DynamicPropertyContainer.iterateDynamicProperties
        this.iterateDynamicProperties()
    }

    //TODO：用于 IShapeElement 编译，isAnimatedWithShape 未找到原函数。
    public open func isAnimatedWithShape(data: Layer): Bool { return true }
    public open func processShapes(flag: Bool): Bool { return true }

}
