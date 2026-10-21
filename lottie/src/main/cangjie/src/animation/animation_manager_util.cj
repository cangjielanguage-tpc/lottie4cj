/**
 * @file This file is AnimationManager release.
 */
package lottie.animation

internal import lottie.utils.helpers.*

public class Callback <: Callback1Argument<IntervalInfo> {
    let resume: (Int64) -> Unit
    public init(resume: (Int64) -> Unit) {
        this.resume = resume
    }
    public open func invoke(arg: IntervalInfo): Unit {
        //返回自1970年1月1日午夜（UTC）以来经过的毫秒数
        resume(SystemDateTime.getCurrentTime())
    }
}

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

