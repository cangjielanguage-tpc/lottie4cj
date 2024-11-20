/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Utils structure for paring the animated json.
 */
package lottie.parser

class Utils {
    static func isAtLeastVersion(major: Int32, minor: Int32, patch: Int32, minMajor: Int32, minMinor: Int32,
        minPatch: Int32): Bool {
        if (major < minMajor) {
            return false
        } else if (major > minMajor) {
            return true
        }

        if (minor < minMinor) {
            return false
        } else if (minor > minMinor) {
            return true
        }

        return patch >= minPatch
    }

    public static func parseSAK(reader: JsonReader): AK {
        var a: Int64 = 0
        var k: Int64 = 0
        while (reader.peek() != EndObject) {
            match (reader.readName()) {
                case "a" => a = reader.readValue<Int64>()
                case "k" => k = reader.readValue<Int64>()
                case _ => reader.skip()
            }
        }
        return AK(a: a, k: k)
    }
}

public func handleAIX(reader: JsonReader, keyframe: ArrayKeyframeFloat64): Unit {
    while (reader.peek() == EndObject) {
        match (reader.readName()) {
            case "a" => keyframe.a = reader.readValue<Int64>()
            case "ix" => keyframe.ix = reader.readValue<Int64>()
            case _ => reader.skip()
        }
    }
}

extend JsonToken {
    public func asString(): String {
        match (this) {
            case JsonNull => "JsonNull"
            case JsonBool => "JsonBool"
            case JsonNumber => "JsonNumber"
            case JsonString => "JsonString"
            case BeginArray => "BeginArray"
            case EndArray => "EndArray"
            case BeginObject => "BeginObject"
            case EndObject => "EndObject"
            case Name => "Name"
        }
    }
}

public class JsonReader {
    var reader: JsonStreamReader

    var tmpList: ArrayList<String> = ArrayList<String>(1)

    public init(inputStream: InputStream) {
        this.reader = JsonStreamReader(inputStream)
    }

    public func endArray(): Unit {
        reader.endArray()
    }
    public func endObject(): Unit {
        reader.endObject()
    }
    public func peek(): Option<JsonToken> {
        reader.peek()
    }
    public func readName(): String {
        let tmpName = reader.readName()
        tmpList.append(tmpName)
        return tmpName
    }
    public func readValue<T>(): T where T <: JsonDeserializable<T> {
        let tmp = reader.readValue<T>()
        return tmp
    }
    public func skip(): Unit {
        reader.skip()
    }
    public func startArray(): Unit {
        reader.startArray()
    }
    public func startObject(): Unit {
        reader.startObject()
    }
}
