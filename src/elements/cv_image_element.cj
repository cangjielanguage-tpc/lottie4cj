/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements


public class CVImageElement <: BaseElement{

    var assetData: Asset

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        //TODO: 暂时用空的 Asset 代替
        this.assetData = EMPTY_ASSET

    }

    public func initElement() {}

    public func prepareFrame() {}

    public func createContent() {
        //TODO
    }

    public func renderInnerContent() {
        //TODO
    }

    public func destroy() {
        ////TODO
    }
}