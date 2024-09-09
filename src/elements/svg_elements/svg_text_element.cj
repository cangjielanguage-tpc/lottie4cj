/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is SVGTextLottieElement.
 */
package lottie4cj.elements.svg_elements


var emptyShapeData = Layer()
//TODO 未完全实现
public class SVGTextLottieElement <: ITextElement{
    
    public var textSpans: ArrayList<TextSpans>
    public var renderType: String
    public var textContainer: CreateNS = CreateNS("")
    public var _sizeChanged: Bool = false
    public var renderedLetters: Array<LetterProps> = Array<LetterProps>()
    public var mHelper: Matrix = Matrix()


    public init(data: Layer, globalData: GlobalData ) {
        super(data, globalData)
        this.textSpans = ArrayList<TextSpans>()
        this.renderType = "svg"
    }

    public func createContent() {
        if (this.data.singleShape && this.globalData.fontManager.chars.size == 0) {
            this.textContainer = CreateNS("text")
        }
    }

    public func buildTextContents(textArray: ArrayList<String>) {
        var i = 0
        var len = textArray.size
        var textContents = ArrayList<String>()
        var currentTextContent = ""
        while (i < len) {
            // \n \r \r\n
            var sc: Array<UInt8> = [13,3]
            if (textArray[i] == String(Rune.fromUtf8(sc,0)[0]) || textArray[i] == String(Rune.fromUtf8(sc,1)[0])) {
                textContents.append(currentTextContent)
                currentTextContent = ""
            } else {
                currentTextContent += textArray[i]
            }
            i += 1
        }
        textContents.append(currentTextContent)
        return textContents
    }

    public func buildShapeData(data: Datas, scale: Float64) {
        if (!data.shapes.isEmpty() && data.shapes.size > 0) {
            var shape = data.shapes[0]
            if (shape.it.size > 0) {
                var shapeItem = shape.it[shape.it.size - 1]
                if (shapeItem.s.isSome()) {
                    shapeItem.s.getOrThrow().k.insert(0,scale)
                    shapeItem.s.getOrThrow().k.insert(1,scale)
                }
            }
        }
        return data
    }

    public func buildNewText() {
        //TODO tSpan.styles.display 
        var documentData = this.textProperty.currentData
        this.renderedLetters = if(documentData.l.size > 0) {
            Array<LetterProps>(documentData.l.size, item: LetterProps())
        }else {
            Array<LetterProps>(0, item: LetterProps())
        }
        if (documentData.fc.size > 0) {
            this.layerElement.setAttribute("fill", this.buildColor(documentData.fc))
        } else {
            this.layerElement.setAttribute("fill", "rgba(0,0,0,0)")
        }
        if (documentData.sc.size > 0) {
            this.layerElement.setAttribute("stroke", this.buildColor(documentData.sc))
            this.layerElement.setAttribute("stroke-width", "${documentData.sw}")
        }
        this.layerElement.setAttribute("font-size", "${documentData.finalSize}")
        var fontData = this.globalData.fontManager.getFontByName(documentData.f)
        if (fontData.fClass.size > 0) {
            this.layerElement.setAttribute("class", fontData.fClass)
        } else {
            this.layerElement.setAttribute("font-family", fontData.fFamily)
            var fWeight = documentData.fWeight
            var fStyle = documentData.fStyle
            this.layerElement.setAttribute("font-style", fStyle)
            this.layerElement.setAttribute("font-weight", fWeight)
        }
        this.layerElement.setAttribute("aria-label", documentData.t)

        var letters = if (documentData.l.size > 0) {
            documentData.l
        }else {
            ArrayList<Letter>()
        }
        var usesGlyphs = this.globalData.fontManager.chars
        var len = letters.size

        var tSpan: CreateNS = CreateNS("")
        var matrixHelper = this.mHelper
        var shapeStr = ""
        var singleShape = this.data.singleShape
        var xPos = 0.0
        var yPos = 0.0
        var firstLine = true
        var trackingOffset = Float64(documentData.tr) * 0.001 * documentData.finalSize
        var i: Int64
        if (singleShape && usesGlyphs.size ==0 && documentData.sz.size == 0) {
            var tElement = this.textContainer
            var justify = "start"
            match (documentData.j) {
                case 1 =>
                    justify = "end"
                case 2 =>
                    justify = "middle"
                case _ =>
                    justify = "start"
            }
            tElement.setAttribute("text-anchor", justify)
            tElement.setAttribute("letter-spacing", "${trackingOffset}")
            var textContent = this.buildTextContents(documentData.finalText)
            len = textContent.size
            yPos = if (documentData.ps.size > 0) {
                documentData.ps[1] + documentData.ascent
            } else {
                0.0
            }
            i = 0
            while (i < len) {
                tSpan = if (this.textSpans.size > i) {
                    this.textSpans[i].span
                }else {
                    CreateNS("tspan")
                }
                tSpan.textContent = textContent[i]
                tSpan.setAttribute("x", "0")
                tSpan.setAttribute("y", "${yPos}")
                tElement.appendChild(tSpan)
                if (this.textSpans.size <= i) {
                    this.textSpans[i] = TextSpans(CreateNS(""), None)
                }
                this.textSpans[i].span = tSpan
                yPos += documentData.finalLineHeight
                i += 1
            }

            this.layerElement.appendChild(tElement)
        
    
        } else {
            var cachedSpansLength = this.textSpans.size
            var charData: FontCharacter
            i = 0
            while (i < len) {
                if (this.textSpans.size <= i) {
                    this.textSpans[i] = TextSpans(CreateNS(""), None)
                }
                if (usesGlyphs.size ==0 || !singleShape || i == 0) {
                    tSpan = if(cachedSpansLength > i) {
                        this.textSpans[i].span
                    }else {
                        if (usesGlyphs.size >0 ) {
                            CreateNS("g")
                        }else {
                            CreateNS("text")
                        }
                    }
                    if (cachedSpansLength <= i) {
                        tSpan.setAttribute("stroke-linecap", "butt")
                        tSpan.setAttribute("stroke-linejoin", "round")
                        tSpan.setAttribute("stroke-miterlimit", "4")
                        this.textSpans[i].span = tSpan
                        if (usesGlyphs.size > 0) {
                            var childSpan = CreateNS("g")
                            tSpan.appendChild(childSpan)
                            this.textSpans[i].childSpan = childSpan
                        }
                        this.textSpans[i].span = tSpan
                        this.layerElement.appendChild(tSpan)
                    }
                }

                matrixHelper.reset()
                if (singleShape) {
                    if (letters[i].n) {
                        xPos = -trackingOffset
                        yPos += documentData.yOffset
                        if (firstLine) {
                            yPos += 1.0
                        }else {
                            yPos += 0.0
                        }
                        firstLine = false
                    }
                    this.applyTextPropertiesToMatrix(documentData, matrixHelper, letters[i].line, xPos, yPos)
                    xPos += letters[i].l
                    xPos += trackingOffset
                }
                if (usesGlyphs.size > 0) {
                    charData = this.globalData.fontManager.getCharData(
                        documentData.finalText[i],
                        fontData.fStyle,
                        this.globalData.fontManager.getFontByName(documentData.f).fFamily
                    )
                    var glyphElement: SVGCompElement
                    // t === 1 means the character has been replaced with an animated shaped
                    if (charData.t == 1) {
                        // charData.data 类型暂时使用
                        glyphElement = SVGCompElement(Layer(), this.globalData)
                    } else {
                        var data = Datas()
                        if (charData.data.shapes.size > 0) {
                            data = this.buildShapeData(Datas(), documentData.finalSize)
                        }
                        glyphElement = SVGCompElement(Layer(), this.globalData)
                    }
                    if (this.textSpans[i].glyph.isSome()) {
                        var glyph = this.textSpans[i].glyph
                    }
                    glyphElement.prepareFrame(0.0)
                    glyphElement.renderFrame()
                    this.textSpans[i].childSpan.getOrThrow().appendChild(glyphElement.layerElement)
                    // when using animated shapes, the layer will be scaled instead of replacing the internal scale
                    // this might have issues with strokes and might need a different solution
                    if (charData.t == 1) {
                        this.textSpans[i].childSpan.getOrThrow().setAttribute("transform", "scale(" + "${documentData.finalSize / 100.0}" + "," + "${documentData.finalSize / 100.0}" + ")")
                    }
                } else {
                    if (singleShape) {
                        tSpan.setAttribute("transform", "translate(" + "${matrixHelper.props[12]}" + "," + "${matrixHelper.props[13]}" + ")")
                    }
                    tSpan.textContent = letters[i].val
                    tSpan.setAttributeNS("http://www.w3.org/XML/1998/namespace", "xml:space", "preserve")
                }
                i += 1
            }

            if (singleShape && tSpan!=CreateNS("")) {
                tSpan.setAttribute("d", shapeStr)
            }
        }
        while (i < this.textSpans.size) {
            this.textSpans[i].span.styles["display"] = "none"
            i += 1
        }

        this._sizeChanged = true
    }

    public func sourceRectAtTime() {
        //TODO : 未找到 getBBox
        this.renderInnerContent()
        var bbox: SourceRect = SourceRect()
        if (this._sizeChanged) {
            this._sizeChanged = false
            var textBox = TempBox()
            bbox = SourceRect(
                top: textBox.y,
                left: textBox.x,
                width: textBox.width,
                height: textBox.height,
            )
        }
        return bbox
    }

    public func getValue() {
        //TODO
        var len = this.textSpans.size
        var glyphElement: ?SVGCompElement
        for (i in 0..len) {
            glyphElement = this.textSpans[i].glyph
            if (glyphElement.isSome()) {
                glyphElement.getOrThrow().prepareFrame(this.data.st)
                if (glyphElement.getOrThrow()._mdf) {
                    this._mdf = true
                }
            }
        }
    }

    public func renderInnerContent() {
        if (!this.data.singleShape || this._mdf) {
            if (this.lettersChangedFlag ) {
                this._sizeChanged = true
                var renderedLetters = this.renderedLetters
                var letters: ArrayList<Letter> = this.textProperty.currentData.l
                var len = letters.size
                var renderedLetter: LetterProps = LetterProps()
                var textSpan: CreateNS
                var glyphElement: ?SVGCompElement = None
                for (i in 0..len) {
                    if (!letters[i].n) {
                        renderedLetter = renderedLetters[i]
                        textSpan = this.textSpans[i].span
                        glyphElement = this.textSpans[i].glyph
                        if (glyphElement.isSome()) {
                            glyphElement.getOrThrow().renderFrame()
                        }
                        if (renderedLetter._mdf.m) {
                            textSpan.setAttribute("transform", renderedLetter.m)
                        }
                        if (renderedLetter._mdf.o) {
                            textSpan.setAttribute("opacity", "${renderedLetter.o}")
                        }
                        if (renderedLetter._mdf.sw) {
                            textSpan.setAttribute("stroke-width", "${renderedLetter.sw}")
                        }
                        if (renderedLetter._mdf.sc) {
                            textSpan.setAttribute("stroke", renderedLetter.sc)
                        }
                        if (renderedLetter._mdf.fc) {
                            textSpan.setAttribute("fill", renderedLetter.fc)
                        }
                    }
                }
            }
        }
    }
}

public class TextSpans{
    public var span: CreateNS
    public var glyph: ?SVGCompElement 
    public var childSpan: ?CreateNS

    public init(span: CreateNS, glyph: ?SVGCompElement, childSpan!: ?CreateNS = None) {
        this.span = span
        this.glyph = glyph
        this.childSpan = childSpan
    }
}
public class TempBox {
    var x:      Int64 = 0     
    var y:      Int64 = 0        
    var width:  Int64 = 0      
    var height: Int64 = 0         
}
