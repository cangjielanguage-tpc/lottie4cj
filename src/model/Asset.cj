/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model

/**
 * A data class that describes an image asset embedded in a Lottie json file.
 */
public class Asset <: ToString {
  
    /* Corresponds to the field key name in the "assets" resource information array in json. */
    public let id: String                    // 0 = id              // Picture id
    private let _layers: Array<Layer>        // 1 = layers          // Layer information
    public let w: Int64                      // 2 = width           // Picture width
    public let h: Int64                      // 3 = height          // Picture height
    public let p: String                     // 4 = imageFileName   // Picture name
    public let u: String                     // 5 = relativeFolder  // Picture path

    public init(id: String, layers: Array<Layer>, w: Int64, h: Int64, p: String, u: String){
        this.id = id
        this._layers = layers
        this.w = w
        this.h = h
        this.p = p
        this.u = u
    }

    public prop layers: Array<Layer> {
        get() { this._layers.clone() }
    }

    public func toString(): String {
        "Asset: {\n" +
        "id = ${id}\n" +
        "layers.size = ${_layers.size}\n" +
        "w = ${w}\n" +
        "h = ${h}\n" +
        "p = ${p}\n" +
        "u = ${u}\n}"
    }
}
