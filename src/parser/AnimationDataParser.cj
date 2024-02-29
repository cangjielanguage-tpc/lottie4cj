/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

from std import convert.*

public let SCALE_FEFAULT: Float64 = 1.0

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
        "markers", // 1
        "nm",      // 1
        "ddd"      // 1
    ]
    
    public static func parse(reader: String): AnimationData {
        /* Get system/device pixel density. let scale: Float64 = Utils.dpScale() */
        let scale: Float64 = SCALE_FEFAULT

        var startFrame: Float64 = 0.0
        var endFrame: Float64 = 0.0
        var frameRate: Float64 = 0.0
        var version: String = ""

        let layerMap: HashMap<Int64, Layer> = HashMap<Int64, Layer>()
        let layers: ArrayList<Layer> = ArrayList<Layer>()
        let assets: ArrayList<Asset> = ArrayList<Asset>()

        var width: Int64 = 0
        var height: Int64 = 0

        let fonts: Fonts = Fonts()
        let markers: ArrayList<Marker> = ArrayList<Marker>()
        let chars: ArrayList<FontCharacter> = ArrayList<FontCharacter>()

        var nm: String = ""
        var ddd: Int64 = 0

        let composition: AnimationData = AnimationData()

        let jsonObject: JsonObject = JsonValue.fromStr(reader).asObject()

        /* Obtain key information by NAMES[0-10]. Other fields are skipped, not processed, and not saved. */
        if (jsonObject.containsKey(NAMES[0])) {
            width = jsonObject[NAMES[0]].asInt().getValue()
        }
        if (jsonObject.containsKey(NAMES[1])) {
            height = jsonObject[NAMES[1]].asInt().getValue()
        }
        if (jsonObject.containsKey(NAMES[2])) {
            startFrame = jsonObject[NAMES[2]].asFloat().getValue()
        }
        if (jsonObject.containsKey(NAMES[3])) {
            endFrame = jsonObject[NAMES[3]].asFloat().getValue()
        }
        if (jsonObject.containsKey(NAMES[4])) {
            frameRate = jsonObject[NAMES[4]].asFloat().getValue()
        }

        if (jsonObject.containsKey(NAMES[5])) {
            version = jsonObject[NAMES[5]].asString().getValue()
            let versions: Array<String> = version.split(".")

            let majorVersion: Int32 = Int32.parse(versions[0])
            let minorVersion: Int32 = Int32.parse(versions[1])
            let patchVersion: Int32 = Int32.parse(versions[2])
            if (!Utils.isAtLeastVersion(majorVersion, minorVersion, patchVersion, 4, 4, 0)) {
                composition.addWarning("Lottie only supports bodymovin >= 4.4.0")
            }
        }

        if (jsonObject.containsKey(NAMES[6])) {
            let ja: JsonArray = jsonObject[NAMES[6]].asArray()
            parseLayers(ja, composition, layers, layerMap)
        }
        if (jsonObject.containsKey(NAMES[7])) {
            let ja: JsonArray = jsonObject[NAMES[7]].asArray()
            parseAssets(ja, composition, assets)
        }

        if (jsonObject.containsKey(NAMES[8])) {
            let jv: JsonValue = jsonObject[NAMES[8]]
            parseFonts(jv, fonts)
        }
        if (jsonObject.containsKey(NAMES[9])) {
            let ja: JsonArray = jsonObject[NAMES[9]].asArray()
            parseChars(ja, composition, chars)
        }

        if (jsonObject.containsKey(NAMES[10])) {
            let ja: JsonArray = jsonObject[NAMES[10]].asArray()
            parseMarkers(ja, markers)
        }

        if (jsonObject.containsKey(NAMES[11])) {
            nm = jsonObject[NAMES[11]].asString().getValue()
        }
        if (jsonObject.containsKey(NAMES[12])) {
            ddd = jsonObject[NAMES[12]].asInt().getValue()
        }

        composition.w = width
        composition.h = height
        composition.ip = startFrame
        composition.op = endFrame
        composition.fr = frameRate
        composition.v = version
        composition.layers = layers
        composition.assets = assets
        composition.fonts = fonts
        composition.chars = chars
        composition.markers = markers
        composition.nm = nm
        composition.ddd = ddd
        return composition
    }

    private static func parseLayers(reader: JsonArray, composition: AnimationData, layers: ArrayList<Layer>, layerMap: HashMap<Int64, Layer>): Unit {
        var imageCount: Int32 = 0
        /* Iterate through and parse each layer. */
        for (i in 0..reader.size()) {
            let jv: JsonValue = reader[i]
            /* Layer parsing. */
            let layer: Layer = LayerParser.parse(jv, composition)
            if (layer.ty == LAYERS_TY_IMAGE) {
                imageCount++
            }
            /* Add layers and map to improve efficiency. */
            layers.append(layer)
            layerMap.put(layer.ind, layer)
        }
    }

    //"assets"
    static let ASSETS_NAMES: Array<String> = [
        "id",     // 0  // Picture id
        "layers", // 1  // Layer information
        "w",      // 2  // Picture width
        "h",      // 3  // Picture height
        "p",      // 4  // Picture name
        "u"       // 5  // Picture path
    ]

    private static func parseAssets(reader: JsonArray, composition: AnimationData, assets: ArrayList<Asset>): Unit {
        for (i in 0..reader.size()) {
            var id: String = ""
            let layers: ArrayList<Layer> = ArrayList<Layer>()
            let layerMap: HashMap<Int64, Layer> = HashMap<Int64, Layer>()

            /* For images. */
            var width: Int64 = 0
            var height: Int64 = 0
            var imageFileName: String = ""
            var relativeFolder: String = ""

            let jo: JsonObject = reader[i].asObject()

            if (jo.containsKey(ASSETS_NAMES[0])) {
                id = jo[ASSETS_NAMES[0]].asString().getValue()
            }
            if (jo.containsKey(ASSETS_NAMES[1])) {
                let ja: JsonArray = jo[ASSETS_NAMES[1]].asArray()
                for (j in 0..ja.size()) {
                  let jsonValue: JsonValue = ja[j]
                  let layer: Layer = LayerParser.parse(jsonValue, composition)
                  layerMap.put(layer.ind, layer)
                  layers.append(layer)
                }
            }
            if (jo.containsKey(ASSETS_NAMES[2])) {
                width = jo[ASSETS_NAMES[2]].asInt().getValue()
            }
            if (jo.containsKey(ASSETS_NAMES[3])) {
                height = jo[ASSETS_NAMES[3]].asInt().getValue()
            }
            if (jo.containsKey(ASSETS_NAMES[4])) {
                imageFileName = jo[ASSETS_NAMES[4]].asString().getValue()
            }
            if (jo.containsKey(ASSETS_NAMES[5])) {
                relativeFolder = jo[ASSETS_NAMES[5]].asString().getValue()
            }

            let asset: Asset = Asset(id, layers, width, height, imageFileName, relativeFolder)
            assets.append(asset)
        }
    }

    //"fonts"
    private static let FONT_NAMES: String = "list"

    private static func parseFonts(reader: JsonValue, fonts: Fonts): Unit {
        let jsonObject: JsonObject = reader.asObject()
        if (jsonObject.containsKey(FONT_NAMES)) {
            let ja: JsonArray = jsonObject[FONT_NAMES].asArray()
            let len: Int64 = ja.size()
            var list: Array<Font> = Array<Font>(len, item: FONT_EMPTY)
            for (i in 0..len) {
                let jo: JsonObject = ja[i].asObject()
                let font: Font = FontParser.parse(jo)
                list[i] = font
            }
            fonts.list = list
        }
    }
    
    private static func parseChars(reader: JsonArray, composition: AnimationData, chars: ArrayList<FontCharacter>): Unit {
        for (i in 0..reader.size()) {
            let jo: JsonObject = reader[i].asObject()
            let character: FontCharacter = FontCharacterParser.parse(jo, composition)
            chars.append(character)
        }
    }
    
    //"markers"
    private static let MARKER_NAMES: Array<String> = [
        "cm",
        "tm",
        "dr"
    ]

    private static func parseMarkers(reader: JsonArray, markers: ArrayList<Marker>): Unit {
        for (i in 0..reader.size()) {
            var comment: String = ""
            var frame: Float64 = 0.0
            var durationFrames: Float64 = 0.0

            let jo: JsonObject = reader[i].asObject()
            if (jo.containsKey(MARKER_NAMES[0])) {
                comment = jo[MARKER_NAMES[0]].asString().getValue()
            }
            if (jo.containsKey(MARKER_NAMES[1])) {
                frame = jo[MARKER_NAMES[1]].asFloat().getValue()
            }
            if (jo.containsKey(MARKER_NAMES[2])) {
                durationFrames = jo[MARKER_NAMES[2]].asFloat().getValue()
            }
            markers.append(Marker(comment, frame, durationFrames))
        }
    }

}
