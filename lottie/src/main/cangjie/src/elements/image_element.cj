/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is IImageElement.
 */
package lottie.elements

public open class IImageElement <: BaseElement {
    var assetData: Asset = empty_asset
    var sourceRect: SourceRect = SourceRect()

    /**
     * Create a IImageElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.sourceRect = SourceRect(top: 0, left: 0, width: this.assetData.w, height: this.assetData.h)
    }

    /**
     * Create content.
     */
    public open func createContent(): Unit {
        var assetPath: String = ""
    
        this.innerElem = CreateNS("image")
        this.innerElem.setAttribute("width", this.assetData.w.toString() + "px")
        this.innerElem.setAttribute("height", this.assetData.h.toString() + "px")
        //未找到 .assetData.pr 和 imagePreserveAspectRatio 实际赋值点，暂时用空的 CreateNS 代替???  
        this.innerElem.setAttributeNS("http://www.w3.org/1999/xlink", "href", assetPath)
    
        this.layerElement.appendChild(this.innerElem)
    }

    /**	    
     * Return the sourceRect value.
     *
     * @return Type of SourceRect, the sourceRect value.
     */
    public func sourceRectAtTime(): SourceRect {
        return this.sourceRect
    }

}
