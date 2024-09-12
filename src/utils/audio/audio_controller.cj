/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is AudioController.
 */
package lottie4cj.utils.audio

internal import std.collection.*

internal import lottie4cj.model.*
internal import lottie4cj.elements.*

//TODO:自定义函数类型，编译用。
func audioFactory(assetPath: String): Audio {
    return Audio()
}

public class AudioControllerFactory {

    public var audios: ArrayList<AudioElement> = ArrayList<AudioElement>(24)
    //TODO: 不确定 audioFactory 数据类型。
    public var audioFactory:(String) -> Audio = audioFactory
    public var _volume: Int64 = 1
    public var _isMuted: Bool = false

    var hasAudioFactory: Bool = false

    public init() {}

    //TODO: 不确定 audioFactory 数据类型。
    public init(audioFactory: (String) -> Audio) {
        this.audioFactory = audioFactory
        this.hasAudioFactory = true
    }

    public func addAudio(audio: AudioElement) {
        this.audios.append(audio)
    }

    public func pause(): Unit {
        let len: Int64 = this.audios.size
        for (i in 0..len) {
            this.audios[i].pause()
        }
    }

    public func resume(): Unit {
        let len: Int64 = this.audios.size
        for (i in 0..len) {
            this.audios[i].resume()
        }
    }

    public func setRate(rateValue: Int64): Unit {
        let len: Int64 = this.audios.size
        for (i in 0..len) {
            this.audios[i].setRate(rateValue)
        }
    }

    public func createAudio(assetPath: String): Audio {
        if (this.hasAudioFactory) {
            return this.audioFactory(assetPath)
        }
        return Audio()
    }

    public func setAudioFactory(audioFactory: (String) -> Audio): Unit {
        this.audioFactory = audioFactory
    }

    public func setVolume(value: Int64): Unit {
        this._volume = value
        this._updateVolume()
    }

    public func mute(): Unit {
        this._isMuted = true
        this._updateVolume()
    }

    public func unmute(): Unit {
        this._isMuted = false
        this._updateVolume()
    }

    public func getVolume(): Int64 {
        return this._volume
    }

    public func _updateVolume(): Unit {
        let len: Int64 = this.audios.size
        var volume: Int64 = 0
        for (i in 0..len) {
            if (!this._isMuted) {
                volume = this._volume
            }
            this.audios[i].volume(volume)
        }
    }

}
