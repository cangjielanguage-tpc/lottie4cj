/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ShapePathForShapePool.
 */
package lottie4cj.utils

internal import std.collection.*

//TODO：需要和 ShapeData 合并么？？？    //public class ShapePath <: ToString 
public class ShapePathForShapePool <: ToString {
    
    public var c: Bool = false
    public var _length: Int64 = 0
    public var _maxLength: Int64 = 8
    public var v: HashMap<Int64, PointF> = HashMap<Int64, PointF>(_maxLength)
    public var i: HashMap<Int64, PointF> = HashMap<Int64, PointF>(_maxLength)
    public var o: HashMap<Int64, PointF> = HashMap<Int64, PointF>(_maxLength)

    /**
     * Create a ShapePathForShapePool instance.
     */
    public init() { }

    /**
     * Release the ShapeCollection.
     */
    public func release(): Unit {
        this.v.clear()
        this.i.clear()
        this.o.clear()
    }

    /**
     * Release the ShapePathForShapePool.
     */
    public func setPathData(closed: Bool, len: Int64): Unit {
        this.c = closed
        this.setLength(len)
    }

    /**
     * Set length to the ShapeCollection.
     *
     * @param len - Type of Int64.
     */
    public func setLength(len: Int64): Unit {
        this._length = len
    }
    
    //TODO: 需要设置扩容逻辑么？？？   //public func doubleArrayLength() {}

    /**
     * Set x and y values at the specified location.
     *
     * @param x - Type of Float64, the value of x.
     * @param y - Type of Float64, the value of y.
     * @param types - Type of String, set the values of x and y for the specified subscripts in the types data.
     * @param pos - Type of Int64, set the values of x and y for the specified subscript pos in the types data.
     * @param replace - Type of Bool, whether to generate a new element for replacement.
     */
    public func setXYAt(x: Float64, y: Float64, types: String, pos: Int64, replace!: Bool = false): Unit {
        var arr: HashMap<Int64, PointF> = HashMap<Int64, PointF>()
        if (types == "v") {
            arr = this.v
        } else if (types == "i") {
            arr = this.i
        } else if (types == "o") {
            arr = this.o
        }
        
        if (arr.size <= pos || (arr.size > pos && !replace)) {
            arr.put(pos, PointF(x: x, y: y))
        } else {
            let point: PointF = arr[pos]
            point.x = x
            point.y = y
        }
    }

    /**
     * Set x and y values at the specified location.
     *
     * @param vX - Type of Float64, set the values of x for the subscript pos in v.
     * @param vY - Type of Float64, set the values of y for the subscript pos in v.
     * @param oX - Type of Float64, set the values of x for the subscript pos in o.
     * @param oY - Type of Float64, set the values of y for the subscript pos in o.
     * @param iX - Type of Float64, set the values of x for the subscript pos in i.
     * @param iY - Type of Float64, set the values of y for the subscript pos in i.
     * @param pos - Type of Int64, set the values of x and y for the subscript pos.
     * @param replace - Type of Bool, whether to generate a new element for replacement.
     */
    public func setTripleAt(vX: Float64, vY: Float64, oX: Float64, oY: Float64, iX: Float64, iY: Float64, pos: Int64, replace!: Bool = false): Unit {
        this.setXYAt(vX, vY, "v", pos, replace: replace)
        this.setXYAt(oX, oY, "o", pos, replace: replace)
        this.setXYAt(iX, iY, "i", pos, replace: replace)
    }

    /**
     * Reverse the ShapePathForShapePool.
     */
    public func reverse(): ShapePathForShapePool {
        let newPath: ShapePathForShapePool = ShapePathForShapePool()
        newPath.setPathData(this.c, this._length)
        let vertices = this.v
        let outPoints = this.o
        let inPoints = this.i
        var index: Int64 = 0
        if (this.c) {
            newPath.setTripleAt(vertices[0].x, vertices[0].y, inPoints[0].x, inPoints[0].y, outPoints[0].x, outPoints[0].y, 0, replace: false)
            index = 1
        }
        var cnt: Int64 = this._length - 1
        let len: Int64 = this._length

        for (i in index..len) {
            newPath.setTripleAt(vertices[cnt].x, vertices[cnt].y, inPoints[cnt].x, inPoints[cnt].y, outPoints[cnt].x, outPoints[cnt].y, i, replace: false)
            cnt -= 1
        }
        return newPath
    }

    /**
     * Get the length from the ShapePathForShapePool.
     *
     * @return Type of Int64, the length value.
     */
    public func length(): Int64 {
        return this._length
    }
    
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapePathForShapePool: {\n" +
               "c = ${c}\n" +
               "v = ${v.size}\n" +
               "i = ${i.size}\n" +
               "o = ${o.size}\n}"
    }

}
