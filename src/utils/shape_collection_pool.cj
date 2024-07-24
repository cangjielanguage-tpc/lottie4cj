/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is shapeCollectionPool.
 */
package lottie4cj.utils

public class shapeCollectionPool {

    var _length: Int64 = 0
    var _maxLength: Int64 = 4
    var pool: ArrayList<ShapeCollection> = ArrayList<ShapeCollection>(this._maxLength)

    /**
     * Create a new ShapeCollection.
     *
     * @return Type of ShapeCollection.
     */
    public func newShapeCollection(): ShapeCollection {
        if (this._length != 0) {
            this._length -= 1
            return pool[this._length]
        } else {
            return ShapeCollection()
        }
    }

    /**
     * release the shapeCollectionPool.
     *
     * @param shapeCollection - Type of ShapeCollection.
     */
    public func release(shapeCollection: ShapeCollection): Unit {
        let len: Int64 = shapeCollection._length
        for (i in 0..len) {
            shapePool.release(shapeCollection.shapes[i])
        }
        shapeCollection._length = 0

        pool.append(shapeCollection)
        this._length += 1
    }

}
