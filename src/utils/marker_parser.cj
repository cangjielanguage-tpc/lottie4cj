/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is MarkerParser.
 */
package lottie4cj.utils

internal import encoding.json.*


/**
 * marker parser.
 *
 * @param _markers - Type of Array<Marker>.
 * @return Type of Array<MarkerData>, analyzed markers data.
 */
public func markerParser(_markers: Array<Marker>): Array<MarkerData> {
    var markers: Array<MarkerData> = Array<MarkerData>(_markers.size, repeat: MarkerData())
    for (i in 0.._markers.size) {
        var _marker: Marker = _markers[i]
        var markerData: MarkerData = MarkerData(
            time: _marker.tm,
            duration: _marker.dr
        )
        try {
            let jo: JsonObject = JsonValue.fromStr(_markers[i].cm).asObject()
            markerData.payload.name = jo["name"].asString().getValue()
        } catch (e: JsonException) {
            let mdp: MarkerDataPayload = parsePayloadLines(_markers[i].cm)
            if (mdp.isNull) {
                markerData.payload.name = _markers[i].cm
            } else {
                markerData.payload = mdp
            }
        }
        markers[i] = markerData
    }
    return markers
}

func parsePayloadLines(payload: String): MarkerDataPayload {
    let lines: Array<String> = payload.split("\r\n", removeEmpty: true)
    var keys: MarkerDataPayload = MarkerDataPayload()
    var line: Array<String> = Array<String>()
    var keysCount: Int64 = 0
    for (i in 0..lines.size) {
        line = lines[i].split(":", removeEmpty: true)
        if (line.size == 2 && line[0] == "name") {
            keys.name = line[1].trimAscii()
            keysCount += 1
        }
    }
    if (keysCount > 0) {
        keys.isNull = false
    }
    return keys
}

