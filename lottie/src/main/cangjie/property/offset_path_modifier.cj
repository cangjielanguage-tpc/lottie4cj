/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property


/* "op", OffsetPathModifier -- 偏移路径修改器 */
public class OffsetPathModifier <: ShapeModifier {

    /* "a": {"a": 0, "k": 0, "ix": 7} => 走【分支1】 */
    var amount: Option<PropertyFactory<AK, Float64>>
    
    var miterLimit: Float64 = 0.0
    
    var lineJoin: Int64 = 0

    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.amount = None
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }

    /* data类型：tm/rd/pb/zz/op / rp /ms */
    public func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer): Unit {

        /*
         * 只在 GradientStroke-"gs"/GradientFill-"gf" 中找到成员变量 a（已新增） -- "a": {"a": 0, "k": 0, "ix": 7} => 走【分支1】
         * 只在 GradientStroke-"gs"/ShapeStroke-"st" 中找到成员变量 ml 和 lj。
         */
        if (data.ty == "gf") {//"a": {"a": 0, "k": 0, "ix": 7} => 走【分支1】
            let gf: GradientFill = (data as GradientFill).getOrThrow()
            /* 传入的 tr.a 必须存在，否则代码运行异常。 */
            this.amount = PropertyFactory<AK, Float64>.getProp(gf.a, Float64(gf.a.k), 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        } else if (data.ty == "gs") {
            let gs: GradientStroke = (data as GradientStroke).getOrThrow()
            this.amount = PropertyFactory<AK, Float64>.getProp(gs.a, Float64(gs.a.k), 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
            this.miterLimit = gs.ml
            this.lineJoin = gs.lj
        } else if (data.ty == "st") {
            let st: ShapeStroke = (data as ShapeStroke).getOrThrow()
            this.miterLimit = st.ml
            this.lineJoin = st.lj
        }

        if (let Some(value) <- amount) {
            value.containerType = 3
            value.container = [this]
            this._isAnimated = value.effectsSequence.size != 0
        }

    }
    
    public func processPath(inputBezier: ShapeData, amount: Float64, lineJoin: Int64, miterLimit: Float64): ShapeData {
        let outputBezier: ShapeData = ShapeData()
        outputBezier.c = inputBezier.c
        var count: Int64 = inputBezier.v.size
        if (!inputBezier.c) {
            count -= 1
        }

        var segment: PolynomialBezier = PolynomialBezier()
        
        var len: Int64 = count
        if (!inputBezier.c) {
            len += count
        }
        var index: Int64 = 0
        var multiSegments: Array<Array<PolynomialBezier>> = Array<Array<PolynomialBezier>>(len, item: Array<PolynomialBezier>())
    
        for (i in 0..count) {
            segment = PolynomialBezier.shapeSegment(inputBezier, i)
            multiSegments[index] = offsetSegmentSplit(segment, amount)
            index++
        }
    
        if (!inputBezier.c) {
            for (i in (count-1)..=0:-1) {
                segment = PolynomialBezier.shapeSegmentInverted(inputBezier, i)
                multiSegments[index] = offsetSegmentSplit(segment, amount)
                index++
            }
        }
    
        multiSegments = pruneIntersections(multiSegments)
    
        /* 将贝塞尔线段添加到输出中并应用线关节 */
        var lastPoint: Array<Float64> = Array<Float64>()
        var lastSeg: PolynomialBezier = PolynomialBezier()
    
        for (i in 0.. multiSegments.size) {
            var multiSegment: Array<PolynomialBezier> = multiSegments[i]
    
            if (i != 0) {
                lastPoint = joinLines(outputBezier, lastSeg, multiSegment[0], lineJoin, miterLimit)
            }
    
            lastSeg = multiSegment[multiSegment.size - 1]
    
            for (j in 0 .. multiSegment.size) {
                segment = multiSegment[j]
    
                if (lastPoint.size > 0 && pointEqual(segment.points[0], lastPoint)) {
                    outputBezier.setXYAt(segment.points[1][0], segment.points[1][1], "o", outputBezier.length() - 1)
                } else {
                    outputBezier.setTripleAt(
                        segment.points[0][0],
                        segment.points[0][1],
                        segment.points[1][0],
                        segment.points[1][1],
                        segment.points[0][0],
                        segment.points[0][1],
                        outputBezier.length()
                    )
                }

                outputBezier.setTripleAt(
                    segment.points[3][0],
                    segment.points[3][1],
                    segment.points[3][0],
                    segment.points[3][1],
                    segment.points[2][0],
                    segment.points[2][1],
                    outputBezier.length()
                )
    
                lastPoint = segment.points[3]
            }
        }
    
        if (multiSegments.size > 0) {
            joinLines(outputBezier, lastSeg, multiSegments[0][0], lineJoin, miterLimit)
        }
    
        return outputBezier
    }
    
    public func processShapes(_isFirstFrame: Bool): Bool {
        var shapePaths: ArrayList<ShapeData> = ArrayList<ShapeData>()
        let len: Int64 = this.shapes.size
        var jLen: Int64 = 0

        var amount_v: Array<Float64> = if (let Some(value) <- amount) {
            value.v
        } else {
            Array<Float64>()
        }

        var miterLimitv: Float64 = this.miterLimit
        
        var lineJoin: Int64 = this.lineJoin
    
        if (amount_v.size > 0 && amount_v[0] != 0.0) {
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
                        localShapeCollection.addShape(this.processPath(shapePaths[j], amount_v[0], lineJoin, miterLimitv))
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
