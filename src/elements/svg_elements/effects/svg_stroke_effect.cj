/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.svg_elements.effects

public class SVGStrokeEffect {
    var initialized: Bool
    var filterManager: FilterManager
    var elem: BaseElement
    var paths: ArrayList<Paths>
    var pathMasker: CreateNS = CreateNS("")
    var masker: CreateNS = CreateNS("")
    public init(filter: CreateNS, filterManager: FilterManager, elem: BaseElement) {
        this.initialized = false;
        this.filterManager = filterManager;
        this.elem = elem;
        this.paths = ArrayList<Paths>()
    }   

    public func initialize(): Unit {
        var elemChildren = this.elem.layerElement.childs
        var path: CreateNS
        var groupPath: CreateNS
        var i: Int64 = 0
        var len: Int64 = 0
        if (this.filterManager.effectElements[1].p.v.value == 1.0) {
            //len = this.elem.maskManager.masksProperties.size
            i = 0
        } else {
            i = Int64(this.filterManager.effectElements[0].p.v.value - 1.0)
            len = i + 1;
        }
        groupPath = CreateNS("g");
        groupPath.setAttribute("fill", "none");
        groupPath.setAttribute("stroke-linecap", "round");
        groupPath.setAttribute("stroke-dashoffset", "1");
        while (i < len) {
            path = CreateNS("path");
            groupPath.appendChild(path);
            this.paths.append(Paths(  path,i ));
            i += 1
        }

       if (this.filterManager.effectElements[10].p.v.value == 3.0) {
            var mask = CreateNS("mask");
            var id = CreateElementID.createID()
            mask.setAttribute("id", id);
            mask.setAttribute("mask-type", "alpha");
            mask.appendChild(groupPath);
            this.elem.globalData.defs.appendChild(mask);
            var g = CreateNS("g");
            g.setAttribute("mask", "url(" + getLocationHref() + "#" + id + ")");
            for (children in elemChildren) {
                g.appendChild(children)
            }
            this.elem.layerElement.appendChild(g);
            this.masker = mask;
            groupPath.setAttribute("stroke", "#fff");
        } else if (this.filterManager.effectElements[10].p.v.value == 1.0 || this.filterManager.effectElements[10].p.v.value == 2.0) {
            if (this.filterManager.effectElements[10].p.v.value == 2.0) {
                elemChildren = this.elem.layerElement.childs
                elemChildren.clear()
            }
            this.elem.layerElement.appendChild(groupPath);
            //未找到 removeAttribute
            groupPath.setAttribute("stroke", "#fff");
        }
        this.initialized = true;
        this.pathMasker = groupPath; 

    }

    public func renderFrame(forceRender: Bool): Unit {
        if (!this.initialized) {
            this.initialize();
        }
        var len = this.paths.size
        var path: CreateNS
        for (i in 0..len) {
            if (this.paths[i].m != -1) {
            //   没有 maskManager属性 mask = this.elem.maskManager.viewData[this.paths[i].m];
            path = this.paths[i].p;
            if (forceRender || this.filterManager._mdf) {
                path.setAttribute("d", "mask.lastPath");
            }
            if (forceRender || this.filterManager.effectElements[9].p._mdf || this.filterManager.effectElements[4].p._mdf || this.filterManager.effectElements[7].p._mdf || this.filterManager.effectElements[8].p._mdf ) {
                var dasharrayValue: String = "";
                if (this.filterManager.effectElements[7].p.v.value != 0.0 || this.filterManager.effectElements[8].p.v.value != 100.0) {
                var s =min(this.filterManager.effectElements[7].p.v.value, this.filterManager.effectElements[8].p.v.value) * 0.01;
                var e = max(this.filterManager.effectElements[7].p.v.value, this.filterManager.effectElements[8].p.v.value) * 0.01;
                // 未找到 path.getTotalLength();
                var l = 1.0
                dasharrayValue = "0 0 0 " + "${l * s}" + " ";
                var lineLength = l * (e - s);
                var segment = 1.0 + this.filterManager.effectElements[4].p.v.value * 2.0 * this.filterManager.effectElements[9].p.v.value * 0.01
                var units = floor(lineLength / segment);
                for (j in 0..Int64(units)) {
                    dasharrayValue += "1 " + "${this.filterManager.effectElements[4].p.v.value * 2.0 * this.filterManager.effectElements[9].p.v.value * 0.01}" + " ";
                }
                dasharrayValue += "0 " + "${l * 10.0}" + " 0 0";
                } else {
                dasharrayValue = "1 " + "${this.filterManager.effectElements[4].p.v.value * 2.0 * this.filterManager.effectElements[9].p.v.value * 0.01}";
                }
                path.setAttribute("stroke-dasharray", dasharrayValue);
            }
            }
        }
        if (forceRender || this.filterManager.effectElements[4].p._mdf) {
            this.pathMasker.setAttribute("stroke-width", "${this.filterManager.effectElements[4].p.v.value * 2.0}");
        }

        if (forceRender || this.filterManager.effectElements[6].p._mdf) {
            this.pathMasker.setAttribute("opacity", "${this.filterManager.effectElements[6].p.v.value}");
        }
        if (this.filterManager.effectElements[10].p.v.value == 1.0 || this.filterManager.effectElements[10].p.v.value == 2.0) {
            if (forceRender || this.filterManager.effectElements[3].p._mdf) {
            var color = this.filterManager.effectElements[3].p.v
            this.pathMasker.setAttribute("stroke", "rgb(" + "${floor(color[0] * 255.0)}" + "," + "${floor(color[1] * 255.0)}" + "," + "${floor(color[2] * 255.0)}" + ")");
            }
        }
    }
}

public class Paths {
    var p: CreateNS
    var m: Int64

    public init(p: CreateNS, m: Int64) {
        this.p = p
        this.m = m
    }
}