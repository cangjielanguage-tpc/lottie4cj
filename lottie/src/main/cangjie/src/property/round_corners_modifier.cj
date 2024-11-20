/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */


package lottie.property

public class RoundCornersModifier <: ShapeModifier {
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], RoundCornersModifier)

    public var rd: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    
    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        
//        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
//        this.rd = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.rd = None
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }

    public func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): Unit {
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        if (data.ty == "rd") {
            let rc: RoundedCorners = (data as RoundedCorners).getOrThrow()
            
            //"r": {"a": 0, "k": 10, "ix": 1}  //_r: Array<Keyframe<Float64>>
            if (rc.r.k.size == 1) {//走【分支1】
                this.rd = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rc.r, rc.r.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
            } else if (rc.r.k.size > 1) {//走【分支3】
                this.rd = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rc.r, rc.r.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
            }

            if (let Some(value) <- rd) {
                value.containerType = 3
                value.container = [this]
                this._isAnimated = value.effectsSequence.size != 0
            }
//            this.rd.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
//            this.rd.container = [this]
        }
//        this._isAnimated = this.rd.effectsSequence.size != 0
    }

    public func processPath(path: ShapeData, round: Float64): ShapeData {
        var clonedPath: ShapeData = ShapeData()  //shapePool.newElement()
        
        clonedPath.c = path.c
        var len: Int64 = path._length
        var currentV: PointF = PointF()
        var currentI: PointF = PointF()
        var currentO: PointF = PointF()
        var closerV: PointF = PointF()
        var distance: Float64 = 0.0
        var newPosPerc: Float64 = 0.0
        var index: Int64 = 0
        var vX: Float64 = 0.0
        var vY: Float64 = 0.0
        var oX: Float64 = 0.0
        var oY: Float64 = 0.0
        var iX: Float64 = 0.0
        var iY: Float64 = 0.0
        for (i in 0..len) {
            currentV = path.v[i]
            currentO = path.o[i]
            currentI = path.i[i]
            if (currentV.x == currentO.x && currentV.y == currentO.y && currentV.x == currentI.x && currentV.y == currentI.y) {
                if ((i == 0 || i == len - 1) && !path.c) {
                    clonedPath.setTripleAt(currentV.x, currentV.y, currentO.x, currentO.y, currentI.x, currentI.y, index)

                    index += 1
                } else {
                    if (i == 0) {
                        closerV = path.v[len - 1]
                    } else {
                        closerV = path.v[i - 1]
                    }
                    distance = sqrt(pow(currentV.x - closerV.x, 2.0) + pow(currentV.y - closerV.y, 2.0))

                    newPosPerc = 0.0
                    if (distance != 0.0) {
                        newPosPerc = min(distance / 2.0, round) / distance
                    }
                    
                    iX = currentV.x + (closerV.x - currentV.x) * newPosPerc
                    vX = iX
                    iY = currentV.y - (currentV.y - closerV.y) * newPosPerc
                    vY = iY
                    oX = vX - (vX - currentV.x) * roundCorner
                    oY = vY - (vY - currentV.y) * roundCorner
                    clonedPath.setTripleAt(vX, vY, oX, oY, iX, iY, index)
                    index += 1
    
                    if (i == len - 1) {
                      closerV = path.v[0]
                    } else {
                      closerV = path.v[i + 1]
                    }
                    distance = sqrt(pow(currentV.x - closerV.x, 2.0) + pow(currentV.y - closerV.y, 2.0))

                    newPosPerc = 0.0
                    if (distance != 0.0) {
                        newPosPerc = min(distance / 2.0, round) / distance
                    }
                    
                    oX = currentV.x + (closerV.x - currentV.x) * newPosPerc
                    vX = oX
                    oY = currentV.y + (closerV.y - currentV.y) * newPosPerc
                    vY = oY
                    iX = vX - (vX - currentV.x) * roundCorner
                    iY = vY - (vY - currentV.y) * roundCorner

                    clonedPath.setTripleAt(vX, vY, oX, oY, iX, iY, index)
                    index += 1
                }
            } else {
                clonedPath.setTripleAt(path.v[i].x, path.v[i].y, path.o[i].x, path.o[i].y, path.i[i].x, path.i[i].y, index)
                index += 1
            }
        }
        return clonedPath
    }
    
    public func processShapes(_isFirstFrame: Bool): Bool {
        var shapePaths: ArrayList<ShapeData> = ArrayList<ShapeData>()
        let len: Int64 = this.shapes.size
        var jLen: Int64 = 0
//        var rd_v: Array<Float64> = this.rd.v
        var rd_v: Array<Float64> = if (let Some(value) <- rd) {
                value.v
            } else {
            	Array<Float64>()
            }
        if (rd_v.size > 0 && rd_v[0] != 0.0) {
            var localShapeCollection: ShapeCollection = ShapeCollection()
            for (i in 0..len) {
                var shapeData: ShapeDataShapeModifiers = this.shapes[i]
                localShapeCollection = shapeData.localShapeCollection
                if (!(!shapeData.shape._mdf && !this._mdf && !_isFirstFrame)) {
                    localShapeCollection.releaseShapes()
                    shapeData.shape._mdf = true
                    shapePaths = shapeData.shape.paths.shapes
                    jLen = shapeData.shape.paths._length
                    for (j in 0..jLen) {
                        localShapeCollection.addShape(this.processPath(shapePaths[j], rd_v[0]))
                    }
                }
                shapeData.shape.paths = shapeData.localShapeCollection
            }
        }
        if (this.dynamicProperties.size == 0) {
            this._mdf = false
        }
        return false
    }

}
