/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

//TODO: 自定义的数据类型是 shapeData，是否需要和 ShapeData 进行关联或者合并？？？
public open class ShapeDataShapeModifiers {

    //数据类型是多种Property：KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
    var shape: ShapePropertyFactory  //shape: data.sh
    
    //TODO: CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来？？？
    var data: BaseShapeData
    
    var localShapeCollection: ShapeCollection = ShapeCollection()
    
    //TODO: 还需要确认pathsData 数据类型。
    public var pathsData: Array<SegmentsLengthElement> = Array<SegmentsLengthElement>()

    public var totalShapeLength: Int64 = 0

    public init(shape!: ShapePropertyFactory, data!: BaseShapeData, localShapeCollection!: ShapeCollection = ShapeCollection()){
        this.shape = shape
        this.data = data
        this.localShapeCollection = localShapeCollection
    }

}

//TODO: 未实现，编译用--CVShapeData/SVGShapeData 抽象一个父类 BaseShapeData 出来？？？
public open class BaseShapeData {

    var sh: ShapePropertyFactory
    
    public init(sh: ShapePropertyFactory){
        this.sh = sh
    }
    
    //TODO: 未实现，编译用
    public func setAsAnimated(): Unit {}
}
