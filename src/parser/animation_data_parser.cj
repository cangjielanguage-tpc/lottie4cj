/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is a AnimationDataParser structure.
 */
package lottie4cj.parser

internal import std.math.*
internal import encoding.json.*
internal import std.collection.*
internal import std.convert.*
internal import std.log.*

internal import lottie4cj.model.*

public let logger: SimpleLogger = SimpleLogger()

/**
 * A parser for lottie json that parses into AnimationData objects.
 */
public class AnimationDataParser {

    private static let LAYERS_TY_IMAGE: Int64 = 2

    /* Fields that correspond to external structures in json */
    private static let NAMES: Array<String> = [
        "w",       // 0
        "h",       // 1
        "ip",      // 2
        "op",      // 3
        "fr",      // 4
        "v",       // 5
        "layers",  // 6
        "assets",  // 7
        "fonts",   // 8
        "chars",   // 9
        "markers", // 10
        "nm",      // 11
        "ddd"      // 12
    ]

    /**
     * Encapsulate the animation's json data parsing into an AnimationData instance.
     *
     * @param reader - Type of String, animated json data string.
     * @return Type of AnimationData, an instance of the json data that encapsulates the animation.
     */
    public static func parse(reader: String): AnimationData {

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

        let jsonObject: JsonObject = JsonValue.fromStr(reader).asObject()

        /* Obtain key information by NAMES[0-10]. Other fields are skipped, not processed, and not saved. */
        if (let Some(v) <- jsonObject.get(NAMES[0])) {
            width = v.asInt().getValue()
        }
        if (let Some(v) <- jsonObject.get(NAMES[1])) {
            height = v.asInt().getValue()
        }
        if (let Some(v) <- jsonObject.get(NAMES[2])) {
            startFrame = v.asFloat().getValue()
        }
        if (let Some(v) <- jsonObject.get(NAMES[3])) {
            endFrame = v.asFloat().getValue()
        }
        if (let Some(v) <- jsonObject.get(NAMES[4])) {
            frameRate = v.asFloat().getValue()
        }

        if (let Some(v) <- jsonObject.get(NAMES[5])) {
            version = v.asString().getValue()
            let versions: Array<String> = version.split(".")

            let majorVersion: Int32 = Int32.parse(versions[0])
            let minorVersion: Int32 = Int32.parse(versions[1])
            let patchVersion: Int32 = Int32.parse(versions[2])
            if (!Utils.isAtLeastVersion(majorVersion, minorVersion, patchVersion, 4, 4, 0)) {
                throw Exception("Lottie only supports bodymovin >= 4.4.0")
            }
        }

        if (let Some(v) <- jsonObject.get(NAMES[6])) {
            let ja: JsonArray = v.asArray()
            layers = parseLayers(ja, layerMap)
        }
        if (let Some(v) <- jsonObject.get(NAMES[7])) {
            let ja: JsonArray = v.asArray()
            assets = parseAssets(ja)
        }

        if (let Some(v) <- jsonObject.get(NAMES[8])) {
            fonts = parseFonts(v)
        }
        if (let Some(v) <- jsonObject.get(NAMES[9])) {
            let ja: JsonArray = v.asArray()
            chars = parseChars(ja)
        }

        if (let Some(v) <- jsonObject.get(NAMES[10])) {
            let ja: JsonArray = v.asArray()
            markers = parseMarkers(ja)
        }

        if (let Some(v) <- jsonObject.get(NAMES[11])) {
            nm = v.asString().getValue()
        }
        if (let Some(v) <- jsonObject.get(NAMES[12])) {
            ddd = v.asInt().getValue()
        }

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

    private static func parseLayers(reader: JsonArray, layerMap: HashMap<Int64, Layer>): Array<Layer> {
        var imageCount: Int32 = 0
        /* Iterate through and parse each layer. */
        let len: Int64 = reader.size()
        let EMPTY_LAYER: Layer = Layer()
        let layers: Array<Layer> = Array<Layer>(len, item: EMPTY_LAYER)
        for (i in 0..len) {
            let jv: JsonValue = reader[i]
            /* Layer parsing. */
            let layer: Layer = LayerParser.parse(jv)
            if (layer.ty == LAYERS_TY_IMAGE) {
                imageCount++
            }
            /* Add layers and map to improve efficiency. */
            layers[i] = layer
            layerMap.put(layer.ind, layer)
        }
        return layers
    }

    //"assets"
    static let ASSETS_NAMES: Array<String> = [
        "id",     // 0  // Picture id
        "layers", // 1  // Layer information
        "w",      // 2  // Picture width
        "h",      // 3  // Picture height
        "p",      // 4  // Picture name
        "u",      // 5  // Picture path
        "e"       // 6
    ]

    private static func parseAssets(reader: JsonArray): Array<Asset> {
        let len: Int64 = reader.size()
        if (len <= 0) {
            return Array<Asset>()
        }
        let EMPTY_ARRAY_LAYER: Array<Layer> = Array<Layer>()
        let EMPTY_ASSET: Asset = Asset("", Array<Layer>(), 0, 0, "", "", 0)
        let assets: Array<Asset> = Array<Asset>(len, item: EMPTY_ASSET)
        for (i in 0..len) {
            var id: String = ""
            var layers: Array<Layer> = EMPTY_ARRAY_LAYER
            let layerMap: HashMap<Int64, Layer> = HashMap<Int64, Layer>()

            /* For images. */
            var width: Int64 = 0
            var height: Int64 = 0
            var imageFileName: String = ""
            var relativeFolder: String = ""
            var e: Int64 = 0

            let jo: JsonObject = reader[i].asObject()

            if (let Some(v) <- jo.get(ASSETS_NAMES[0])) {
                id = v.asString().getValue()
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[1])) {
                let ja: JsonArray = v.asArray()
                let len: Int64 = ja.size()
                let EMPTY_LAYER: Layer = Layer()
                layers = Array<Layer>(len, item: EMPTY_LAYER)
                for (j in 0..len) {
                  let jsonValue: JsonValue = ja[j]
                  let layer: Layer = LayerParser.parse(jsonValue)
                  layerMap.put(layer.ind, layer)
                  layers[j] = layer
                }
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[2])) {
                width = v.asInt().getValue()
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[3])) {
                height = v.asInt().getValue()
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[4])) {
                imageFileName = v.asString().getValue()
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[5])) {
                relativeFolder = v.asString().getValue()
            }
            if (let Some(v) <- jo.get(ASSETS_NAMES[6])) {
                e = v.asInt().getValue()
            }

            let asset: Asset = Asset(id, layers, width, height, imageFileName, relativeFolder, e)
            assets[i] = asset
        }
        return assets
    }

    //"fonts"
    private static let FONT_NAMES: String = "list"

    private static func parseFonts(reader: JsonValue): Fonts {
        let jsonObject: JsonObject = reader.asObject()
        var list: Array<Font> = Array<Font>()
        if (let Some(v) <- jsonObject.get(FONT_NAMES)) {
            let ja: JsonArray = v.asArray()
            let len: Int64 = ja.size()
            if (len > 0) {
                let EMPTY_FONT: Font = Font("", "", "", 0.0, "", 0, "", "", "")
                list = Array<Font>(len, item: EMPTY_FONT)
                for (i in 0..len) {
                    let jo: JsonObject = ja[i].asObject()
                    let font: Font = FontParser.parse(jo)
                    list[i] = font
                }
            }
        }
        return Fonts(list: list)
    }

    private static func parseChars(reader: JsonArray): Array<FontCharacter> {
        let len: Int64 = reader.size()
        let EMPTY_FCHARS: FontCharacter = FontCharacter(CharsData(shapes: Array<ContentModel>()), "", 0.0, 0.0, "", "")
        let chars: Array<FontCharacter> = Array<FontCharacter>(len, item: EMPTY_FCHARS)
        for (i in 0..len) {
            let jo: JsonObject = reader[i].asObject()
            let character: FontCharacter = FontCharacterParser.parse(jo)
            chars[i] = character
        }
        return chars
    }

    //"markers"
    private static let MARKER_NAMES: Array<String> = [
        "cm",
        "tm",
        "dr"
    ]

    private static func parseMarkers(reader: JsonArray): Array<Marker> {
        let len: Int64 = reader.size()
        if (len <= 0) {
            return Array<Marker>()
        }
        let EMPTY_MARKER: Marker = Marker("", 0.0, 0.0)
        let markers: Array<Marker> = Array<Marker>(len, item: EMPTY_MARKER)
        for (i in 0..len) {
            var comment: String = ""
            var frame: Float64 = 0.0
            var durationFrames: Float64 = 0.0

            let jo: JsonObject = reader[i].asObject()
            if (let Some(v) <- jo.get(MARKER_NAMES[0])) {
                comment = v.asString().getValue()
            }
            if (let Some(v) <- jo.get(MARKER_NAMES[1])) {
                frame = v.asFloat().getValue()
            }
            if (let Some(v) <- jo.get(MARKER_NAMES[2])) {
                durationFrames = v.asFloat().getValue()
            }
            markers[i] = Marker(comment, frame, durationFrames)
        }
        return markers
    }

}
