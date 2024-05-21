package elements

from std import collection.*


public class CvGaussianBlurEffect {

    private var filterManager: EffectsManager
    private var canvasContext: CanvasContext

    public init(filterManager: EffectsManager, elem: ElementOptions) {
        this.filterManager = filterManager
        this.canvasContext = elem.canvasContext
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var sigma = this.filterManager.effectElements[0].pv
        //给图层设置高斯模糊效果
        this.canvasContext.filter = "blur(" + "${sigma}" + "px)"
    }
}