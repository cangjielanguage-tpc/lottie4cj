/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

import kit.ImageKit.*

public class CvImageElement <: IImageElement {

    var img:ImgOB
    public init(data: Layer, globalData: GlobalData,
        buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit,
        compType!: Int8 = 0, comp!: Array<BaseElement> = Array<BaseElement>(),
        getElementByIdInRender!: (Int64) -> Option<BaseElement> = { m => Option<BaseElement>.None },
        compDataInd!: Int64 = -1
    ) {
        super(data, globalData)
        this.buildElementParentingInComp = buildElementParentingInComp
        this.compType = compType
        this.compDataInd = compDataInd
        this.comp = comp
        this.getElementByIdInRender = getElementByIdInRender
        this.assetData = globalData.getAssetData(data.refId)
        this.img = globalData.imageLoader.getAsset(this.assetData)
        this.initElement(data, globalData)
    }

    public override  func createContent() {
        if (this.img.width > 0 && (this.assetData.w != this.img.width || this.assetData.h != this.img.height)) {
            try {
                var imgW: Float64 = Float64(this.img.width)
                var imgH: Float64 = Float64(this.img.height)
                var imgRel: Float64 = imgW / imgH
                var canvasRel: Float64 = Float64(this.assetData.w) / Float64(this.assetData.h)
                var widthCrop: Float64
                var heightCrop: Float64
                // assetData.pr 属性不存在 ，var par = this.assetData.pr || this.globalData.renderConfig.imagePreserveAspectRatio;
                var par = this.globalData.renderConfig.imagePreserveAspectRatio
                if ((imgRel > canvasRel && par == "xMidYMid slice") || (imgRel < canvasRel && par != "xMidYMid slice")) {
                  heightCrop = imgH
                  widthCrop = heightCrop * canvasRel
                } else {
                  widthCrop = imgW
                  heightCrop = widthCrop / canvasRel
                }
                this.canvasContext.drawImage(this.img.pixel_map.getOrThrow(), (imgW - widthCrop) / 2.0, (imgH - heightCrop) / 2.0, widthCrop, heightCrop, 0.0, 0.0, Float64(this.assetData.w), Float64(this.assetData.h))
            } catch (err: Exception) {
                Hilog.error(0, "[CvImageElement]","[createContent] has an error: ${err.message}")
            }
        }
    }

    public func renderInnerContent() {
         if (let Some(v) <- this.img.pixel_map) {
            //传入base64资源与rawfile资源解析出的pixelMap进行绘制
            this.canvasContext.drawImage(this.img.pixel_map.getOrThrow(), 0, 0, this.img.width, this.img.height);
         } else {
            //this.img为 ImageBitmap  //this.canvasContext.drawImage(this.img, 0, 0)
         }
    }

    public func destroy() {
        if (!this.assetData.hasDestroy) {
            if (let Some(v) <- this.img.pixel_map) {
                v.Release()
                this.assetData.hasDestroy = true
            }
        }
        this.img = ImgOB()
    }
}
