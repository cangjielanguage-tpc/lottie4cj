/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is ISolidElement.
 */
package elements

import model.*

public class ISolidElement <: BaseElement {

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    //TODO：拆分多继承问题 --extendPrototype([IImageElement], ISolidElement)

    public func createContent(): Unit {
        let rect: CreateNS = CreateNS("rect")
        rect.setAttribute("width", this.data.sw.toString())
        rect.setAttribute("height", this.data.sh.toString())
        rect.setAttribute("fill", this.data.sc)
        this.layerElement.appendChild(rect)
    }

}
