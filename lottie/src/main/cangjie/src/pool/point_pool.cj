/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is pointPool.
 */
//package lottie.utils.pooling
package lottie.pool

/**
 * The point pool.
 */
public let pointPool: PoolFactory<PointF> = PoolFactory<PointF>(8, createPointPool)

//TODO: 怎么把 PointF 和 Element关联起来？？？  -->   Element 是可变数据类型，用 T 代替
func createPointPool(): PointF {
    return PointF()
}

//func create(): Array<Float32> {
//    return Array<Float32>(2, item: 0.0)
//}
