/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is AnimationManager.
 */
package lottie4cj.animation

internal import std.sync.*
internal import std.time.*
internal import std.math.*
internal import std.collection.HashMap
internal import std.collection.ArrayList

internal import lottie4cj.inner.*
internal import lottie4cj.global_data.*
internal import lottie4cj.model.*
internal import lottie4cj.parser.*
internal import lottie4cj.renderers.*
internal import lottie4cj.elements.*
internal import lottie4cj.utils.*
internal import lottie4cj.utils.audio.*

public class AnimationManager {

    //TODO：cj 没有 js 的可以直接用的 document。设置一个 document：CreateTag 对象在 最外层的 lottie 中？？？
    //TODO: 最外层的 lottie 传过来？？？
    var document: HashMap<String, Array<CreateNS>> = HashMap<String, Array<CreateNS>>(24)

    var params: AnimationConfig = AnimationConfig()

    //TODO: 暂未确认 registeredAnimations 的数据类型。自定义数据类型 RegisteredAnimation。
    var registeredAnimations: ArrayList<RegisteredAnimation> = ArrayList<RegisteredAnimation>()
    var initTime: Int64 = 0
    var animatorTime: Int64 = 0
    var len: Int64 = 0
    var playingAnimationsNum: Int64 = 0
    var _stopped: Bool = true
    var _paused: Bool = true
    var _isFrozen: Bool = false
    //TODO：需要引入 @ohos.animator 的 AnimatorResult   //var _animator = undefined
    var _packageName: String = ""

    //当前Animator的状态
    var animatorState: AnimationStatus = AnimationStatus.Empty

    //TODO: 暂未确认 ev 的数据类型。综合查找，暂定数据类型为 BMDestroyEvent。
    func removeElement(ev: BMDestroyEvent): Unit {
        var i: Int64 = 0
        let animItem: AnimationItem = ev.target
        while (i < len) {
            //TODO: 暂未确认 registeredAnimations 的数据类型。自定义数据类型 RegisteredAnimation。
            if (registeredAnimations.size > i) {
                if (refEq(registeredAnimations[i].animation, animItem)) {
                    //splice: 从数组中添加或删除元素。-- splice(i, 1) 此处是删除--删除下标 i 处元素
                    registeredAnimations.remove(i)
                    i -= 1
                    len -= 1
                    if (!animItem.isPaused) {
                        subtractPlayingCount()
                    }
                }
            }
            i += 1
        }
    }

    //TODO: element 的数据类型： CreateTag/CreateNS。将 CreateTag 和 CreateNS 进行合并，合并为 CreateNS？？？
    //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？
    public func registerAnimation(element: CreateNS, animationData: AnimationData): Option<AnimationItem> {
        if (element.isNull) {
            return None
        }
        for (i in 0..len) {
            //TODO: 暂未确认 registeredAnimations 的数据类型。自定义数据类型 RegisteredAnimation。
            if (registeredAnimations.size > i) {
                if (refEq(registeredAnimations[i].elem, element) && !registeredAnimations[i].elem.isNull) {
                    return registeredAnimations[i].animation
                }
            }
        }
        //TODO: 暂未和 AnimationItem 联调。  //var animItem: AnimationItem = AnimationItem(this)
        var animItem: AnimationItem = AnimationItem()

        setupAnimation(animItem, element)

        //TODO: 调用 setData(wrapper: CanvasRenderingContext2D, animationData: AnimationData) ？？？
        //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？-- 再增加一个参数 wrapper_ns: CreateNS
        //TODO: AnimationItem 暂未联合编译。  //animItem.setData(params.container, animationData, wrapper_ns: element)

        return animItem
    }

    public func getRegisteredAnimations(): ArrayList<AnimationItem> {
        let lenAnims: Int64 = registeredAnimations.size
        //TODO: 暂未确认 registeredAnimations[i].animation 数据类型，暂定为 AnimationItem。
        var animations: ArrayList<AnimationItem> = ArrayList<AnimationItem>(24)
        for (i in 0..lenAnims) {
            //TODO: 是否保留 registeredAnimations[i] 为 Null 的判断？？？  //if (registeredAnimations.size > i) {}
            animations.append(registeredAnimations[i].animation)
        }
        return animations
    }

    func addPlayingCount(): Unit {
        this.playingAnimationsNum += 1
        activate()
    }

    func subtractPlayingCount(): Unit {
        this.playingAnimationsNum -= 1
    }

    //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？
    func setupAnimation(animItem: AnimationItem, element: CreateNS): Unit {
        //TODO:需要增加判断 animItem 是否是 null 吗？  //if (!!animItem) {}
        //TODO: AnimationItem 暂未联合编译。
        /*
        animItem.addEventListener("destroy", removeElement)
        animItem.addEventListener("_active", addPlayingCount)
        animItem.addEventListener("_idle", subtractPlayingCount)
        registeredAnimations.append(RegisteredAnimation( elem: element, animation: animItem ))
        */
        len += 1
    }

    public func loadAnimation(ac: AnimationConfig): AnimationItem {
        this.params = ac
        //TODO: 暂未和 AnimationItem 联调。  //let animItem: AnimationItem = AnimationItem(this)
        let animItem: AnimationItem = AnimationItem()

        setupAnimation(animItem, CreateNS(""))
        //TODO: AnimationItem 暂未联合编译。  //animItem.setParams(ac)
        return animItem
    }

    //TODO: 暂未确认 animation 数据类型。
    public func setSpeed(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: 多了一个参数？？？
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.setSpeed(val, animation)
            }
        }
    }

    //TODO: 暂未确认 animation 数据类型。
    public func setDirection(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: 多了一个参数？？？
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.setDirection(val, animation)
            }
        }
    }

    public func play(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.play(animation)
            }
        }
        _paused = false
    }

    func resume(nowTime: Int64): Unit {
        var elapsedTime: Int64 = nowTime - initTime
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.advanceTime(elapsedTime)
            }
        }
        initTime = nowTime
        if (!(playingAnimationsNum != 0 && !_isFrozen)) {
            //防止暂停后再播放时，创建新Animator对象
            if(!_paused){
                _stopped = true
            }
        }
    }

    func first(nowTime: Int64): Unit {
        initTime = nowTime
        //TODO: 未引入 windows。   //window.requestAnimationFrame(resume)
    }

    public func pause(animation: String): Unit {
        _paused= true
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.pause(animation)
            }
        }
    }

    public func goToAndStop(value: Float64, isFrame: Bool, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.goToAndStop(value, isFrame, animation)
            }
        }
    }

    public func stop(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.stop(animation)
            }
        }
    }

    public func togglePause(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.togglePause(animation)
            }
        }
    }

    /**
     * 设置Animator的状态
     * @param state Animator的状态
     */
    public func setAnimatorState(state: AnimationStatus): Unit {
        if (state == AnimationStatus.Paused || state == AnimationStatus.Stopped) {
            _stopped = true
        }
        //TODO：需要引入 @ohos.animator 的 AnimatorResult
        //TODO：_animator 非空判断。//if (!!_animator) {}
        
        if (state == AnimationStatus.Paused) {
            //TODO：需要引入 @ohos.animator 的 AnimatorResult  //_animator.pause()
        }
        if (state == AnimationStatus.Stopped) {
            //TODO：需要引入 @ohos.animator 的 AnimatorResult  //_animator.finish()
        }
        animatorState = state
    }

    /**
     * 设置pause的状态
     * @param state pause的状态
     */
    public func setPauseState(state: Bool): Unit {
        _paused = state
    }

    /**
     *  获取Animator的状态
     * @returns Animator的状态
     */
    public func getAnimatorState(): AnimationStatus {
        return animatorState
    }

    /**
     * 设置packageName
     * @param name 应用的包名
     */
    public func setPackageName(name: String): Unit {
        _packageName = name
    }

    public func destroy(animation: String): Unit {
        var tag: Bool = false
        for (i in (len - 1)..=0:-1) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                if (!registeredAnimations[i].animation.isPaused && registeredAnimations[i].animation.name != animation) {
                    //如果还有其他动画也在播放，则不需要停止
                    tag = true
                }
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.destroy(animation)
            }
        }
        //判断动画是否全部销毁，如果animation全部销毁，则设置Animator的状态为Stopped
        if (animation == "" || registeredAnimations.size == 0 || !tag) {
            setAnimatorState(AnimationStatus.Stopped)
            _stopped = true
            _isFrozen = false
            //TODO：需要引入 @ohos.animator 的 AnimatorResult  //_animator = undefined
        }
    }

    public func searchAnimations(animationData: AnimationData, standalone: Bool, renderer2: String): Unit {
        //TODO：cj 没有 js 的可以直接用的 document。设置一个 document：CreateTag 对象在 最外层的 lottie 中？？？
        let lotties: Array<CreateNS> = document["lottie"]
        let bodymovins: Array<CreateNS> = document["bodymovin"]
        let animElements: Array<CreateNS> = lotties.concat(bodymovins)
        
        var renderer: String = renderer2

        let lenAnims: Int64 = animElements.size
        for (i in 0..lenAnims) {
            if (renderer != "") {
                animElements[i].setAttribute("data-bm-type", renderer)
            }
            registerAnimation(animElements[i], animationData)
        }
        if (standalone && lenAnims == 0) {
            if (renderer == "") {
                renderer = "svg"
            }
            let body: CreateNS = document["body"][0]

            body.innerText = ""
            var div: CreateNS = CreateNS("div")
            div.style.width = "100%"
            div.style.height = "100%"
            div.setAttribute("data-bm-type", renderer)
            body.appendChild(div)
            registerAnimation(div, animationData)
        }
    }

    public func setContentMode(contentMode: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.setContentMode(contentMode)
            }
        }
    }

    public func resize(): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            //if (registeredAnimations.size > i  && !!registeredAnimations[i].animation) {
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.resize()
            }
        }
    }

    //TODO: 暂未实现。
    func activate() {
        if (!_isFrozen && playingAnimationsNum != 0) {
            if (_stopped) {
                //TODO：需要引入 @ohos.animator 的 AnimatorResult
                //TODO：_animator 非空判断。 //if(!!_animator){}
                //TODO：需要引入 @ohos.animator 的 AnimatorResult   //_animator.finish()

                //TODO：数据类型需要再确认，是时间格式还是数值格式？？？  //initTime = Date.now()
                let options: AnimatorOptions = AnimatorOptions(
                    duration: 20000,
                    easing: "linear",
                    delay: 0,
                    fill: "forwards",
                    direction: "normal",
                    iterations: -1,
                    begin: 0,
                    end: 1
                )
                //TODO：需要引入 @ohos.animator 的 create(options: AnimatorOptions): AnimatorResult
                /*
                _animator = animator.create(options)
                //TODO：需要引入 @ohos.animator 的 AnimatorResult
                func inside(value): {
                    resume(Date.now())
                }
                _animator.onframe = inside
                _animator.play()
                */

                animatorState = AnimationStatus.Running
                _stopped = false
            }
        }
    }

    public func freeze(): Unit {
        _isFrozen = true
    }

    public func unfreeze(): Unit {
        _isFrozen = false
        activate()
    }

    public func setVolume(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.setVolume(val, animation)
            }
        }
    }

    public func mute(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。  //registeredAnimations[i].animation.mute(animation)
            }
        }
    }

    public func unmute(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: AnimationItem 暂未联合编译。 //registeredAnimations[i].animation.unmute(animation)
            }
        }
    }

}
