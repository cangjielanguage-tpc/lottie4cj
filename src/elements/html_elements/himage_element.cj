/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.html_elements

//TODO
public class HImageElement <: HBaseElement{
    
    var assetData: Asset
    var imageElem: CreateNS = CreateNS("")
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        // 使用 assetData 替代 globalData.getAssetData
        this.assetData = EMPTY_ASSET
    }

    public func createContent() {
        var assetPath: String = ""
        var img = CreateNS("img")
        if (this.data.hasMask) {
            this.imageElem = CreateNS("image")
            this.imageElem.setAttribute("width", "${this.assetData.w}" + "px")
            this.imageElem.setAttribute("height", "${this.assetData.h}" + "px")
            this.imageElem.setAttributeNS("http://www.w3.org/1999/xlink", "href", assetPath)
            this.layerElement.appendChild(this.imageElem)
            this.baseElement.setAttribute("width", "${this.assetData.w}")
            this.baseElement.setAttribute("height", "${this.assetData.h}")
        } else {
            this.layerElement.appendChild(img)
        }
        if (this.data.ln.size > 0) {
            this.baseElement.setAttribute("id", this.data.ln)
        }
    }
}