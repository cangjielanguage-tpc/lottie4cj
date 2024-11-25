/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

import ohos.image.*
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
            var imgW = this.img.width;
            var imgH = this.img.height;
            var imgRel = imgW / imgH;
            var canvasRel = this.assetData.w / this.assetData.h;
            var widthCrop: Int64
            var heightCrop: Int64
            // assetData.pr 属性不存在 ，var par = this.assetData.pr || this.globalData.renderConfig.imagePreserveAspectRatio;
            var par = this.globalData.renderConfig.imagePreserveAspectRatio;
            if ((imgRel > canvasRel && par == "xMidYMid slice") || (imgRel < canvasRel && par != "xMidYMid slice")) {
              heightCrop = imgH;
              widthCrop = heightCrop * canvasRel;
            } else {
              widthCrop = imgW;
              heightCrop = widthCrop / canvasRel;
            }
            this.canvasContext.drawImage(this.img.pixel_map.getOrThrow(), (imgW - widthCrop) / 2, (imgH - heightCrop) / 2, widthCrop, heightCrop, 0, 0, this.assetData.w, this.assetData.h);
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
