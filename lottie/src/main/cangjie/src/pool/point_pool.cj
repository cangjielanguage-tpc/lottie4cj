/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is pointPool.
 */
package lottie.pool

/**
 * The point pool.
 */
public let pointPool: PoolFactory<PointF> = PoolFactory<PointF>(8, createPointPool)

func createPointPool(): PointF {
    return PointF()
}

