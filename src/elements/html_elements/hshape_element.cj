/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.html_elements

internal import std.math.*
//TODO
public class HShapeElement <: HBaseElement {
    var currentBBox: CurrentBBox
    var shapesContainer: CreateNS
    var prevViewData: ArrayList<Object>
    var stylesList: ArrayList<Object>
    var shapeModifiers: ArrayList<Object>
    var processedElements: ArrayList<Object>
    var animatedContents: ArrayList<Object>
    var shapes: ArrayList<Object>
    var shapeCont: CreateNS = CreateNS("")
    var shapeBoundingBox: ShapeBoundingBox = ShapeBoundingBox()
    var tempBoundingBox: TempBoundingBox = TempBoundingBox()

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.shapes = ArrayList<Object>()
        this.shapesData = data.shapes
        this.stylesList = ArrayList<Object>()
        this.shapeModifiers = ArrayList<Object>()
        this.itemsData = Array<ContentModel>()
        this.processedElements = ArrayList<Object>()
        this.animatedContents = ArrayList<Object>()
        this.shapesContainer = CreateNS("g")
        this.prevViewData = ArrayList<Object>()
        this.currentBBox = CurrentBBox(x: 999999, y: -999999, h: 0, w: 0)
    }

    public func createContent() {
        var cont: CreateNS
        if (this.data.hasMask) {
            this.layerElement.appendChild(this.shapesContainer)
            cont = this.svgElement
        } else {
            cont = CreateNS("svg")
            var size: CompSize = this.globalData.compSize
            cont.setAttribute("width", "${size.w}")
            cont.setAttribute("height", "${size.h}")
            cont.appendChild(this.shapesContainer)
            this.layerElement.appendChild(cont)
        }
        // //TODO: 暂时无 SVGShapeElement 类型的函数 searchShapes 和 filterUniqueShapes
        this.shapeCont = cont
    }

    public func getTransformedPoint(transformers: Array<SvgTransforms>, points: Array<Float64>) {
        var point: Array<Float64> = points
        var len = transformers.size
        for (i in 0..len) {
            point = transformers[i].mProps.v.applyToPointArray(point[0], point[1], 0.0)
        }
        return point
    }

    public func calculateShapeBoundingBox(item: ElementData, boundingBox: BoundingBox) {
        var shape = item.sh.getOrThrow().v
        var transformers = item.transformers
        var len = shape._length
        var vPoint: Array<Float64>
        var oPoint: Array<Float64>
        var nextIPoint: Array<Float64>
        var nextVPoint: Array<Float64>
        if (len <= 1) {
            return
        }
        var i = 0
        while (i < len - 1) {
            vPoint = this.getTransformedPoint(transformers, shape.v[i])
            oPoint = this.getTransformedPoint(transformers, shape.o[i])
            nextIPoint = this.getTransformedPoint(transformers, shape.i[i + 1])
            nextVPoint = this.getTransformedPoint(transformers, shape.v[i + 1])
            i += 1
        }
        if (shape.c > 0) {
            vPoint = this.getTransformedPoint(transformers, shape.v[i])
            oPoint = this.getTransformedPoint(transformers, shape.o[i])
            nextIPoint = this.getTransformedPoint(transformers, shape.i[0])
            nextVPoint = this.getTransformedPoint(transformers, shape.v[0])
        }
    }

    public func checkBounds(vPoint: Array<Float64>, oPoint: Array<Float64>, nextIPoint: Array<Float64>,
        nextVPoint: Array<Float64>, boundingBox: BoundingBox) {
        this.getBoundsOfCurve(vPoint, oPoint, nextIPoint, nextVPoint)
        var bounds = this.shapeBoundingBox
        boundingBox.x = min(bounds.left, boundingBox.x)
        boundingBox.xMax = min(bounds.right, boundingBox.xMax)
        boundingBox.y = min(bounds.top, boundingBox.y)
        boundingBox.yMax = min(bounds.bottom, boundingBox.yMax)
    }

    public func getBoundsOfCurve(p0: Array<Float64>, p1: Array<Float64>, p2: Array<Float64>, p3: Array<Float64>) {
        var bounds: ArrayList<ArrayList<Float64>> = ArrayList<ArrayList<Float64>>(ArrayList<Float64>([p0[0], p3[0]]),
            ArrayList<Float64>([p0[1], p3[1]]))

        var a: Float64 = 0.0
        var b: Float64 = 0.0
        var c: Float64 = 0.0
        var t: Float64 = 0.0
        var b2ac: Float64 = 0.0
        var t1: Float64 = 0.0
        var t2: Float64 = 0.0

        for (i in 0..2) { // eslint-disable-line no-plusplus
            b = 6.0 * p0[i] - 12.0 * p1[i] + 6.0 * p2[i]
            a = -3.0 * p0[i] + 9.0 * p1[i] - 9.0 * p2[i] + 3.0 * p3[i]
            c = 3.0 * p1[i] - 3.0 * p0[i]

            if (a == 0.0 && b == 0.0) {
            //
            } else if (a == 0.0) {
                t = -c / b

                if (t > 0.0 && t < 1.0) {
                    bounds[i].append(this.calculateF(t, p0, p1, p2, p3, i))
                }
            } else {
                b2ac = b * b - 4.0 * c * a

                if (b2ac >= 0.0) {
                    t1 = (-b + sqrt(b2ac)) / (2.0 * a)
                    if (t1 > 0.0 && t1 < 1.0) {
                        bounds[i].append(this.calculateF(t1, p0, p1, p2, p3, i))
                    }
                    t2 = (-b - sqrt(b2ac)) / (2.0 * a)
                    if (t2 > 0.0 && t2 < 1.0) {
                        bounds[i].append(this.calculateF(t2, p0, p1, p2, p3, i))
                    }
                }
            }
        }
        bounds[0].sortBy(
            stable: false,
            comparator: {
                rht: Float64, lht: Float64 =>
                return rht.compare(lht)
            }
        )
        bounds[1].sortBy(
            stable: false,
            comparator: {
                rht: Float64, lht: Float64 =>
                return rht.compare(lht)
            }
        )
        this.shapeBoundingBox.left = bounds[0][0]
        this.shapeBoundingBox.top = bounds[1][0]
        this.shapeBoundingBox.right = bounds[0][bounds[0].size - 1]
        this.shapeBoundingBox.bottom = bounds[1][bounds[1].size - 1]
    }

    public func calculateF(t: Float64, p0: Array<Float64>, p1: Array<Float64>, p2: Array<Float64>, p3: Array<Float64>,
        i: Int64): Float64 {
        return pow(1.0 - t, 3) * p0[i] + 3.0 * pow(1.0 - t, 2) * t * p1[i] + 3.0 * (1.0 - t) * pow(t, 2) * p2[i] +
            pow(t, 3) * p3[i]
    }

    public func calculateBoundingBox(itemsData: Array<ElementData>, boundingBox: BoundingBox): Unit {
        var len = itemsData.size
        for (i in 0..len : 1) {
            if (itemsData[i].sh.isSome()) {
                this.calculateShapeBoundingBox(itemsData[i], boundingBox)
            } else if (itemsData[i].it.size > 0) {
                this.calculateBoundingBox(itemsData[i].it, boundingBox)
            } else if (let Some(v) <- itemsData[i].w) {
                this.expandStrokeBoundingBox(v, boundingBox)
            }
        }
    }

    public func expandStrokeBoundingBox(widthProperty: ElementDataw, boundingBox: BoundingBox) {
        var width: Float64 = 0.0
        if (widthProperty.keyframes.size > 0) {
            for (i in 0..widthProperty.keyframes.size) {
                var kfw = widthProperty.keyframes[i].s.getOrThrow()
                if (kfw > width) {
                    width = kfw
                }
            }
            width *= widthProperty.mult
        } else {
            width = widthProperty.v * widthProperty.mult;
        }
        boundingBox.x -= width
        boundingBox.xMax += width
        boundingBox.y -= width
        boundingBox.yMax += width
    }

    public func currentBoxContains(box: TempBoundingBox) {
        return this.currentBBox.x <= box.x && this.currentBBox.y <= box.y &&
            this.currentBBox.width + this.currentBBox.x >= box.x + box.width &&
            this.currentBBox.height + this.currentBBox.y >= box.y + box.height
    }

    public func renderInnerContent() {
        if (!this.hidden && (this._isFirstFrame || this._mdf)) {
            var tempBoundingBox = this.tempBoundingBox
            var max = 999999
            tempBoundingBox.x = max
            tempBoundingBox.xMax = -max
            tempBoundingBox.y = max
            tempBoundingBox.yMax = -max
            // 使用ElementData 代替 this.itemsData，BoundingBox代替  tempBoundingBox
            this.calculateBoundingBox([ElementData()], BoundingBox())
            tempBoundingBox.width = if (tempBoundingBox.xMax < tempBoundingBox.x) {
                0
            } else {
                tempBoundingBox.xMax - tempBoundingBox.x
            }
            tempBoundingBox.height = if (tempBoundingBox.yMax < tempBoundingBox.y) {
                0
            } else {
                tempBoundingBox.yMax - tempBoundingBox.y
            }
            if (this.currentBoxContains(tempBoundingBox)) {
                return
            }
            var changed = false
            if (this.currentBBox.w != tempBoundingBox.width) {
                this.currentBBox.w = tempBoundingBox.width
                this.shapeCont.setAttribute("width", "${tempBoundingBox.width}")
                changed = true
            }
            if (this.currentBBox.h != tempBoundingBox.height) {
                this.currentBBox.h = tempBoundingBox.height
                this.shapeCont.setAttribute("height", "${tempBoundingBox.height}")
                changed = true
            }
            if (changed || this.currentBBox.x != tempBoundingBox.x || this.currentBBox.y != tempBoundingBox.y) {
                this.currentBBox.w = tempBoundingBox.width
                this.currentBBox.h = tempBoundingBox.height
                this.currentBBox.x = tempBoundingBox.x
                this.currentBBox.y = tempBoundingBox.y

                this.shapeCont.setAttribute("viewBox", "${this.currentBBox.x}" + " " + "${this.currentBBox.y}" + " " + "${this.currentBBox.w}" + " " + "${this.currentBBox.h}")
                var shapeStyle = this.shapeCont.styles
                var shapeTransform = "translate(" + "${this.currentBBox.x}" + "px," + "${this.currentBBox.y}" + "px)"
                shapeStyle.put("transform", shapeTransform)
                shapeStyle.put("webkitTransform", shapeTransform)
            }
        }
    }
}

public class CurrentBBox {
    var x: Int64
    var y: Int64
    var h: Int64
    var w: Int64
    var width: Int64
    var height: Int64

    public init(x!: Int64 = 0, y!: Int64 = 0, h!: Int64 = 0, w!: Int64 = 0, width!: Int64 = 0, height!: Int64 = 0) {
        this.x = x
        this.y = y
        this.h = h
        this.w = w
        this.width = width
        this.height = height
    }
}

public class BoundingBox {
    var x: Float64
    var xMax: Float64
    var y: Float64
    var yMax: Float64

    public init(x!: Float64 = 0.0, xMax!: Float64 = 0.0, y!: Float64 = 0.0, yMax!: Float64 = 0.0) {
        this.x = x
        this.xMax = xMax
        this.y = y
        this.yMax = yMax
    }
}

public class ShapeBoundingBox {
    var left: Float64
    var right: Float64
    var top: Float64
    var bottom: Float64

    public init(left!: Float64 = 0.0, right!: Float64 = 0.0, top!: Float64 = 0.0, bottom!: Float64 = 0.0) {
        this.left = left
        this.right = right
        this.top = top
        this.bottom = bottom
    }
}

public class TempBoundingBox {
    var x: Int64
    var xMax: Int64
    var y: Int64
    var yMax: Int64
    var width: Int64
    var height: Int64

    public init(x!: Int64 = 0, xMax!: Int64 = 0, y!: Int64 = 0, yMax!: Int64 = 0, width!: Int64 = 0, height!: Int64 = 0) {
        this.x = x
        this.xMax = xMax
        this.y = y
        this.yMax = yMax
        this.width = width
        this.height = height
    }
}
