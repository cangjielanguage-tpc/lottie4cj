/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property

public open class ShapeDataShapeModifiers {

    //数据类型是多种Property：KeyframedShapeProperty/ShapeProperty/RectShapeProperty/EllShapeProperty/StarShapeProperty
    var shape: ShapePropertyFactory  //shape: data.sh

    var data: CvShapeData
    
    var localShapeCollection: ShapeCollection = ShapeCollection()
    
    public var pathsData: Array<SegmentsLengthElement> = Array<SegmentsLengthElement>()
    
    public var totalShapeLength: Float64 = 0.0

    public init(shape!: ShapePropertyFactory, data!: CvShapeData, localShapeCollection!: ShapeCollection = ShapeCollection()){
        this.shape = shape
        this.data = data
        this.localShapeCollection = localShapeCollection
    }

}
