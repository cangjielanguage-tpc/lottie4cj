/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.text

internal import lottie.model.*
internal import lottie.utils.*
internal import lottie.global_data.*

internal import std.random.*
internal import std.collection.*
internal import std.math.*

public func default_addDynamicProperty(tp: TextProperty): Unit {}

/*
 * 初始化后需要传入2个函数：
 * 1. addDynamicProperty    => 传入 TextElement 中的这个函数；（在TextElement.init传入编译失败，只能init之后传入。）
 * 2. renderedFrameInElemComp() => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
 */
public class TextProperty {

    var frameId: Int64 = 0
    var lock: Bool = false

    var _frameId: Int64 = -999999

    var pv: DocumentData = DocumentData()
    var v: DocumentData = DocumentData()

    var kf: Bool = false
    public var _isFirstFrame: Bool = true
    public var _mdf: Bool = false

    var data: LayerT

    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
    public var addDynamicPropertyInTextElement: (TextProperty) -> Unit = default_addDynamicProperty
    let elemGlobalData: GlobalData
    //TODO：this.elem.comp.renderedFrame 的值是可变的，故不能直接传值，需要通过函数【renderedFrameInElemComp】间接获取当时值。
    public var renderedFrameInElemComp: () -> Float64 = { => 0.0}
    //TODO: 暂时没有引入 BaseElement.comp--【不会再直接引入comp，具体用到comp的什么，再单独处理。】  //var comp = this.elem.comp

    var keysIndex: Int64 = 0
    var canResize: Bool = false
    var minimumFontSize: Float64 = 1.0
    //TODO: 为了兼容，增加 2 个暂时不用的参数。
    var effectsSequence: ArrayList<(DocumentData, String) -> DocumentData> = ArrayList<(DocumentData, String) -> DocumentData>()

    public var currentData: DocumentData = DocumentData()

    let defaultBoxWidth: Array<Float64> = [0.0, 0.0]
    

    //TODO:需要解构 ITextElement 和 TextProperty 互调用。改成 TextProperty 中只传入 ITextElement 中部分函数和值
    //public TextProperty(data: LayerT, elemGlobalData: GlobalData, addDynamicProperty: (TextProperty) -> Unit) {
    public TextProperty(data: LayerT, elemGlobalData: GlobalData) {
        this.data = data
        
        this.elemGlobalData = elemGlobalData
        //this.addDynamicPropertyInTextElement = addDynamicProperty

        //this.currentData = DocumentData()
        this.currentData.boxWidth = this.defaultBoxWidth

        /*
         * 数据来源分析： this.data.d.k[0].s => layer.t.d.k[0].s
         *  => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>)
         */
        if (this.data.d.k.size > 0) {
            this.copyData(this.currentData, this.data.d.k[0].s)
        }
    
        if (!this.searchProperty()) {
            this.completeTextData(this.currentData)
        }
    }

    public func copyData(obj: DocumentData, data: Option<DocumentData>): DocumentData {
        if (let Some(k) <- data) {
            /*
             * 数据来源分析： this.currentData.t  =>  this.data.d.k[this.keysIndex].s.t => layer.t.d.k[i].s.t
             *  => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>).t
             * obj.t  = k.t //原生的 t 改为 _t，现在的 t == layer.t.d.k[i].s.t，后续单独处理
             * 理解错误，t就是字符串，只是js中开始赋值的是 0
             */
            obj.t  = k.t
            obj.f  = k.f
            obj.s  = k.s
            obj.j  = k.j
            obj.tr = k.tr
            obj.lh = k.lh
            obj.ls = k.ls
            obj.fc = k.fc
            obj.sc = k.sc
            obj.sw = k.sw
            obj.of = k.of
            obj.ps = k.ps
            obj.sz = k.sz
        }
        return obj
    }

    public func setCurrentData(data: DocumentData): Unit {
        if (!data.__complete) {
            this.completeTextData(data)
        }
        this.currentData = data

        if (this.currentData.boxWidth.size == 0) {
            this.currentData.boxWidth = this.defaultBoxWidth
        } else {
            this.currentData.boxWidth = this.currentData.boxWidth
        }

        this._mdf = true
    }
    
    public func searchProperty(): Bool {
        return this.searchKeyframes()
    }

    public func searchKeyframes(): Bool {
        //数据来源分析： this.data.d.k => layer.t.d.k => Layer.t(LayerT).d(LayerTD).k(Array<Keyframe<DocumentData>>)
        this.kf = this.data.d.k.size > 1
        if (this.kf) {
            //this.addEffect(this.getKeyframeValue.bind(this))
            this.addEffect(this.getKeyframeValue)
        }
        return this.kf
    }

    //TODO: 为了兼容，增加 2 个不用的参数                                                           ???---lp---20240521--
    public func addEffect(effectFunction: (DocumentData, String) -> DocumentData) {
        this.effectsSequence.append(effectFunction)
        //TODO: 未实现 elem.addDynamicProperty。
        //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
        this.addDynamicPropertyInTextElement(this)
    }

    public func getValue(): Unit {
        this.getValue(Option<DocumentData>.None)
    }

    public func getValue(_finalValue: Option<DocumentData>): Unit {
        if (this.elemGlobalData.frameId == this.frameId || this.effectsSequence.size == 0) {
            match(_finalValue) {
                case Some(v) => ()
                case None => return
            }
        }

        /*
         * 数据来源分析 this.currentData.t  =>  this.data.d.k[this.keysIndex].s.t => layer.t.d.k[i].s.t
         *  => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>).t
         */
        this.currentData.t = (this.data.d.k[this.keysIndex].s ?? DocumentData()).t
        let currentValue: DocumentData = this.currentData
        let currentIndex: Int64 = this.keysIndex
        if (this.lock) {
            this.setCurrentData(this.currentData)
            return
        }
        this.lock = true
        this._mdf = false

        let len: Int64 = this.effectsSequence.size

        var finalValue: DocumentData = this.data.d.k[this.keysIndex].s ?? DocumentData()
        if (let Some(k) <- _finalValue) {
            finalValue = k
        }

        for (i in 0..len) {
            //检查索引是否已更改，以防止每次表达式更新时都创建新对象。
            if (currentIndex != this.keysIndex) {
                //TODO: 未实现 effectsSequence 带参重载函数                                         ???---lp---20240517--
                finalValue = this.effectsSequence[i](finalValue, finalValue.t)
            } else {
                //TODO: 未实现 effectsSequence 带参重载函数                                         ???---lp---20240517--
                finalValue = this.effectsSequence[i](this.currentData, finalValue.t)
            }
        }

        if (currentValue != finalValue) {
            this.setCurrentData(finalValue)
        }
        this.v = this.currentData
        this.pv = this.v
        this.lock = false
        this.frameId = this.elemGlobalData.frameId
    }

    //TODO: 为了兼容，增加 2 个暂时不用的参数。
    public func getKeyframeValue(data: DocumentData, t: String): DocumentData {
        //数据来源分析： this.data.d.k => layer.t.d.k => Layer.t(LayerT).d(LayerTD).k(Array<Keyframe<DocumentData>>)
        let textKeys: Array<Keyframe<DocumentData>> = this.data.d.k

        //TODO：this.elem.comp.renderedFrame 的值是可变的，故不能直接传值，需要通过函数【renderedFrameInElemComp】间接获取当时值。
        var frameNum: Float64 = this.renderedFrameInElemComp()

        var i: Int64 = 0
        let len: Int64 = textKeys.size
        while (i <= len - 1) {
            if (i == len - 1 || textKeys[i + 1].t > frameNum) {
                break
            }
            i += 1
        }
        if (this.keysIndex != i) {
            this.keysIndex = i
        }
        return this.data.d.k[this.keysIndex].s ?? DocumentData()
    }

    public func buildFinalText(text: String): ArrayList<String> {
        var charactersArray: ArrayList<String> = ArrayList<String>(24)
        var i: Int64 = 0
        var len = text.size
        var charCode: UInt32 = 0
        var secondCharCode: UInt32 = 0
        var shouldCombine: Bool = false

        let chars: Array<Rune> = text.toRuneArray()

        while (i < len) {
            //charCode = text.charCodeAt(i)
            charCode = UInt32(chars[i])
            if (FontManager.isCombinedCharacter(charCode)) {
                charactersArray[charactersArray.size - 1] = charactersArray[charactersArray.size - 1] + chars[i].toString()
            } else if (charCode >= 0xD800 && charCode <= 0xDBFF) {
                secondCharCode = UInt32(chars[i + 1])
                if (secondCharCode >= 0xDC00 && secondCharCode <= 0xDFFF) {
                    if (shouldCombine || FontManager.isModifier(charCode, secondCharCode)) {
                        charactersArray[charactersArray.size - 1] = charactersArray[charactersArray.size - 1] + String(chars[i..(i+2)])
                        shouldCombine = false
                    } else {
                        charactersArray.append(String(chars[i..(i+2)]))
                    }
                    i += 1
                } else {
                    charactersArray.append(chars[i].toString())
                }
            } else if (charCode > 0xDBFF) {
                secondCharCode = UInt32(chars[i + 1])
                if (FontManager.isZeroWidthJoiner(charCode, secondCharCode)) {
                    shouldCombine = true
                    charactersArray[charactersArray.size - 1] = charactersArray[charactersArray.size - 1] + String(chars[i..(i+2)])
                    i += 1
                } else {
                    charactersArray.append(chars[i].toString())
                }
            //} else if (FontManager.isZeroWidthJoiner(charCode)) {
            } else if (FontManager.isZeroWidthJoiner(charCode, 0)) {
                charactersArray[charactersArray.size - 1] = charactersArray[charactersArray.size - 1] + chars[i].toString()
                shouldCombine = true
            } else {
                charactersArray.append(chars[i].toString())
            }
            i += 1
        }
        return charactersArray
    }

    public func completeTextData(documentData: DocumentData) {
        documentData.__complete = true
        //TODO: 未实现 FontManager                                                                ???---lp---20240520--
        var fontManager: FontManager = this.elemGlobalData.fontManager
        var data: LayerT = this.data
        var letters: ArrayList<Letter> = ArrayList<Letter>()

        var newLineFlag: Bool = false
        var index: Int64 = 0
        var val: String = ""
        let anchorGrouping: Int64 = data.m.g
        var currentSize: Float64 = 0.0
        var currentPos: Int64 = 0
        var currentLine: Int64 = 0
        var lineWidths: ArrayList<Float64> = ArrayList<Float64>()
        var lineWidth: Float64 = 0.0
        var maxLineWidth: Float64 = 0.0

        //TODO: 未实现 FontManager.getFontByName                                                 ???---lp---20240520--
        var fontData: Font = fontManager.getFontByName(documentData.f)
        //TODO: 未确认使用位置                                                                     ???---lp---20240520--
        var charData: FontCharacter = FontCharacter(CharsData(shapes: Array<ContentModel>()), "", 0.0, 0.0, "", "")

        var cLength: Float64 = 0.0

        //TODO: 未实现 FontManager                                                               ???---lp---20240520--
        var fontProps: FontProps = getFontProperties(fontData)

        documentData.fWeight = fontProps.weight
        documentData.fStyle = fontProps.style
        documentData.finalSize = documentData.s
        documentData.finalText = this.buildFinalText(documentData.t)

        var len: Int64 = documentData.finalText.size
        documentData.finalLineHeight = documentData.lh
        var trackingOffset: Float64 = Float64(documentData.tr / 1000) * documentData.finalSize
        var charCode: UInt32 = 0

        if (documentData.sz.size > 0) {
            var flag: Bool = true
            var boxWidth: Float64 = documentData.sz[0]
            var boxHeight: Float64 = documentData.sz[1]
            var currentHeight: Float64 = 0.0
            var finalText: ArrayList<String> = ArrayList<String>()
            while (flag) {
                finalText = this.buildFinalText(documentData.t)
                currentHeight = 0.0
                lineWidth = 0.0
                len = finalText.size
                trackingOffset = Float64(documentData.tr / 1000) * documentData.finalSize
                var lastSpaceIndex: Int64 = -1

                var idx: Int64 = 0
                while (idx < len) {
                    charCode = UInt32(finalText[idx].toRuneArray()[0])
                    newLineFlag = false
                    if (finalText[idx] == " ") {
                        lastSpaceIndex = idx
                    } else if (charCode == 13 || charCode == 3) {
                        lineWidth = 0.0
                        newLineFlag = true
                        //currentHeight += documentData.finalLineHeight || documentData.finalSize * 1.2
                        if (documentData.finalLineHeight != 0.0) {
                            currentHeight += documentData.finalLineHeight
                        } else {
                            currentHeight += documentData.finalSize * 1.2
                        }

                    }
                    if (fontManager.chars.size > 0) {
                        //TODO: 未实现 FontManager.getCharData                                    ???---lp---20240520--
                        charData = fontManager.getCharData(finalText[idx], fontData.fStyle, fontData.fFamily)
                        //cLength = newLineFlag ? 0 : (charData.w * documentData.finalSize) / 100
                        if (newLineFlag) {
                            cLength = 0.0
                        } else {
                            cLength = (charData.w * documentData.finalSize) / 100.0
                        }
                    } else {
                        // tCanvasHelper.font = documentData.s + "px "+ fontData.fFamily
                        //TODO: 未实现 FontManager.measureText                                    ???---lp---20240520--
                        //cLength = fontManager.measureText(finalText[idx], documentData.f, documentData.finalSize)
                    }
                    if (lineWidth + cLength > boxWidth && finalText[idx] != " ") {
                        if (lastSpaceIndex == -1) {
                            len += 1
                        } else {
                            idx = lastSpaceIndex
                        }
                        //currentHeight += documentData.finalLineHeight || documentData.finalSize * 1.2
                        if (documentData.finalLineHeight != 0.0) {
                            currentHeight += documentData.finalLineHeight
                        } else {
                            currentHeight += documentData.finalSize * 1.2
                        }

                        //finalText.splice(i, lastSpaceIndex === i ? 1 : 0, "\r")
                        if (lastSpaceIndex == idx) {
                            finalText.remove(idx)
                        } else {
                            finalText.insert(idx, "\r")
                        }

                        // finalText = finalText.substr(0,i) + "\r" + finalText.substr(i === lastSpaceIndex ? i + 1 : i)
                        lastSpaceIndex = -1
                        lineWidth = 0.0
                    } else {
                        lineWidth += cLength
                        lineWidth += trackingOffset
                    }
                    idx++
                }
                currentHeight += (fontData.ascent * documentData.finalSize) / 100.0
                if (this.canResize && documentData.finalSize > this.minimumFontSize && boxHeight < currentHeight) {
                    documentData.finalSize -= 1.0
                    documentData.finalLineHeight = (documentData.finalSize * documentData.lh) / documentData.s
                } else {
                    documentData.finalText = finalText
                    len = documentData.finalText.size
                    flag = false
                }
            }
        }
        lineWidth = -trackingOffset
        cLength = 0.0
        var uncollapsedSpaces: Float64 = 0.0
        var currentChar: String = ""
        for (i in 0..len) {
            newLineFlag = false
            currentChar = documentData.finalText[i]
            //charCode = currentChar.charCodeAt(0)
            charCode = UInt32(currentChar.toRuneArray()[0])
            if (charCode == 13 || charCode == 3) {
                uncollapsedSpaces = 0.0
                lineWidths.append(lineWidth)
                //maxLineWidth = lineWidth > maxLineWidth ? lineWidth : maxLineWidth
                if (lineWidth > maxLineWidth) {
                    maxLineWidth = lineWidth
                }

                lineWidth = -2.0 * trackingOffset
                val = ""
                newLineFlag = true
                currentLine += 1
            } else {
                val = currentChar
            }
            if (fontManager.chars.size > 0) {
                //TODO: 未实现 FontManager.getCharData                                          ???---lp---20240520--
                charData = fontManager.getCharData(currentChar, fontData.fStyle, fontManager.getFontByName(documentData.f).fFamily)
                //cLength = newLineFlag ? 0 : (charData.w * documentData.finalSize) / 100
                cLength = (charData.w * documentData.finalSize) / 100.0
                if (newLineFlag) {
                    cLength = 0.0
                }
            } else {
                // var charWidth = fontManager.measureText(val, documentData.f, documentData.finalSize)
                // tCanvasHelper.font = documentData.finalSize + "px "+ fontManager.getFontByName(documentData.f).fFamily
                //TODO: 未实现 FontManager.measureText                                           ???---lp---20240520--
                //cLength = fontManager.measureText(val, documentData.f, documentData.finalSize)
            }

            //
            if (currentChar == " ") {
                uncollapsedSpaces += (cLength + trackingOffset)
            } else {
                lineWidth += (cLength + trackingOffset + uncollapsedSpaces)
                uncollapsedSpaces = 0.0
            }
            //TODO: 未确认 anIndexes: [] 数据类型                                                  ???---lp---20240520--
            letters.append(Letter(l: cLength, an: cLength, add: currentSize, n: newLineFlag, anIndexes: Array<Int64>(), val: val, line: currentLine, animatorJustifyOffset: 0.0))
            if (anchorGrouping == 2) { // eslint-disable-line eqeqeq
                currentSize += cLength
                if (val == "" || val == " " || i == len - 1) {
                    if (val == "" || val == " ") {
                        currentSize -= cLength
                    }
                    while (currentPos <= i) {
                        letters[currentPos].an = currentSize
                        letters[currentPos].ind = index
                        letters[currentPos].extra = cLength
                        currentPos += 1
                    }
                    index += 1
                    currentSize = 0.0
                }
            } else if (anchorGrouping == 3) { // eslint-disable-line eqeqeq
                currentSize += cLength
                if (val == "" || i == len - 1) {
                    if (val == "") {
                        currentSize -= cLength
                    }
                    while (currentPos <= i) {
                        letters[currentPos].an = currentSize
                        letters[currentPos].ind = index
                        letters[currentPos].extra = cLength
                        currentPos += 1
                    }
                    currentSize = 0.0
                    index += 1
                }
            } else {
                letters[index].ind = index
                letters[index].extra = 0.0
                index += 1
            }
        }
        documentData.l = letters
        //maxLineWidth = lineWidth > maxLineWidth ? lineWidth : maxLineWidth
        if (lineWidth > maxLineWidth) {
            maxLineWidth = lineWidth
        }

        lineWidths.append(lineWidth)
        if (documentData.sz.size > 0) {
            documentData.boxWidth = [documentData.sz[0]]
            documentData.justifyOffset = 0.0
        } else {
            documentData.boxWidth = [maxLineWidth]
            if(documentData.j == 1) {
                documentData.justifyOffset = -documentData.boxWidth[0]
            } else if(documentData.j == 2) {
                documentData.justifyOffset = -documentData.boxWidth[0] / 2.0
            } else {
                documentData.justifyOffset = 0.0
            }
        }
        documentData.lineWidths = lineWidths

        // this.data.a => layer.t.a  => Layer.t(LayerT).a(Array<AnimatableTextPropertiesA>)
        // animatorData => this.data.a[i] => layer.t.a[i]  => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>)


        var animators: Array<AnimatableTextPropertiesA> = data.a
        var animatorData: AnimatableTextPropertiesA = AnimatableTextPropertiesA()
        var letterData: Letter = Letter()
        var jLen: Int64 = animators.size
        var based: Int64 = 0
        var ind: Int64 = 0
        var indexes: ArrayList<Int64> = ArrayList<Int64>()
        for (j in 0..jLen) {
            animatorData = animators[j]
            // animatorData => this.data.a[i] => layer.t.a[i]  => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>)
            // animatorData.a.sc => this.data.a[i].a.sc => layer.t.a[i].a.sc
            // => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>).a(AnimatableTextProperties).sc(Array<Keyframe<Array<Float64>>>)
            if (animatorData.a.sc.size > 0) {
                documentData.strokeColorAnim = true
            }
            if (animatorData.a.sw.size > 0) {
                documentData.strokeWidthAnim = true
            }
            //TODO: 未确认 animatorData.a.fh/fs/fb 数据类型                                         ???---lp---20240521--
            //if (animatorData.a.fc.k.size > 0 || animatorData.a.fh || animatorData.a.fs || animatorData.a.fb) {
            //    documentData.fillColorAnim = true
            //}
            ind = 0

            // animatorData.s.b => this.data.a[i].s.b => layer.t.a[i].s.b
            // => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>).s(AnimatableTextPropertiesS).b(Int64)
            based = animatorData.s.b
            for (i in 0..len) {
                letterData = letters[i]
                letterData.anIndexes[j] = ind
                if ((based == 1 && letterData.val != "") || (based == 2 && letterData.val != "" && letterData.val != " ") || (based == 3 && (letterData.n || letterData.val == " " || i == len - 1)) || (based == 4 && (letterData.n || i == len - 1))) { // eslint-disable-line eqeqeq
                    if (animatorData.s.rn == 1) {
                        indexes.append(ind)
                    }
                    ind += 1
                }
            }

            data.a[j].s.totalChars = ind
            var currentInd: Int64 = -1
            var newInd: Int64 = 0
            if (animatorData.s.rn == 1) {
                for (i in 0..len) {
                    letterData = letters[i]
                    if (currentInd != letterData.anIndexes[j]) { // eslint-disable-line eqeqeq
                        currentInd = letterData.anIndexes[j]

                        let m: Random = Random()
                        m.seed = 3
                        let num: Float64 = m.nextFloat64()
                        newInd = indexes.remove(Int64(floor(num * Float64(indexes.size))))
                    }
                    letterData.anIndexes[j] = newInd
                }
            }
        }

        documentData.yOffset = documentData.finalSize * 1.2
        if (documentData.finalLineHeight != 0.0) {
            documentData.yOffset = documentData.finalLineHeight
        }

        if (documentData.ls != 0.0) {
            documentData.ls = documentData.ls
        }

        documentData.ascent = (fontData.ascent * documentData.finalSize) / 100.0
    }


    public func updateDocumentData(newData: Option<DocumentData>, indexs: Option<Int64>): Unit {
        var index: Int64 = this.keysIndex
        if (let Some(k) <- indexs) {
            index = k
        }
        let dd: DocumentData = this.data.d.k[index].s ?? DocumentData()

        let dData: Option<DocumentData> = this.copyData(dd, newData)
        this.data.d.k[index].s = dData
        this.recalculate(index)
        //TODO: 未实现 ITextElement.addDynamicProperty。
        //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
        this.addDynamicPropertyInTextElement(this)
    }

    public func recalculate(index: Int64): Unit {
        // this.data.d.k[this.keysIndex].s => layer.t.d.k[i].s
        // => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>)
        var dData: DocumentData = this.data.d.k[index].s ?? DocumentData()
        dData.__complete = false
        this.keysIndex = 0
        this._isFirstFrame = true
        this.getValue(dData)
    }
    
    public func canResizeFont(_canResize: Bool): Unit {
        this.canResize = _canResize
        this.recalculate(this.keysIndex)
        //TODO: 未实现 ITextElement.addDynamicProperty。
        //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
        this.addDynamicPropertyInTextElement(this)
    }

    public func setMinimumFontSize(_fontValue: Option<Float64>): Unit {
        if (let Some(v) <- _fontValue) {
            this.minimumFontSize = floor(v)
        } else {
            this.minimumFontSize = 1.0
        }
        this.recalculate(this.keysIndex)
        //TODO: 未实现 ITextElement.addDynamicProperty。
        //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
        this.addDynamicPropertyInTextElement(this)
    }

}
