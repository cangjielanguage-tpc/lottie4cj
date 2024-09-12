/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.html_elements

//TODO
public class HSolidElement <: HBaseElement {

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func createContent() {
        var rect: CreateNS
        if (this.data.hasMask) {
            rect = CreateNS("rect")
            rect.setAttribute("width", "${this.data.sw}")
            rect.setAttribute("height", "${this.data.sh}")
            rect.setAttribute("fill", this.data.sc)
            this.svgElement.setAttribute("width", "${this.data.sw}")
            this.svgElement.setAttribute("height", "${this.data.sh}")
        } else {
            rect = (CreateTag("div") as CreateNS).getOrThrow()
            rect.style.width ="${this.data.sw}" + "px"
            rect.style.height="${this.data.sh}" + "px"
            rect.style.backgroundColor = this.data.sc
        }
        this.layerElement.appendChild(rect)
    }
}