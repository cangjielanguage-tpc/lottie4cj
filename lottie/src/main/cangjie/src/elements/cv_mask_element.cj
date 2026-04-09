/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

internal import lottie.model.*

public class CvMaskElement <: RenderableElement {

    protected var hasMasks: Bool

    protected var element: RenderableElement
    protected var masksProperties: Array<Mask>
    protected var viewData: Array<ShapePropertyFactory>
    protected var list: ArrayList<Array<Float64>>
    protected var ptsds: Array<Float64> = unsafe {zeroValue<Array<Float64>>()}

    public init(data: Layer, element: RenderableElement) {
        super(data, element.globalData)
        this.element = element
        this.masksProperties = this.data.masksProperties
        this.viewData = Array<ShapePropertyFactory>(this.masksProperties.size,repeat: unsafe {zeroValue<ShapePropertyFactory>()})
        this.list = ArrayList<Array<Float64>>()
        var len = this.masksProperties.size
        var hasMasks = false
        for (i in 0..len) {
            if (this.masksProperties[i].mode != "n") {
                hasMasks = true
            }
            this.viewData[i] = ShapePropertyFactory.getShapeProp(this.masksProperties[i], 3, element.globalData,this.data, dynamicProperties: element.dynamicProperties, compType: element.compType, renderedFrame: [element.getRenderedFrameInElemComp], compDataInd: element.compDataInd)
        }
        this.hasMasks = hasMasks
        if (hasMasks) {
            this.element.addRenderableComponent(this)
        }
    }

    public func renderFrame() {
         if (!this.hasMasks) {
            return;
          }
          var transform = this.element.finalTransform.mat;
          var ctx = this.element.canvasContext
          var len = this.masksProperties.size
          var pt: Array<Float64>
          var pts: Array<Float64>
          var data: ShapeData
          ctx.beginPath();
          for (i in 0..len) {
            if (this.masksProperties[i].mode != "n") {
              if (this.masksProperties[i].mode == "s" && !this.masksProperties[i].inv) {
                if (i == 0) {
                  ctx.moveTo(0, 0);
                  ctx.lineTo(this.element.globalData.compSize.w, 0.0);
                  ctx.lineTo(this.element.globalData.compSize.w, this.element.globalData.compSize.h);
                  ctx.lineTo(0.0, this.element.globalData.compSize.h);
                  ctx.lineTo(0, 0);
                } else {
                  if (this.ptsds.size > 1) {
                    ctx.moveTo(this.ptsds[0], this.ptsds[1]);
                  }
                  for(value in this.list) {
                    ctx.lineTo(value[4], value[5]);
                    ctx.bezierCurveTo(value[0], value[1], value[2], value[3], value[4], value[5]);
                  }
                }
                data = this.viewData[i].v;
                pt = transform.applyToPointArray(data.v[0].x, data.v[0].y, 0.0);
                ctx.moveTo(pt[0], pt[1]);
                var j = 1
                var jLen = data._length;
                while  (j < jLen) {
                  pts = transform.applyToTriplePoints([data.o[j - 1].x,data.o[j - 1].y], [data.i[j].x,data.i[j].y], [data.v[j].x,data.v[j].y]);
                  ctx.bezierCurveTo(pts[0], pts[1], pts[2], pts[3], pts[4], pts[5]);
                  j += 1
                }
                pts = transform.applyToTriplePoints([data.o[j - 1].x,data.o[j - 1].y], [data.i[0].x,data.i[0].y], [data.v[0].x,data.v[0].y]);
                ctx.bezierCurveTo(pts[0], pts[1], pts[2], pts[3], pts[4], pts[5]);

              } else {
                if (this.masksProperties[i].inv) {
                  ctx.moveTo(0, 0);
                  ctx.lineTo(this.element.globalData.compSize.w, 0.0);
                  ctx.lineTo(this.element.globalData.compSize.w, this.element.globalData.compSize.h);
                  ctx.lineTo(0.0, this.element.globalData.compSize.h);
                  ctx.lineTo(0, 0);
                }
                data = this.viewData[i].v;

                pt = transform.applyToPointArray(data.v[0].x, data.v[0].y, 0.0);
                ctx.moveTo(pt[0], pt[1]);
                var jLen = data._length;
                 var j = 0
                if (i == 0) {
                  this.list.clear();
                  this.ptsds = pt;
                  j = jLen - 1
                  while ( j > 0) {
                    var ptsd = transform.applyToTriplePoints([data.o[j - 1].x,data.o[j - 1].y], [data.i[j].x,data.i[j].y], [data.v[j].x,data.v[j].y]);
                    this.list.add(ptsd);
                         j--
                  }

                }
                j = 1
                while (j < jLen) {
                  pts = transform.applyToTriplePoints([data.o[j - 1].x,data.o[j - 1].y], [data.i[j].x,data.i[j].y],[ data.v[j].x, data.v[j].y]);
                  ctx.bezierCurveTo(pts[0], pts[1], pts[2], pts[3], pts[4], pts[5]);
                   j += 1
                }
                pts = transform.applyToTriplePoints([data.o[j - 1].x,data.o[j - 1].y], [data.i[0].x,data.i[0].y], [data.v[0].x,data.v[0].y]);
                ctx.bezierCurveTo(pts[0], pts[1], pts[2], pts[3], pts[4], pts[5]);
              }
            }
          }
          this.element.globalData.save(true);
          ctx.clip();
    }

    public func destroy() {
        this.list = ArrayList<Array<Float64>>()
    }

    public func getMaskProperty() {}
}