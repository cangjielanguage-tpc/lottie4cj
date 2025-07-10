/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a AnimationDataParser structure.
 */
package lottie.parser

internal import std.math.*
internal import std.collection.*
internal import std.convert.*
internal import std.io.{InputStream, ByteBuffer}
internal import stdx.encoding.json.stream.*
internal import lottie.model.*

/**
 * A parser for lottie json that parses into AnimationData objects.
 */
public class AnimationDataParser {
    private static let LAYERS_TY_IMAGE: Int64 = 2
    /**
     * Encapsulate the animation's json data parsing into an AnimationData instance.
     *
     * @param reader - Type of String, animated json data string.
     * @return Type of AnimationData, an instance of the json data that encapsulates the animation.
     */
    public static func parse(inputstr: String): AnimationData {
        return parse(ByteBuffer(inputstr.toArray()))
    }

    public static func parse(bas: ByteBuffer): AnimationData {
        if (bas.length == 0) {
            return AnimationData(isNull: true)
        }
        var startFrame: Float64 = 0.0
        var endFrame: Float64 = 0.0
        var frameRate: Float64 = 0.0
        var version: String = ""

        let layerMap: HashMap<Int64, Layer> = HashMap<Int64, Layer>()
        var layers: Array<Layer> = Array<Layer>()
        var assets: Array<Asset> = Array<Asset>()

        var width: Int64 = 0
        var height: Int64 = 0

        var fonts: Fonts = Fonts()
        var markers: Array<Marker> = Array<Marker>()
        var chars: Array<FontCharacter> = Array<FontCharacter>()

        var nm: String = ""
        var ddd: Int64 = 0

        let reader = JsonReader(bas)
        /* Obtain key information by NAMES[0-10]. Other fields are skipped, not processed, and not saved. */
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "w" => width = reader.readValue<Int64>()
                case "h" => height = reader.readValue<Int64>()
                case "ip" => startFrame = reader.readValue<Float64>()
                case "op" => endFrame = reader.readValue<Float64>()
                case "fr" => frameRate = reader.readValue<Float64>()
                case "v" =>
                    version = reader.readValue<String>()
                case "layers" => layers = parseLayers(reader, layerMap)
                case "assets" => assets = parseAssets(reader)
                case "fonts" => fonts = parseFonts(reader)
                case "chars" => chars = parseChars(reader)
                case "markers" => markers = parseMarkers(reader)
                case "nm" => nm = reader.readValue<String>()
                case "ddd" => ddd = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        reader.endObject()

        let composition: AnimationData = AnimationData(
            w: width,
            h: height,
            ip: startFrame,
            op: endFrame,
            fr: frameRate,
            v: version,
            layers: layers,
            assets: assets,
            fonts: fonts,
            chars: chars,
            markers: markers,
            nm: nm,
            ddd: ddd
        )
        return composition
    }

    private static func parseLayers(reader: JsonReader, layerMap: HashMap<Int64, Layer>): Array<Layer> {
        var imageCount: Int32 = 0
        /* Iterate through and parse each layer. */
        let layers: ArrayList<Layer> = ArrayList<Layer>()
        reader.startArray()
        while (reader.peek() != EndArray) {
            let layer: Layer = LayerParser.parse(reader)
            if (layer.ty == LAYERS_TY_IMAGE) {
                imageCount++
            }
            layers.add(layer)
            layerMap.add(layer.ind, layer)
        }
        reader.endArray()
        return layers.toArray()
    }

    private static func parseAssets(reader: JsonReader): Array<Asset> {
        let assets: ArrayList<Asset> = ArrayList<Asset>()
        reader.startArray()
        while (reader.peek() != EndArray) {
            var id: String = ""
            var layers: Array<Layer> = Array<Layer>()
            let layerMap: HashMap<Int64, Layer> = HashMap<Int64, Layer>()

            /* For images. */
            var width: Int64 = 0
            var height: Int64 = 0
            var imageFileName: String = ""
            var relativeFolder: String = ""
            var e: Int64 = 0
            reader.startObject()
            while (reader.peek() != EndObject) {
                match (reader.readName()) {
                    case "id" => id = reader.readValue<String>()
                    case "layers" => layers = parseLayers(reader, layerMap)
                    case "w" => width = reader.readValue<Int64>()
                    case "h" => height = reader.readValue<Int64>()
                    case "p" => imageFileName = reader.readValue<String>()
                    case "u" => relativeFolder = reader.readValue<String>()
                    case "e" => e = reader.readValue<Int64>()
                    case _ => reader.skip()
                }
            }

            reader.endObject()
            assets.add(Asset(id, layers, width, height, imageFileName, relativeFolder, e))
        }
        reader.endArray()
        return assets.toArray()
    }

    private static func parseFonts(reader: JsonReader): Fonts {
        var fonts: ArrayList<Font> = ArrayList<Font>()
        reader.startObject()
        if (reader.readName() == "list") {
            reader.startArray()
            while (reader.peek() != JsonToken.EndArray) {
                fonts.add(FontParser.parse(reader))
            }
            reader.endArray()
        }
        reader.endObject()
        return Fonts(list: fonts.toArray())
    }

    private static func parseChars(reader: JsonReader): Array<FontCharacter> {
        let chars: ArrayList<FontCharacter> = ArrayList<FontCharacter>()
        reader.startArray()
        while (reader.peek() != EndArray) {
            chars.add(FontCharacterParser.parse(reader))
        }
        reader.endArray()
        return chars.toArray()
    }

    private static func parseMarkers(reader: JsonReader): Array<Marker> {
        let markers = ArrayList<Marker>()
        reader.startArray()
        while (reader.peek() != EndArray) {
            var comment: String = ""
            var frame: Float64 = 0.0
            var durationFrames: Float64 = 0.0
            reader.startObject()
            while (reader.peek() != EndObject) {
                match (reader.readName()) {
                    case "cm" => comment = reader.readValue<String>()
                    case "tm" => frame = reader.readValue<Float64>()
                    case "dr" => durationFrames = reader.readValue<Float64>()
                    case _ => reader.skip()
                }
            }
            reader.endObject()
            markers.add(Marker(comment, frame, durationFrames))
        }
        reader.endArray()
        return markers.toArray()
    }
}
