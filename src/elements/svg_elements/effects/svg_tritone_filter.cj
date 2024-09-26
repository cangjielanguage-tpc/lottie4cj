/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public class SVGTritoneFilter {

    var filterManager: FilterManager 
    var feFuncR: CreateNS 
    var matrixFilter: CreateNS 
    var feFuncG: CreateNS 
    var feFuncB: CreateNS 

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String) {
        this.filterManager = filterManager;
        var feColorMatrix = CreateNS("feColorMatrix");
        feColorMatrix.setAttribute("type", "matrix");
        feColorMatrix.setAttribute("color-interpolation-filters", "linearRGB");
        feColorMatrix.setAttribute("values", "0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0.3333 0.3333 0.3333 0 0 0 0 0 1 0");
        filter.appendChild(feColorMatrix);
        var feComponentTransfer = CreateNS("feComponentTransfer");
        feComponentTransfer.setAttribute("color-interpolation-filters", "sRGB");
        feComponentTransfer.setAttribute("result", id);
        this.matrixFilter = feComponentTransfer;
        var feFuncR = CreateNS("feFuncR");
        feFuncR.setAttribute("type", "table");
        feComponentTransfer.appendChild(feFuncR);
        this.feFuncR = feFuncR;
        var feFuncG = CreateNS("feFuncG");
        feFuncG.setAttribute("type", "table");
        feComponentTransfer.appendChild(feFuncG);
        this.feFuncG = feFuncG;
        var feFuncB = CreateNS("feFuncB");
        feFuncB.setAttribute("type", "table");
        feComponentTransfer.appendChild(feFuncB);
        this.feFuncB = feFuncB;
        filter.appendChild(feComponentTransfer);
    }

    public func renderFrame(forceRender: Bool): Unit {
        if (forceRender || this.filterManager._mdf) {
            var color1 = this.filterManager.effectElements[0].p.v;
            var color2 = this.filterManager.effectElements[1].p.v;
            var color3 = this.filterManager.effectElements[2].p.v;
            var tableR = "${color3[0]}" + " " + "${color2[0]}" + " " + "${color1[0]}";
            var tableG = "${color3[1]}" + " " + "${color2[1]}" + " " + "${color1[1]}";
            var tableB = "${color3[2]}" + " " + "${color2[2]}" + " " + "${color1[2]}";
            this.feFuncR.setAttribute("tableValues", tableR);
            this.feFuncG.setAttribute("tableValues", tableG);
            this.feFuncB.setAttribute("tableValues", tableB);
        }
    }
}