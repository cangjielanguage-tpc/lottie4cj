/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is CanvasRenderer.
 */
package renderers

public class CanvasRenderer <: CanvasRendererBase {

    /**
     * Create a CanvasRenderer instance based on parameters.
     *
     * @param animationItem - Type of AnimationItem.
     * @param config - Type of Option<RenderConfig>.
     */
    public init(animationItem: AnimationItem, config: Option<RenderConfig>) {
        super(animationItem, config)
    }

    //TODO：拆分多继承问题 -- extendPrototype([CanvasRendererBase], CanvasRenderer)

    /**
     * Create Comp Element.
     *
     * @param data - Type of Layer.
     * @return Type of CvCompElement.
     */
    //TODO: 未实现 BaseElement 子类 CvCompElement   //public func createComp(data: Layer): CvCompElement { return CvCompElement(data, this.globalData, this) }
    public func createComp(data: Layer): BaseElement { 
        return BaseElement(data, globalData)
    }

}
