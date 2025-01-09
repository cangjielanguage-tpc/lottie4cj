/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a MaskElement dependency file.
 */
package lottie

//main 中定义的变量及函数。
var locationHref: String = ""
public func getLocationHref(): String {
    return locationHref
}

class StoredData {
    var elem: CreateNS
    var x: PropertyFactory<Array<Keyframe<Int64>>, Int64>
    var expan: CreateNS
    var lastPath: String = ""
    var lastOperator: String = ""
    var filterId: String = ""
    var lastRadius: Int64 = 0
    
    init(
        elem!: CreateNS,
        x!: PropertyFactory<Array<Keyframe<Int64>>, Int64>,
        expan!: CreateNS,
        lastPath!: String = "",
        lastOperator!: String = "",
        filterId!: String = "",
        lastRadius!: Int64 = 0
    ){
       this.elem = elem
       this.x = x
       this.expan = expan
       this.lastPath = lastPath
       this.lastOperator = lastOperator
       this.filterId = filterId
       this.lastRadius = lastRadius
    }
}

public class ViewData {
    var elem: CreateNS
    var lastPath: String
    var op: PropertyFactory<Array<Keyframe<Int64>>, Int64>
    var props: ShapePropertyFactory
    var invRect: CreateNS

    init(
        op!: PropertyFactory<Array<Keyframe<Int64>>, Int64>,
        props!: ShapePropertyFactory,
        elem!: CreateNS = CreateNS(""),
        lastPath!: String = "",
        invRect!: CreateNS = CreateNS("")
    ){
        this.op = op
        this.props = props
        this.elem = elem
        this.lastPath = lastPath
        this.invRect = invRect
    }
}
