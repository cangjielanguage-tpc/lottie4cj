/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is shapePool.
 */
//package lottie.utils.pooling
package lottie.pool

/**
 * The shape pool.
 */
//TODO：调不到shapePool.clone，需要把 shapePool 改为对象？？？-----------------------------------------------------------------2024.08.19
public let shapePool = PoolFactory<ShapeData>(4, createShapePool, _release: releaseShapePool)

func createShapePool(): ShapeData {
    return ShapeData()
}

func releaseShapePool(shapePath: ShapeData): Unit {
    let len: Int64 = shapePath._length
    for (i in 0..len) {
        pointPool.release(shapePath.v[i])
        pointPool.release(shapePath.i[i])
        pointPool.release(shapePath.o[i])
        //shapePath.v[i] = null
        //shapePath.i[i] = null
        //shapePath.o[i] = null
    }
    shapePath.release()
    
    shapePath._length = 0
    shapePath.c = false
}

//TODO: 怎么和 [PoolFactory]factory.clone 关联？？？----------------------------------------------------------------------2024.07.12
public func clone(shape: ShapeData): ShapeData {
    var cloned: ShapeData = shapePool.newElement()

    //var len = shape._length === undefined ? shape.v.length : shape._length
    var len: Int64 = shape._length
    if (shape.v.size > shape._length) {
        len = shape.v.size
    }
    cloned.setLength(len)
    cloned.c = shape.c

    var shape_v: PointF = PointF()
    var shape_i: PointF = shape_v
    var shape_o: PointF = shape_v
    for (i in 0..len) {
        shape_v = shape.v[i]
        shape_i = shape.o[i]
        shape_o = shape.i[i]
        cloned.setTripleAt(shape_v.x, shape_v.y, shape_i.x, shape_i.y, shape_o.x, shape_o.y, i)
    }
    return cloned
}

//var factory = poolFactory(4, create, release)
//factory.clone = clone

//return factory

