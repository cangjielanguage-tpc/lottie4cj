/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

//TODO
public class CvCompElement <: ICompElement {

    protected var hasMasks: Bool = false
    protected var pendingElements: ArrayList<String> 

    //使用了data.layers暂时使用AnimationData
    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
        this.completeLayers = false
        //使用了data.layers暂时使用AnimationData
        //this.layers = data.layers
        this.layers = Array<Layer>()
        this.pendingElements = ArrayList<String>()
        this.elements = Array<BaseElement>(this.layers.size, repeat: BaseElement(data, globalData))
        //tm暂时不是data属性
        this.tm = TM()
        this.tm._placeholder = true

    }
    public func renderInnerContent() {
        //TODO
    }

    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
        if (index == 0) {
            let len: Int64 = this.layers.size
            var i = len - 1
            while (i >= 0) {
                if (this.completeLayers || this.elements.size > i) {
                    this.elements[i].changeColor(color, endColor)
                }
                i -= 1
            }
        } else {
            if (this.completeLayers || this.elements.size > index - 1) {
                this.elements[index - 1].changeColor(color, endColor)
            }
        }
    }

    public open func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64): Unit {
        if (endColor == 0) {
        var len = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                //this.elements[i].changeColor(color, undefined)
                this.elements[i].changeColor(color, 0)
            }
        }
        } else {
            if (this.completeLayers || this.elements.size > endColor-1) {
                //this.elements[endColor-1].changeColor(color, undefined)
                this.elements[endColor-1].changeColor(color, 0)
            }
        }
    }

    public open func renderShapeColor(color: Array<Int64>, index: Int64): Unit {
        var len = this.layers.size
        for (i in 0..len) {
            if (this.completeLayers || this.elements.size > i) {
                //this.elements[i].changeColor(color, undefined)
                this.elements[i].changeColor(color, 0)
            }
        }
    }


    public func destroy() {
        var len = this.layers.size
        var i = len - 1
        while (i >= 0) {
            if (this.elements.size > i) {
                this.elements[i].destroy()
            }
            i -= 1
        }
        this.layers = Array<Layer>()
        this.elements = Array<BaseElement>()
    }

    public func createComp(data: Layer) {
        return CvCompElement(data, this.globalData)
    }
}