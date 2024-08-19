/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils


func default_Unit_To_Unit(): Unit {}
func default_Asset_To_OB_CreateNS(asset: Asset): OB<CreateNS> {
    return OB<CreateNS>(img: CreateNS(""), assetData: asset)
}


let TYPE_IMAGE_SOURCE_RAWFILE: Int64 = 0
let TYPE_IMAGE_SOURCE_BASE64: Int64 = 1

public class OB<T> <: ToString where T <: ToString {
    var img: T
    var assetData: Asset

    /**
     * Create a OB<T> instance based on parameters.
     *
     * @param img - Type of T.
     * @param assetData - Type of Asset.
     */
    public init(img!: T, assetData!: Asset = Asset("", Array<Layer>(), 0, 0, "", "", 0)){
        this.img = img
        this.assetData = assetData
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

