/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.pool

public class ShapeCollection {

    public var _length: Int64 = 0
    public var _maxLength: Int64 = 4
    public var shapes: ArrayList<ShapeData> = ArrayList<ShapeData>(4)

    /**
     * Create a ShapeCollection instance.
     */
    public init() { }

    /**
     * Add shape to the ShapeCollection.
     *
     * @param nm - Type of ShapeData.
     */
    public func addShape(shapeData: ShapeData): Unit {
        if (this.shapes.size > this._length) {
            this.shapes.set(this._length, shapeData)
        } else {
            this.shapes.append(shapeData)
        }
        this._length += 1
    }

    public func clone(): ShapeCollection {
        let sc = ShapeCollection()
        sc._length = this._length
        sc._maxLength = this._maxLength
        var rc = ArrayList<ShapeData>(this.shapes.size)
        for(i in 0..this.shapes.size) {
            rc.append(this.shapes[i].clone())
        }
        sc.shapes = rc
        return sc
    }

    /**
     * Release the ShapeCollection.
     */
    public func releaseShapes(): Unit {
        for (i in 0..this._length) {
            shapePool.release(this.shapes[i])
        }
        this.shapes.clear()
        this._length = 0
    }
}
