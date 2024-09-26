/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

var _svgMatteSymbols: ArrayList<SvgBaseElement> = ArrayList<SvgBaseElement>()
public open class SVGMatte3Effect {

    var initialized: Bool
    var filterManager: FilterManager
    var elem: BaseElement


    public init(filterManager: FilterManager, elem: BaseElement) {
        this.initialized = false;
        this.filterManager = filterManager;
        this.elem = elem;
        elem.matteElement = CreateNS("g");
        elem.matteElement.appendChild(elem.layerElement);
        // 没有 属性 transformedElement elem.matteElement.appendChild(elem.transformedElement);
        elem.baseElement = elem.matteElement;
    }


    public func findSymbol(mask: SvgBaseElement): Option<SvgBaseElement> {
        var i = 0
        var len = _svgMatteSymbols.size
        while (i < len) {
            if (_svgMatteSymbols[i] == mask) {
                return _svgMatteSymbols[i];
            }
            i += 1
        }
        return None
    }

    public func replaceInParent(mask: SvgBaseElement, symbolId: String) { }

    public func setElementAsMask(elem: BaseElement,mask: SvgBaseElement) { 
        if (this.findSymbol(mask).isNone()) {
            var symbolId = CreateElementID.createID()
            var masker = CreateNS("mask");
            masker.setAttribute("id", mask.layerId);
            masker.setAttribute("mask-type", "alpha");
            _svgMatteSymbols.append(mask);
            var defs = elem.globalData.defs;
            defs.appendChild(masker);
            var symbol = CreateNS("symbol");
            symbol.setAttribute("id", symbolId);
            this.replaceInParent(mask, symbolId);
            symbol.appendChild(mask.layerElement);
            defs.appendChild(symbol);
            var useElem = CreateNS("use");
            useElem.setAttribute("href", "#" + symbolId);
            masker.appendChild(useElem);
            mask.data.hd = false;
            mask.show();
        }
        // 未找到 setMatte函数 elem.setMatte(mask.layerId);
    }

    public func initialize(): Unit {
        var ind = this.filterManager.effectElements[0].p.v.value
        // 替代 this.elem.comp.elements
        var elements = ArrayList<SvgBaseElement>()
        var i = 0;
        var len = elements.size
        while (i < len) {
            if (Float64(elements[i].data.ind) == ind) {
                this.setElementAsMask(this.elem, elements[i]);
            }
            i += 1;
        }
        this.initialized = true;
    }

    public func renderFrame(): Unit {
        if (!this.initialized) {
            this.initialize();
        }
    }
}