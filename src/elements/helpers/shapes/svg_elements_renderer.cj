/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements.helpers.shapes

import std.collection.*
import std.math.*

import lottie4cj.global_data.*
import lottie4cj.bezier.*
internal import lottie4cj.utils.helpers.*
import lottie4cj.model.*
public type RenderFunction = (Datas, ElementData, Bool) -> Unit
//TODO
public class SVGElementsRenderer {

    var _identityMatrix = Matrix()
    var _matrixHelper = Matrix()

    public func createRenderFunction(data: Datas): RenderFunction {
        match (data.ty) {
            case "fl" =>
                return renderContentTransform
            case "gf" =>
                return renderGradient
            case "gs" =>
                return renderGradientStroke
            case "st" =>
                return renderStroke
            case "sh" => 
                return renderPath 
            case "el" => 
                return renderPath
            case "rc" => 
                return renderPath
            case "sr" =>
                return renderPath
            case "tr" =>
                return renderContentTransform
            case "no" =>
                return renderNoop
            case _ =>
                return renderNull
        }
    }

    func renderNull(styleData: Datas, itemData: ElementData, isFirstFrame: Bool): Unit {
        //TODO
    }

    func renderContentTransform(styleData: Datas, itemData: ElementData, isFirstFrame: Bool): Unit {
        if (isFirstFrame || itemData.transform.op._mdf) {
            itemData.transform.container.setAttribute("opacity", itemData.transform.op.v)
        }
        if (isFirstFrame || itemData.transform.mProps._mdf) {
            itemData.transform.container.setAttribute("transform", itemData.transform.mProps.v.to2dCSS())
        }
    }

    func renderNoop(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {

    }

    func renderPath(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {
        var pathStringTransformed: String
        var redraw: Bool
        var pathNodes: Option<ShapeData>
        var lLen = itemData.styles.size
        var lvl = itemData.lvl
        var paths: ElementDataShPaths
        var mat: Matrix
        var props: Array<Float64>
        var iterations: Int64
        var k: Int64
        for (l in 0..lLen) {
            redraw = itemData.sh.getOrThrow()._mdf || isFirstFrame
            if (itemData.styles[l].lvl < lvl) {
                mat = _matrixHelper.reset()
                iterations = lvl - itemData.styles[l].lvl
                k = itemData.transformers.size - 1
                while (!redraw && iterations > 0) {
                    redraw = itemData.transformers[k].mProps._mdf || redraw
                    iterations -= 1
                    k -= 1
                }
                if (redraw) {
                    iterations = lvl - itemData.styles[l].lvl
                    k = itemData.transformers.size - 1
                    while (iterations > 0) {
                        props = itemData.transformers[k].mProps.v.props
                        mat.transform(props[0], props[1], props[2], props[3], props[4], props[5], props[6], props[7], props[8], props[9], props[10], props[11], props[12], props[13], props[14], props[15])
                        iterations -= 1
                        k -= 1
                    }
                }
            } else {
                mat = _identityMatrix
            }
            var paths = itemData.sh.getOrThrow().paths
            var jLen = paths._length
            if (redraw) {
                pathStringTransformed = ""
                for (j in 0..jLen) {
                    pathNodes = paths.shapes[j]
                    if (pathNodes.isSome() && pathNodes.getOrThrow()._length != 0) {
                        //TODO
                    }
                }
                itemData.caches[l] = pathStringTransformed
            } else {
                pathStringTransformed = itemData.caches[l]
            }
            if (styleData.hd == true) {
                itemData.styles[l].d +=""
            }else {
                itemData.styles[l].d +=pathStringTransformed
            }
            itemData.styles[l]._mdf = redraw || itemData.styles[l]._mdf
        }
    }

    func renderFill(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {
        var styleElem = itemData.style

        if (itemData.c._mdf || isFirstFrame) {
            styleElem.pElem.setAttribute("fill", "rgb(" + "${floor(itemData.c.v[0])}" + "," + "${floor(itemData.c.v[1])}" + "," + "${floor(itemData.c.v[2])}" + ")")
        }
        if (itemData.o._mdf || isFirstFrame) {
            styleElem.pElem.setAttribute("fill-opacity", itemData.o.v)
        }
    }

    func renderGradientStroke(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {
        renderGradient(styleData, itemData, isFirstFrame)
        renderStroke(styleData, itemData, isFirstFrame)
    }

    func renderGradient(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {
        var gfill = itemData.gf
        var hasOpacity = itemData.g._hasOpacity
        var pt1 = itemData.s.v
        var pt2 = itemData.e.v

        if (itemData.o._mdf || isFirstFrame) {
            var attr = if (styleData.ty == "gf") {
                "fill-opacity"
            }else {
                "stroke-opacity"
            }
            itemData.style.pElem.setAttribute(attr, itemData.o.v)
        }
        if (itemData.s._mdf || isFirstFrame) {
            var attr1 = if (styleData.t == 1) {
                "x1"
            }else {
                "cx"
            }
            var attr2 = if (attr1 == "x1") {
                "y1"
            }else {
                "cy"
            }
            gfill.setAttribute(attr1, "${pt1[0]}")
            gfill.setAttribute(attr2, "${pt1[1]}")
            if (hasOpacity !=0 && !itemData.g._collapsable) {
                itemData.of.setAttribute(attr1, "${pt1[0]}")
                itemData.of.setAttribute(attr2, "${pt1[1]}")
            }
        }
        var stops: Array<CreateNS>
        var len: Int64
        var stop: CreateNS
        if (itemData.g._cmdf || isFirstFrame) {
            stops = itemData.cst
            var cValues = itemData.g.c
            len = stops.size
            for (i in 0..len) {
                stop = stops[i]
                stop.setAttribute("offset", "${cValues[i * 4]}" + "%")
                stop.setAttribute("stop-color", "rgb(" + "${cValues[i * 4 + 1]}" + "," + "${cValues[i * 4 + 2]}" + "," + "${cValues[i * 4 + 3]}" + ")")
            }
        }
        if (hasOpacity !=0 && (itemData.g._omdf || isFirstFrame)) {
            var oValues = itemData.g.o
            if (itemData.g._collapsable) {
                stops = itemData.cst
            } else {
                stops = itemData.ost
            }
            len = stops.size
            for (i in 0..len) {
                stop = stops[i]
                if (!itemData.g._collapsable) {
                    stop.setAttribute("offset", "${oValues[i * 2]}" + "%")
                }
                stop.setAttribute("stop-opacity", "${oValues[i * 2 + 1]}")
            }
        }
        if (styleData.t == 1) {
            if (itemData.e._mdf || isFirstFrame) {
                gfill.setAttribute("x2", "${pt2[0]}")
                gfill.setAttribute("y2", "${pt2[1]}")
                if (hasOpacity != 0 && !itemData.g._collapsable) {
                    itemData.of.setAttribute("x2", "${pt2[0]}")
                    itemData.of.setAttribute("y2", "${pt2[1]}")
                }
            }
        } else {
            var rad: Float64 = 0.0
            if (itemData.s._mdf || itemData.e._mdf || isFirstFrame) {
                rad = sqrt(pow(pt1[0] - pt2[0], 2) + pow(pt1[1] - pt2[1], 2))
                gfill.setAttribute("r", "${rad}")
                if (hasOpacity != 0 && !itemData.g._collapsable) {
                    itemData.of.setAttribute("r", "${rad}")
                }
            }
            if (itemData.e._mdf || itemData.h._mdf || itemData.a._mdf || isFirstFrame) {
                if (rad == 0.0) {
                    rad = sqrt(pow(pt1[0] - pt2[0], 2) + pow(pt1[1] - pt2[1], 2))
                }
                var ang = atan(pt2[1] - pt1[1]/pt2[0] - pt1[0])

                var percent = itemData.h.v
                if (percent >= 1.0) {
                    percent = 0.99
                } else if (percent <= -1.0) {
                    percent = -0.99
                }
                var dist = rad * percent
                var x = cos(ang + itemData.a.v) * dist + pt1[0]
                var y = sin(ang + itemData.a.v) * dist + pt1[1]
                gfill.setAttribute("fx", "${x}")
                gfill.setAttribute("fy", "${y}")
                if (hasOpacity  !=0 && !itemData.g._collapsable) {
                    itemData.of.setAttribute("fx", "${x}")
                    itemData.of.setAttribute("fy", "${y}")
                }
            }
        }
    }

    func renderStroke(styleData: Datas, itemData: ElementData, isFirstFrame: Bool) {
        var styleElem = itemData.style
        var d = itemData.d
        if (d.isSome() && (d.getOrThrow()._mdf || isFirstFrame) && !d.getOrThrow().dashStr.isEmpty()) {
            styleElem.pElem.setAttribute("stroke-dasharray", d.getOrThrow().dashStr)
            styleElem.pElem.setAttribute("stroke-dashoffset", d.getOrThrow().dashoffset[0])
        }
        if (itemData.c._mdf || isFirstFrame) { 
            styleElem.pElem.setAttribute("stroke", "rgb(" + "${floor(itemData.c.v[0])}" + "," + "${floor(itemData.c.v[1])}" + "," + "${floor(itemData.c.v[2])}" + ")")
        }
        if (itemData.o._mdf || isFirstFrame) {
            styleElem.pElem.setAttribute("stroke-opacity", itemData.o.v)
        }
        if (itemData.w.getOrThrow()._mdf || isFirstFrame) {
            styleElem.pElem.setAttribute("stroke-width", "${itemData.w.getOrThrow().v}")
            if(let Some (vs) <- styleElem.msElem){
                vs.setAttribute("stroke-width", "${itemData.w.getOrThrow().v}") 
            }
        }
    }
}



