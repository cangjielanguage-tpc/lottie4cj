/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public open class SVGFillFilter {

    var filterManager: FilterManager
    var matrixFilter: CreateNS

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String) {
        this.filterManager = filterManager;
        var feColorMatrix = CreateNS("feColorMatrix");
        feColorMatrix.setAttribute("type", "matrix");
        feColorMatrix.setAttribute("color-interpolation-filters", "sRGB");
        feColorMatrix.setAttribute("values", "1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0");
        feColorMatrix.setAttribute("result", id);
        filter.appendChild(feColorMatrix);
        this.matrixFilter = feColorMatrix;
    }

    public func renderFrame(forceRender: Bool): Unit {
        if (forceRender || this.filterManager._mdf) {
            var color = this.filterManager.effectElements[2].p.v;
            var opacity = this.filterManager.effectElements[6].p.v;
           
            this.matrixFilter.setAttribute("values", "0 0 0 0 " + "${color[0]}" + " 0 0 0 0 " +"${color[1]}" + " 0 0 0 0 " + "${color[2]}" + " 0 0 0 " + "${opacity.value}" + " 0");
        }
    }

}