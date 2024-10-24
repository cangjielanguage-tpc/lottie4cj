/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

internal import std.collection.*

//TODO
public class CvGaussianBlurEffect {

    private var filterManager: GroupEffect
    //private var canvasContext: CanvasContext
    private var canvasContext: LottieCanvasRenderingContext2D

    //TODO: 暂时先将 CvBaseElement 和 BaseElement 合并。避免后面 CVXXXElement 多继承 XXXElement和 CVBaseElement
    //public init(filterManager: EffectsManager, elem: CvBaseElement) {
    public init(filterManager: GroupEffect, elem: RenderableElement) {
        this.filterManager = filterManager
        this.canvasContext = elem.canvasContext
    }

    public func renderFrame(_isFirstFrame: Bool) {
        var sigma = this.filterManager.effectElements[0].p.v[0]

        //TODO：暂未实现。--------------------------------------------------------------------------------------------2024.10.09
        //TODO：可以用 shadowBlur 函数代替吗？？？--不可以
        //给图层设置高斯模糊效果
        this.canvasContext.shadowBlur(sigma)
    }
}