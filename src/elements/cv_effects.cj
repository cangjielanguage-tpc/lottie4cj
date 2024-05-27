package elements

from std import collection.*

var registeredEffects: HashMap<Int64,RegisteredEffectes> = HashMap<Int64,RegisteredEffectes>()

public class CvEffects {

    private var filters: ArrayList<CvGaussianBlurEffect>

    public init(elem: ElementOptions) {
        
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
                filterManager = CvGaussianBlurEffect(elem.effectsManager.effectElements[i], elem);
            }
            if (filterManager.isSome()) {
                this.filters.append(filterManager.getOrThrow())
            }
        }

        if (this.filters.size > 0) {
            //TODO
        }
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var len = this.filters.size
        for (i in 0..len) {
            this.filters[i].renderFrame(_isFirstFrame)
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

public class ElementOptions {

    public var data: ElementData = ElementData()

    public var canvasContext: CanvasContext = CanvasContext()

    public var effectsManager: EffectsManager = EffectsManager()

}

public class EffectsManager {

    public var effectElements: ArrayList<EffectsManager> = ArrayList<EffectsManager>()

    public var pv: Int64 = 0

}


public class ElementData {

    public var ef: ArrayList<ElementTy> = ArrayList<ElementTy>()
}

public class ElementTy {
    public var ty: Int64 = 0
}