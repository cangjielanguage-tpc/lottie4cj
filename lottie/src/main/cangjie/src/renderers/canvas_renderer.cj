/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is CanvasRenderer.
 */
package lottie.renderers


public class CanvasRenderer <: CanvasRendererBase {
    //TODO：拆分多继承问题 -- //extendPrototype([CanvasRendererBase], CanvasRenderer)

    /**
     * Create a CanvasRenderer instance based on parameter.
     *
     * @param config - Type of Option<RenderConfig>.
     */
    public init(config: Option<RenderConfig>, container: CanvasRenderingContext2D) {
        super(config, container)
        if (let Some(v) <- config) {
            this.renderConfig.runExpressions = v.runExpressions
        }

        /*
        //调试CVCompElement 中图形绘制渲染未生效，未报错问题。 继承关系中成员变量赋值成功与否。【后续删除】
        this.canvasContext = container
        this.wrapperInAnimationItem = container

        this.renderConfig = RenderConfig()
        if (let Some(v) <- config) {
            this.renderConfig.runExpressions = v.runExpressions

            this.renderConfig.clearCanvas = v.clearCanvas
            //TODO: 未确认数据类型 context
            //context = v.context
            this.renderConfig.progressiveLoad = v.progressiveLoad
            this.renderConfig.preserveAspectRatio = v.preserveAspectRatio
            this.renderConfig.imagePreserveAspectRatio = v.imagePreserveAspectRatio
            this.renderConfig.contentVisibility = v.contentVisibility
            this.renderConfig.className = v.className
            this.renderConfig.id = v.id
            this.renderConfig.dpr = v.dpr
        }
        // initRenderConfig 函数中同时处理了 dpr

        this.globalData = GlobalData(
            frameNum: -1.0,
            _mdf: false,
            renderConfig: this.renderConfig,
            currentGlobalAlpha: -1,
            canvasContext: container
        )
        this.rendererType = "canvas"
        */
    }

    /**
     * Create Comp Element.
     *
     * @param data - Type of Layer.
     * @return Type of CvCompElement.
     */
    public func createComp(data: Layer): CvCompElement { 
        let cvCompElement: CvCompElement = CvCompElement(data, this.globalData, this.createItem, this.buildElementParenting)

        return cvCompElement
    }

}
