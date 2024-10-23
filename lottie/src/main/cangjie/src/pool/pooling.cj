/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
//package lottie.utils.pooling
package lottie.pool

internal import lottie.model.*

public open class SegmentsLengthElement <: ToString {

    public var lengths: Array<BezierLengthElement>
    public var totalLength: Int64

    public init(lengths!: Array<BezierLengthElement> = Array<BezierLengthElement>(), totalLength!: Int64 = 0){
        this.lengths = lengths
        this.totalLength = totalLength
    }

    public func toString(): String {
        return "totalLength = ${totalLength}, lengths.size = ${lengths.size}"
    }
}

public open class BezierLengthElement <: ToString {
    
    //bezierLengthPool
    public var addedLength: Int64
    public var percents: Array<Float64>
    public var lengths: Array<Float64>

    public init(addedLength!: Int64 = 0, percents!: Array<Float64> = Array<Float64>(), lengths!: Array<Float64> = Array<Float64>()){
        this.addedLength = addedLength
        this.percents = percents
        this.lengths = lengths
    }

    public func toString(): String {
        return "addedLength = ${addedLength}, percents.size = ${percents.size}, lengths.size = ${lengths.size}"
    }
}

/*
//TODO: 未确认数据类型，编译用
public class Element<T> <: ToString where T <: ToString {
//public class Element {
    var addedLength: Int64 = 0
    
    public var percents: Array<Float64> = Array<Float64>()
    public var lengths: Array<T> = Array<T>()
    
    public var totalLength: Int64 = 0
    
    public init(addedLength!: Int64 = 0, 
        percents!: Array<T> = Array<T>(), 
        lengths!: Array<T> = Array<T>(),
        totalLength!: Int64 = 0
    ){
        this.addedLength = addedLength
        this.percents = percents
        this.lengths = lengths
    }
    
    public func toString(): String {
        return "addedLength = ${addedLength}, percents.size = ${percents.size}, lengths.size = ${lengths.size}"
    }
}
*/

/*
public class CreateElementID <: ToString {

    static var _count: Int64 = 0

    static func createID(): String {
        _count += 1
        return idPrefix + "__lottie4cj_element_" + _count
    }

}*/
