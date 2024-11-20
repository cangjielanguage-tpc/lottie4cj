/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a ShapeData structure.
 */
package lottie.model

internal import std.math.*

public class ShapeData <: ToString {

    public var c: Bool                //0 =  closed
    public var v: Array<PointF>       //1 =  pointsArray
    public var i: Array<PointF>       //2 =  inTangents
    public var o: Array<PointF>       //3 =  outTangents
    
    public var _length: Int64 = 0
    
    public var _maxLength: Int64 = 8

    public init(sd: ShapeData) {
        this.c = sd.c
        this.v = sd.v.clone()
        this.i = sd.i.clone()
        this.o = sd.o.clone()
        this._length = sd._length
        this._maxLength = sd._maxLength
    }

    /**
     * Create a ShapeData instance based on parameters.
     *
     * @param maxLength - Type of Int64, the value of maxLength.
     */
    public init(maxLength: Int64) {
        this.c = false
        this._length = 0
        if (maxLength < 8) {
            this._maxLength = 8
        } else {
            this._maxLength = maxLength
        }
        let empty_point: PointF = PointF()
        empty_point.isNull = true
        this.v = Array<PointF>(this._maxLength, item: empty_point)
        this.i = Array<PointF>(this._maxLength, item: empty_point)
        this.o = Array<PointF>(this._maxLength, item: empty_point)
    }

    /**
     * Create a ShapeData instance based on parameters.
     *
     * @param c - Type of Bool, the value of c.
     * @param v - Type of Array<PointF>, the value of v.
     * @param i - Type of Array<PointF>, the value of i.
     * @param o - Type of Array<PointF>, the value of o.
     */
    public init(
        c!: Bool,
        v!: Array<PointF>,
        i!: Array<PointF>,
        o!: Array<PointF>
    ){
        this.c = c
        this.v = v
        this.i = i
        this.o = o
        this._maxLength = v.size
    }

    public init() {
        this.c = false
        this._length = 0
        this._maxLength = 0
        this.v = Array<PointF>()
        this.i = Array<PointF>()
        this.o = Array<PointF>()
    }

/*
    /**
     * Obtain the v of ShapeData.
     */
    public prop v: Array<PointF> {
        get() { this._v.clone() }
    }

    /**
     * Obtain the i of ShapeData.
     */
    public prop i: Array<PointF> {
        get() { this._i.clone() }
    }

    /**
     * Obtain the o of ShapeData.
     */
    public prop o: Array<PointF> {
        get() { this._o.clone() }
    }
*/

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ShapeData: {\n" +
               "c = ${c}\n" +
               "v = ${v}\n" +
               "i = ${i}\n" +
               "o = ${o}\n}"
    }

//融合 utils.shapes.ShapePath 分割线-------------------------------------------------------------------------------
    public func isNull(): Bool {
        return v.size == 0 && i.size == 0 && o.size == 0
    }
    
    /**
     * Release the ShapeData.
     */
    public func setPathData(closed: Bool, len: Int64): Unit {
        this.c = closed
        this.setLength(len)
        
        for (i in 0..len) {
            //TODO: pointPool.newElement() => 直接在数组中放入，初始化的空的 PointF ？？？
            this.v[i] = PointF()
            this.o[i] = PointF()
            this.i[i] = PointF()
        }
    }

    /**
     * Set length to the ShapeCollection.
     *
     * @param len - Type of Int64.
     */
    public func setLength(len: Int64): Unit {
        if (this._maxLength < len) {
            //TODO: 需要设置扩容逻辑么？？？--类似于缓存结构
            this.doubleArrayLength(len)
        }
        this._length = len
    }

    //TODO: 需要设置扩容逻辑么？？？--类似于缓存结构
    public func doubleArrayLength() {
        let empty_point: PointF = PointF()
        empty_point.isNull = true
        this.v = this.v.concat(Array<PointF>(this._maxLength, item: empty_point))
        this.i = this.i.concat(Array<PointF>(this._maxLength, item: empty_point))
        this.o = this.o.concat(Array<PointF>(this._maxLength, item: empty_point))
        this._maxLength *= 2
    }
    
    public func doubleArrayLength(len: Int64) {
        var maxLength: Int64 = this._maxLength
        if (maxLength == 0) {
            maxLength = 8
        }
        while (maxLength < len) {
            //TODO: 需要设置扩容逻辑么？？？--类似于缓存结构
            maxLength *= 2
        }
        let empty_point: PointF = PointF()
        empty_point.isNull = true
        let length: Int64 = maxLength - this._maxLength
        if (this._maxLength == 0) {
            this.v = Array<PointF>(maxLength, item: empty_point)
            this.i = Array<PointF>(maxLength, item: empty_point)
            this.o = Array<PointF>(maxLength, item: empty_point)
        } else {
            this.v = this.v.concat(Array<PointF>(maxLength, item: empty_point))
            this.i = this.i.concat(Array<PointF>(maxLength, item: empty_point))
            this.o = this.o.concat(Array<PointF>(maxLength, item: empty_point))
        }
        this._maxLength += maxLength
    }

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
        this._length = max(this._length, pos + 1)
        if (this._length >= this._maxLength) {
            this.doubleArrayLength(this._length)
        }
        var arr: Array<PointF> = Array<PointF>()
        if (types == "v") {
            arr = this.v
        } else if (types == "i") {
            arr = this.i
        } else if (types == "o") {
            arr = this.o
        }

        if (arr[pos].isNull || (!arr[pos].isNull && !replace)) {
            arr[pos] = PointF(x: x, y: y)
        } else {
            arr[pos].x = x
            arr[pos].y = y
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
     * Reverse the ShapeData.
     */
    public func reverse(): ShapeData {
        let newPath: ShapeData = ShapeData()
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
     * Get the length from the ShapeData.
     *
     * @return Type of Int64, the length value.
     */
    public func length(): Int64 {
        return this._length
    }

    /**
     * Release the ShapeCollection.
     */
    public func release(): Unit {
        //TODO: this.v/i/o 是否需要做清空处理？？？
        this.c = false
        this.v = Array<PointF>()
        this.i = Array<PointF>()
        this.o = Array<PointF>()
        this._length = 0
    }

    public func clone(): ShapeData {
        var src = ShapeData()
        src.c = this.c
        src._length = this._length
        src._maxLength = this._maxLength
        var vr: Array<PointF> = Array<PointF>(this.v.size,item: PointF())
        var ur: Array<PointF> = Array<PointF>(this.i.size,item: PointF())
        var ors: Array<PointF> = Array<PointF>(this.o.size,item: PointF())
        for (i in 0..this.v.size) {
            vr[i] = this.v[i].clone()
        }
        for (i in 0..this.i.size) {
            ur[i] = this.i[i].clone()
        }
        for (i in 0..this.o.size) {
            ors[i] = this.o[i].clone()
        }
        src.v = vr
        src.i = ur
        src.o = ors
        return src
    }

}
