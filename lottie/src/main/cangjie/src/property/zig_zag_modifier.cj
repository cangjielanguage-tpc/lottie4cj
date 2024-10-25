/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie.property

public open class ZigZagModifier <: ShapeModifier {
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], ZigZagModifier)

    //TODO: 暂定ZigZagModifier 对应 PolystarShape 数据类型。
    var amplitude: PropertyFactory<ArrayKeyframeFloat64, Float64>
    var frequency: PropertyFactory<ArrayKeyframeFloat64, Float64>
    var pointsType: PropertyFactory<ArrayKeyframeFloat64, Float64>

    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        
        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.amplitude = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.frequency = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.pointsType = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }
    
    public func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer) {
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        //TODO: 暂定 ZigZagModifier 对应 PolystarShape 数据类型。
        if (data.ty == "sr") {
            let sr: PolystarShape = (data as PolystarShape).getOrThrow()

            //TODO: 暂定 ZigZagModifier 对应 PolystarShape 数据类型。暂未确认 data.s 数据类型。  //this.amplitude = PropertyFactory.getProp(elem, data.s, 0, null, this)
            
            if (sr.r.k.size == 1) {//走【分支1】
                this.frequency = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.r, sr.r.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            } else if (sr.r.k.size > 1) {//走【分支3】
                this.frequency = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.r, sr.r.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            }
            this.frequency.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.frequency.container = [this]
            
            if (sr.pt.k.size == 1) {//走【分支1】
                this.pointsType = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.pt, sr.pt.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            } else if (sr.pt.k.size > 1) {//走【分支3】
                this.pointsType = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.pt, sr.pt.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            }
            this.pointsType.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
            this.pointsType.container = [this]
        }

        this._isAnimated = this.amplitude.effectsSequence.size != 0 || this.frequency.effectsSequence.size != 0 || this.pointsType.effectsSequence.size != 0
    }

    public func processPath(path: ShapeData, amplitude: Float64, frequency: Float64, pointType: Float64): ShapeData {
        var count: Int64 = path._length

        var clonedPath: ShapeData = ShapeData()  //shapePool.newElement()
        
        clonedPath.c = path.c
        if (!path.c) {
            count -= 1
        }
    
        if (count == 0) {
            return clonedPath
        }
    
        var direction: Float64 = -1.0

        var segment: PolynomialBezier = PolynomialBezier.shapeSegment(path, 0)
        zigZagCorner(clonedPath, path, 0, amplitude, frequency, pointType, direction)
    
        for (i in 0..count) {
            direction = zigZagSegment(clonedPath, segment, amplitude, Int64(frequency), pointType, -direction)
    
            if (i == count - 1 && !path.c) {
                segment.isNull = true
            } else {
                segment = PolynomialBezier.shapeSegment(path, (i + 1) % count)
            }
            zigZagCorner(clonedPath, path, i + 1, amplitude, frequency, pointType, direction)
        }
    
        return clonedPath
    }
    
    public func processShapes(_isFirstFrame: Bool): Bool {
        var shapePaths: ArrayList<ShapeData> = ArrayList<ShapeData>()
        var len: Int64 = this.shapes.size
        var jLen: Int64 = 0
        
        var amplitude_v: Array<Float64> = this.amplitude.v
        
        let frequency_v: Float64 = max(0.0, round(this.frequency.v[0]))
        
        var pointType_v: Array<Float64> = this.pointsType.v
    
        if (amplitude_v.size > 0 && amplitude_v[0] != 0.0) {

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
                        localShapeCollection.addShape(this.processPath(shapePaths[j], amplitude_v[0], frequency_v, pointType_v[0]))
                    }
                }
                shapeData.shape.paths = shapeData.localShapeCollection
            }
        }
        if (this.dynamicProperties.size == 0) {
            this._mdf = false
        }
        return true
    }

}
