/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.pool

public class ShapeCollection {

    public var _length: Int64 = 0
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
