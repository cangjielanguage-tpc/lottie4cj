/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a Asset structure.
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
    public init(id: String, layers: Array<Layer>, w: Int64, h: Int64, p: String, u: String){
        this.id = id
        this._layers = layers
        this.w = w
        this.h = h
        this.p = p
        this.u = u
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
        "u = ${u}\n}"
    }
}
