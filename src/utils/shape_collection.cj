/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.utils

public class ShapeCollection {

    var _length: Int64 = 0
    var shapes: ArrayList<ShapePathForShapePool> = ArrayList<ShapePathForShapePool>(4)

    /**
     * Create a ShapeCollection instance.
     */
    public init() { }

    /**
     * Add shape to the ShapeCollection.
     *
     * @param nm - Type of ShapePathForShapePool.
     */
    public func addShape(shapeData: ShapePathForShapePool): Unit {
        this.shapes[this._length] = shapeData
        this._length += 1
    }

    /**
     * Release the ShapeCollection.
     */
    public func releaseShapes(): Unit {
        for (i in 0..this._length) {
            shapePool.release(this.shapes[i])
        }
        this._length = 0
    }
}
