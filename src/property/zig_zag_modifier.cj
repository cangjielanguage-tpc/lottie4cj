/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

public open class ZigZagModifier <: ShapeModifier {
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], ZigZagModifier)

    //TODO: 暂定ZigZagModifier 对应 PolystarShape 数据类型。
    var amplitude: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    var frequency: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    var pointsType: PropertyFactory<Array<Keyframe<Float64>>, Float64>

    public init(elem: IShapeElement, data: ContentModel){
        super(elem, data)
        
        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elem)
        this.amplitude = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
        this.frequency = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
        this.pointsType = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }
    
    public func initModifierProperties(elem: IShapeElement, data: ContentModel) {
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        //TODO: 暂定 ZigZagModifier 对应 PolystarShape 数据类型。
        if (data.ty == "sr") {
            let sr: PolystarShape = (data as PolystarShape).getOrThrow()

            //TODO: 暂定 ZigZagModifier 对应 PolystarShape 数据类型。暂未确认 data.s 数据类型。  //this.amplitude = PropertyFactory.getProp(elem, data.s, 0, null, this)
            
            if (sr.r.size == 1) {//走【分支1】
                this.frequency = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, sr.r, sr.r[0].k ?? 0.0, 0.0, this)
            } else if (sr.r.size > 1) {//走【分支3】
                this.frequency = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, sr.r, sr.r, 0, 0.0, this)
            }
            
            if (sr.pt.size == 1) {//走【分支1】
                this.pointsType = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, sr.pt, sr.pt[0].k ?? 0.0, 0.0, this)
            } else if (sr.pt.size > 1) {//走【分支3】
                this.pointsType = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, sr.pt, sr.pt, 0, 0.0, this)
            }
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
    
    public func processShapes(_isFirstFrame: Bool) {
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
    }

}
