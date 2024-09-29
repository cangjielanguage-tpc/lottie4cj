/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is CanvasRenderer.
 */
package lottie4cj.renderers


public class CanvasRenderer <: CanvasRendererBase {
    //TODO：拆分多继承问题 -- //extendPrototype([CanvasRendererBase], CanvasRenderer)

    /**
     * Create a CanvasRenderer instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(config: Option<RenderConfig>) {
        super(config)
        if (let Some(v) <- config) {
            this.renderConfig.runExpressions = v.runExpressions
        }
    }

    /**
     * Create Comp Element.
     *
     * @param data - Type of Layer.
     * @return Type of CvCompElement.
     */
    //TODO: 未实现 BaseElement 子类 CvCompElement
    public func createComp(data: Layer): CvCompElement { 
        let cvCompElement: CvCompElement = CvCompElement(data, globalData)
        //TODO: CvCompElement 需要继承 ICompElement ？？？
        cvCompElement.buildAllItems = this.buildAllItems
        cvCompElement.checkLayers = this.checkLayers
        return cvCompElement
    }

}
