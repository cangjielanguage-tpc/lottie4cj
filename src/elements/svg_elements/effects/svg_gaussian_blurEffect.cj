/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public open class SVGGaussianBlurEffect {

    var filterManager: FilterManager 
    var feGaussianBlur: CreateNS 

    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement, id: String) {
        filter.setAttribute("x", "-100%");
        filter.setAttribute("y", "-100%");
        filter.setAttribute("width", "300%");
        filter.setAttribute("height", "300%");

        this.filterManager = filterManager;
        var feGaussianBlur = CreateNS("feGaussianBlur");
        feGaussianBlur.setAttribute("result", id);
        filter.appendChild(feGaussianBlur);
        this.feGaussianBlur = feGaussianBlur;
    }

    public func renderFrame(forceRender: Bool): Unit {
        if (forceRender || this.filterManager._mdf) {
            // Empirical value, matching AE"s blur appearance.
            var kBlurrinessToSigma = 0.3;
            var sigma = this.filterManager.effectElements[0].p.v.value * kBlurrinessToSigma;

            // Dimensions mapping:
            //
            //   1 -> horizontal & vertical
            //   2 -> horizontal only
            //   3 -> vertical only
            //
            var dimensions = this.filterManager.effectElements[1].p.v.value
            // eslint-disable-line eqeqeq
            // eslint-disable-line eqeqeq
            var sigmaX = if(dimensions == 3.0) {
                0.0
            }else{
                sigma
            }
            var sigmaY = if(dimensions == 2.0) {
                0.0
            }else{
                sigma
            }
            this.feGaussianBlur.setAttribute("stdDeviation", "${sigmaX}" + " " + "${sigmaY}");
            // Repeat edges mapping:
            //
            //   0 -> off -> duplicate
            //   1 -> on  -> wrap
            // eslint-disable-line eqeqeq
            var edgeMode = if(this.filterManager.effectElements[2].p.v.value == 1.0){
                "wrap"
            } else {
                "duplicate"
            }
            this.feGaussianBlur.setAttribute("edgeMode", edgeMode)
        }
    }

}