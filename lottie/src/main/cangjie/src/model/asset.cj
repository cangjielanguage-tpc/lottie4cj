/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Asset structure.
 */
package lottie.model

/**
 * A data class that describes an image asset embedded in a Lottie json file.
 */
public class Asset <: ToString & Equatable<Asset> {

    //TODO: 编译用，暂时在 json 中找不到 assets[i].t。
    public var t: String = ""
    //TODO: 不确定来源和数据类型
    public var xt: Bool = false
    
    //确认 "assets"."layers" 是否被 从 json 处理成对象格式
    public var __used: Bool = false
    
    /* Corresponds to the field key name in the "assets" resource information array in json. */
    public let id: String                    // 0 = id              // Picture id
    private let _layers: Array<Layer>        // 1 = layers          // Layer information
    public let w: Int64                      // 2 = width           // Picture width
    public let h: Int64                      // 3 = height          // Picture height
    public let p: String                     // 4 = imageFileName   // Picture name
    public let u: String                     // 5 = relativeFolder  // Picture path

    public let e: Int64

    /**
     * Create a Asset instance based on parameters.
     *
     * @param id - Type of String, the value of id.
     * @param layers - Type of Array<Layer>, the value of x.
     * @param w - Type of Int64, the value of w.
     * @param h - Type of Int64, the value of h.
     * @param p - Type of String, the value of p.
     * @param u - Type of String, the value of u.
     */
    public init(id: String, layers: Array<Layer>, w: Int64, h: Int64, p: String, u: String, e: Int64){
        this.id = id
        this._layers = layers
        this.w = w
        this.h = h
        this.p = p
        this.u = u
        this.e = e
    }

    /**
     * Obtain the layers of Asset.
     */
    public prop layers: Array<Layer> {
        get() { this._layers.clone() }
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        "Asset: {\n" +
        "id = ${id}\n" +
        "layers.size = ${_layers.size}\n" +
        "w = ${w}\n" +
        "h = ${h}\n" +
        "p = ${p}\n" +
        "u = ${u}\n" +
        "e = ${e}\n}"
    }
    
    /**
     * Check if the current Asset is equal to the target that.
     *
     * @param that - Type of Asset.
     * @return Type of Bool.
     */
    public operator func ==(that: Asset): Bool {
        return refEq(this, that)
    }

    /**
     * Check if the current Asset is not equal to the target that.
     *
     * @param that - Type of Asset.
     * @return Type of Bool.
     */
    public operator func !=(that: Asset): Bool {
        return !(this == that)
    }

    /**
     * The instance is empty.
     *
     * @return Type of Bool, if the instance is empty, return true.
     */
    public func isNull(): Bool {
        return this.id == "" &&
                this._layers.size == 0 &&
                this.w == -1 &&
                this.h == -1 &&
                this.p == "" &&
                this.u == "" &&
                this.e == -1
    }
}
