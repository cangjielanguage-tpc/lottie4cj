/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

/**
 * A data class that describes an image asset embedded in a Lottie json file.
 */
public class Asset <: ToString {
  
    /* Corresponds to the field key name in the "assets" resource information array in json. */
    var id: String = ""                                        // 0 = id              // Picture id
    public var layers: ArrayList<Layer> = ArrayList<Layer>()   // 1 = layers          // Layer information
    var w: Int64 = 0                                           // 2 = width           // Picture width
    var h: Int64 = 0                                           // 3 = height          // Picture height
    var p: String = ""                                         // 4 = imageFileName   // Picture name
    var u: String = ""                                         // 5 = relativeFolder  // Picture path

    init(){}
    init(id: String, layers: ArrayList<Layer>, w: Int64, h: Int64, p: String, u: String){
        this.id = id
        this.layers = layers
        this.w = w
        this.h = h
        this.p = p
        this.u = u
    }

    public func toString(): String {
        "Asset: {\n" +
        "id = ${id}\n" +
        "layers.size = ${layers.size}\n" +
        "w = ${w}\n" +
        "h = ${h}\n" +
        "p = ${p}\n" +
        "u = ${u}\n" +
        "}\n"
    }
}
