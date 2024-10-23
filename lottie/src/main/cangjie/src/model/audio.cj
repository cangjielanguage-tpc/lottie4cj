/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is Audio.
 */
package lottie.model

public class Audio <: ToString {

    public var isPlaying: Bool = false
    public var play: () -> Unit = { => this.isPlaying = true }
    public var seek: () -> Unit = { => this.isPlaying = false }
    public var playing: () -> Unit = { => ()}
    public var rate: () -> Unit = { => ()}
    public var setVolume: () -> Unit = { => ()}

    /**
     * Create a Audio instance based on parameters.
     *
     * @param isPlaying - Type of Bool, the value of isPlaying.
     * @param play - Type of function () -> Unit.
     * @param seek - Type of function () -> Unit.
     * @param playing - Type of function () -> Unit.
     * @param rate - Type of function () -> Unit.
     * @param setVolume - Type of function () -> Unit.
     */
    public init(
        isPlaying!: Bool = false,
        play!: () -> Unit = { => ()},
        seek!: () -> Unit = { => ()},
        playing!: () -> Unit = { => ()},
        rate!: () -> Unit = { => ()},
        setVolume!: () -> Unit = { => ()}
    ){
        this.isPlaying = isPlaying
        this.play = play
        this.seek = seek
        this.playing = playing
        this.rate = rate
        this.setVolume = setVolume
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "Audio: {isPlaying = ${this.isPlaying}}}"
    }

    //TODO: AudioControllerFactory 中编译用，暂未实现。
    public func volume(volume: Int64): Unit {}
    public func setRate(rateValue: Int64): Unit {}
    public func resume(): Unit {}
    public func pause(): Unit {}


}
