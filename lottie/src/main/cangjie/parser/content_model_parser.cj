/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.parser

class ContentModelParser {
    static func parse(reader: JsonReader): ContentModel {
        var types: String = ""

        var model: ContentModel = ContentModel()
        // Unfortunately, for an ellipse, d is before "ty" which means that it will get parsed
        // before we are in the ellipse parser.
        // "d" is 2 for normal and 3 for reversed.
        var d: Int64 = 2
        reader.startObject()
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "d" => d = reader.readValue<Int64>()
                case "ty" =>
                    types = reader.readValue<String>()
                    break
                case _ => reader.skip()
            }
        }

        if (types.isEmpty()) {
            reader.endObject()
            return model
        }
        match (types) {
            case "gr" => model = ShapeGroupParser.parse(reader)
            case "st" => model = ShapeStrokeParser.parse(reader)
            case "gs" => model = GradientStrokeParser.parse(reader)
            case "fl" => model = ShapeFillParser.parse(reader)
            case "gf" => model = GradientFillParser.parse(reader)
            case "tr" => model = AnimatableTransformParser.parse(reader, types)
            case "sh" => model = ShapePathParser.parse(reader)
            case "el" => model = CircleShapeParser.parse(reader, d)
            case "rc" => model = RectangleShapeParser.parse(reader)
            case "tm" => model = ShapeTrimPathParser.parse(reader)
            case "sr" => model = PolystarShapeParser.parse(reader)
            case "mm" =>
                model = MergePathsParser.parse(reader)
                logger.log(
                    LogLevel.INFO,
                    "Animation contains merge paths. Merge paths are only " +
                        "supported on KitKat+ and must be manually enabled by calling " +
                        "enableMergePathsForKitKatAndAbove()."
                )
            case "rp" => model = RepeaterParser.parse(reader)
            case "rd" => model = RoundedCornersParser.parse(reader)
            case _ => throw Exception("Unknown shape type: " + types)
        }
        reader.endObject()
        return model
    }
}
