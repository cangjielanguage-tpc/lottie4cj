/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public open class SVGDropShadowEffect {

    var filterManager: FilterManager = FilterManager()
    var feGaussianBlur: CreateNS = CreateNS("")
    var feOffset: CreateNS = CreateNS("")
    var feFlood: CreateNS = CreateNS("")

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String, source: String) {
        var globalFilterSize = filterManager.filterSize;
        var filterSize = filterManager.fs ?? globalFilterSize
        if(filterSize.x == 0.0) {
            filter.setAttribute("x", "${globalFilterSize.x}");
        }else {
            filter.setAttribute("x", "${filterSize.x}");
        }
        if(filterSize.y == 0.0) {
            filter.setAttribute("y", "${globalFilterSize.y}");
        }else {
            filter.setAttribute("y", "${filterSize.y}");
        }
        if(filterSize.width == 0.0) {
            filter.setAttribute("width", "${globalFilterSize.width}");
        }else {
            filter.setAttribute("width", "${filterSize.width}");
        }
        if(filterSize.height == 0.0) {
            filter.setAttribute("height", "${globalFilterSize.height}");
        }else {
            filter.setAttribute("height", "${filterSize.height}");
        }
        this.filterManager = filterManager;

        var feGaussianBlur = CreateNS("feGaussianBlur");
        feGaussianBlur.setAttribute("in", "SourceAlpha");
        feGaussianBlur.setAttribute("result", id + "_drop_shadow_1");
        feGaussianBlur.setAttribute("stdDeviation", "0");
        this.feGaussianBlur = feGaussianBlur;
        filter.appendChild(feGaussianBlur);

        var feOffset = CreateNS("feOffset");
        feOffset.setAttribute("dx", "25");
        feOffset.setAttribute("dy", "0");
        feOffset.setAttribute("in", id + "_drop_shadow_1");
        feOffset.setAttribute("result", id + "_drop_shadow_2");
        this.feOffset = feOffset;
        filter.appendChild(feOffset);
        var feFlood = CreateNS("feFlood");
        feFlood.setAttribute("flood-color", "#00ff00");
        feFlood.setAttribute("flood-opacity", "1");
        feFlood.setAttribute("result", id + "_drop_shadow_3");
        this.feFlood = feFlood;
        filter.appendChild(feFlood);

        var feComposite = CreateNS("feComposite");
        feComposite.setAttribute("in", id + "_drop_shadow_3");
        feComposite.setAttribute("in2", id + "_drop_shadow_2");
        feComposite.setAttribute("operator", "in");
        feComposite.setAttribute("result", id + "_drop_shadow_4");
        filter.appendChild(feComposite);

        var feMerge = SVGComposableEffect.createMergeNode(id,[id + "_drop_shadow_4",source]);
        filter.appendChild(feMerge);
    } 

}

public class FilterManager{
    var fs: ?FilterSize
    var filterSize: FilterSize 
    var _mdf: Bool 
    var effectElements: Array<EffectElement>
    public init(filterSize!: FilterSize = FilterSize(), fs!: FilterSize = FilterSize(), _mdf!: Bool = false, effectElements!: Array<EffectElement> = Array<EffectElement>()) {
        this.filterSize = filterSize
        this.fs = fs
        this._mdf = _mdf
        this.effectElements = effectElements
    }
}
public class EffectElement{
    var p: EffectElementp
    public init(p!: EffectElementp = EffectElementp()){
        this.p = p
    }
}
public class EffectElementp{
    var v: Boxdata
    var k: Bool
    var _mdf: Bool
    public init(v!: Boxdata = Boxdata(0.0), k!: Bool = false, _mdf!: Bool = false) {
        this.v = v
        this.k = k
        this._mdf = _mdf
    }
}

enum myBox {
    ARR(ArrayList<Float64>)|
    STR(Float64)
}
public class Boxdata {
    var my: myBox
    public init(sizes: ArrayList<Float64>) {
        this.my = ARR(sizes)
    }
    public init(str: Float64) {
        this.my = STR(str)
    }
    prop value: Float64 {get() {
        match (this.my) {
            case STR(v) => v
            case _ => 0.0
        }
    }}
    operator func [](index: Int64) :Float64 {
        match (this.my) {
            case ARR(v) => v[index]
            case _ => throw Exception()
        }
    }

}

public class FilterSize{
    var x: Float64
    var y: Float64
    var width: Float64
    var height: Float64
    public init(x!: Float64 = 0.0, y!: Float64 = 0.0, width!: Float64 = 0.0, height!: Float64 = 0.0) {
        this.x = x
        this.y = y
        this.width = width
        this.height = height
    }
}