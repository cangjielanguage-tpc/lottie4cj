/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.property

public open class TrimModifier <: ShapeModifier {
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], TrimModifier)

    var s: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    var e: PropertyFactory<Array<Keyframe<Float64>>, Float64>
    var o: PropertyFactory<Array<Keyframe<Float64>>, Float64>

    var sValue: Float64 = 0.0
    var eValue: Float64 = 0.0
    var m: Int64 = 0

    public init(elem: IShapeElement, data: ContentModel){
        super(elem, data)
        
        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elem)
        this.s = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
        this.e = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
        this.o = PropertyFactory<Array<Keyframe<Float64>>, Float64>(elem, Array<Keyframe<Float64>>(), 0.0, dp)
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }

    public func initModifierProperties(elem: IShapeElement, data: ContentModel) {
        if (data.ty == "tm") {
            let tm: ShapeTrimPath = (data as ShapeTrimPath).getOrThrow()

            //"s": {"a": 0, "k": 0, "ix": 1}  //_s: Array<Keyframe<Float64>>
            if (tm.s.size == 1) {//走【分支1】
                this.s = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.s, tm.s[0].k ?? 0.0, 0.01, this)
            } else if (tm.s.size > 1) {//走【分支3】
                this.s = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.s, tm.s, 0, 0.01, this)
            }

            //"e":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":37,"s":[0],"e":[100]},{"t":58.0000023623884}],"ix":2}
            if (tm.e.size == 1) {//走【分支1】  //_e: Array<Keyframe<Float64>>
                this.e = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.e, tm.e[0].k ?? 0.0, 0.01, this)
            } else if (tm.e.size > 1) {//走【分支3】
                this.e = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.e, tm.e, 0, 0.01, this)
            }

            //"o":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":37,"s":[18],"e":[0]},{"t":58.0000023623884}],"ix":3}
            if (tm.o.size == 1) {//走【分支1】   //_o: Array<Keyframe<Float64>>
                this.o = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.o, tm.o[0].k ?? 0.0, 0.0, this)
            } else if (tm.o.size > 1) {//走【分支3】
                this.o = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(elem, tm.o, tm.o, 0, 0.0, this)
            }
            
            this.m = tm.m
        }

        this.sValue = 0.0
        this.eValue = 0.0
        
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        this._isAnimated = this.s.effectsSequence.size != 0 || this.e.effectsSequence.size != 0 || this.o.effectsSequence.size != 0
    }
    
    public func addShapeToModifier(shapeData: ShapeDataShapeModifiers): Unit {
        //TODO: ShapeDataShapeModifiers 暂未找到成员变量 pathsData，需确认参数类型。
        shapeData.pathsData = Array<SegmentsLengthElement>()
    }
    
    public func calculateShapeEdges(s: Float64, e: Float64, shapeLength: Float64, addedLength: Float64, totalModifierLength: Float64): Array<Array<Float64>> {
        var segments: Array<Array<Float64>> = Array<Array<Float64>>(2, repeat: Array<Float64>())
        var len: Int64 = 0
        if (e <= 1.0) {
            //TODO: [注意]-直接用 Array<Int64> 代替 [s: s, e: e]，s 代表下标 0，e 代表下标 1。  //segments.push([s: s, e: e])
            segments[0] = [s, e]
            len = 1
        } else if (s >= 1.0) {
            segments[0] = [s - 1.0, e - 1.0]
            len = 1
        } else {
            segments[0] = [s, 1.0]
            segments[1] = [0.0, e - 1.0]
            len = 2
        }
        var index: Int64 = 0
        let shapeSegments: Array<Array<Float64>> = Array<Array<Float64>>(2, repeat: Array<Float64>())

        var segmentOb: Array<Float64> = Array<Float64>()
        for (i in 0..len) {
            segmentOb = segments[i]
            //TODO: [注意]-直接用 Array<Int64> 代替 [s: s, e: e]，s 代表下标 0，e 代表下标 1。
            let addedLengthFloat64: Float64 = Float64(addedLength)
            if (!(segmentOb[1] * totalModifierLength < addedLength || segmentOb[0] * totalModifierLength > addedLength + shapeLength)) {
                var shapeS: Float64 = 0.0
                var shapeE: Float64 = 0.0
                if (segmentOb[0] * totalModifierLength <= addedLength) {
                    shapeS = 0.0
                } else {
                    shapeS = (segmentOb[0] * totalModifierLength - addedLength) / shapeLength
                }
                if (segmentOb[1] * totalModifierLength >= addedLength + shapeLength) {
                    shapeE = 1.0
                } else {
                    shapeE = ((segmentOb[1] * totalModifierLength - addedLength) / shapeLength)
                }
                shapeSegments[index] = [shapeS, shapeE]
                index++
            }
        }
        if (index == 0) {
            shapeSegments[0] = [0.0, 0.0]
            index++
        }
        if (index == 1) {
            return [shapeSegments[0]]
        }
        return shapeSegments
    }
    
    // 数据类型分析推测：pathsData  =>  [segmentsLengthPool.newElement(), ......]
    //TODO: 未确认 pathsData 数据类型，暂定为 SegmentsLengthElement。
    public func releasePathsData(pathsData: Array<SegmentsLengthElement>): Array<SegmentsLengthElement> {
        //TODO: pathsData.length ??? length 是成员变量。
        let len: Int64 = pathsData.size
        for (i in 0..len) {
            segmentsLengthPool.release(pathsData[i])
        }
        //TODO: 没有办法清空 clean 参数数组，只能返回值为空，在调用处做赋值为空处理。  //pathsData.length = 0
        return Array<SegmentsLengthElement>()
    }
    
    public func processShapes(_isFirstFrame: Bool): Unit {
        var s_v: Float64 = 0.0
        var e_v: Float64 = 0.0
        if (this._mdf || _isFirstFrame) {
            var o_v: Float64 = Float64(Int64(this.o.v[0]) % 360) / 360.0
            if (o_v < 0.0) {
                o_v += 1.0
            }
            if (this.s.v[0] > 1.0) {
                s_v = 1.0 + o_v
            } else if (this.s.v[0] < 0.0) {
                s_v = 0.0 + o_v
            } else {
                s_v = this.s.v[0] + o_v
            }
            if (this.e.v[0] > 1.0) {
                e_v = 1.0 + o_v
            } else if (this.e.v[0] < 0.0) {
                e_v = 0.0 + o_v
            } else {
                e_v = this.e.v[0] + o_v
            }
    
            if (s_v > e_v) {
                var _s: Float64 = s_v
                s_v = e_v
                e_v = _s
            }
            s_v = round(s_v * 10000.0) * 0.0001
            e_v = round(e_v * 10000.0) * 0.0001
            this.sValue = s_v
            this.eValue = e_v
        } else {
            s_v = this.sValue
            e_v = this.eValue
        }
        var shapePaths: ShapeCollection = ShapeCollection()
        var len: Int64 = this.shapes.size
        var jLen: Int64 = 0
        //TODO: 还需要确认 pathsData 和 pathData 数据类型。
        var pathsData: Array<SegmentsLengthElement> = Array<SegmentsLengthElement>()
        var pathData: SegmentsLengthElement = SegmentsLengthElement()
        
        var totalShapeLength: Int64 = 0
        var totalModifierLength: Int64 = 0
    
        if (e_v == s_v) {
            for (i in 0..len) {
                this.shapes[i].localShapeCollection.releaseShapes()
                this.shapes[i].shape._mdf = true
                this.shapes[i].shape.paths = this.shapes[i].localShapeCollection
                if (this._mdf) {
                    //TODO: ShapeDataShapeModifiers 中新增成员变量 pathsData 数据类型还未确定。
                    //TODO: 手动清除数据。 // this.shapes[i].pathsData.length = 0
                    this.shapes[i].pathsData = Array<SegmentsLengthElement>()
                }
            }
        } else if (!((e_v == 1.0 && s_v == 0.0) || (e_v == 0.0 && s_v == 1.0))) {
            var segments: Array<Array<Float64>> = Array<Array<Float64>>()
            var localShapeCollection: ShapeCollection = ShapeCollection()
            for (i in 0..len) {
                var shapeData: ShapeDataShapeModifiers = this.shapes[i]
                //如果形状没有改变，修剪属性也没有改变，则可以使用缓存的先前路径
                if (!shapeData.shape._mdf && !this._mdf && !_isFirstFrame && this.m != 2) {
                    shapeData.shape.paths = shapeData.localShapeCollection
                } else {
                    shapePaths = shapeData.shape.paths
                    jLen = shapePaths._length
                    totalShapeLength = 0
                    //TODO: ShapeDataShapeModifiers 中新增成员变量 pathsData 数据类型还未确定。
                    if (!shapeData.shape._mdf && shapeData.pathsData.size != 0) {
                        totalShapeLength = shapeData.totalShapeLength
                    } else {
                        //TODO: ShapeDataShapeModifiers 中新增成员变量 pathsData 数据类型还未确定。
                        pathsData = this.releasePathsData(shapeData.pathsData)
                        //TODO: 在函数 releasePathsData 中没有办法清空 clean 参数数组 shapeData.pathsData，只能返回值为空，再赋值为空。
                        shapeData.pathsData = pathsData
                        pathsData = Array<SegmentsLengthElement>(jLen, repeat: SegmentsLengthElement())
                        for (j in 0..jLen) {
                            // 数据类型分析推测：pathData = segmentsLengthPool.newElement()  =>   pathData.lengths[i] = bezierLengthPool.newElement()
                            pathData = Bez.getSegmentsLength(shapePaths.shapes[j])
                            
                            // 数据类型分析推测：pathsData[pathData]  =>  pathsData[segmentsLengthPool.newElement(), ......]
                            pathsData[j] = pathData
                            totalShapeLength += pathData.totalLength
                        }
                        shapeData.totalShapeLength = totalShapeLength
                        shapeData.pathsData = pathsData
                    }
    
                    totalModifierLength += totalShapeLength
                    shapeData.shape._mdf = true
                }
            }
            var shapeS: Float64 = s_v
            var shapeE: Float64 = e_v
            var addedLength: Int64 = 0
            var edges: Array<Array<Float64>> = Array<Array<Float64>>()
            for (i in (len - 1)..=0:-1) {
                var shapeData: ShapeDataShapeModifiers = this.shapes[i]
                if (shapeData.shape._mdf) {
                    localShapeCollection = shapeData.localShapeCollection
                    localShapeCollection.releaseShapes()
                    //如果m===2表示路径是单独修剪的，因此需要找到相对于whoel组的特定形状的边
                    if (this.m == 2 && len > 1) {
                        //TODO: calculateShapeEdges 中传入的参数 s/e 数据类型是 Int64，需要对齐。
                        edges = this.calculateShapeEdges(s_v, e_v, Float64(shapeData.totalShapeLength), Float64(addedLength), Float64(totalModifierLength))
                        addedLength += shapeData.totalShapeLength
                    } else {
                        edges = [[shapeS, shapeE]]
                    }

                    jLen = edges.size
                    for (j in 0..jLen) {
                        shapeS = edges[j][0]
                        shapeE = edges[j][1]

                        segments = Array<Array<Float64>>(2, repeat: Array<Float64>())
                        var segmentsLength: Int64 = 0
                        let shapeData_totalShapeLength: Float64 = Float64(shapeData.totalShapeLength)
                        if (shapeE <= 1.0) {
                            //TODO: [注意]-直接用 Array<Int64> 代替 [s: s, e: e]，s 代表下标 0，e 代表下标 1。
                            segments[0] = [shapeData_totalShapeLength * shapeS, shapeData_totalShapeLength * shapeE]
                            segmentsLength = 1
                        } else if (shapeS >= 1.0) {
                            segments[0] = [shapeData_totalShapeLength * (shapeS - 1.0), shapeData_totalShapeLength * (shapeE - 1.0)]
                            segmentsLength = 1
                        } else {
                            segments[0] = [shapeData_totalShapeLength * shapeS, shapeData_totalShapeLength]
                            segments[1] = [0.0, shapeData_totalShapeLength * (shapeE - 1.0)]
                            segmentsLength = 2
                        }
                        var newShapesData: ArrayList<ShapeData> = this.addShapes(shapeData, segments[0], ShapeData())
                        if (segments[0][0] != segments[0][1]) {
                            if (segments.size > 1) {
                                var lastShapeInCollection = shapeData.shape.paths.shapes[shapeData.shape.paths._length - 1]
                                if (lastShapeInCollection.c) {
                                    //pop() 方法用于删除数组的最后一个元素并返回删除的元素。
                                    var lastShape: ShapeData = newShapesData.remove(newShapesData.size - 1)
                                    this.addPaths(newShapesData, localShapeCollection)
                                    newShapesData = this.addShapes(shapeData, segments[1], lastShape)
                                } else {
                                    this.addPaths(newShapesData, localShapeCollection)
                                    newShapesData = this.addShapes(shapeData, segments[1], ShapeData())
                                }
                            }
                            this.addPaths(newShapesData, localShapeCollection)
                        }
                    }
                    shapeData.shape.paths = localShapeCollection
                }
            }
        } else if (this._mdf) {
            for (i in 0..len) {
                //如果形状在其间被修改，则当没有应用修剪时，重新调整修剪缓存路径数据。
                //即使它丢失了缓存信息，也不要删除它。  //this.shapes[i].pathsData.length = 0
                this.shapes[i].pathsData = Array<SegmentsLengthElement>()
                this.shapes[i].shape._mdf = true
            }
        }
    }
    
    public func addPaths(newPaths: ArrayList<ShapeData>, localShapeCollection: ShapeCollection): Unit {
        var len: Int64 = newPaths.size
        for (i in 0..len) {
            localShapeCollection.addShape(newPaths[i])
        }
    }

    public func addSegment(pt1: PointF, pt2: PointF, pt3: PointF, pt4: PointF, shapePath: ShapeData, pos: Int64, newShape: Bool): Unit {
        return addSegment([pt1.x, pt1.y], [pt2.x, pt2.y], [pt3.x, pt3.y], [pt4.x, pt4.y], shapePath, pos, newShape)
    }
    public func addSegment(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>, pt4: Array<Float64>, shapePath: ShapeData, pos: Int64, newShape: Bool): Unit {
        if (pt2.size < 2 || pt3.size < 2 || pt4.size < 2) {
            throw IndexOutOfBoundsException("[addSegment]: pt2.size = ${pt2.size}, pt3.size = ${pt3.size}, pt4.size = ${pt4.size}")
        }
        shapePath.setXYAt(pt2[0], pt2[1], "o", pos)
        shapePath.setXYAt(pt3[0], pt3[1], "i", pos + 1)
        if (newShape) {
            if (pt1.size < 2) {
                throw IndexOutOfBoundsException("[addSegment]: pt1.size = ${pt1.size}")
            }
            shapePath.setXYAt(pt1[0], pt1[1], "v", pos)
        }
        shapePath.setXYAt(pt4[0], pt4[1], "v", pos + 1)
    }
    
    public func addSegmentFromArray(points: Array<Float64>, shapePath: ShapeData, pos: Int64, newShape: Bool): Unit {
        if (points.size < 8) {
            throw IndexOutOfBoundsException("[addSegmentFromArray]: points.size = ${points.size}")
        }
        shapePath.setXYAt(points[1], points[5], "o", pos)
        shapePath.setXYAt(points[2], points[6], "i", pos + 1)
        if (newShape) {
            shapePath.setXYAt(points[0], points[4], "v", pos)
        }
        shapePath.setXYAt(points[3], points[7], "v", pos + 1)
    }

    //TODO: [注意]-直接用 Array<Float64> 代替 [s: s, e: e]，s 代表下标 0，e 代表下标 1。
    public func addShapes(shapeData: ShapeDataShapeModifiers, shapeSegment: Array<Float64>, shapePathOld: ShapeData): ArrayList<ShapeData> {
        var pathsData: Array<SegmentsLengthElement> = shapeData.pathsData
        var shapePaths: ArrayList<ShapeData> = shapeData.shape.paths.shapes

        var len: Int64 = shapeData.shape.paths._length
        var j: Int64 = 0
        var jLen: Int64 = 0
        var addedLength: Float64 = 0.0
        var currentLengthData: BezierLengthElement = BezierLengthElement()
        var segmentCount: Int64 = 0
        var lengths: Array<BezierLengthElement> = Array<BezierLengthElement>()

        var segment: Array<Float64> = Array<Float64>()
        var shapes: ArrayList<ShapeData> = ArrayList<ShapeData>()
        var initPos: Int64 = 0
        var newShape: Bool = true
        
        var shapePath: ShapeData = shapePathOld
        if (shapePath.isNull()) {
            shapePath = ShapeData()  //shapePool.newElement()
            segmentCount = 0
            initPos = 0
        } else {
            segmentCount = shapePath._length
            initPos = shapePath._length
        }
        shapes.append(shapePath)
        for (i in 0..len) {
            lengths = pathsData[i].lengths
            shapePath.c = shapePaths[i].c

            if (shapePaths[i].c) {
                jLen = lengths.size
            } else {
                jLen = lengths.size + 1
            }
            for (j in 1..jLen) {
                currentLengthData = lengths[j - 1]
                if (addedLength + Float64(currentLengthData.addedLength) < shapeSegment[0]) {
                    addedLength += Float64(currentLengthData.addedLength)
                    shapePath.c = false
                } else if (addedLength > shapeSegment[1]) {
                    shapePath.c = false
                    break
                } else {
                    if (shapeSegment[0] <= addedLength && shapeSegment[1] >= addedLength + Float64(currentLengthData.addedLength)) {
                        this.addSegment(shapePaths[i].v[j - 1], shapePaths[i].o[j - 1], shapePaths[i].i[j], shapePaths[i].v[j], shapePath, segmentCount, newShape)
                        newShape = false
                    } else {
                        segment = Bez.getNewSegment(shapePaths[i].v[j - 1], shapePaths[i].v[j], shapePaths[i].o[j - 1], shapePaths[i].i[j], Int64(shapeSegment[0] - addedLength) / currentLengthData.addedLength, Int64(shapeSegment[1] - addedLength) / currentLengthData.addedLength, lengths[j - 1])
                        this.addSegmentFromArray(segment, shapePath, segmentCount, newShape)
                        
                        newShape = false
                        shapePath.c = false
                    }
                    addedLength += Float64(currentLengthData.addedLength)
                    segmentCount += 1
                }
            }
            if (shapePaths[i].c && lengths.size != 0) {
                currentLengthData = lengths[j - 1]
                if (addedLength <= shapeSegment[1]) {
                    var segmentLength: Int64 = lengths[j - 1].addedLength
                    if (shapeSegment[0] <= addedLength && shapeSegment[1] >= addedLength + Float64(segmentLength)) {
                        this.addSegment(shapePaths[i].v[j - 1], shapePaths[i].o[j - 1], shapePaths[i].i[0], shapePaths[i].v[0], shapePath, segmentCount, newShape)
                        newShape = false
                    } else {
                        segment = Bez.getNewSegment(shapePaths[i].v[j - 1], shapePaths[i].v[0], shapePaths[i].o[j - 1], shapePaths[i].i[0], Int64(shapeSegment[0] - addedLength) / segmentLength, Int64(shapeSegment[1] - addedLength) / segmentLength, lengths[j - 1])
                        this.addSegmentFromArray(segment, shapePath, segmentCount, newShape)

                        newShape = false
                        shapePath.c = false
                    }
                } else {
                    shapePath.c = false
                }
                addedLength += Float64(currentLengthData.addedLength)
                segmentCount += 1
            }
            if (shapePath._length != 0) {
                shapePath.setXYAt(shapePath.v[initPos].x, shapePath.v[initPos].y, "i", initPos)
                shapePath.setXYAt(shapePath.v[shapePath._length - 1].x, shapePath.v[shapePath._length - 1].y, "o", shapePath._length - 1)
            }
            if (addedLength > shapeSegment[1]) {
                break
            }
            if (i < len - 1) {
                shapePath = shapePool.newElement()
                shapePath = ShapeData()
                newShape = true
                shapes.append(shapePath)
                segmentCount = 0
            }
        }
        return shapes
    }

}
