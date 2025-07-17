/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.utils
import ohos.image.*

func default_Unit_To_Unit(): Unit {}
func default_Asset_To_OB_CreateNS(asset: Asset): OB {
    return OB(img: ImgOB(isNull: true), assetData: asset)
}

let SOURCE_BASE64 = ##"data:image/([a-zA-Z0-9+-]+/?);base64"##
let TYPE_IMAGE_SOURCE_RAWFILE: Int64 = 0
let TYPE_IMAGE_SOURCE_BASE64: Int64 = 1

public class ImgOB <: ToString {

    var createNS: CreateNS
    var animationData: AnimationData
    var isCreateNS: Bool

    public var pixel_map: ?PixelMap = unsafe {zeroValue<PixelMap>()}
    public var width: Int64 = 0
    public var height: Int64 = 0
    public var src: String = ""
    public var crossOrigin: String = ""

    var isNull: Bool = false

    public init(
        createNS!: CreateNS = CreateNS(""),
        animationData!: AnimationData = AnimationData(),
        isCreateNS!: Bool = false,
        isNull!: Bool = false
    ){
        this.createNS = createNS
        this.animationData = animationData
        this.isCreateNS = isCreateNS
        this.isNull = isNull
    }
    
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "ImgOB: {\n" +
               "isCreateNS = ${isCreateNS}\n" +
               "width = ${width}\n" +
               "height = ${height}\n}"
    }
}

public class OB <: ToString {

    var img: ImgOB
    var assetData: Asset

    var isNull: Bool = false

    /**
     * Create a OB instance based on parameters.
     *
     * @param img - Type of ImgOB.
     * @param assetData - Type of Asset.
     */
    public init(img!: ImgOB = ImgOB(), 
                assetData!: Asset = Asset("", Array<Layer>(), 0, 0, "", "", 0),
                isNull!: Bool = false
    ){
        this.img = img
        this.assetData = assetData
        this.isNull = isNull
    }
    
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "OB: {\n" +
               "img = ${img}\n" +
               "assetData = ${assetData}\n}"
    }
}

class Box {
     var x:      Float64 = 0.0          // 左上角 x
     var y:      Float64 = 0.0          // 左上角y
     var x2:     Float64 = 0.0          // 右下角 x
     var y2:     Float64 = 0.0          // 右下角 y
     var width:  Float64 = 0.0          // 宽
     var height: Float64 = 0.0          // 高
     var cx:     Float64 = 0.0          // 数值。中心点x位置。
     var cy:     Float64 = 0.0          // 数值。中心点y位置。
}
