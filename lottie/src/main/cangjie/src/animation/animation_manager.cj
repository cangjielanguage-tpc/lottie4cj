/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is AnimationManager.
 */
package lottie.animation

internal import std.sync.*
internal import std.time.*
internal import std.math.*
internal import std.collection.HashMap
internal import std.collection.ArrayList

internal import lottie.inner.*
internal import lottie.global_data.*
internal import lottie.model.*
internal import lottie.parser.*
internal import lottie.renderers.*
internal import lottie.elements.*
internal import lottie.utils.*
internal import lottie.utils.audio.*

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.animator.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.ability.*
internal import ohos.resource_manager.*
internal import ohos.bundle_manager.*

internal import ohos.hilog.*

public class AnimationManager {

    //TODO：cj 没有 js 的可以直接用的 document。设置一个 document：CreateTag 对象在 最外层的 lottie 中？？？
    //TODO: 最外层的 lottie 传过来？？？
    var document: HashMap<String, Array<CreateNS>> = HashMap<String, Array<CreateNS>>(24)

    //TODO: 初始化一个空的 AnimationConfig。
    var params: AnimationConfig
    //var params: AnimationConfig = AnimationConfig(
    //      wrapper_ns: CreateNS("doc"),
    //      container: canvasRenderingContext,
    //      renderer: "canvas", // canvas 渲染模式
    //      loop: true,
    //      autoplay: true,
    //      name: "2016",
    //      contentMode: "Contain",
    //      path: "common/lottie/data.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
    //      // path: "common/lottie/data_rawfile.json"
    //      // path: "common/lottie/data_base64.json"
    //      animationData: AnimationData()
    //    )

    //TODO: 暂未确认 registeredAnimations 的数据类型。自定义数据类型 RegisteredAnimation。
    var registeredAnimations: ArrayList<RegisteredAnimation> = ArrayList<RegisteredAnimation>()
    var initTime: Int64 = 0
    var animatorTime: Int64 = 0
    var len: Int64 = 0
    var playingAnimationsNum: Int64 = 0
    var _stopped: Bool = true
    var _paused: Bool = true
    var _isFrozen: Bool = false

    var _packageName: String = ""

    //需要引入 @ohos.animator 的 AnimatorResult
    var _animator: ?AnimatorResult = None


    //当前Animator的状态
    var animatorState: AnimationStatus = AnimationStatus.None

    public init(canvasRenderingContext: CanvasRenderingContext2D){
        this.params = AnimationConfig(
          wrapper_ns: CreateNS("doc"),
          container: canvasRenderingContext
        )
    }

    //TODO: 暂未确认 ev 的数据类型。综合查找，暂定数据类型为 BMDestroyEvent。
    //func subtractPlayingCount(en: Option<BMEvent>): Unit {
    func removeElement(ev2: Option<BMEvent>): Unit {
        var ev: BMDestroyEvent = (ev2.getOrThrow() as BMDestroyEvent).getOrThrow()
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
                        subtractPlayingCount(Option<BMEvent>.None)
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

        var animItem: AnimationItem = AnimationItem(this)

        setupAnimation(animItem, element)

        //TODO: 调用 setData(wrapper: CanvasRenderingContext2D, animationData: AnimationData) ？？？
        //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？-- 再增加一个参数 wrapper_ns: CreateNS
        animItem.setData(params.container.ctx2d, animationData, wrapper_ns: element)

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

    func addPlayingCount(en: Option<BMEvent>): Unit {
        this.playingAnimationsNum += 1
        activate()
    }

    func subtractPlayingCount(en: Option<BMEvent>): Unit {
        this.playingAnimationsNum -= 1
    }

    //TODO: element 数据类型是 CanvasRenderingContext2D 还是 CreateNS ？？？
    func setupAnimation(animItem: AnimationItem, element: CreateNS): Unit {
        //TODO:需要增加判断 animItem 是否是 null 吗？  //if (!!animItem) {}
        animItem.addEventListener("destroy", AnimationEventCallback(this.removeElement))
        animItem.addEventListener("_active", AnimationEventCallback(this.addPlayingCount))
        animItem.addEventListener("_idle", AnimationEventCallback(this.subtractPlayingCount))
        registeredAnimations.append(RegisteredAnimation( elem: element, animation: animItem ))
        len += 1
    }

    public func loadAnimation(ac: AnimationConfig): AnimationItem {

        this.params = ac
        let animItem: AnimationItem = AnimationItem(this)

        setupAnimation(animItem, CreateNS(""))

        animItem.setParams(ac)
        return animItem
    }

    //TODO: 暂未确认 animation 数据类型。
    public func setSpeed(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: 多了一个参数？？？   //registeredAnimations[i].animation.setSpeed(val, animation)
                registeredAnimations[i].animation.setSpeed(val)
            }
        }
    }

    //TODO: 暂未确认 animation 数据类型。
    public func setDirection(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                //TODO: 多了一个参数？？？   //registeredAnimations[i].animation.setDirection(val, animation)
                registeredAnimations[i].animation.setDirection(val)
            }
        }
    }

    public func play(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.play(name: animation)
            }
        }
        _paused = false
    }

    func resume(nowTime: Int64): Unit {
        var elapsedTime: Int64 = nowTime - initTime
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.advanceTime(Float64(elapsedTime))
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
                registeredAnimations[i].animation.pause(name: animation)
            }
        }
    }

    public func goToAndStop(value: Float64, isFrame: Bool, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.goToAndStop(value, isFrame, animation)
            }
        }
    }

    public func stop(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.stop(animation)
            }
        }
    }

    public func togglePause(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.togglePause(animation)
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
        if (let Some(v) <- this._animator) {
            if (state == AnimationStatus.Paused) {
                //TODO：需要引入 @ohos.animator 的 AnimatorResult
                v.pause()
            }
            if (state == AnimationStatus.Stopped) {
                //TODO：需要引入 @ohos.animator 的 AnimatorResult
                v.finish()
            }
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
                registeredAnimations[i].animation.destroy(animation)
            }
        }
        //判断动画是否全部销毁，如果animation全部销毁，则设置Animator的状态为Stopped
        if (animation == "" || registeredAnimations.size == 0 || !tag) {
            setAnimatorState(AnimationStatus.Stopped)
            _stopped = true
            _isFrozen = false
            //TODO：需要引入 @ohos.animator 的 AnimatorResult
            this._animator = None
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
                registeredAnimations[i].animation.setContentMode(contentMode)
            }
        }
    }

    public func resize(): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            //if (registeredAnimations.size > i  && !!registeredAnimations[i].animation) {
            if (registeredAnimations.size > i) {
                //TODO: 少传 2 个参数。  //registeredAnimations[i].animation.resize()
                registeredAnimations[i].animation.resize(0, 0)
            }
        }
    }

    //TODO: 暂未实现。
    func activate() {
        if (!_isFrozen && playingAnimationsNum != 0) {
            if (_stopped) {
                //TODO：需要引入 @ohos.animator 的 AnimatorResult
                if (let Some(v) <- this._animator) {
                    v.finish()
                }

                //TODO：数据类型需要再确认，是时间格式还是数值格式？？？  //initTime = Date.now()
                initTime = DateTime.now().toUnixTimeStamp().toMilliseconds()
                let options: AnimatorOptions = AnimatorOptions(
                    duration: 20000,
                    easing: "linear",
                    delay: 0,
                    fill: AnimatorFill.Forwards, //"forwards",
                    direction: AnimatorDirection.Normal, //"normal",
                    iterations: -1,
                    begin: 0.0,
                    end: 1.0
                )
                //TODO：需要引入 @ohos.animator 的 create(options: AnimatorOptions): AnimatorResult
                //this._animator = animator.create(options)
                let backAnimator: AnimatorResult = AnimatorResult(options)
                 //TODO：需要引入 @ohos.animator 的 AnimatorResult
                backAnimator.onframe = { value: Float64  =>
                    AppLog.info("onframe called ${value}")
                    // js 中 Date.now()：返回自1970年1月1日午夜（UTC）以来经过的毫秒数  //resume(Date.now())
                    resume(DateTime.now().toUnixTimeStamp().toMilliseconds())
                }
                backAnimator.play()
                this._animator = backAnimator

                animatorState = AnimationStatus.Running
                _stopped = false
            }
        }
    }

    public func freeze(): Unit {
        this._isFrozen = true
    }

    public func unfreeze(): Unit {
        this._isFrozen = false
        activate()
    }

    public func setVolume(val: Int64, animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.setVolume(val, animation)
            }
        }
    }

    public func mute(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.mute(animation)
            }
        }
    }

    public func unmute(animation: String): Unit {
        for (i in 0..len) {
            //TODO: 是否增加 registeredAnimations[i].animation 非null判断？？？
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.unmute(animation)
            }
        }
    }

}
