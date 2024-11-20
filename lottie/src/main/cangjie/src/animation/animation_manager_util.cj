/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is AnimationManager release.
 */
package lottie.animation

internal import lottie.utils.helpers.*

/*
class AnimatorOptions {
    var duration: Int64     //动画播放的时长，单位毫秒。默认值:0。
    var easing:	String      //动画插值曲线，仅支持以下可选值：
    var delay: Int64        //动画延时播放时长，单位毫秒，设置为0时，表示不延时。设置为负数时动画提前播放，如果提前播放的时长大于动画总时长，动画直接过渡到终点。默认值:0。
    var fill: String        //动画执行后是否恢复到初始状态，动画执行后，动画结束时的状态（在最后一个关键帧中定义）将保留。
    var direction: String   //动画播放模式。
    var iterations: Int64   //动画播放次数。设置为0时不播放，设置为-1时无限次播放。说明: 设置为除-1外其他负数视为无效取值，无效取值动画默认播放1次。
    var begin: Int64        //动画插值起点。默认值:0。
    var end: Int64          //动画插值终点。默认值:1。
    
    init(
        duration!: Int64 = 0,
        easing!:	String = "",
        delay!: Int64 = 0,
        fill!: String = "",
        direction!: String = "",
        iterations!: Int64 = 0,
        begin!: Int64 = 0,
        end!: Int64 = 1
    ){
        this.duration = duration
        this.easing = easing
        this.delay = delay
        this.fill = fill
        this.direction = direction
        this.iterations = iterations
        this.begin = begin
        this.end = end
    }
}
*/

class RegisteredAnimation {
    //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？
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

