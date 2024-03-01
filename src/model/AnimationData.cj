/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package model


/**
 * After Effects/Bodymovin composite model. This is the serialization model that the animation will create from.
 * It is designed to be stateless, cacheable, and shareable.
 * Synchronize the key and value data formats in json
 */
public class AnimationData <: ToString {

    public let w: Int64                          // 0 = width       // View width
    public let h: Int64                          // 1 = height      // View height
    public let ip: Float64                       // 2 = startFrame  // Start key frame
    public let op: Float64                       // 3 = endFrame    // End key frame
    public let fr: Float64                       // 4 = frameRate   // Frame rate
    public let v: String                         // 5 = version     // bodymovin version
    private let _layers: Array<Layer>            // 6 = layers      // Layer information
    private let _assets: Array<Asset>            // 7 = assets      // Resource information
    public let fonts: Fonts                      // 8 = fonts       // typeface
    private let _chars: Array<FontCharacter>     // 9 = chars
    private let _markers: Array<Marker>          // 10 = markers    // Mask set
    public let nm: String                        // 11 = nm         // name
    public let ddd: Int64                        // 12 = ddd        // Whether it is 3D

    public init(w!: Int64, h!: Int64, ip!: Float64, op!: Float64, fr!: Float64, v!: String,
        layers!: Array<Layer>, assets!: Array<Asset>, fonts!: Fonts, chars!: Array<FontCharacter>,
        markers!: Array<Marker>, nm!: String, ddd!: Int64
    ){
        this.w = w
        this.h = h
        this.ip = ip
        this.op = op
        this.fr = fr
        this.v = v
        this._layers = layers
        this._assets = assets
        this.fonts = fonts
        this._chars = chars
        this._markers = markers
        this.nm = nm
        this.ddd = ddd
    }

    public prop layers: Array<Layer> {
        get() { this._layers.clone() }
    }
    public prop assets: Array<Asset> {
        get() { this._assets.clone() }
    }
    public prop chars: Array<FontCharacter> {
        get() { this._chars.clone() }
    }
    public prop markers: Array<Marker> {
        get() { this._markers.clone() }
    }

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

        "layers.size = ${_layers.size}\n" +    // 6 = layers
        "assets.size = ${_assets.size}\n" +    // 7 = assets
        "fonts = ${fonts}\n" +                // 8 = fonts
        "chars.size = ${_chars.size}\n" +      // 9 = chars
        "markers.size = ${_markers.size}\n}"   // 10 = markers
    }

}
