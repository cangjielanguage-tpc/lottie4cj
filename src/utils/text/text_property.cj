/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is TextProperty.
 */
package utils.text

import model.*
import utils.*
import global_data.*

from std import random.*
from std import collection.*
from std import math.*

func default_addDynamicProperty(tp: TextProperty): Unit {}

public class TextProperty {

    var frameId: Int64 = 0
    var lock: Bool = false

    /* _frameId => initialDefaultFrame => -999999 */
    var _frameId: Int64 = -999999

    var pv: DocumentData = DocumentData()
    var v: DocumentData = DocumentData()

    var kf: Bool = false
    public var _isFirstFrame: Bool = true
    public var _mdf: Bool = false

    var keysIndex: Int64 = 0
    var canResize: Bool = false
    var minimumFontSize: Float64 = 1.0
    //TODO: 为了兼容，增加 2 个不用的参数
    var effectsSequence: ArrayList<(DocumentData, String) -> DocumentData> = ArrayList<(DocumentData, String) -> DocumentData>()

    public var currentData: DocumentData = DocumentData()

    let defaultBoxWidth: Array<Float64> = [0.0, 0.0]

    var data: LayerT
    //TODO: 未完全实现 RendererBase / CanvasRendererBase        //public var comp: RendererBase

    let globalData: GlobalData
    public var addDynamicProperty: (TextProperty) -> Unit = default_addDynamicProperty

    /**
     * Create a TextProperty instance based on parameters.
     *
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     * @param data - Type of LayerT, an instance of the "layers.t" data that encapsulates the animation.
     */
    //data => layer.t
    //TODO: 需要解构 ITextElement 和 TextProperty 互调用。
    //TODO: 改成 TextProperty 中只传入 ITextElement 中部分函数和值
    public TextProperty(globalData: GlobalData, data: LayerT) {
        this.data = data
        //TODO: 未完全实现 RendererBase / CanvasRendererBase       //this.comp = comp
        this.globalData = globalData

        this.currentData.boxWidth = this.defaultBoxWidth

        /**
         * 数据类型对应：this.data.d.k[0].s => layer.t.d.k[0].s
         * => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>)
         */
        this.copyData(this.currentData, this.data.d.k[0].s)
    
        if (!this.searchProperty()) {
            this.completeTextData(this.currentData)
        }
    }

    /**
     * Copy data.
     *
     * @param obj - Type of DocumentData, copy data to this instance.
     * @param data - Type of Option<DocumentData>, the data to be copied.
     * @return Type of DocumentData, returns the copied data.
     */
    public func copyData(obj: DocumentData, data: Option<DocumentData>): DocumentData {
        if (let Some(k) <- data) {
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

    /**
     * Set current data.
     *
     * @param data - Type of DocumentData.
     */
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

    /**
     * Search for keyframes.
     *
     * @return Type of Bool.
     */
    public func searchProperty(): Bool {
        return this.searchKeyframes()
    }

    /**
     * Search for keyframes.
     *
     * @return Type of Bool.
     */
    public func searchKeyframes(): Bool {
        //数据类型对应：this.data.d.k => layer.t.d.k => Layer.t(LayerT).d(LayerTD).k(Array<Keyframe<DocumentData>>)
        this.kf = this.data.d.k.size > 1
        if (this.kf) {
            this.addEffect(this.getKeyframeValue)
        }
        return this.kf
    }

    /**
     * Add effect.
     *
     * @param effectFunction - Type of (DocumentData, String) -> DocumentData.
     */
    //TODO: 为了兼容，增加 2 个不用的参数
    public func addEffect(effectFunction: (DocumentData, String) -> DocumentData): Unit {
        this.effectsSequence.append(effectFunction)
        //TODO: 未实现 elem.addDynamicProperty
        this.addDynamicProperty(this)
    }

    /**
     * Get value.
     */
    public func getValue(): Unit {
        this.getValue(Option<DocumentData>.None)
    }

    /**
     * Get value.
     *
     * @param finalValue - Type of Option<DocumentData>.
     */
    public func getValue(finalValue: Option<DocumentData>): Unit {
        if (this.globalData.frameId == this.frameId || this.effectsSequence.size == 0) {
            match(finalValue) {
                case Some(v) => ()
                case None => return
            }
        }

        /**
         * 数据类型对应：this.currentData.t  =>  this.data.d.k[this.keysIndex].s.t => layer.t.d.k[i].s.t
         * => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>).t
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

        var _finalValue: DocumentData = this.data.d.k[this.keysIndex].s ?? DocumentData()
        if (let Some(k) <- finalValue) {
            _finalValue = k
        }

        for (i in 0..len) {
            //检查索引是否已更改，以防止每次表达式更新时都创建新对象。
            if (currentIndex != this.keysIndex) {
                //TODO: 未实现 effectsSequence 带参重载函数
                _finalValue = this.effectsSequence[i](_finalValue, _finalValue.t)
            } else {
                //TODO: 未实现 effectsSequence 带参重载函数
                _finalValue = this.effectsSequence[i](this.currentData, _finalValue.t)
            }
        }

        if (currentValue != _finalValue) {
            this.setCurrentData(_finalValue)
        }
        this.v = this.currentData
        this.pv = this.v
        this.lock = false
        this.frameId = this.globalData.frameId
    }

    /**
     * Get keyframe values.
     *
     * @param data - Type of DocumentData.
     * @param t - Type of String.
     * @return Type of DocumentData.
     */
    //TODO: 为了兼容，增加 2 个不用的参数
    public func getKeyframeValue(data: DocumentData, t: String): DocumentData {
        // 数据类型对应：this.data.d.k => layer.t.d.k => Layer.t(LayerT).d(LayerTD).k(Array<Keyframe<DocumentData>>)
        let textKeys: Array<Keyframe<DocumentData>> = this.data.d.k

        //TODO: 未完全实现 RendererBase    //var frameNum: Float64 = this.elem.comp.renderedFrame
        //TODO: this.elem.comp.renderedFrame 暂时用 0.0 代替
        var frameNum: Float64 = 0.0

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

    /**
     * Generate final text.
     *
     * @param text - Type of String.
     * @return Type of ArrayList<String>.
     */
    public func buildFinalText(text: String): ArrayList<String> {
        var charactersArray: ArrayList<String> = ArrayList<String>(24)
        var i: Int64 = 0
        var len = text.size
        var charCode: UInt32 = 0
        var secondCharCode: UInt32 = 0
        var shouldCombine: Bool = false

        let chars: Array<Rune> = text.toRuneArray()

        while (i < len) {
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

    /**
     * Complete text data.
     *
     * @param documentData - Type of DocumentData.
     */
    public func completeTextData(documentData: DocumentData): Unit {
        documentData.__complete = true
        //TODO: 未完全实现 FontManager
        var fontManager: FontManager = this.globalData.fontManager
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

        var fontData: Font = fontManager.getFontByName(documentData.f)
        var charData: FontCharacter = FontCharacter(CharsData(shapes: Array<ContentModel>()), "", 0.0, 0.0, "", "")

        var cLength: Float64 = 0.0

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

                        if (documentData.finalLineHeight != 0.0) {
                            currentHeight += documentData.finalLineHeight
                        } else {
                            currentHeight += documentData.finalSize * 1.2
                        }

                    }
                    if (fontManager.chars.size > 0) {
                        charData = fontManager.getCharData(finalText[idx], fontData.fStyle, fontData.fFamily)
                        if (newLineFlag) {
                            cLength = 0.0
                        } else {
                            cLength = (charData.w * documentData.finalSize) / 100.0
                        }
                    } else {
                        //TODO: 未实现 FontManager.measureText
                        //cLength = fontManager.measureText(finalText[idx], documentData.f, documentData.finalSize)
                    }
                    if (lineWidth + cLength > boxWidth && finalText[idx] != " ") {
                        if (lastSpaceIndex == -1) {
                            len += 1
                        } else {
                            idx = lastSpaceIndex
                        }

                        if (documentData.finalLineHeight != 0.0) {
                            currentHeight += documentData.finalLineHeight
                        } else {
                            currentHeight += documentData.finalSize * 1.2
                        }

                        if (lastSpaceIndex == idx) {
                            finalText.remove(idx)
                        } else {
                            finalText.insert(idx, "\r")
                        }

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

            charCode = UInt32(currentChar.toRuneArray()[0])
            if (charCode == 13 || charCode == 3) {
                uncollapsedSpaces = 0.0
                lineWidths.append(lineWidth)

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
                charData = fontManager.getCharData(currentChar, fontData.fStyle, fontManager.getFontByName(documentData.f).fFamily)
                cLength = (charData.w * documentData.finalSize) / 100.0
                if (newLineFlag) {
                    cLength = 0.0
                }
            } else {
                //TODO: 未实现 FontManager.measureText
                //cLength = fontManager.measureText(val, documentData.f, documentData.finalSize)
            }

            if (currentChar == " ") {
                uncollapsedSpaces += (cLength + trackingOffset)
            } else {
                lineWidth += (cLength + trackingOffset + uncollapsedSpaces)
                uncollapsedSpaces = 0.0
            }

            letters.append(Letter(l: cLength, an: cLength, add: currentSize, n: newLineFlag, anIndexes: Array<Int64>(), val: val, line: currentLine, animatorJustifyOffset: 0))
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

        /**
         * 数据类型对应：this.data.a => layer.t.a  => Layer.t(LayerT).a(Array<AnimatableTextPropertiesA>)
         * animatorData => this.data.a[i] => layer.t.a[i]  => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>)
         */

        var animators: Array<AnimatableTextPropertiesA> = data.a
        var animatorData: AnimatableTextPropertiesA = AnimatableTextPropertiesA()
        var letterData: Letter = Letter()
        var jLen: Int64 = animators.size
        var based: Int64 = 0
        var ind: Int64 = 0
        var indexes: ArrayList<Int64> = ArrayList<Int64>()
        for (j in 0..jLen) {
            animatorData = animators[j]
            /**
             * 数据类型对应：
             * animatorData => this.data.a[i] => layer.t.a[i]  => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>)
             * animatorData.a.sc => this.data.a[i].a.sc => layer.t.a[i].a.sc
             * => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>).a(AnimatableTextProperties).sc(Array<Keyframe<Array<Float64>>>)
             */
            if (animatorData.a.sc.size > 0) {
                documentData.strokeColorAnim = true
            }
            if (animatorData.a.sw.size > 0) {
                documentData.strokeWidthAnim = true
            }
            //TODO: 未确认 animatorData.a.fh/fs/fb 数据类型
            //if (animatorData.a.fc.k.size > 0 || animatorData.a.fh || animatorData.a.fs || animatorData.a.fb) {
            //    documentData.fillColorAnim = true
            //}
            ind = 0

            /**
             * 数据类型对应：animatorData.s.b => this.data.a[i].s.b => layer.t.a[i].s.b
             * => Layer.t(LayerT).a[i](Array<AnimatableTextPropertiesA>).s(AnimatableTextPropertiesS).b(Int64)
             */
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
                        newInd = indexes.remove(Int64(math.floor(num * Float64(indexes.size))))
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

    /**
     * Update document data.
     *
     * @param newData - Type of Option<DocumentData>.
     * @param indexs - Type of Option<Int64>.
     */
    public func updateDocumentData(newData: Option<DocumentData>, indexs: Option<Int64>): Unit {
        var index: Int64 = this.keysIndex
        if (let Some(k) <- indexs) {
            index = k
        }
        let dd: DocumentData = this.data.d.k[index].s ?? DocumentData()

        let dData: Option<DocumentData> = this.copyData(dd, newData)
        this.data.d.k[index].s = dData
        this.recalculate(index)
        //TODO: 未实现 ITextElement.addDynamicProperty
        this.addDynamicProperty(this)
    }

    /**
     * recalculate.
     *
     * @param index - Type of Int64.
     */
    public func recalculate(index: Int64): Unit {
        /**
         * 数据类型对应：this.data.d.k[this.keysIndex].s => layer.t.d.k[i].s
         * => Layer.t(LayerT).d(LayerTD).k[i](Array<Keyframe<DocumentData>>[i]).s(Option<DocumentData>)
         */
        var dData: DocumentData = this.data.d.k[index].s ?? DocumentData()
        dData.__complete = false
        this.keysIndex = 0
        this._isFirstFrame = true
        this.getValue(dData)
    }

    /**
     * Can adjust font size.
     *
     * @param canResize - Type of Bool.
     */
    public func canResizeFont(canResize: Bool): Unit {
        this.canResize = canResize
        this.recalculate(this.keysIndex)
        //TODO: 未实现 ITextElement.addDynamicProperty
        this.addDynamicProperty(this)
    }

    /**
     * Update the LetterProps instance.
     *
     * @param fontValue - Type of Option<Float64>.
     */
    public func setMinimumFontSize(fontValue: Option<Float64>): Unit {
        if (let Some(v) <- fontValue) {
            this.minimumFontSize = math.floor(v)
        } else {
            this.minimumFontSize = 1.0
        }
        this.recalculate(this.keysIndex)
        //TODO: 未实现 ITextElement.addDynamicProperty
        this.addDynamicProperty(this)
    }

}
