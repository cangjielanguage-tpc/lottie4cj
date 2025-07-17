/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is ISolidElement.
 */
package lottie.elements

internal import lottie.model.*

public open class ISolidElement <: BaseElement {

    /**
     * Create a ISolidElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    /**
     * Create content.
     */
    public func createContent(): Unit {
        let rect: CreateNS = CreateNS("rect")
        rect.setAttribute("width", this.data.sw.toString())
        rect.setAttribute("height", this.data.sh.toString())
        rect.setAttribute("fill", this.data.sc)
        this.layerElement.appendChild(rect)
    }

}
