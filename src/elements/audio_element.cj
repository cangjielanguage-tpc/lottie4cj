/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie4cj.elements

//TODO: 未完全实现
public class AudioElement {
    

    public var _isPlaying: Bool
    public var _canPlay: Bool
    public var _currentTime: Float64
    public var _volumeMultiplier: Int64
    public var _volume: Int64
    public var _previousVolume: Int64
    public var data: Layer

    public init(data: Layer, globalData: GlobalData) {
        //TODO: 未实现this.globalData 函数
        this._isPlaying = false
        this._canPlay = false
        this._currentTime = 0.0
        this._volumeMultiplier = 1
        this._volume = 1
        this._previousVolume = 0
        this.data = data
    }

    public func prepareFrame(num: Float64): Unit {
        if (!this._canPlay) {
            //var timeRemapped = this.tm.v;
            this._currentTime = 0.0
        } else {
            this._currentTime = num / this.data.sr
        }
        //this._volume = this.lv.v[0];
        var totalVolume = this._volume * this._volumeMultiplier;
        if (this._previousVolume != totalVolume) {
            this._previousVolume = totalVolume;
            //this.audio.volume(totalVolume);
        }
    }

    public func show() {

    }

    public func hide() {
        //this.audio.pause();
        this._isPlaying = false
    }

    public func pause() {
        try{
            //this.audio.pause();
        } catch (e: Exception) {
            return;
        }
        this._isPlaying = false
        this._canPlay = false
    }

    public func resume(){
        this._canPlay = true
    }

    public func setRate(rateValue: Int64) {
        //this.audio.rate(rateValue)
    }

    public func volume(volumeValue: Int64) {
        this._volumeMultiplier = volumeValue;
        this._previousVolume = volumeValue * this._volume;
        //this.audio.volume(this._previousVolume);
    }

    public func getBaseElement(): Option<Object> {
        return None
    }

    public func destroy(){}
    public func sourceRectAtTime(){}
    public func initExpressions(){}
}