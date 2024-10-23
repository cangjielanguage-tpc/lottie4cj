/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is shapeCollectionPool.
 */
//package lottie.utils.pooling
package lottie.pool

public class shapeCollectionPool {

    var _length: Int64 = 0
    var _maxLength: Int64 = 4
    //TODO: ShapeCollection 未实现---------------------------------------------------------------------------2024.07.12
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

        //TODO: 需要设置扩容逻辑么？？？-----------------------------------------------------------------------2024.07.12
        //if (_length == _maxLength) {
        //    pool = pooling.double(pool)
        //    _maxLength *= 2
        //}
        //pool[_length] = shapeCollection
        pool.append(shapeCollection)
        this._length += 1
    }

}

