/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.property

class DataProp<T, E> where T <: ToString , E <: ToString { 
    var n: String
    var p: PropertyFactory<T, E>

    init(n!: String, p!: PropertyFactory<T, E>){
        this.n = n
        this.p = p
    }
}

