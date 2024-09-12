/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.html_elements

internal import lottie4cj.utils.text.*
//TODO
public class HTextElement <: HBaseElement {

    var textSpans: ArrayList<CreateTag>
    var textPaths: ArrayList<CreateNS>
    var currentBBox: CurrentBBox
    var renderType: String
    var isMasked: Bool
    var compW: Float64 = 0.0
    var compH: Float64 = 0.0
    var renderedLetters: ArrayList<Object> = ArrayList<Object>()


    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        textSpans = ArrayList<CreateTag>()
        textPaths = ArrayList<CreateNS>()
        this.currentBBox = CurrentBBox(x: 999999,y: -999999,h: 0,w: 0)
        this.renderType = "svg"
        this.isMasked = false
    }

    public func createContent() {

        this.isMasked = this.checkMasks()
        if (this.isMasked) {
            this.renderType = "svg";
            this.compW = this.data.w
            this.compH = this.data.h
            this.svgElement.setAttribute("width", "${this.compW}")
            this.svgElement.setAttribute("height", "${this.compH}")
            var g = CreateNS("g")
            this.maskedElement.appendChild(g)
            this.innerElem = g
        } else {
            this.renderType = "html"
            this.innerElem = this.layerElement
        }
    }

    public func buildNewText() {
        var documentData = DocumentData()
        //未找到符合条件 documentData = this.textProperty.currentData
        this.renderedLetters =if (documentData.l.size > 0) {
            ArrayList<Object>(documentData.l.size)
        }else {
            ArrayList<Object>()
        }
        var innerElemStyle = this.innerElem.style
        var textColor = if (!documentData.fc.isEmpty()) {
            this.buildColor(documentData.fc)
        }else {
            "rgba(0,0,0,0)"
        }
        innerElemStyle.fill = textColor;
        innerElemStyle.color = textColor;
        if (documentData.sc.size > 0) {
            innerElemStyle.stroke = this.buildColor(documentData.sc);
            innerElemStyle.strokeWidth = "${documentData.sw}" + "px";
        }
        var fontData = this.globalData.fontManager.getFontByName(documentData.f);
        if (!this.globalData.fontManager.chars.size > 0) {
                innerElemStyle.fontSize = "${documentData.finalSize}" + "px";
                innerElemStyle.lineHeight = "${documentData.finalSize}" + "px";
                //未找到 innerElem.className
            if (fontData.fClass.size < 0) {
                innerElemStyle.fontFamily = fontData.fFamily;
                var fWeight = documentData.fWeight;
                var fStyle = documentData.fStyle;
                innerElemStyle.fontStyle = fStyle;
                innerElemStyle.fontWeight = fWeight;
            }
        }

        var letters = documentData.l;
        var len = letters.size
        var tSpan: CreateNS = CreateNS("")
        var tParent: CreateTag = CreateTag("")
        var tCont: CreateNS= CreateNS("")
        var matrixHelper = this.mHelper()
        var shapeStr = ""
        var cnt = 0
        for (i in 0..len) {
            if (this.globalData.fontManager.chars.size > 0) {
                if (!this.textPaths.size > cnt) {
                    tSpan = CreateNS("path");
                    tSpan.setAttribute("stroke-linecap", lineCapEnum[1]);
                    tSpan.setAttribute("stroke-linejoin", lineJoinEnum[2]);
                    tSpan.setAttribute("stroke-miterlimit", "4");
                } else {
                    tSpan = this.textPaths[cnt];
                }
                if (!this.isMasked) {
                    if (this.textSpans.size > cnt) {
                        tParent = this.textSpans[cnt];
                        // 未找到 children属性
                    } else {
                        tParent = CreateTag("div");
                        tParent.style.lineHeight = "0"
                        tCont = CreateNS("svg");
                        tCont.appendChild(tSpan);
                        styleDiv(tParent)
                    }
                }
            } else if (!this.isMasked) {
                if (this.textSpans.size > cnt) {
                    tParent = this.textSpans[cnt];
                    tSpan = this.textPaths[cnt];
                } else {
                    tParent = CreateTag("span");
                    styleDiv(tParent)
                    tSpan = (CreateTag("span") as CreateNS).getOrThrow()
                    styleDiv(tSpan)
                    tParent.appendChild(tSpan);
                }
            } else {
                tSpan = if (this.textPaths.size > cnt) {
                    this.textPaths[cnt]
                }else {
                    CreateNS("text")
                }
            }
            tSpan.setAttribute("visibility", "hidden");
            if (this.globalData.fontManager.chars.size > 0) {
                var charData: Option<FontCharacter> = this.globalData.fontManager.getCharData(documentData.finalText[i], fontData.fStyle, this.globalData.fontManager.getFontByName(documentData.f).fFamily);
                var shapeData: ?CharsData
                if (charData.isSome()) {
                    shapeData = charData.getOrThrow().data;
                } else {
                    shapeData = None
                }
                matrixHelper.reset();
                if (shapeData.isSome() && shapeData.getOrThrow().shapes.size > 0) {
                    // ContentModel未找到it属性，需要的类型为 Array<ContentModel>  shapes = shapeData.getOrThrow().shapes[0].it;
                    matrixHelper.scale(documentData.finalSize / 100.0, documentData.finalSize / 100.0);
                    //属于 ITextElement 类型里面的 shapeStr = this.createPathShape(matrixHelper, shapes);
                    tSpan.setAttribute("d", shapeStr);
                }
                if (!this.isMasked) {
                    this.innerElem.appendChild((tParent as CreateNS).getOrThrow());
                    if (shapeData.isSome() && shapeData.getOrThrow().shapes.size > 0) {
                        // document.body.appendChild is needed to get exact measure of shape
                        //类型 document.body 找不到 document.body.appendChild(tCont);
                        // 未在 cj 找到 getBBox,使用  TempBoundingBox
                        var boundingBox = TempBoundingBox();
                        tCont.setAttribute("width", "${boundingBox.width + 2}");
                        tCont.setAttribute("height", "${boundingBox.height + 2}");
                        tCont.setAttribute("viewBox", "${(boundingBox.x - 1)}" + " " + "${(boundingBox.y - 1)}" + " " + "${(boundingBox.width + 2)}" + " " + "${(boundingBox.height + 2)}");
                        var tContStyle = tCont.style;
                        var tContTranslation = "translate(" + "${(boundingBox.x - 1)}" + "px," + "${(boundingBox.y - 1)}" + "px)";
                        tContStyle.transform = tContTranslation;
                        tContStyle.webkitTransform = tContTranslation;
                       letters[i].yOffset = boundingBox.y - 1
                    } else {
                        tCont.setAttribute("width", "${1}");
                        tCont.setAttribute("height", "${1}");
                    }
                    tParent.appendChild(tCont);
                } else {
                    this.innerElem.appendChild(tSpan);
                }
            } else {
                tSpan.textContent = letters[i].val;
                tSpan.setAttributeNS("http://www.w3.org/XML/1998/namespace", "xml:space", "preserve");
                if (!this.isMasked) {
                    this.innerElem.appendChild(tParent);
                    var tStyle = tSpan.style;
                    var tSpanTranslation = "translate3d(0," + "${-documentData.finalSize / 1.2}" + "px,0)";
                    tStyle.transform = tSpanTranslation;
                    tStyle.webkitTransform = tSpanTranslation;
                } else {
                    this.innerElem.appendChild(tSpan);
                }
            }
            
            if (!this.isMasked) {
                this.textSpans[cnt] = tParent;
            } else {
                this.textSpans[cnt] = (tSpan as CreateTag).getOrThrow()
            }
            this.textSpans[cnt].style.display = "block";
            this.textPaths[cnt] = tSpan;
            cnt += 1;
        }
        while (cnt < this.textSpans.size) {
            this.textSpans[cnt].style.display = "none";
            cnt += 1;
         }
    }

    public func renderInnerContent() {
        var svgStyle: TagStyle = TagStyle()
        if (this.data.singleShape) {
            // 类型ITextElement未继承，lettersChangedFlag if (!this._isFirstFrame && !this.lettersChangedFlag) {
            if (!this._isFirstFrame ) {
                return;
            } else if (this.isMasked && this.finalTransform._matMdf) {
                // Todo Benchmark if using this is better than getBBox
                this.svgElement.setAttribute("viewBox", "${-this.finalTransform.mProp.p.v[0]}" + " " + "${-this.finalTransform.mProp.p.v[1]}" + " " + "${this.compW}" + " " + "${this.compH}");
                svgStyle = this.svgElement.style;
                var translation = "translate(" + "${-this.finalTransform.mProp.p.v[0]}" + "px," + "${-this.finalTransform.mProp.p.v[1]}" + "px)";
                svgStyle.transform = translation;
                svgStyle.webkitTransform = translation;
            }
        }
        //TODO  类型ITextElement 的 textAnimator 和 lettersChangedFlag

        var count = 0;
        //this.textAnimator未调用，使用 ArrayList替代
        var renderedLetters = ArrayList<LetterProps>(24);
        // ITextElement 的textProperty调用不到 this.textProperty.currentData
        var letters = DocumentData().l;

        var len = letters.size
        var renderedLetter: LetterProps
        var textSpan: CreateTag
        var textPath: CreateNS
        for (i in 0..len) {
            if (letters[i].n) {
                count += 1;
            } else {
                textSpan = this.textSpans[i];
                textPath = this.textPaths[i];
                renderedLetter = renderedLetters[count];
                count += 1;
                if (renderedLetter._mdf.m) {
                    if (!this.isMasked) {
                        textSpan.style.webkitTransform = renderedLetter.m;
                        textSpan.style.transform = renderedLetter.m;
                    } else {
                        textSpan.setAttribute("transform", renderedLetter.m);
                    }
                }

                textSpan.style.opacity = renderedLetter.o;
                if (renderedLetter.sw != 0 && renderedLetter._mdf.sw) {
                    textPath.setAttribute("stroke-width", "${renderedLetter.sw}");
                }
                if (renderedLetter.sc.size > 0 && renderedLetter._mdf.sc) {
                    textPath.setAttribute("stroke", renderedLetter.sc);
                }
                if (renderedLetter.fc.size > 0 && renderedLetter._mdf.fc) {
                    textPath.setAttribute("fill", renderedLetter.fc);
                    textPath.style.color = renderedLetter.fc;
                }
            }
        }

        if (!this.hidden && (this._isFirstFrame || this._mdf)) {
            //未找到 getBBox() this.innerElem.getBBox();
            var boundingBox = TempBoundingBox();

            if (this.currentBBox.w != boundingBox.width) {
                this.currentBBox.w = boundingBox.width;
                this.svgElement.setAttribute("width", "${boundingBox.width}");
            }
            if (this.currentBBox.h != boundingBox.height) {
                this.currentBBox.h = boundingBox.height;
                this.svgElement.setAttribute("height", "${boundingBox.height}");
            }

            var margin = 1;
            if (this.currentBBox.w != (boundingBox.width + margin * 2) || this.currentBBox.h != (boundingBox.height + margin * 2) || this.currentBBox.x != (boundingBox.x - margin) || this.currentBBox.y != (boundingBox.y - margin)) {
                this.currentBBox.w = boundingBox.width + margin * 2;
                this.currentBBox.h = boundingBox.height + margin * 2;
                this.currentBBox.x = boundingBox.x - margin;
                this.currentBBox.y = boundingBox.y - margin;

                this.svgElement.setAttribute("viewBox", "${this.currentBBox.x}" + " " + "${this.currentBBox.y}" + " " + "${this.currentBBox.w}" + " " + "${this.currentBBox.h}");
                svgStyle = this.svgElement.style;
                var svgTransform = "translate(" + "${this.currentBBox.x}" + "px," + "${this.currentBBox.y}" + "px)";
                svgStyle.transform = svgTransform;
                svgStyle.webkitTransform = svgTransform;
            }
        }
    }

    public func buildColor(colorData: Array<Float64>): String {
        return "rgb(" + round(colorData[0] * 255.0).toString() +
        "," + round(colorData[1] * 255.0).toString() +
        "," + round(colorData[2] * 255.0).toString() + ")"
    }
}