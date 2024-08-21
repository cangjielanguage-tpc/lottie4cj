/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is segmentsLengthPool.
 */
package lottie4cj.pool

func createSegmentsLength(): SegmentsLengthElement {
    return SegmentsLengthElement(
        lengths: Array<BezierLengthElement>(), 
        totalLength: 0
    )
}

func releaseSegmentsLength(element: SegmentsLengthElement) {
    let len: Int64 = element.lengths.size
    for (i in 0..len) {
        bezierLengthPool.release(element.lengths[i])
    }
    element.lengths = Array<BezierLengthElement>()
}
    
/**
 * The segments length pool.
 */
public let segmentsLengthPool = PoolFactory<SegmentsLengthElement>(8, createSegmentsLength, _release: releaseSegmentsLength)
