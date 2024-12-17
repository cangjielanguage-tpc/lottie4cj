/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is Event.
 */
package lottie.animation

func onErrorEmpty(m: BMEvent): Unit { }

public open class BMEvent {
    public var types: String
    public init(types: String) {
        this.types = types
    }
}

//类型：type = enterFrame  /drawnFrame
public class BMEnterFrameEvent <: BMEvent {
    var currentTime: Float64
    var totalTime: Float64
    var direction: Float64

    init(types: String, currentTime: Float64, totalTime: Float64, frameMultiplier: Float64) {
        super(types)
        this.currentTime = currentTime
        this.totalTime = totalTime
        if (frameMultiplier < 0.0) {
            this.direction = -1.0
        } else {
            this.direction = 1.0
        }
    }
}

//类型：type = complete
public class BMCompleteEvent <: BMEvent {
    var direction: Float64

    init(types: String, frameMultiplier: Float64) {
        super(types)
        if (frameMultiplier < 0.0) {
            this.direction = -1.0
        } else {
            this.direction = 1.0
        }
    }
}

//类型：type = loopComplete
public class BMCompleteLoopEvent <: BMEvent {
    var currentLoop: Int64
    var totalLoops: Int64
    var direction: Float64

    init(types: String, totalLoops: Int64, currentLoop: Int64, frameMultiplier: Float64) {
        super(types)
        this.currentLoop = currentLoop
        this.totalLoops = totalLoops
        if (frameMultiplier < 0.0) {
            this.direction = -1.0
        } else {
            this.direction = 1.0
        }
    }
}

//类型：type = types = "segmentStart"
public class BMSegmentStartEvent <: BMEvent {
    var firstFrame: Float64
    var totalFrames: Float64

    init(types: String, firstFrame: Float64, totalFrames: Float64) {
        super(types)
        this.firstFrame = firstFrame
        this.totalFrames = totalFrames
    }
}

//类型：type = types = "destroy"; target = AnimationItem
public class BMDestroyEvent <: BMEvent {
    public var target: AnimationItem

    public init(types: String, target: AnimationItem) {
        super(types)
        this.target = target
    }
}

public class BMRenderFrameErrorEvent <: BMEvent {
    var nativeError: Exception
    var currentTime: Int64

    init(nativeError: Exception, currentTime: Int64) {
        super("renderFrameError")
        this.nativeError = nativeError
        this.currentTime = currentTime
    }
}

public class BMConfigErrorEvent <: BMEvent {
    var nativeError: Exception

    init(nativeError: Exception) {
        super("configError")
        this.nativeError = nativeError
    }
}

public class BMLoadAnimationErrorEvent <: BMEvent {
    var nativeError: Exception

    init(nativeError: Exception) {
        super("loadAnimation")
        this.nativeError = nativeError
    }
}

public class BMLoadImageErrorEvent <: BMEvent {
    var nativeError: Exception

    init(nativeError: Exception) {
        super("loadImage")
        this.nativeError = nativeError
    }
}
