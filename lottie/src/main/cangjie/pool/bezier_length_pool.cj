/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is bezierLengthPool.
 */
package lottie.pool

/**
 * The bezier length pool.
 */
public let bezierLengthPool: PoolFactory<BezierLengthElement> = PoolFactory<BezierLengthElement>(8, createBezierLeng)

func createBezierLeng(): BezierLengthElement {
    return BezierLengthElement(
        addedLength: 0.0,
        percents: Array<Float64>(getDefaultCurveSegments(), item: 0.0),
        lengths: Array<Float64>(getDefaultCurveSegments(), item: 0.0)
    )
}

