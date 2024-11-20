/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Marker structure.
 */
package lottie.model

public class MarkerDataPayload {
    public var name: String = ""                          // markers.cm
    public var isNull: Bool = false
    
    public init(){
        this.name = name
        this.isNull = true
    }
    public init(name!: String){
        this.name = name
    }
}

public class MarkerData {

    public var payload: MarkerDataPayload             // 0 = { name: marker.cm }
    public var time: Float64                          // 1 =         marker.tm
    public var duration: Float64                      // 2 =         marker.dr
    public var isNull: Bool = false

    /**
     * Create a MarkerData instance based on parameters.
     *
     * @param payload - Type of MarkerDataPayload, the value of payload.
     * @param time - Type of Float64, the value of time.
     * @param duration - Type of Float64, the value of duration.
     */
    public init(payload!: MarkerDataPayload = MarkerDataPayload(), time!: Float64 = 0.0, duration!: Float64 = 0.0, isNull!: Bool = false) {
        this.payload = payload
        this.time = time
        this.duration = duration
        this.isNull = isNull
    }

}
