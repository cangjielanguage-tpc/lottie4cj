/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements
import std.convert.*

public class CvSolidElement <: ISolidElement {
    public init(data:Layer, globalData: GlobalData,
        buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit,
        compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>(),
        getElementByIdInRender!: (Int64) -> Option<BaseElement> = { m => Option<BaseElement>.None },
        compDataInd!: Int64 = -1
    ) {
        super(data, globalData)
        this.buildElementParentingInComp = buildElementParentingInComp
        this.getElementByIdInRender = getElementByIdInRender
        this.compType = compType
        this.compDataInd = compDataInd
        this.comp = comp
        this.initElement(data, globalData)
    }

    public override func renderInnerContent() {
        var ctx = this.canvasContext;
        let tmps = this.data.sc.replace("#","0x")
        let tmps1 = UInt32.parse(tmps)
        ctx.fillStyle(Color(tmps1))
        ctx.fillRect(0, 0, this.data.sw, this.data.sh);
    }
}
