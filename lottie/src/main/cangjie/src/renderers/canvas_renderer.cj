/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is CanvasRenderer.
 */
package lottie.renderers


public class CanvasRenderer <: CanvasRendererBase {

    /**
     * Create a CanvasRenderer instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(config: Option<RenderConfig>, container: LottieCanvasRenderingContext2D) {
        super(config, container)
        if (let Some(v) <- config) {
            this.renderConfig.runExpressions = v.runExpressions
        }
    }

    public func getRenderedFrame(): Float64{
        return this.renderedFrame
    }

    /**
     * Create Comp Element.
     *
     * @param data - Type of Layer.
     * @return Type of CvCompElement.
     */
    public func createComp(data: Layer): CvCompElement { 
        let cvCompElement: CvCompElement = CvCompElement(data, this.globalData, this.createItem, this.buildElementParenting, compType: 2, getElementByIdInRender: this.getElementById)

        return cvCompElement
    }

}
