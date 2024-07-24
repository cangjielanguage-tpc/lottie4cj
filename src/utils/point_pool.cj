/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is pointPool.
 */
package lottie4cj.utils

/**
 * The point pool.
 */
public let pointPool: PoolFactory<PointF> = PoolFactory<PointF>(8, createPointPool)

func createPointPool(): PointF {
    return PointF()
}
