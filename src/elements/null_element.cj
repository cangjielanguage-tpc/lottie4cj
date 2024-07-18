/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements

public class NullElement <: BaseElement {

    /**
     * Create a NullElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func prepareFrame(num: Int64): Unit {
        //TODO: (问题点)仓颉的calss是单继承，调不到 FrameElement.prepareProperties  //this.prepareProperties(num, true)
    }
    
    public func renderFrame() {}
    
    public func changeColor() {}
    
    public func getBaseElement(): Option<BaseElement> {
        return None
    }
    
    public func destroy() {}
    
    public func hide() {}

    //TODO：拆分多继承问题 -- extendPrototype([BaseElement, TransformElement, HierarchyElement, FrameElement], NullElement)

}
