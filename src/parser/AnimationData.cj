/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

/**
 * After Effects/Bodymovin composite model. This is the serialization model that the animation will create from.
 * It is designed to be stateless, cacheable, and shareable.
 * Synchronize the key and value data formats in json
 */
public class AnimationData <: ToString {

    var w: Int64 = 0                                                         // 0 = width       // View width
    var h: Int64 = 0                                                         // 1 = height      // View height
    var ip: Float64 = 0.0                                                    // 2 = startFrame  // Start key frame
    var op: Float64 = 0.0                                                    // 3 = endFrame    // End key frame
    var fr: Float64 = 0.0                                                    // 4 = frameRate   // Frame rate
    var v: String = ""                                                       // 5 = version     // bodymovin version
    public var layers: ArrayList<Layer> = ArrayList<Layer>()                 // 6 = layers      // Layer information
    public var assets: ArrayList<Asset> = ArrayList<Asset>()                 // 7 = assets      // Resource information

    var fonts: Fonts = Fonts()                                               // 8 = fonts       // typeface

    public var chars: ArrayList<FontCharacter> = ArrayList<FontCharacter>()  // 9 = chars
    public var markers: ArrayList<Marker> = ArrayList<Marker>()              // 10 = markers    // Mask set
    var nm: String = ""                                                      // 11 = nm         // name
    var ddd: Int64 = 0                                                       // 12 = ddd        // Whether it is 3D

    init(){}

    public func toString(): String {
        "AnimationData {\n" +
        "w  = ${w}\n" +                       // 0 = width
        "h  = ${h}\n" +                       // 1 = height
        "ip = ${ip}\n" +                      // 2 = startFrame
        "op = ${op}\n" +                      // 3 = endFrame
        "fr = ${fr}\n" +                      // 4 = frameRate
        "v  = ${v}\n" +                       // 5 = version

        "nm  = ${nm}\n" +                     // 11 = nm
        "ddd = ${ddd}\n" +                    // 12 = ddd

        "layers.size = ${layers.size}\n" +    // 6 = layers
        "assets.size = ${assets.size}\n" +    // 7 = assets

        "fonts = ${fonts}\n" +                // 8 = fonts

        "chars.size = ${chars.size}\n" +      // 9 = chars
        "markers.size = ${markers.size}\n" +  // 10 = markers
        "}\n"
    }

}
