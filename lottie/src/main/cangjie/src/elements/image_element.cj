/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is IImageElement.
 */
package lottie.elements




/*
 * TODO：初始化后需要单独执行 this.initElement(data, globalData)，放在 init 中编译报错。
 */
public open class IImageElement <: BaseElement {
    //TODO：拆分多继承问题 -- extendPrototype([BaseElement, TransformElement, SVGBaseElement, HierarchyElement, FrameElement, RenderableDOMElement], IImageElement)

    //TODO: 未实现this.globalData.getAssetData = this.animationItem.getAssetData.bind(this.animationItem)
    //TODO: 暂时用空的 Asset 代替
    var assetData: Asset = empty_asset
    //父[5]类 RenderableDOMElement 中有 baseElement/layerElement/innerElem

    var sourceRect: SourceRect = SourceRect()

    /**
     * Create a IImageElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)

        //TODO: 暂未实现 //this.assetData = globalData.getAssetData(data.refId)
        //TODO：初始化后需要单独执行 this.initElement(data, globalData)，放在 init 中编译报错。  //this.initElement(data, globalData)

        this.sourceRect = SourceRect(top: 0, left: 0, width: this.assetData.w, height: this.assetData.h)
    }

    /**
     * Create content.
     */
    public open func createContent(): Unit {
        //TODO: 未实现  //var assetPath: String = this.globalData.getAssetsPath(this.assetData)
        var assetPath: String = ""
    
        this.innerElem = CreateNS("image")
        this.innerElem.setAttribute("width", this.assetData.w.toString() + "px")
        this.innerElem.setAttribute("height", this.assetData.h.toString() + "px")
        //TODO: 未找到 .assetData.pr 和 imagePreserveAspectRatio 实际赋值点，暂时用空的 CreateNS 代替???  //this.innerElem.setAttribute("preserveAspectRatio", this.assetData.pr || this.globalData.renderConfig.imagePreserveAspectRatio)
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
