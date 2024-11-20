/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.pool

internal import lottie.model.*

public open class SegmentsLengthElement <: ToString {

    public var lengths: Array<BezierLengthElement>
    public var totalLength: Float64

    public init(lengths!: Array<BezierLengthElement> = Array<BezierLengthElement>(), totalLength!: Float64 = 0.0){
        this.lengths = lengths
        this.totalLength = totalLength
    }

    public func toString(): String {
        return "totalLength = ${totalLength}, lengths.size = ${lengths.size}"
    }
}

public open class BezierLengthElement <: ToString {
    public var addedLength: Float64
    public var percents: Array<Float64>
    public var lengths: Array<Float64>

    public init(addedLength!: Float64 = 0.0, percents!: Array<Float64> = Array<Float64>(), lengths!: Array<Float64> = Array<Float64>()){
        this.addedLength = addedLength
        this.percents = percents
        this.lengths = lengths
    }

    public func toString(): String {
        return "addedLength = ${addedLength}, percents.size = ${percents.size}, lengths.size = ${lengths.size}"
    }
}
