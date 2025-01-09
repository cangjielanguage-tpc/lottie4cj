/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

internal import std.collection.*


var registeredEffects: HashMap<Int64,RegisteredEffectes> = HashMap<Int64,RegisteredEffectes>()

public class CvEffects {

    private var filters: ArrayList<CvGaussianBlurEffect>

    public init(elem: RenderableElement) {
        
        var len = if (!elem.data.ef.isEmpty()) {
            elem.data.ef.size
        }else {
            0
        }
        this.filters = ArrayList<CvGaussianBlurEffect>()
        var filterManager: ?CvGaussianBlurEffect

        for (i in 0..len) {
            filterManager = None
            var types = elem.data.ef[i].ty

            if (registeredEffects.contains(types)) {    
                filterManager = CvGaussianBlurEffect(elem.effectsManager.effectElements[i], elem)
            }
            if (let Some(v) <- filterManager) {
                this.filters.append(v)
            }
        }

        if (this.filters.size > 0) {
            elem.addRenderableComponent(this)
        }
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var len = this.filters.size
        for (i in 0..len) {
            this.filters[i].renderFrame(_isFirstFrame) // CVGaussianBlurEffect
        }
    }

}



public func registerCVEffect(id: Int64, effect: CvGaussianBlurEffect, countsAsEffect: Bool) {
    //注册高斯模糊效果监听
    registeredEffects.put(id,RegisteredEffectes(effect,countsAsEffect))
}

public class RegisteredEffectes {

    public var effect: CvGaussianBlurEffect
    public var countsAsEffect: Bool

    public init(effect: CvGaussianBlurEffect,countsAsEffect: Bool) {
        this.effect = effect
        this.countsAsEffect = countsAsEffect
    }

}


