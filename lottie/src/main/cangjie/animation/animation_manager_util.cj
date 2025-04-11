/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is AnimationManager release.
 */
package lottie.animation

class RegisteredAnimation {
    var elem: CreateNS
    var animation: AnimationItem
    
    init(elem!: CreateNS, animation!: AnimationItem){
        this.elem = elem
        this.animation = animation
    }
}

public enum AnimationStatus {
    | Paused
    | Stopped
    | Blue
    | Running
    | None
    
    /**
     * The Function is ==
     *
     * @param that of AnimationStatus
     *
     * @return Type of Bool
     */
    public operator func == (that: AnimationStatus): Bool {
        match ((this, that)) {
            case (Paused, Paused) => true
            case (Stopped, Stopped) => true
            case (Blue, Blue) => true
            case (Running, Running) => true
            case _ => false
        }
    }

    /**
     * The Function is !=
     *
     * @param that of AnimationStatus
     *
     * @return Type of Bool
     */
    public operator func != (that: AnimationStatus): Bool {
        return !(this == that)
    }
}

