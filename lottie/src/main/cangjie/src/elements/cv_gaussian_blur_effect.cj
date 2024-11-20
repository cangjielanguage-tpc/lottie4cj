/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

internal import std.collection.*

public class CvGaussianBlurEffect {

    private var filterManager: GroupEffect
    private var canvasContext: LottieCanvasRenderingContext2D

    public init(filterManager: GroupEffect, elem: RenderableElement) {
        this.filterManager = filterManager
        this.canvasContext = elem.canvasContext
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var sigma = this.filterManager.effectElements[0].p.v[0]
        //给图层设置高斯模糊效果
        this.canvasContext.shadowBlur(sigma)
    }
}