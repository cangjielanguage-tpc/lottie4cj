/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public class SVGProLevelsFilter {

    var filterManager: FilterManager = FilterManager()
    var feFuncR: ?CreateNS = None   
    var feFuncG: ?CreateNS = None   
    var feFuncB: ?CreateNS = None   
    var feFuncA: ?CreateNS = None   
    var feFuncRComposed: ?CreateNS = None   
    var feFuncGComposed: ?CreateNS = None   
    var feFuncBComposed: ?CreateNS = None   

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String) {
        this.filterManager = filterManager;
        var effectElements = this.filterManager.effectElements;
        var feComponentTransfer = CreateNS("feComponentTransfer");

        // Red
        if (effectElements[10].p.k || effectElements[10].p.v.value != 0.0 || effectElements[11].p.k || effectElements[11].p.v.value != 1.0 || effectElements[12].p.k || effectElements[12].p.v.value != 1.0 || effectElements[13].p.k || effectElements[13].p.v.value != 0.0 || effectElements[14].p.k || effectElements[14].p.v.value != 1.0) {
            this.feFuncR = this.createFeFunc("feFuncR", feComponentTransfer);
        }
        // Green
        if (effectElements[17].p.k || effectElements[17].p.v.value != 0.0 || effectElements[18].p.k || effectElements[18].p.v.value != 1.0 || effectElements[19].p.k || effectElements[19].p.v.value != 1.0 || effectElements[20].p.k || effectElements[20].p.v.value != 0.0 || effectElements[21].p.k || effectElements[21].p.v.value != 1.0) {
            this.feFuncG = this.createFeFunc("feFuncG", feComponentTransfer);
        }
        // Blue
        if (effectElements[24].p.k || effectElements[24].p.v.value != 0.0 || effectElements[25].p.k || effectElements[25].p.v.value != 1.0 || effectElements[26].p.k || effectElements[26].p.v.value != 1.0 || effectElements[27].p.k || effectElements[27].p.v.value != 0.0 || effectElements[28].p.k || effectElements[28].p.v.value != 1.0) {
            this.feFuncB = this.createFeFunc("feFuncB", feComponentTransfer);
        }
        // Alpha
        if (effectElements[31].p.k || effectElements[31].p.v.value != 0.0 || effectElements[32].p.k || effectElements[32].p.v.value != 1.0 || effectElements[33].p.k || effectElements[33].p.v.value != 1.0 || effectElements[34].p.k || effectElements[34].p.v.value != 0.0 || effectElements[35].p.k || effectElements[35].p.v.value != 1.0) {
            this.feFuncA = this.createFeFunc("feFuncA", feComponentTransfer);
        }
        // RGB
        if (this.feFuncR.isSome() || this.feFuncG.isSome() || this.feFuncB.isSome() || this.feFuncA.isSome()) {
            feComponentTransfer.setAttribute("color-interpolation-filters", "sRGB");
            filter.appendChild(feComponentTransfer);
        }

        if (effectElements[3].p.k || effectElements[3].p.v.value != 0.0 || effectElements[4].p.k || effectElements[4].p.v.value != 1.0 || effectElements[5].p.k || effectElements[5].p.v.value != 1.0 || effectElements[6].p.k || effectElements[6].p.v.value != 0.0 || effectElements[7].p.k || effectElements[7].p.v.value != 1.0) {
            feComponentTransfer = CreateNS("feComponentTransfer");
            feComponentTransfer.setAttribute("color-interpolation-filters", "sRGB");
            feComponentTransfer.setAttribute("result", id);
            filter.appendChild(feComponentTransfer);
            this.feFuncRComposed = this.createFeFunc("feFuncR", feComponentTransfer);
            this.feFuncGComposed = this.createFeFunc("feFuncG", feComponentTransfer);
            this.feFuncBComposed = this.createFeFunc("feFuncB", feComponentTransfer);
        }
    }

    public func createFeFunc(types: String, feComponentTransfer: CreateNS): CreateNS {
        var feFunc = CreateNS(types);
        feFunc.setAttribute("type", "table");
        feComponentTransfer.appendChild(feFunc);
        return feFunc;
        
    }

    public func getTableValue(inputBlack: Float64, inputWhite: Float64, gamma: Float64, outputBlack: Float64, outputWhite: Float64){
        var cnt = 0
        var segments = 256
        var perc: Float64 
        var min = min(inputBlack, inputWhite);
        var max = max(inputBlack, inputWhite);
        var table = Array<String>(segments, repeat: "")
        var colorValue: Float64
        var pos = 0;
        var outputDelta = outputWhite - outputBlack;
        var inputDelta = inputWhite - inputBlack;
        while (cnt <= 256) {
            perc = Float64(cnt / 256)
            if (perc <= min) {
                colorValue = if(inputDelta < 0.0) {
                    outputWhite
                } else {
                    outputBlack
                }
            } else if (perc >= max) {
                colorValue = if(inputDelta < 0.0) {
                    outputBlack
                } else {
                    outputWhite
                }
            } else {
                colorValue = (outputBlack + outputDelta * pow((perc - inputBlack) / inputDelta, 1.0 / gamma));
            }
            table[pos] = "${colorValue}"
            pos += 1;
            cnt += 256 / (segments - 1);
        }
        return table.toString();
    }

    public func renderFrame(forceRender: Bool): Unit {
        if (forceRender || this.filterManager._mdf) {
            var val: String
            var effectElements = this.filterManager.effectElements;
            if (this.feFuncRComposed.isSome() && (forceRender || effectElements[3].p._mdf || effectElements[4].p._mdf || effectElements[5].p._mdf || effectElements[6].p._mdf || effectElements[7].p._mdf)) {
                val = this.getTableValue(effectElements[3].p.v.value, effectElements[4].p.v.value, effectElements[5].p.v.value, effectElements[6].p.v.value, effectElements[7].p.v.value);
                this.feFuncRComposed.getOrThrow().setAttribute("tableValues", val);
                this.feFuncGComposed.getOrThrow().setAttribute("tableValues", val);
                this.feFuncBComposed.getOrThrow().setAttribute("tableValues", val);
            }

            if (this.feFuncR.isSome() && (forceRender || effectElements[10].p._mdf || effectElements[11].p._mdf || effectElements[12].p._mdf || effectElements[13].p._mdf || effectElements[14].p._mdf)) {
                val = this.getTableValue(effectElements[10].p.v.value, effectElements[11].p.v.value, effectElements[12].p.v.value, effectElements[13].p.v.value, effectElements[14].p.v.value);
                this.feFuncR.getOrThrow().setAttribute("tableValues", val);
            }

            if (this.feFuncG.isSome() && (forceRender || effectElements[17].p._mdf || effectElements[18].p._mdf || effectElements[19].p._mdf || effectElements[20].p._mdf || effectElements[21].p._mdf)) {
                val = this.getTableValue(effectElements[17].p.v.value, effectElements[18].p.v.value, effectElements[19].p.v.value, effectElements[20].p.v.value, effectElements[21].p.v.value);
                this.feFuncG.getOrThrow().setAttribute("tableValues", val);
            }

            if (this.feFuncB.isSome() && (forceRender || effectElements[24].p._mdf || effectElements[25].p._mdf || effectElements[26].p._mdf || effectElements[27].p._mdf || effectElements[28].p._mdf)) {
                val = this.getTableValue(effectElements[24].p.v.value, effectElements[25].p.v.value, effectElements[26].p.v.value, effectElements[27].p.v.value, effectElements[28].p.v.value);
                this.feFuncB.getOrThrow().setAttribute("tableValues", val);
            }

            if (this.feFuncA.isSome() && (forceRender || effectElements[31].p._mdf || effectElements[32].p._mdf || effectElements[33].p._mdf || effectElements[34].p._mdf || effectElements[35].p._mdf)) {
                val = this.getTableValue(effectElements[31].p.v.value, effectElements[32].p.v.value, effectElements[33].p.v.value, effectElements[34].p.v.value, effectElements[35].p.v.value);
                this.feFuncA.getOrThrow().setAttribute("tableValues", val);
            }
        }
    }
}