/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.property

public open class ZigZagModifier <: ShapeModifier {
    // 暂定ZigZagModifier 对应 PolystarShape 数据类型。
    var amplitude: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    var frequency: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    var pointsType: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>

    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.amplitude = None
        this.frequency = None
        this.pointsType = None
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }
    
    public func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer) {
        // 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        // 暂定 ZigZagModifier 对应 PolystarShape 数据类型。
        if (data.ty == "sr") {
            let sr: PolystarShape = (data as PolystarShape).getOrThrow()

            // 暂定 ZigZagModifier 对应 PolystarShape 数据类型。暂未确认 data.s 数据类型。  //this.amplitude = PropertyFactory.getProp(elem, data.s, 0, null, this)
            
            if (sr.r.k.size == 1) {//走【分支1】
                this.frequency = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.r, sr.r.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            } else if (sr.r.k.size > 1) {//走【分支3】
                this.frequency = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.r, sr.r.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            }

            if (let Some(value) <- frequency) {
            	value.containerType = 3
                value.container = [this]
            }

            if (sr.pt.k.size == 1) {//走【分支1】
                this.pointsType = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.pt, sr.pt.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            } else if (sr.pt.k.size > 1) {//走【分支3】
                this.pointsType = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(sr.pt, sr.pt.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            }

            if (let Some(value) <- pointsType) {
            	value.containerType = 3
                value.container = [this]
            }

        }
        this._isAnimated = (if (let Some(value) <- amplitude) {
            value.effectsSequence.size != 0
        } else {
        	false
        }) || (if (let Some(value) <- frequency) {
            value.effectsSequence.size != 0
        } else {
        	false
        }) || (if (let Some(value) <- pointsType) {
            value.effectsSequence.size != 0
        } else {
        	false
        })
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

        var amplitude_v: Array<Float64> = if (let Some(value) <- amplitude) {
            value.v
        } else {
        	Array<Float64>()
        }

        var frequency_v: Float64 = max(0.0, round(if (let Some(value) <- frequency) {
            value.v[0]
        } else {
        	0.0
        }))

        var pointType_v: Array<Float64> = if (let Some(value) <- pointsType) {
            value.v
        } else {
        	Array<Float64>()
        }

//        var amplitude_v: Array<Float64> = this.amplitude.v
        
//        let frequency_v: Float64 = max(0.0, round(this.frequency.v[0]))
        
//        var pointType_v: Array<Float64> = this.pointsType.v
    
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
        return false
    }

}
