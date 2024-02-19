/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package lottie4cj

public open class Point {
    //public open let types: Int64 = 0
}


public class PointL <: Point {

    private var x: Int64 = 0
    private var y: Int64 = 0
    public let types: Int64 = 1

    init(){}
    public init(x: Int64, y: Int64) {
        this.x = x
        this.y = y
    }

    public func toString(): String {
        return "{x='${x}', y='${y}'"
    }
}

public class PointF <: Point {

    private var x: Float64 = 0.0
    private var y: Float64 = 0.0
    public let types: Int64 = 2

    init(){}
    public init(x: Float64, y: Float64) {
        this.x = x
        this.y = y
    }

    public func toString(): String {
        return "{x='${x}', y='${y}'"
    }
}
