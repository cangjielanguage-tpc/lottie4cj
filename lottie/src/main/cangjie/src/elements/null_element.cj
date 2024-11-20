/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is NullElement.
 */
package lottie.elements

public class NullElement <: BaseElement {

    /**
     * Create a NullElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)

        this.initFrame()
        this.initBaseData(data, globalData)
        this.initFrame()
        this.initTransform(data, globalData)
        this.initHierarchy()
    }

    public func prepareFrame(num: Float64): Unit {
        this.prepareProperties(num, true)
    }
    
    public func renderFrame(forceRender: Bool) {}
    
    public func renderFrame() {}
    
    public func changeColor() {}
    
    public func getBaseElement(): Option<BaseElement> {
        return None
    }
    
    public func destroy() {}
    
    public func hide() {}

}
