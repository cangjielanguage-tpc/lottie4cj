/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import lottie4cj.model.*

//TODO
public class CvMaskElement {

    protected var hasMasks: Bool
    protected var data: Layer
    protected var element: ?CvBaseElement
    protected var masksProperties: Array<Mask>
    protected var viewData: Array<Object>
    protected var list: ArrayList<Array<Float64>>
    protected var ptsds: ?Array<Float64>

    public init(data: Layer, element: CvBaseElement) {
        this.data = data
        this.element = element
        this.masksProperties = this.data.masksProperties
        this.viewData = Array<Object>(this.masksProperties.size,item: Object())
        this.list = ArrayList<Array<Float64>>()
        this.ptsds = None
        var len = this.masksProperties.size
        var hasMasks = false
        for (i in 0..len) {
            if (this.masksProperties[i].mode != "n") {
                hasMasks = true
            }
        }
        this.hasMasks = hasMasks
        if (hasMasks) {
           //TODO
        }
    }

    public func renderFrame() {
        //TODO
    }

    public func destroy() {
        this.element = None
        this.list = ArrayList<Array<Float64>>()
    }

    public func getMaskProperty() {
        
    }
}