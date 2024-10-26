/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

//TODO
public class CvSolidElement <: ISolidElement {
    public init(data:Layer, globalData: GlobalData, compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>()) {
        super(data, globalData)
        this.compType = compType
        this.comp = comp
        this.initElement(data, globalData) //RenderableDOMElement
    }

//    public func initElement() {
//        //TODO
//    }

//    public func prepareFrame() {
//        //TODO
//    }

    public override func renderInnerContent() {
       var ctx = this.canvasContext;
        //ctx.fillStyle = this.data.sc
      ctx.fillStyle(0)
      ctx.fillRect(0, 0, this.data.sw, this.data.sh);
      //
    }
}
