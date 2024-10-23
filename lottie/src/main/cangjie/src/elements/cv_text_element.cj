/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

internal import ohos.font.*

//TODO: 未完全实现
public class CvTextElement <: ITextElement {
    var textSpans: ArrayList<TextSpans>

    var yOffset: Int64

    var fillColorAnim: Bool

    var strokeColorAnim: Bool

    var strokeWidthAnim: Bool

    var stroke: Bool

    var fill: Bool

    var justifyOffset: Int64

    var currentRender: Option<String>

    //TODO：父类 ITextElement 中存在此成员变量 //var renderType: String

    var values: ValuesData

    //TODO comp

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.textSpans = ArrayList<TextSpans>()
        this.yOffset = 0
        this.fillColorAnim = false
        this.strokeColorAnim = false
        this.strokeWidthAnim = false
        this.stroke = false
        this.fill = false
        this.justifyOffset = 0
        this.currentRender = None
        this.renderType = "canvas"
        this.values = ValuesData(Color(0, 0, 0, alpha: 0.0), Color(0, 0, 0, alpha: 0.0), 0.0,
            FValue(Length(0.0, unitType: LengthType.px), ""))
        this.initElement(data, globalData)
    }

    public func tHelper() {}

    public func buildNewText() {
        var documentData = this.textProperty.currentData
        var hasFill = false
        if (documentData.fc.isEmpty()) {
            this.values.fill = Color(0, 0, 0, alpha: 0.0)
        } else {
            hasFill = true
            this.values.fill = this.buildColor(documentData.fc)
        }
        this.fill = hasFill
        var hasStroke = false
        if (!documentData.sc.isEmpty()) {
            hasStroke = true
            this.values.stroke = this.buildColor(documentData.sc)
            this.values.sWidth = documentData.sw
        }

        var fontData = this.globalData.fontManager.getFontByName(documentData.f)
        var letters: ArrayList<Letter> = documentData.l
        var matrixHelper: Matrix = Matrix()
        this.stroke = hasStroke
        //this.values.fValue = "${documentData.finalSize}" + "px " + this.globalData.fontManager.getFontByName(documentData.f).fFamily
        this.values.fValue.value1 = Length(documentData.finalSize, unitType: LengthType.px)
        this.values.fValue.value2 = this.globalData.fontManager.getFontByName(documentData.f).fFamily
        var len: Int64 = documentData.finalText.size
        var xPos = 0.0
        var yPos = 0.0
        var firstLine = true
        var cnt = 0
        var singleShape = this.data.singleShape
        var trackingOffset = Float64(documentData.tr) * 0.001 * documentData.finalSize
        for (i in 0..len) {
            var charData = this.globalData.fontManager.getCharData(documentData.finalText[i], fontData.fStyle,
                this.globalData.fontManager.getFontByName(documentData.f).fFamily)
            var shapeData = charData.data
            matrixHelper.reset()
            if (singleShape && letters[i].n) {
                xPos = -trackingOffset
                yPos += documentData.yOffset
                if (firstLine) {
                    yPos += 1.0
                } else {
                    yPos += 0.0
                }
                firstLine = false
            }
            var shapes = if (shapeData.shapes.size > 0) {
                (shapeData.shapes[0] as ShapeGroup).getOrThrow().it
            } else {
                Array<ContentModel>()
            }
            var jLen = shapes.size
            matrixHelper.scale(documentData.finalSize / 100.0, documentData.finalSize / 100.0);
            if (singleShape) {
                this.applyTextPropertiesToMatrix(documentData, matrixHelper, letters[i].line, xPos, yPos);
            }
            var commands = Array<ArrayList<Float64>>(jLen - 1,item:ArrayList<Float64>())
            var commandsCounter = 0;
            for (j in 0..jLen) {
                if (shapes[j].ty == "sh") {
                    var pathNodes = ((shapes[j] as ShapePath).getOrThrow().ks[0] as Keyframe<ShapeData>).getOrThrow().k.getOrThrow()
                    var kLen = pathNodes.i.size
                    var pathArr = ArrayList<Float64>()
                    var k = 1
                    while (k < kLen) {
                        if (k == 1) {
                            pathArr.appendAll([matrixHelper.applyToX(pathNodes.v[0].x, pathNodes.v[0].y, 0.0),
                                matrixHelper.applyToY(pathNodes.v[0].x, pathNodes.v[0].y, 0.0)])
                        }
                        pathArr.appendAll([matrixHelper.applyToX(pathNodes.o[k - 1].x, pathNodes.o[k - 1].y, 0.0),
                            matrixHelper.applyToY(pathNodes.o[k - 1].x, pathNodes.o[k - 1].y, 0.0),
                            matrixHelper.applyToX(pathNodes.i[k].x, pathNodes.i[k].y, 0.0),
                            matrixHelper.applyToY(pathNodes.i[k].x, pathNodes.i[k].y, 0.0),
                            matrixHelper.applyToX(pathNodes.v[k].x, pathNodes.v[k].y, 0.0),
                            matrixHelper.applyToY(pathNodes.v[k].x, pathNodes.v[k].y, 0.0)]);
                        k += 1
                    }
                    pathArr.appendAll([matrixHelper.applyToX(pathNodes.o[k - 1].x, pathNodes.o[k - 1].y, 0.0),
                        matrixHelper.applyToY(pathNodes.o[k - 1].x, pathNodes.o[k - 1].y, 0.0),
                        matrixHelper.applyToX(pathNodes.i[0].x, pathNodes.i[0].y, 0.0),
                        matrixHelper.applyToY(pathNodes.i[0].x, pathNodes.i[0].y, 0.0),
                        matrixHelper.applyToX(pathNodes.v[0].x, pathNodes.v[0].y, 0.0),
                        matrixHelper.applyToY(pathNodes.v[0].x, pathNodes.v[0].y, 0.0)]);
                    commands[commandsCounter] = pathArr
                    commandsCounter += 1
                }
            }
            if (singleShape) {
                xPos += letters[i].l
                xPos += trackingOffset
            }
            if (this.textSpans.size > cnt) {
                this.textSpans[cnt].elem = commands
            } else {
                this.textSpans[cnt] = TextSpans(commands)
            }
            cnt += 1
        }
    }
    public override func renderInnerContent() {
        var ctx = this.canvasContext;
        ctx.font(size: this.values.fValue.value1, family: this.values.fValue.value2)
        ctx.lineCap(LineCapStyle.Butt)
        ctx.lineJoin(LineJoinStyle.Miter)
        ctx.miterLimit(4)

        if (!this.data.singleShape) {
            this.textAnimator.getMeasures(this.textProperty.currentData, this.lettersChangedFlag)
        }

        var jLen: Int64
        var kLen: Int64
        var renderedLetters: ArrayList<LetterProps> = this.textAnimator.renderedLetters;
        var letters = this.textProperty.currentData.l
        var len = letters.size
        var renderedLetter: ?LetterProps = None
                  var lastFill = Color(0,0,0)
                  var lastStroke = Color(0,0,0)
                  var lastStrokeW: Int64 = -1
                  var commands = Array<ArrayList<Float64>>()
                  var pathArr=ArrayList<Float64>()
                  for (i in 0..len) {
                    if (!letters[i].n) {
                        if (let Some(v) <- renderedLetters.get(i)) {
                            renderedLetter = v
        //                    this.globalData.renderer.save();
        //                    this.globalData.renderer.ctxTransform(renderedLetter.p);
        //                    this.globalData.renderer.ctxOpacity(renderedLetter.o);
                        }
                      if (this.fill) {
                        if (renderedLetter.isSome() && renderedLetter.getOrThrow().fc.toUInt32() != Color(0,0,0).toUInt32()) {
                          if (lastFill.toUInt32() != renderedLetter.getOrThrow().fc.toUInt32()) {
                            lastFill = renderedLetter.getOrThrow().fc;
                            ctx.fillStyle(renderedLetter.getOrThrow().fc)
                          }
                        } else if (lastFill.toUInt32() != this.values.fill.toUInt32()) {
                          lastFill = this.values.fill;
                          ctx.fillStyle(this.values.fill)
                        }
                        commands = this.textSpans[i].elem;
                        jLen = commands.size
                        this.globalData.canvasContext.beginPath();
                        for (j in 0..jLen) {
                          pathArr = commands[j]
                          kLen = pathArr.size
                          this.globalData.canvasContext.moveTo(pathArr[0], pathArr[1]);
                          for (k in 2..kLen: 6) {
                            this.globalData.canvasContext.bezierCurveTo(pathArr[k], pathArr[k + 1], pathArr[k + 2], pathArr[k + 3], pathArr[k + 4], pathArr[k + 5]);
                          }
                        }
                        this.globalData.canvasContext.closePath();
                        this.globalData.canvasContext.fill();
                        /// ctx.fillText(this.textSpans[i].val,0,0);
                      }
                      if (this.stroke) {
                        if (renderedLetter.isSome() && renderedLetter.getOrThrow().sw !=0) {
                          if (lastStrokeW != renderedLetter.getOrThrow().sw) {
                            lastStrokeW = renderedLetter.getOrThrow().sw;
                            ctx.lineWidth(renderedLetter.getOrThrow().sw)
                          }
                        } else if (Float64(lastStrokeW) != this.values.sWidth) {
                          lastStrokeW = Int64(this.values.sWidth);
                          ctx.lineWidth(this.values.sWidth)
                        }
                        if (renderedLetter.isSome() && renderedLetter.getOrThrow().sc.toUInt32() != Color(0,0,0).toUInt32()) {
                          if (lastStroke.toUInt32() != renderedLetter.getOrThrow().sc.toUInt32() ) {
                            lastStroke = renderedLetter.getOrThrow().sc;
                            ctx.strokeStyle(renderedLetter.getOrThrow().sc)
                          }
                        } else if (lastStroke.toUInt32() != this.values.stroke.toUInt32()) {
                          lastStroke = this.values.stroke;
                          ctx.strokeStyle(this.values.stroke)
                        }
                        commands = this.textSpans[i].elem;
                        jLen = commands.size
                        this.globalData.canvasContext.beginPath();
                        for (j in 0..jLen) {
                          pathArr = commands[j];
                          kLen = pathArr.size
                          this.globalData.canvasContext.moveTo(pathArr[0], pathArr[1]);
                          for (k in 2..kLen:6) {
                            this.globalData.canvasContext.bezierCurveTo(pathArr[k], pathArr[k + 1], pathArr[k + 2], pathArr[k + 3], pathArr[k + 4], pathArr[k + 5]);
                          }
                        }
                        this.globalData.canvasContext.closePath();
                        this.globalData.canvasContext.stroke();
                        /// ctx.strokeText(letters[i].val,0,0);
                      }
                      if (renderedLetter.isSome()) {
                        //this.globalData.renderer.restore();
                      }
                    }
                  }
    }
}

public class ValuesData {
    var fill: Color
    var stroke: Color
    var sWidth: Float64
    var fValue: FValue

    public init(fill: Color, stroke: Color, sWidth: Float64, fValue: FValue) {
        this.fill = fill
        this.stroke = stroke
        this.sWidth = sWidth
        this.fValue = fValue
    }
}

public class FValue {
    var value1: Length
    var value2: String

    public init(value1: Length, value2: String) {
        this.value1 = value1
        this.value2 = value2
    }
}

public class TextSpans {
    var elem: Array<ArrayList<Float64>>
    public init(elem: Array<ArrayList<Float64>>) {
        this.elem = elem
    }
}
