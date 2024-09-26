/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

var linearFilterValue = "0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0 0 0";
public class SVGTintFilter {

    var filterManager: FilterManager 
    var linearFilter: CreateNS 
    var matrixFilter: CreateNS 

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String, source: String) {
        this.filterManager = filterManager;
        var feColorMatrix = CreateNS("feColorMatrix");
        feColorMatrix.setAttribute("type", "matrix");
        feColorMatrix.setAttribute("color-interpolation-filters", "linearRGB");
        feColorMatrix.setAttribute("values", linearFilterValue + " 1 0");
        this.linearFilter = feColorMatrix;
        feColorMatrix.setAttribute("result", id + "_tint_1");
        filter.appendChild(feColorMatrix);
        feColorMatrix = CreateNS("feColorMatrix");
        feColorMatrix.setAttribute("type", "matrix");
        feColorMatrix.setAttribute("color-interpolation-filters", "sRGB");
        feColorMatrix.setAttribute("values", "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0");
        feColorMatrix.setAttribute("result", id + "_tint_2");
        filter.appendChild(feColorMatrix);
        this.matrixFilter = feColorMatrix;
        var feMerge = SVGComposableEffect.createMergeNode(id,[source, id + "_tint_1",id + "_tint_2"]);
        filter.appendChild(feMerge)
    }

    public func renderFrame(forceRender: Bool): Unit {
        if (forceRender || this.filterManager._mdf) {
            var colorBlack = this.filterManager.effectElements[0].p.v;
            var colorWhite = this.filterManager.effectElements[1].p.v;
            var opacity = this.filterManager.effectElements[2].p.v.value / 100.0
            this.linearFilter.setAttribute("values", linearFilterValue + " " + "${opacity}" + " 0");
            this.matrixFilter.setAttribute("values", "${(colorWhite[0] - colorBlack[0])}" + " 0 0 0 " + "${colorBlack[0]}" + " " + "${(colorWhite[1] - colorBlack[1])}" + " 0 0 0 " + "${colorBlack[1]}" + " " + "${(colorWhite[2] - colorBlack[2])}" + " 0 0 0 " + "${colorBlack[2]}" + " 0 0 0 1 0");
        }
    }

}