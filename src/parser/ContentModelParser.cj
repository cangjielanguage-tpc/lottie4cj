/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

class ContentModelParser {

    // "chars"."data"."shapes"
    private static let NAMES: Array<String> = [
        "ty",
        "d"
    ]

    static func parse(reader: JsonObject, composition: AnimationData): ContentModel {
        var types: String = ""

        var d: Int64 = 2

        var model: ContentModel = ContentModel()

        if (reader.containsKey(NAMES[0])) {
            types = reader[NAMES[0]].asString().getValue()
        }

        if (types.isEmpty()) {
            return model
        }

        if (reader.containsKey(NAMES[1]) && (types == "el" || types == "sr")) {
            d = reader[NAMES[1]].asInt().getValue()
        }

        if (types == "gr") {
            model = ShapeGroupParser.parse(reader, composition)
        } else if (types == "st") {
            model = ShapeStrokeParser.parse(reader, composition)
        } else if (types == "gs") {
            model = GradientStrokeParser.parse(reader, composition)
        } else if (types == "fl") {
            model = ShapeFillParser.parse(reader, composition)
        } else if (types == "gf") {
            model = GradientFillParser.parse(reader, composition)
        } else if (types == "tr") {
            model = AnimatableTransformParser.parse(reader, composition)
        } else if (types == "sh") {
            model = ShapePathParser.parse(reader, composition)
        } else if (types == "el") {
            model = CircleShapeParser.parse(reader, composition, d)
        } else if (types == "rc") {
            model = RectangleShapeParser.parse(reader, composition)
        } else if (types == "tm") {
            model = ShapeTrimPathParser.parse(reader, composition)
        } else if (types == "sr") {
            model = PolystarShapeParser.parse(reader, composition, d)
        } else if (types == "mm") {
            model = MergePathsParser.parse(reader)
            composition.addWarning("Animation contains merge paths. Merge paths are only " +
                "supported on KitKat+ and must be manually enabled by calling " +
                "enableMergePathsForKitKatAndAbove().")
        } else if (types == "rp") {
            model = RepeaterParser.parse(reader, composition)
        } else if (types == "rd") {
            model = RoundedCornersParser.parse(reader, composition)
        } else {
            throw Exception("Unknown shape type: " + types)
        }

        return model
    }
}
