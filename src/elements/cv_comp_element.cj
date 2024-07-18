/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements


public class CvCompElement {

    protected var _isFirstFrame: Bool = false
    protected var globalData: GlobalData
    protected var completeLayers: Bool = false
    protected var hasMasks: Bool = false
    protected var layers: ArrayList<Object>
    protected var pendingElements: ArrayList<String> 
    protected var elements: ArrayList<Object>
    //protected var tm: Object
    // comp: CanvasRenderer
    public init(data: Data, globalData: GlobalData, comp: Object) {
        this.completeLayers = false
        this.layers = data.layers
        this.globalData = globalData
        this.pendingElements = ArrayList<String>()
        this.elements = ArrayList<Object>(this.layers.size)

    }
    public func renderInnerContent() {
        //TODO
    }

    public func renderShapeColor(color: Array<Int64>, endColor: Object, index: Int64) {
        
        if (endColor is Array<Int64>) {
            if (index > 0) {
                var len = this.layers.size
                var i = len - 1
                while (i >= 0) {
                    if (this.completeLayers || (i < this.elements.size)) {
                        //TODO
                    }
                    i -= 1
                }
            } else {
                if (this.completeLayers || (index-1 < this.elements.size)) {
                    //TODO
                }
            }
        } else if (endColor is Int64) {
            if ((endColor as Int64).getOrThrow() > 0) {
                var len = this.layers.size
                for (i in 0..len) {
                    if (this.completeLayers || (i < this.elements.size)) {
                        //TODO
                    }
                }
            } else {
                if (this.completeLayers || ((endColor as Int64).getOrThrow() -1 < this.elements.size)) {
                    //TODO
                }
            }
        } else {
            var len = this.layers.size
            for (i in 0..len) {
                if (this.completeLayers || (i < this.elements.size)) {
                    //TODO
                }
            }
        }
    }

    public func destroy() {
        var len = this.layers.size
        var i = len - 1
        while (i >= 0) {
            if (i < this.elements.size) {
                //TODO
            }
            i -= 1
        }
        this.layers = ArrayList<Object>()
        this.elements = ArrayList<Object>()
    }

    public func createComp(data: Data) {
        return CvCompElement(data, this.globalData, this)
    }
}