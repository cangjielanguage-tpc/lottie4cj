/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is TextAnimatorProperty.
 */
package lottie.utils.text
//package lottie.property

internal import lottie.bezier.*
internal import lottie.inner.*
internal import lottie.pool.*

internal import lottie.property.*

public class TextAnimatorProperty <: DynamicPropertyContainer {
    //TODO：拆分多继承问题 -- extendPrototype([DynamicPropertyContainer], TextAnimatorProperty)

    var _isFirstFrame: Bool = true
    var _hasMaskedPath: Bool = false
    var _frameId: Int64 = -1

    var _animatorsData: Array<TextAnimatorDataProperty> = Array<TextAnimatorDataProperty>()
    //TODO: 暂时在 json 中找不到 layer.t.p。 this._pathData 是空对象。
    var _pathData: PathData
    var _moreOptions: MoreOptions
    public var renderedLetters: ArrayList<LetterProps> = ArrayList<LetterProps>(24)
    var lettersChangedFlag: Bool = false

    public var mHelper: Matrix = Matrix()
    public var defaultPropsArray: Array<Float64> = Array<Float64>()

    public var _textData: LayerT
    public var _renderType: String
    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    public let elemTextPropertyCurrentData: DocumentData

    public init(textData: LayerT, renderType: String, elemGlobalData: GlobalData, elemData: Layer, elemTextPropertyCurrentData: DocumentData, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this._textData = textData
        this._renderType = renderType

        this.elemTextPropertyCurrentData = elemTextPropertyCurrentData
        //TODO: 初始化放在后面。
        //this._animatorsData = Array<TextAnimatorDataProperty>(this._textData.a.size)

        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        let emptyPF: PropertyFactory<Float64, Float64> = PropertyFactory<Float64, Float64>(0.0, 0.0, dp, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        this._pathData = PathData(
                            a: emptyPF,
                            f: emptyPF,
                            l: emptyPF,
                            r: emptyPF,
                            p: emptyPF,
                            m: ShapePropertyFactory(ContentModel(), 0, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties),
                            pi: PathInfo()
                        )

        this._moreOptions = MoreOptions( alignment: PropertyFactory<LayerTMA, Array<Float64>>(LayerTMA(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties) )

        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        this.initDynamicPropertyContainer(elemGlobalData, elemData)
    }

    public func searchProperties() {
        let len: Int64 = this._textData.a.size
        var animatorProps: AnimatableTextPropertiesA = AnimatableTextPropertiesA()

        this._animatorsData = Array<TextAnimatorDataProperty>(len, item: TextAnimatorDataProperty(animatorProps, this, this.elemGlobalData, this.elemData, this.elemTextPropertyCurrentData, dynamicProperties: this.dynamicProperties))
        for (i in 0..len) {
            //数据类型分析: animatorProps  =>  this._textData.a[i]  =>  layer.t.a[i](AnimatableTextPropertiesA)
            animatorProps = this._textData.a[i]
            this._animatorsData[i] = TextAnimatorDataProperty(animatorProps, this, this.elemGlobalData, this.elemData, this.elemTextPropertyCurrentData, dynamicProperties: this.dynamicProperties)
        }

        //TODO: 暂时在 json 中找不到 layer.t.p。 this._pathData 是空对象。
        this._hasMaskedPath = false
        //if (this._textData.p && 'm' in this._textData.p) {
        //TODO: this._pathData 是空对象。
        //    this._pathData = {
        //      // this._textData.p  =>  layer.t(LayerT).p
        //      a: getProp(this._elem, this._textData.p.a, 0, 0, this),
        //      f: getProp(this._elem, this._textData.p.f, 0, 0, this),
        //      l: getProp(this._elem, this._textData.p.l, 0, 0, this),
        //      r: getProp(this._elem, this._textData.p.r, 0, 0, this),
        //      p: getProp(this._elem, this._textData.p.p, 0, 0, this),
        //      //TODO: this._pathData.m == ShapePropertyFactory
        //      m: this._elem.maskManager.getMaskProperty(this._textData.p.m),
        //    }
        //    this._hasMaskedPath = true
        //} else {
        //    this._hasMaskedPath = false
        //}

        //数据类型分析: this._textData.m.a  =>  layer.t.m.a(LayerTMA)
        //走【分支2】 => "a": {"a": 0, "k": [0, 0]}
        //TODO：需要将 this._textData.m.a.k 的 Array<Int64> 转为 Array<Float64>。
        let lens: Int64 = this._textData.m.a.k.size
        var arr: Array<Float64> = Array<Float64>()
        if (lens > 0) {
            arr = Array<Float64>(lens, item: 0.0)
            let ak: Array<Int64> = this._textData.m.a.k
            for (i in 0..lens) {
                arr[i] = Float64(ak[i])
            }
        }

        this._moreOptions.alignment = PropertyFactory<LayerTMA, Array<Float64>>.getProp(this._textData.m.a, arr, 0.0, this, this.elemGlobalData, this.elemData, dynamicProperties: this.dynamicProperties)
    }

    /*
     * 数据来源分析：this.textProperty.currentData == TextProperty.currentData（DocumentData）
     * 数据来源分析：this.lettersChangedFlag == Bool
     */
    public func getMeasures(documentData: DocumentData, lettersChangedFlag: Bool): Unit {
        this.lettersChangedFlag = lettersChangedFlag
        //TODO: 暂时在 json 中找不到 layer.t.p。 this._pathData 是空对象。
        if (!this._mdf && !this._isFirstFrame && !lettersChangedFlag && (!this._hasMaskedPath || !this._pathData.m._mdf)) {
            return
        }
        this._isFirstFrame = false
        let alignment: Array<Float64> = this._moreOptions.alignment.v
        let animators: Array<TextAnimatorDataProperty> = this._animatorsData
        let textData: LayerT = this._textData
        let matrixHelper: Matrix = this.mHelper
        let renderType: String = this._renderType
        var renderedLettersCount: Int64 = this.renderedLetters.size

        var xPos: Float64 = 0.0
        var yPos: Float64 = 0.0
        var i: Int64 = 0
        var len: Int64 = 0
        let letters: ArrayList<Letter> = documentData.l
        //TODO: PathInfo 是自定义数据类型。
        var pathInfo: PathInfo = PathInfo()
        var currentLength: Float64 = 0.0
        var currentPoint: PointData = PointData()
        var segmentLength: Float64 = 0.0
        var flag: Bool = false
        var pointInd: Int64 = 0
        var segmentInd: Int64 = 0
        var prevPoint: PointData = PointData()
        var points: Array<PointData> = Array<PointData>()
        var segments: ArrayList<BezierData> = ArrayList<BezierData>(24)
        var partialLength: Float64 = 0.0
        var totalLength: Float64 = 0.0
        var perc: Float64 = 0.0
        var tanAngle: Float64 = 0.0
        var mask: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, this.elemGlobalData, this.elemData, dynamicProperties: this.dynamicProperties)
        //TODO: 暂时在 json 中找不到 layer.t.p。 <=  //this._hasMaskedPath = false 
        if (this._hasMaskedPath) {
            mask = this._pathData.m
            if (!this._pathData.n || this._pathData._mdf) {
                var paths: ShapeData = mask.v
                if (this._pathData.r.v.size != 0) {
                    paths = paths.reverse()
                }
                //TODO:释放从前面的 pathInfo 缓存的 bezier 数据：this_pathData.pi
                //TODO: PathInfo 是自定义数据类型。前面已经初始化。
                //pathInfo = PathInfo(
                //    tLength: 0,
                //    segments: []
                //)

                len = paths._length - 1
                var bezierData: BezierData = BezierData()
                totalLength = 0.0
                for (j in 0..len) {
                    bezierData = Bez.buildBezierData(paths.v[j],
                        paths.v[j + 1],
                        [paths.o[j].x - paths.v[j].x, paths.o[j].y - paths.v[j].y],
                        [paths.i[j + 1].x - paths.v[j + 1].x, paths.i[j + 1].y - paths.v[j + 1].y])
                    pathInfo.tLength += bezierData.segmentLength
                    pathInfo.segments.append(bezierData)
                    totalLength += bezierData.segmentLength
                }
                i = len
                if (mask.v.c) {
                    bezierData = Bez.buildBezierData(paths.v[i],
                        paths.v[0],
                        [paths.o[i].x - paths.v[i].x, paths.o[i].y - paths.v[i].y],
                        [paths.i[0].x - paths.v[0].x, paths.i[0].y - paths.v[0].y])
                    pathInfo.tLength += bezierData.segmentLength
                    pathInfo.segments.append(bezierData)
                    totalLength += bezierData.segmentLength
                }
                this._pathData.pi = pathInfo
            }
            pathInfo = this._pathData.pi
    
            currentLength = this._pathData.f.v[0]
            segmentInd = 0
            pointInd = 1
            segmentLength = 0.0
            flag = true
            segments = pathInfo.segments
            if (currentLength < 0.0 && mask.v.c) {
                if (pathInfo.tLength < abs(currentLength)) {
                    currentLength = Float64(Int64(-abs(currentLength)) % Int64(pathInfo.tLength))
                }
                segmentInd = segments.size - 1
                points = segments[segmentInd].points
                pointInd = points.size - 1
                while (currentLength < 0.0) {
                    currentLength += points[pointInd].partialLength
                    pointInd -= 1
                    if (pointInd < 0) {
                        segmentInd -= 1
                        points = segments[segmentInd].points
                        pointInd = points.size - 1
                    }
                }
            }
            points = segments[segmentInd].points
            prevPoint = points[pointInd - 1]
            currentPoint = points[pointInd]
            partialLength = currentPoint.partialLength
        }
    
        len = letters.size
        xPos = 0.0
        yPos = 0.0
        var yOff: Float64 = documentData.finalSize * 1.2 * 0.714
        var firstLine: Bool = true

        var animatorProps: AnimatableTextProperty = animators[0].a

        var animatorSelector: TextSelectorPropFactory = TextSelectorPropFactory(AnimatableTextPropertiesS(), this.elemGlobalData, this.elemData, this.elemTextPropertyCurrentData, dynamicProperties: this.dynamicProperties)

        var letterValue: LetterProps = LetterProps()
    
        let jLen: Int64 = animators.size
    
        //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
        var mult: Float64 = 0.0
        var ind: Int64 = -1
        var offf: Float64 = 0.0
        var xPathPos: Float64 = 0.0
        var yPathPos: Float64 = 0.0
        var initPathPos: Float64 = currentLength
        var initSegmentInd: Int64 = segmentInd
        var initPointInd: Int64 = pointInd
        var currentLine: Int64 = -1
        var elemOpacity: Float64 = 0.0
        var sc: Array<Float64> = Array<Float64>()
        var sw: Float64 = 0.0
        var fc: Array<Float64> = Array<Float64>()

        var letterSw: Int64 = 0
        var letterSc: Color =  Color(0,0,0)
        var letterFc: Color = Color(0,0,0)
        var letterM: String = ""
        var letterP: Array<Float64> = this.defaultPropsArray
        var letterO: Int64 = 0

        if (documentData.j == 2 || documentData.j == 1) {
            var animatorJustifyOffset: Float64 = 0.0
            var animatorFirstCharOffset: Float64 = 0.0

            var justifyOffsetMult: Float64 = -1.0
            if (documentData.j == 2) {
                justifyOffsetMult = -0.5
            }
            var lastIndex: Int64 = 0
            var isNewLine: Bool = true
    
            for (i in 0..len) {
                if (letters[i].n) {
                    if (animatorJustifyOffset != 0.0) {
                        animatorJustifyOffset += animatorFirstCharOffset
                    }
                    while (lastIndex < i) {
                        letters[lastIndex].animatorJustifyOffset = animatorJustifyOffset
                        lastIndex += 1
                    }
                    animatorJustifyOffset = 0.0
                    isNewLine = true
                } else {
                    for (j in 0..jLen) {
                        animatorProps = animators[j].a
                        if (animatorProps.t.propType != "") {
                            if (isNewLine && documentData.j == 2) {
                                animatorFirstCharOffset += animatorProps.t.v[0] * justifyOffsetMult
                            }
                            animatorSelector = animators[j].s
                            //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                            mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                            //if (mult.size != 0) {
                            //    animatorJustifyOffset += animatorProps.t.v[0] * mult[0] * justifyOffsetMult
                            //} else {
                                animatorJustifyOffset += animatorProps.t.v[0] * mult * justifyOffsetMult
                            //}
                        }
                    }
                    isNewLine = false
                }
            }
            if (animatorJustifyOffset != 0.0) {
                animatorJustifyOffset += animatorFirstCharOffset
            }
            while (lastIndex < i) {
                letters[lastIndex].animatorJustifyOffset = animatorJustifyOffset
                lastIndex += 1
            }
        }

        for (i in 0..len) {
            matrixHelper.reset()
            elemOpacity = 1.0
            if (letters[i].n) {
                xPos = 0.0
                yPos += documentData.yOffset

                if (firstLine) {
                    yPos += 1.0
                }
                currentLength = initPathPos
                firstLine = false
                if (this._hasMaskedPath) {
                    segmentInd = initSegmentInd
                    pointInd = initPointInd
                    points = segments[segmentInd].points
                    prevPoint = points[pointInd - 1]
                    currentPoint = points[pointInd]
                    partialLength = currentPoint.partialLength
                    segmentLength = 0.0
                }
                letterM = ""
                letterFc = Color(0,0,0)
                //TODO: letterSw 是 Int64 类型.
                //letterSw = ""
                //TODO: letterSw 是 Int64 类型.
                //letterO = ""
                letterP = this.defaultPropsArray
            } else {
                if (this._hasMaskedPath) {
                    if (currentLine != letters[i].line) {
                        if (documentData.j == 1) {
                            currentLength += totalLength - documentData.lineWidths[letters[i].line]
                        } else if (documentData.j == 2){
                            currentLength += (totalLength - documentData.lineWidths[letters[i].line]) / 2.0
                        }
                        currentLine = letters[i].line
                    }
                    if (ind != letters[i].ind) {
                        if (letters.size > ind) {
                            currentLength += letters[ind].extra
                        }
                        currentLength += letters[i].an / 2.0
                        ind = letters[i].ind
                    }
                    currentLength += (alignment[0] * letters[i].an) * 0.005
                    var animatorOffset: Float64 = 0.0
                    for (j in 0..jLen) {
                        animatorProps = animators[j].a
                        if (animatorProps.p.propType != "") {
                            animatorSelector = animators[j].s
                            //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                            mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                            //if (mult.length) {
                            //    animatorOffset += animatorProps.p.v[0] * mult[0]
                            //} else {
                                animatorOffset += animatorProps.p.v[0] * mult
                            //}
                        }
                        //TODO: 暂时未完全实现 AnimatableTextProperty。
                        if (animatorProps.a.propType != "") {
                            animatorSelector = animators[j].s
                            //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                            mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                            //if (mult.length) {
                            //    animatorOffset += animatorProps.a.v[0] * mult[0]
                            //} else {
                                animatorOffset += animatorProps.a.v[0] * mult
                            //}
                        }
                    }
                    flag = true
                    //目前，力对齐仅适用于单线
                    if (this._pathData.a.v.size > 0) {
                        currentLength = letters[0].an * 0.5 + ((totalLength - this._pathData.f.v[0] - letters[0].an * 0.5 - letters[letters.size - 1].an * 0.5) * Float64(ind)) / Float64(len - 1)
                        currentLength += this._pathData.f.v[0]
                    }
                    while (flag) {
                        if ((segmentLength + partialLength) >= currentLength + animatorOffset || points.size == 0) {
                            perc = (currentLength + animatorOffset - segmentLength) / currentPoint.partialLength
                            xPathPos = prevPoint.point[0] + (currentPoint.point[0] - prevPoint.point[0]) * perc
                            yPathPos = prevPoint.point[1] + (currentPoint.point[1] - prevPoint.point[1]) * perc
                            matrixHelper.translate((-alignment[0] * letters[i].an) * 0.005, -(alignment[1] * yOff) * 0.01)
                            flag = false
                        } else if (points.size != 0) {
                            segmentLength += currentPoint.partialLength
                            pointInd += 1
                            if (pointInd >= points.size) {
                                pointInd = 0
                                segmentInd += 1
                                if (segments.size <= segmentInd) {
                                    if (mask.v.c) {
                                        pointInd = 0
                                        segmentInd = 0
                                        points = segments[segmentInd].points
                                    } else {
                                        segmentLength -= currentPoint.partialLength
                                        points = Array<PointData>()
                                    }
                                } else {
                                    points = segments[segmentInd].points
                                }
                            }
                            if (points.size != 0) {
                                prevPoint = currentPoint
                                currentPoint = points[pointInd]
                                partialLength = currentPoint.partialLength
                            }
                        }
                    }
                    offf = letters[i].an / 2.0 - letters[i].add
                    matrixHelper.translate(-offf, 0.0, tz: 0.0)
                } else {
                    offf = letters[i].an / 2.0 - letters[i].add
                    matrixHelper.translate(-offf, 0.0, tz: 0.0)

                    //分组对齐
                    matrixHelper.translate((-alignment[0] * letters[i].an) * 0.005, (-alignment[1] * yOff) * 0.01, tz: 0.0)
                }
    
                for (j in 0..jLen) {
                    animatorProps = animators[j].a
                    if (animatorProps.t.propType != "") {
                        animatorSelector = animators[j].s
                        //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                        mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                        //此条件是为了防止对每行中的第一个字符应用跟踪。使用布尔值“isNewLine”可能更好.
                        if (xPos != 0.0 || documentData.j != 0) {
                            if (this._hasMaskedPath) {
                                //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                                //if (mult.size != 0) {
                                //    currentLength += animatorProps.t.v[0] * mult[0]
                                //} else {
                                    currentLength += animatorProps.t.v[0] * mult
                                //}
                            //} else if (mult.size != 0) {
                            //    //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //    xPos += animatorProps.t.v[0] * mult[0]
                            } else {
                                xPos += animatorProps.t.v[0] * mult
                            }
                        }
                    }
                }
                if (documentData.strokeWidthAnim) {
                    sw = documentData.sw
                }
                if (documentData.strokeColorAnim) {
                    if (documentData.sc.size > 3) {
                        sc = [documentData.sc[0], documentData.sc[1], documentData.sc[2]]
                    } else {
                        sc = [0.0, 0.0, 0.0]
                    }
                }
                if (documentData.fillColorAnim && documentData.fc.size > 0) {
                    fc = [documentData.fc[0], documentData.fc[1], documentData.fc[2]]
                }
                for (j in 0..jLen) {
                    animatorProps = animators[j].a
                    if (animatorProps.a.propType != "") {
                        animatorSelector = animators[j].s
                        //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                        mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
    
                        //if (mult.size > 0) {
                        //    matrixHelper.translate(-animatorProps.a.v[0] * mult[0], -animatorProps.a.v[1] * mult[1], animatorProps.a.v[2] * mult[2])
                        //} else {
                            matrixHelper.translate(-animatorProps.a.v[0] * mult, -animatorProps.a.v[1] * mult, tz: animatorProps.a.v[2] * mult)
                        //}
                    }
                }
                for (j in 0..jLen) {
                    animatorProps = animators[j].a
                    if (animatorProps.s.propType != "") {
                        animatorSelector = animators[j].s
                        //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                        mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                        //if (mult.size != 0) {
                        //    matrixHelper.scale(1 + ((animatorProps.s.v[0] - 1) * mult[0]), 1 + ((animatorProps.s.v[1] - 1) * mult[1]), 1)
                        //} else {
                            matrixHelper.scale(1.0 + ((animatorProps.s.v[0] - 1.0) * mult), 1.0 + ((animatorProps.s.v[1] - 1.0) * mult), sz: 1.0)
                        //}
                    }
                }
                for (j in 0..jLen) {
                    animatorProps = animators[j].a
                    animatorSelector = animators[j].s
                    //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                    mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                    if (animatorProps.sk.propType != "") {
                        //if (mult.size != 0) {
                        //    matrixHelper.skewFromAxis(-animatorProps.sk.v[0] * mult[0], animatorProps.sa.v[0] * mult[1])
                        //} else {
                            matrixHelper.skewFromAxis(-animatorProps.sk.v[0] * mult, animatorProps.sa.v[0] * mult)
                        //}
                    }
                    if (animatorProps.r.propType != "") {
                        //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //if (mult.size != 0) {
                        //    matrixHelper.rotateZ(-animatorProps.r.v[0] * mult[2])
                        //} else {
                            matrixHelper.rotateZ(-animatorProps.r.v[0] * mult)
                        //}
                    }
                    if (animatorProps.ry.propType != "") {
                        //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //if (mult.size != 0) {
                        //    matrixHelper.rotateY(animatorProps.ry.v[0] * mult[1])
                        //} else {
                            matrixHelper.rotateY(animatorProps.ry.v[0] * mult)
                        //}
                    }
                    if (animatorProps.rx.propType != "") {
                        //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //if (mult.size != 0) {
                        //    matrixHelper.rotateX(animatorProps.rx.v[0] * mult[0])
                        //} else {
                            matrixHelper.rotateX(animatorProps.rx.v[0] * mult)
                        //}
                    }
                    if (animatorProps.o.propType != "") {
                        //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //if (mult.size != 0) {
                        //    elemOpacity += ((animatorProps.o.v[0]) * mult[0] - elemOpacity) * mult[0]
                        //} else {
                            elemOpacity += ((animatorProps.o.v[0]) * mult - elemOpacity) * mult
                        //}
                    }
                    if (documentData.strokeWidthAnim && animatorProps.sw.propType != "") {
                        //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //if (mult.size != 0) {
                        //    sw += animatorProps.sw.v[0] * mult[0]
                        //} else {
                            sw += animatorProps.sw.v[0] * mult
                        //}
                    }
                    if (documentData.strokeColorAnim && animatorProps.sc.propType != "") {
                        for (k in 0..3) {
                            //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //if (mult.size != 0) {
                            //    sc[k] += (animatorProps.sc.v[k] - sc[k]) * mult[0]
                            //} else {
                                sc[k] += (animatorProps.sc.v[k] - sc[k]) * mult
                            //}
                        }
                    }
                    if (documentData.fillColorAnim && documentData.fc.size > 0) {
                        if (animatorProps.fc.propType != "") {
                            for (k in 0..3) {
                                //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                                //if (mult.size != 0) {
                                //    fc[k] += (animatorProps.fc.v[k] - fc[k]) * mult[0]
                                //} else {
                                    fc[k] += (animatorProps.fc.v[k] - fc[k]) * mult
                                //}
                            }
                        }
                        if (animatorProps.fh.propType != "") {
                            //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //if (mult.size != 0) {
                            //    fc = addHueToRGB(fc, animatorProps.fh.v[0] * mult[0])
                            //} else {
                                fc = addHueToRGB(fc, animatorProps.fh.v[0] * mult)
                            //}
                        }
                        if (animatorProps.fs.propType != "") {
                            //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //if (mult.size != 0) {
                            //    fc = addSaturationToRGB(fc, animatorProps.fs.v[0] * mult[0])
                            //} else {
                                fc = addSaturationToRGB(fc, animatorProps.fs.v[0] * mult)
                            //}
                        }
                        if (animatorProps.fb.propType != "") {
                            //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //if (mult.size != 0) {
                            //    fc = addBrightnessToRGB(fc, animatorProps.fb.v[0] * mult[0])
                            //} else {
                                fc = addBrightnessToRGB(fc, animatorProps.fb.v[0] * mult)
                            //}
                        }
                    }
                }
    
                for (j in 0..jLen) {
                    animatorProps = animators[j].a
    
                    if (animatorProps.p.propType != "") {
                        animatorSelector = animators[j].s
                        //TODO: 冲突。animatorSelector.getMult 返回值是 Float64，但此处结果是 Float64/Array<Float64>
                        mult = animatorSelector.getMult(letters[i].anIndexes[j], textData.a[j].s.totalChars)
                        if (this._hasMaskedPath) {
                            //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                            //if (mult.size != 0) {
                            //    matrixHelper.translate(0.0, animatorProps.p.v[1] * mult[0], tz: -animatorProps.p.v[2] * mult[1])
                            //} else {
                                matrixHelper.translate(0.0, animatorProps.p.v[1] * mult, tz: -animatorProps.p.v[2] * mult)
                            //}
                        //} else if (mult.size != 0) {
                        //    //TODO: 冲突。animatorSelector.getMult 返回值 mult 是 Float64，但此处 mult 是 Float64/Array<Float64>
                        //    matrixHelper.translate(animatorProps.p.v[0] * mult[0], animatorProps.p.v[1] * mult[1], tz: -animatorProps.p.v[2] * mult[2])
                        } else {
                            matrixHelper.translate(animatorProps.p.v[0] * mult, animatorProps.p.v[1] * mult, tz: -animatorProps.p.v[2] * mult)
                        }
                    }
                }
                if (documentData.strokeWidthAnim) {
                    if (sw < 0.0) {
                        letterSw = 0
                    } else {
                        letterSw = Int64(sw)
                    }
                }
                if (documentData.strokeColorAnim) {
                    //TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
                    //letterSc = "rgb(" + round(sc[0] * 255.0).toString() + "," + round(sc[1] * 255.0).toString() + "," + round(sc[2] * 255.0).toString() + ")"
                    //letterSc = Color(UInt8(round(sc[0] * 255.0)), UInt8(round(sc[1] * 255.0)), UInt8(round(sc[2] * 255.0)))
                    letterSc = Color(UInt8(round(sc[0] * 255.0)), UInt8(round(sc[1] * 255.0)), UInt8(round(sc[2] * 255.0)))
                }
                if (documentData.fillColorAnim && documentData.fc.size > 0) {
                    //TODO: 是否将和 rgb 颜色有关的都改为 Int64 ？？？
                    //letterFc = "rgb(" + round(fc[0] * 255.0).toString() + "," + round(fc[1] * 255.0).toString() + "," + round(fc[2] * 255.0).toString() + ")"
                    letterFc = Color(UInt8(round(fc[0] * 255.0)),UInt8(round(fc[1] * 255.0)),UInt8(round(fc[2] * 255.0)))
                }
    
                if (this._hasMaskedPath) {
                    matrixHelper.translate(0.0, -documentData.ls)
    
                    matrixHelper.translate(0.0, (alignment[1] * yOff) * 0.01 + yPos, tz: 0.0)
                    if (this._pathData.p.v.size > 0) {
                        tanAngle = (currentPoint.point[1] - prevPoint.point[1]) / (currentPoint.point[0] - prevPoint.point[0])
                        var rot: Float64 = (atan(tanAngle) * 180.0) / Float64.PI
                        if (currentPoint.point[0] < prevPoint.point[0]) {
                            rot += 180.0
                        }
                        matrixHelper.rotate((-rot * Float64.PI) / 180.0)
                    }
                    matrixHelper.translate(xPathPos, yPathPos, tz: 0.0)
                    currentLength -= (alignment[0] * letters[i].an) * 0.005
                    if (letters.size > (i + 1) && ind != letters[i + 1].ind) {
                        currentLength += letters[i].an / 2.0
                        currentLength += (Float64(documentData.tr) * 0.001) * documentData.finalSize
                    }
                } else {
                    matrixHelper.translate(xPos, yPos, tz: 0.0)
    
                    if (documentData.ps.size > 2) {
                        matrixHelper.translate(documentData.ps[0], documentData.ps[1] + documentData.ascent, tz: 0.0)
                    }

                    if (documentData.j == 1) {
                        matrixHelper.translate(letters[i].animatorJustifyOffset + documentData.justifyOffset + (documentData.boxWidth[0] - documentData.lineWidths[letters[i].line]), 0.0, tz: 0.0)
                    } else if (documentData.j == 2) {
                        matrixHelper.translate(letters[i].animatorJustifyOffset + documentData.justifyOffset + (documentData.boxWidth[0] - documentData.lineWidths[letters[i].line]) / 2.0, 0.0, tz: 0.0)
                    }
                    matrixHelper.translate(0.0, -documentData.ls)
                    matrixHelper.translate(offf, 0.0, tz: 0.0)
                    matrixHelper.translate((alignment[0] * letters[i].an) * 0.005, (alignment[1] * yOff) * 0.01, tz: 0.0)
                    xPos += letters[i].l + (Float64(documentData.tr) * 0.001) * documentData.finalSize
                }
                if (renderType == "html") {
                    letterM = matrixHelper.toCSS()
                } else if (renderType == "svg") {
                    letterM = matrixHelper.to2dCSS()
                } else {
                    letterP = [matrixHelper.props[0], matrixHelper.props[1], matrixHelper.props[2], matrixHelper.props[3], matrixHelper.props[4], matrixHelper.props[5], matrixHelper.props[6], matrixHelper.props[7], matrixHelper.props[8], matrixHelper.props[9], matrixHelper.props[10], matrixHelper.props[11], matrixHelper.props[12], matrixHelper.props[13], matrixHelper.props[14], matrixHelper.props[15]]
                }
                letterO = Int64(elemOpacity)
            }
    
            if (renderedLettersCount <= i) {
                letterValue = LetterProps(letterO, letterSw, letterSc, letterFc, letterM, letterP)
                this.renderedLetters.append(letterValue)
                renderedLettersCount += 1
                this.lettersChangedFlag = true
            } else {
                letterValue = this.renderedLetters[i]
                this.lettersChangedFlag = letterValue.update(letterO, letterSw, letterSc, letterFc, letterM, letterP) || this.lettersChangedFlag
            }
        }
    }

    public func getValue(): Unit {
        if (this.elemGlobalData.frameId == this._frameId) {
            return
        }
        this._frameId = this.elemGlobalData.frameId
        //TODO：调用父类 DynamicPropertyContainer.iterateDynamicProperties
        this.iterateDynamicProperties()
    }

}
