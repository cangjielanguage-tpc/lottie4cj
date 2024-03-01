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

    static func parse(reader: JsonObject): ContentModel {
        var types: String = ""

        var model: ContentModel = ContentModel()
        if (let Some(v) <- reader.get(NAMES[0])) {
            types = v.asString().getValue()
        }
        if (types.isEmpty()) {
            return model
        }

        if (types == "gr") {
            model = ShapeGroupParser.parse(reader)
        } else if (types == "st") {
            model = ShapeStrokeParser.parse(reader)
        } else if (types == "gs") {
            model = GradientStrokeParser.parse(reader)
        } else if (types == "fl") {
            model = ShapeFillParser.parse(reader)
        } else if (types == "gf") {
            model = GradientFillParser.parse(reader)
        } else if (types == "tr") {
            model = AnimatableTransformParser.parse(reader)
        } else if (types == "sh") {
            model = ShapePathParser.parse(reader)
        } else if (types == "el") {
            model = CircleShapeParser.parse(reader)
        } else if (types == "rc") {
            model = RectangleShapeParser.parse(reader)
        } else if (types == "tm") {
            model = ShapeTrimPathParser.parse(reader)
        } else if (types == "sr") {
            model = PolystarShapeParser.parse(reader)
        } else if (types == "mm") {
            model = MergePathsParser.parse(reader)
            logger.log(LogLevel.INFO,  "Animation contains merge paths. Merge paths are only " +
                "supported on KitKat+ and must be manually enabled by calling " +
                "enableMergePathsForKitKatAndAbove().")
        } else if (types == "rp") {
            model = RepeaterParser.parse(reader)
        } else if (types == "rd") {
            model = RoundedCornersParser.parse(reader)
        } else {
            throw Exception("Unknown shape type: " + types)
        }

        return model
    }
}
