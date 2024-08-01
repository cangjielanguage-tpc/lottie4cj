/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import std.collection.*

//TODO
public class CvGaussianBlurEffect {

    private var filterManager: EffectsManager
    private var canvasContext: CanvasContext

    public init(filterManager: EffectsManager, elem: CvBaseElement) {
        this.filterManager = filterManager
        this.canvasContext = elem.canvasContext.getOrThrow()
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var sigma = this.filterManager.effectElements[0].pv
        //给图层设置高斯模糊效果
        this.canvasContext.filter = "blur(" + "${sigma}" + "px)"
    }
}