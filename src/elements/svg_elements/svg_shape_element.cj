/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements.svg_elements

import lottie4cj.global_data.*
import lottie4cj.utils.helpers.lineJoinEnum
import lottie4cj.utils.helpers.lineCapEnum
//TODO
public open class SVGShapeElement {

    public var data: Layer
    public var globalData: GlobalData
    public var shapes: ArrayList<SVGShapeData>
    public var shapesData: ArrayList<Datas>
    public var stylesList: ArrayList<SVGStyleData>
    public var shapeModifiers: ArrayList<Object>
    public var itemsData: ArrayList<SVGNoStyleData>
    public var processedElements: ArrayList<Object> =  ArrayList<Object>()
    public var animatedContents: ArrayList<AnimatedContent>
    public var prevViewData: ArrayList<SVGNoStyleData>
    public var _isFirstFrame: Bool =  false
    public var _render: Bool =  false
    public var layerElement: CreateNS =  CreateNS("")

    public init(datalayer: Layer, dataGlobal: GlobalData) {
        this.data = datalayer
        this.globalData = dataGlobal
        this.shapes = ArrayList<SVGShapeData>()
        this.shapesData = ArrayList<Datas>()
        this.stylesList = ArrayList<SVGStyleData>()
        this.shapeModifiers = ArrayList<Object>()
        this.itemsData = ArrayList<SVGNoStyleData>()
        this.animatedContents = ArrayList<AnimatedContent>()
        this.prevViewData = ArrayList<SVGNoStyleData>()
    }

    public func initSecondaryElement() {}

    public func identityMatrix(): Matrix {
        return Matrix()
    }

    public func buildExpressionInterface() {}

    public func createContent() {
        this.searchShapes(this.shapesData, this.itemsData, this.prevViewData, this.layerElement, 0, ArrayList<ElementData>(), true)
        this.filterUniqueShapes()
    }

    public func filterUniqueShapes() {
        var len = this.shapes.size
        var shape: SVGShapeData
        var jLen = this.stylesList.size
        var style: SVGStyleData
        var tempShapes = ArrayList<SVGShapeData>()
        var areAnimated = false
        for (j in 0..jLen) {
            style = this.stylesList[j]
            areAnimated = false
            tempShapes.clear()
            for (i in 0..len) {
            shape = this.shapes[i]
            if (indexOf(style,shape.styles) != -1) {
                tempShapes.append(shape)
                areAnimated = shape._isAnimated || areAnimated
            }
            }
            if (tempShapes.size > 1 && areAnimated) {
                this.setShapesAsAnimated(tempShapes)
            }
        }
    }

    public func setShapesAsAnimated(shapes: ArrayList<SVGShapeData>) {
        var len = shapes.size
        for (i in 0..len) {
            shapes[i].setAsAnimated()
        }
    }

    // elementData 元素 暂时全部继承 SVGNoStyleData类
    public func createStyleElement(data: Datas, level: Int64) {
        var styleOb = SVGStyleData(data, level)
        var pathElement = styleOb.pElem
        var elementData: SVGNoStyleData = SVGNoStyleData(this, data, styleOb)
        if (data.ty == "st") {
            elementData = SVGStrokeStyleData(this, data, styleOb)
        } else if (data.ty == "fl") {
            elementData = SVGFillStyleData(this, data, styleOb)
        } else if (data.ty == "gf" || data.ty == "gs") {
            var elementData = if (data.ty == "gf") {
                SVGGradientFillStyleData(this, data, styleOb)
            }else {
                SVGGradientStrokeStyleData(this, data, styleOb)
            }
            this.globalData.defs.appendChild(elementData.gf)
            if (elementData.maskId.size > 0) {
                this.globalData.defs.appendChild(elementData.ms)
                this.globalData.defs.appendChild(elementData.of)
                pathElement.setAttribute("mask", "url(" + "${getLocationHref()}" + "#" + "${elementData.maskId}" + ")")
            }
        } else if (data.ty == "no") {
            elementData = SVGNoStyleData(this, data, styleOb)
        }

        if (data.ty == "st" || data.ty == "gs") {
            if (data.lc != 0) {
                pathElement.setAttribute("stroke-linecap", lineCapEnum[data.lc])
            }else {
                pathElement.setAttribute("stroke-linecap", lineCapEnum[2])
            }
            if (data.lj != 0) {
                pathElement.setAttribute("stroke-linejoin", lineJoinEnum[data.lj])
            }else {
                pathElement.setAttribute("stroke-linejoin", lineJoinEnum[2])
            }
            pathElement.setAttribute("fill-opacity", "0")
            if (data.lj == 1) {
                pathElement.setAttribute("stroke-miterlimit", data.ml)
            }
        }

        if (data.r == 2) {
            pathElement.setAttribute("fill-rule", "evenodd")
        }

        if (data.ln.size > 0) {
            pathElement.setAttribute("id", data.ln)
        }
        if (data.cl.size > 0) {
            pathElement.setAttribute("class", data.cl)
        }

        if (data.bm != 0) {
            pathElement.styles["mix-blend-mode"] = BlendModes.getBlendMode(data.bm)
        }
        this.stylesList.append(styleOb)
        //TODO
        return elementData
    }

    public func createGroupElement(data: Datas) {
        var elementData = ShapeGroupData()
        if (data.ln.size > 0) {
            elementData.gr.setAttribute("id", data.ln)
        }
        if (data.cl.size > 0) {
            elementData.gr.setAttribute("class", data.cl)
        }
        if (data.bm != 0) {
            elementData.gr.styles["mix-blend-mode"] = BlendModes.getBlendMode(data.bm)
        }
        return elementData
    }

    public func createTransformElement(data: Datas,container: Object) {
        //TODO
        var elementData = SVGTransformData()
        return elementData
    }

    public func  createShapeElement(data: Datas,ownTransformers: ArrayList<ElementData>, level: Int64) {
        var ty = 4
        if (data.ty == "rc") {
            ty = 5
        } else if (data.ty == "el") {
            ty = 6
        } else if (data.ty == "sr") {
            ty = 7
        }
        //TODO
        var elementData = SVGShapeData(ownTransformers, level, Object())
        this.shapes.append(elementData)
        return elementData
    }


    public func addToAnimatedContents(data: Datas, element: AnimatedContentElement) {
        var i = 0
        var len = this.animatedContents.size
        while (i < len) {
            if (refEq(this.animatedContents[i].element, element)) {
                return
            }
            i += 1
        }
        this.animatedContents.append(AnimatedContent( SVGElementsRenderer().createRenderFunction(data),  element, data))
    }

    public func setElementStyles(elementData: SVGShapeData) {
        var arr = elementData.styles
        var jLen = this.stylesList.size
        for (j in 0..jLen) {
            if (!this.stylesList[j].closed) {
                arr.append(this.stylesList[j])
            }
        }
    }

    public func reloadShapes() {
        this._isFirstFrame = true
        var len = this.itemsData.size
        for (i in 0..len) {
            this.prevViewData[i] = this.itemsData[i]
        }
        //TODO
        this.filterUniqueShapes()
        
    }

    public func searchShapes(arr: ArrayList<Datas>, itemsData: ArrayList<SVGNoStyleData>, prevViewData: ArrayList<SVGNoStyleData>, container: CreateNS, level: Int64, transformers: ArrayList<ElementData>, render: Bool) {
        //TODO
        var ownTransformers = transformers
        var len = arr.size - 1
        var ownStyles = ArrayList<SVGStyleData>()
        var ownModifiers = ArrayList<Object>()
        var currentTransform  = ElementData()
        var modifier: Object =Object()
        var processedPos: Int64 = 0
        var i = len
        while (i >= 0) {
            if (processedPos == 0) {
                arr[i]._render = render
            } else {
                itemsData[i] = prevViewData[processedPos - 1]
            }
            if (arr[i].ty == "fl" || arr[i].ty == "st" || arr[i].ty == "gf" || arr[i].ty == "gs" || arr[i].ty == "no") {
                if (processedPos == 0) {
                    itemsData[i] = this.createStyleElement(arr[i], level)
                } else {
                    itemsData[i].style.closed = false
                }
                if (arr[i]._render) {
                    if (itemsData[i].style.pElem != container) {
                        container.appendChild(itemsData[i].style.pElem)
                    }
                }
                ownStyles.append(itemsData[i].style)
            } else if (arr[i].ty == "gr") {
                if (processedPos == 0) {
                    itemsData[i] = SVGNoStyleData(this, arr[i], SVGStyleData(arr[i], level))
                }
               
            } else if (arr[i].ty == "tr") {
                ownTransformers.append(currentTransform)
            } else if (arr[i].ty == "sh" || arr[i].ty == "rc" || arr[i].ty == "el" || arr[i].ty == "sr") {
                if (processedPos == 0) {
                    //TODO
                }
            } else if (arr[i].ty == "tm" || arr[i].ty == "rd" || arr[i].ty == "ms" || arr[i].ty == "pb" || arr[i].ty == "zz" || arr[i].ty == "op") {
                if (processedPos == 0) {
                    this.shapeModifiers.append(modifier)
                } else {
                    modifier = itemsData[i]
                }
                ownModifiers.append(modifier)
            } else if (arr[i].ty == "rp") {
                if (processedPos == 0) {
                    this.shapeModifiers.append(modifier)
                } else {
                    modifier = itemsData[i]
                }
                ownModifiers.append(modifier)
            }
        }
        len = ownStyles.size
        for (i in 0..len) {
            ownStyles[i].closed = true
        }
        len = ownModifiers.size
    }

    public func renderInnerContent() {
        //TODO
        var len = this.stylesList.size
        for (i in 0..len) {
            this.stylesList[i].reset()
        }
        this.renderShape()
        for (i in 0..len) {
            if (this.stylesList[i]._mdf || this._isFirstFrame) {
                if (this.stylesList[i].msElem.isSome()) {
                    this.stylesList[i].msElem.getOrThrow().setAttribute("d", this.stylesList[i].d)
                    // Adding M0 0 fixes same mask bug on all browsers
                    this.stylesList[i].d = "M0 0" + this.stylesList[i].d
                }
                if (this.stylesList[i].d.size > 0) {
                    this.stylesList[i].pElem.setAttribute("d", this.stylesList[i].d )
                }else {
                    this.stylesList[i].pElem.setAttribute("d", "M0 0")
                }
            }
        } 
    }

    public func renderShape() {
        var len = this.animatedContents.size
        var animatedContent: AnimatedContent
        for (i in 0..len) {
            animatedContent = this.animatedContents[i]
            //TODO
        }
    }

    public func renderShapeColor(color: Array<Float64>, endColor: Array<Float64>) {
        //TODO
        var len = this.animatedContents.size
        var animatedContent: AnimatedContent
        for (i in 0..len) {
            animatedContent = this.animatedContents[i]
            if ((this._isFirstFrame || animatedContent.element._isAnimated)) {
                if ((animatedContent.element.c._mdf || this._isFirstFrame)) {
                    try {
                    if (endColor.size > 0 && endColor.size > 0) {
                        if (color.size == 4) {
                            animatedContent.element.c.data.k[0].s[0] = color[0] / 255.0
                            animatedContent.element.c.data.k[0].s[1] = color[1] / 255.0
                            animatedContent.element.c.data.k[0].s[2] = color[2] / 255.0

                            animatedContent.element.c.data.k[0].e[0] = endColor[0] / 255.0
                            animatedContent.element.c.data.k[0].e[1] = endColor[1] / 255.0
                            animatedContent.element.c.data.k[0].e[2] = endColor[2] / 255.0

                            animatedContent.element.o.v = color[3]
                        } else if (color.size == 3) {
                            animatedContent.element.c.data.k[0].s[0] = color[0] / 255.0
                            animatedContent.element.c.data.k[0].s[1] = color[1] / 255.0
                            animatedContent.element.c.data.k[0].s[2] = color[2] / 255.0

                            animatedContent.element.c.data.k[0].e[0] = endColor[0] / 255.0
                            animatedContent.element.c.data.k[0].e[1] = endColor[1] / 255.0
                            animatedContent.element.c.data.k[0].e[2] = endColor[2] / 255.0
                        } else if (color.size == 2) {
                            animatedContent.element.c.data.k[0].s[0] = color[0] / 255.0
                            animatedContent.element.c.data.k[0].s[2] = color[1] / 255.0

                            animatedContent.element.c.data.k[0].e[0] = endColor[0] / 255.0
                            animatedContent.element.c.data.k[0].e[2] = endColor[1] / 255.0
                        } else if (color.size == 1) {
                            animatedContent.element.c.data.k[0].s[0] = color[0] / 255.0
                            animatedContent.element.c.data.k[0].e[0] = endColor[0] / 255.0
                        }
                    } else {
                        if (color.size == 4) {
                            animatedContent.element.c.v[0] = color[0]
                            animatedContent.element.c.v[1] = color[1]
                            animatedContent.element.c.v[2] = color[2]
                            animatedContent.element.o.v = color[3]
                        } else if (color.size == 3) {
                            animatedContent.element.c.v[0] = color[0]
                            animatedContent.element.c.v[1] = color[1]
                            animatedContent.element.c.v[2] = color[2]
                        } else if (color.size == 2) {
                            animatedContent.element.c.v[0] = color[0]
                            animatedContent.element.c.v[2] = color[1]
                        } else if (color.size == 1) {
                            animatedContent.element.c.v[0] = color[0]
                        }
                    }
                    } catch (e: Exception) {
                    }
                
                } else {
                    try {
                        if ((animatedContent.element.g._cmdf || this._isFirstFrame)) {
                            var lens = 3
                            for (j in 0..lens) {
                                if (color.size >= 3) {
                                    animatedContent.element.g.c[j * 4] = color[0]
                                    animatedContent.element.g.c[j * 4 + 1] = color[0]
                                    animatedContent.element.g.c[j * 4 + 2] = color[1]
                                    animatedContent.element.g.c[j * 4 + 3] = color[2]
                                } else if (color.size == 2) {
                                    animatedContent.element.g.c[j * 4] = color[0]
                                    animatedContent.element.g.c[j * 4 + 1] = color[0]
                                    animatedContent.element.g.c[j * 4 + 2] = color[1]
                                } else if (color.size == 1) {
                                    animatedContent.element.g.c[j * 4] = color[0]
                                    animatedContent.element.g.c[j * 4 + 1] = color[0]
                                }
                            }
                        }
                    } catch (e: Exception) {
                    }
                }
            }
        }
    }

    public func destroy() {
        //TODO
        this.shapesData= ArrayList<Datas>()
        this.itemsData.clear()
    }
}

public class AnimatedContent {
    public var fn: RenderFunction
    public var element: AnimatedContentElement
    public var data: Datas
    public init(fn: RenderFunction,element: AnimatedContentElement, data: Datas) {
        this.fn = fn
        this.element = element
        this.data = data
    }
}

public class AnimatedContentElement {
    public var c: AnimatedContentElementc = AnimatedContentElementc()
    public var o: AnimatedContentElemento = AnimatedContentElemento()
    public var g: AnimatedContentElementg = AnimatedContentElementg()
    public var _isAnimated: Bool = false
}
public class AnimatedContentElementc {
    public var _mdf: Bool = false
    public var data: AnimatedContentElementData = AnimatedContentElementData()
    public var v: Array<Float64> = Array<Float64>()
}
public class AnimatedContentElementData {
    public var k: Array<AnimatedContentElementDatak> = Array<AnimatedContentElementDatak>()
}
public class AnimatedContentElementDatak {
    public var e: Array<Float64> = Array<Float64>()
    public var s: Array<Float64> = Array<Float64>()
}
public class AnimatedContentElementg {
    public var c: Array<Float64> = Array<Float64>()
    public var _cmdf: Bool = false
}
public class AnimatedContentElemento {
    public var v:Float64 = 0.0
}

