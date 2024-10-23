/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is PoolFactory.
 */
//package lottie.utils.pooling
package lottie.pool


internal import std.collection.*

public class PoolFactory<T> where T <: ToString {
    
    //TODO: Element 是可变数据类型，用 T 代替
    var _create: () -> T
    var _release: Option<(T) -> Unit>

    var _length: Int64 = 0
    
    var _maxLength: Int64
    var pool: ArrayList<T>

    /**
     * Create a PoolFactory<T> instance based on parameters.
     *
     * @param initialLength - Type of Int64.
     * @param _create - Type of function, () -> T.
     * @param _release - Type of function, Option<(T) -> Unit>.
     */
    //TODO: Element 是可变数据类型，用 T 代替
    public init(initialLength: Int64, _create: () -> T, _release!: Option<(T) -> Unit> = None) {
        this._create = _create
        this._release = _release

        this._maxLength = initialLength
        this.pool = ArrayList<T>(initialLength)
    }

    /**
     * Create a new Element.
     *
     * @return Type of T.
     */
    public func newElement(): T {
        //TODO: Element 是可变数据类型，用 T 代替
        var element: T
        if (this._length != 0) {
            this._length -= 1
            element = this.pool[this._length]
        } else {
            element = this._create()
        }
        return element
    }

    /**
     * Release the element.
     *
     * @param element - Type of T, release it.
     */
    public func release(element: T): Unit {
        //TODO: Element 是未确认数据类型，编译用
        //TODO: 扩容。cj中用的是 ArrayList，不用扩容。
        //if (this._length == this._maxLength) {
        //    this.pool = pooling.double(pool)
        //    this._maxLength *= 2
        //}
        if (let Some(v) <- this._release) {
            v(element)
        }
        if (this.pool.size > this._length) {
            this.pool[this._length] = element
        } else {
            this.pool.append(element)
        }
        this._length += 1
    }

}
