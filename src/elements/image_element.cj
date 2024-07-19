/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is IImageElement.
 */
package lottie4cj.elements

public class SourceRect {
    var top: Int64 = 0
    var left: Int64 = 0
    var width: Int64 = 0
    var height: Int64 = 0
    
    /**
     * Create a SourceRect instance based on parameters.
     *
     * @param top - Type of Int64.
     * @param left - Type of Int64.
     * @param width - Type of Int64.
     * @param height - Type of Int64.
     */
    public init(top!: Int64, left!: Int64, width!: Int64, height!: Int64){
        this.top = top
        this.left = left
        this.width = width
        this.height = height
    }
}

let EMPTY_ASSET: Asset = Asset("", Array<Layer>(), 0, 0, "", "", 0)

public class IImageElement <: BaseElement {

    //TODO: 未实现this.globalData.getAssetData = this.animationItem.getAssetData.bind(this.animationItem)
    //TODO: 暂时用空的 Asset 代替
    var assetData: Asset = EMPTY_ASSET

    //TODO: 未找到[初始]赋值点，暂时用空的 CreateNS 代替
    var innerElem: CreateNS = CreateNS("")

    var sourceRect: SourceRect

    /**
     * Create a IImageElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        //TODO: 未实现this.globalData.getAssetData = this.animationItem.getAssetData.bind(this.animationItem)  //this.assetData = globalData.getAssetData(data.refId)
        //TODO: 未实现 initElement  //this.initElement(data, globalData, comp)
        
        super(data, globalData)

        //TODO: 未实现this.globalData.getAssetData = this.animationItem.getAssetData.bind(this.animationItem)
        this.sourceRect = SourceRect(top: 0, left: 0, width: this.assetData.w, height: this.assetData.h)
    }


    /**
     * Create content.
     */
    public func createContent(): Unit {
        //TODO: 未实现this.globalData.getAssetsPath = this.animationItem.getAssetsPath.bind(this.animationItem)  //var assetPath: String = this.globalData.getAssetsPath(this.assetData)
        var assetPath: String = ""
    
        this.innerElem = CreateNS("image")
        this.innerElem.setAttribute("width", this.assetData.w.toString() + "px")
        this.innerElem.setAttribute("height", this.assetData.h.toString() + "px")
        
        //TODO: 未找到 .assetData.pr 和 imagePreserveAspectRatio 实际赋值点，暂时用空的 CreateNS 代替  //this.innerElem.setAttribute("preserveAspectRatio", this.assetData.pr || this.globalData.renderConfig.imagePreserveAspectRatio)
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
