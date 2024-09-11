/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a TextAnimatorProperty dependency file.
 */

package lottie4cj.property

class MoreOptions {
    var alignment: PropertyFactory<LayerTMA, Array<Float64>>
    
    init(alignment!: PropertyFactory<LayerTMA, Array<Float64>>){
        this.alignment = alignment
    }
}

class PathInfo {
    var tLength: Float64 = 0.0
    var segments: ArrayList<BezierData> = ArrayList<BezierData>()
    
    init(){}
}

class PathData {
    // this._textData.p  =>  layer.t(LayerT).p
    //TODO: 暂时在 json 中找不到 layer.t.p。 this._pathData 是空对象。暂定都是 PropertyFactory<Float64, Float64> 类型。
    var a: PropertyFactory<Float64, Float64>
    var f: PropertyFactory<Float64, Float64>
    var l: PropertyFactory<Float64, Float64>
    var r: PropertyFactory<Float64, Float64>
    var p: PropertyFactory<Float64, Float64>
    //TODO: this._pathData.m == ShapePropertyFactory
    var m: ShapePropertyFactory
    
    var pi: PathInfo = PathInfo()
    
    //TODO: TextAnimatorProperty.getMeasures 编译用。
    var _mdf: Bool = false
    var n: Bool = false
    
    init(
        a!: PropertyFactory<Float64, Float64>,
        f!: PropertyFactory<Float64, Float64>,
        l!: PropertyFactory<Float64, Float64>,
        r!: PropertyFactory<Float64, Float64>,
        p!: PropertyFactory<Float64, Float64>,
        m!: ShapePropertyFactory,
        pi!: PathInfo = PathInfo()
    ){
        this.a = a
        this.f = f
        this.l = l
        this.r = r
        this.p = p
        this.m = m
        this.pi = pi
    }
}
