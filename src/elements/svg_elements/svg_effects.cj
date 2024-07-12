/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package elements.svg_elements

from std import collection.*
import utils.*
import model.*
import global_data.*
import utils.helpers.*
import elements.*

//TODO: 未完全实现
var registeredEffects: HashMap<Int64, SvgRegisterEffect> = HashMap<Int64, SvgRegisterEffect>()
var idPrefix = "filter_result_"

public class SVGEffects  {
    var filters: ArrayList<Object> 

    public init(elem: SvgBaseElement) {
        var source: String = "SourceGraphic"
        var len = if (!elem.data.ef.isEmpty()) {
            elem.data.ef.size
        } else {
            0
        }
        var filId: String = CreateElementID.createID()
        var fil: CreateNS = FiltersFactory.createFilter(filId, skipCoordinates: true)
        var count: Int64 = 0
        this.filters = ArrayList<Object>()
        var filterManager: Option<Object>
        for (i in 0..len) {
            filterManager = None
            var types = elem.data.ef[i].ty
            if (registeredEffects.contains(types)) {
                // var Effect = registeredEffects[types].effect
                // filterManager = Effect(fil, elem.effectsManager.effectElements[i], elem, idPrefix + count, source);
                source = idPrefix + "${count}"
                if (registeredEffects[types].countsAsEffect.isSome()) {
                    count += 1
                }
            }
            if (filterManager.isSome()) {
                //this.filters.push(filterManager)
            }
        }
        if (count != 0) {
            elem.globalData.defs.appendChild(fil)
            elem.layerElement.setAttribute("filter", "url(" + getLocationHref() + "#" + filId + ")")
        }
        // if (this.filters.length) {
        //     elem.addRenderableComponent(this)
        // }
    }
}

public class SvgRegisterEffect {

    var effect: Object
    var countsAsEffect: Option<Object>
    public init(effect: Object,countsAsEffect: Object) {
        this.effect = effect
        this.countsAsEffect = countsAsEffect
    }
}