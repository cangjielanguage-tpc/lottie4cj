/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is AnimationManager.
 */
package lottie.animation

internal import std.sync.*
internal import std.time.*
internal import std.math.*
internal import std.fs.{FileInfo}
internal import std.collection.HashMap
internal import std.collection.ArrayList
internal import std.io.{InputStream, ByteArrayStream}

internal import lottie.inner.*
internal import lottie.global_data.*
internal import lottie.model.*
internal import lottie.parser.*
internal import lottie.renderers.*
internal import lottie.elements.*
internal import lottie.utils.*
internal import lottie.utils.audio.*

internal import tpc.UIKit.component_interop.CanvasGradient
internal import tpc.UIKit.component_interop.RenderingContextSettings
internal import tpc.UIKit.component_interop.CanvasRenderingContext2D
internal import tpc.UIKit.component_interop.Canvas
import ohos.state_macro_manage.*
import tpc.AbilityKit.UIAbilityContext
//internal import ohos.resource_manager.*
internal import ohos.bundle_manager.*

internal import ohos.hilog.*
import ohos.animator.{AnimatorResult,AnimatorOptions,AnimatorFill,AnimatorDirection}
internal import ohos.system_date_time.*

public class AnimationManager {

    //cj 没有 js 的可以直接用的 document。设置一个 document：CreateTag 对象在 最外层的 lottie 中？？？
    //最外层的 lottie 传过来？？？
    var document: HashMap<String, Array<CreateNS>> = HashMap<String, Array<CreateNS>>(16)

    var params: AnimationConfig

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

    func removeElement(ev2: Option<BMEvent>): Unit {
        var ev: BMDestroyEvent = (ev2.getOrThrow() as BMDestroyEvent).getOrThrow()
        var i: Int64 = 0
        let animItem: AnimationItem = ev.target
        while (i < len) {
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

    public func registerAnimation(element: CreateNS, animationData: AnimationData): Option<AnimationItem> {
        if (element.isNull) {
            return None
        }
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                if (refEq(registeredAnimations[i].elem, element) && !registeredAnimations[i].elem.isNull) {
                    return registeredAnimations[i].animation
                }
            }
        }

        var animItem: AnimationItem = AnimationItem(this)

        setupAnimation(animItem, element)

        animItem.setData(params.container.ctx2d, animationData, wrapper_ns: element)

        return animItem
    }

    public func getRegisteredAnimations(): ArrayList<AnimationItem> {
        let lenAnims: Int64 = registeredAnimations.size
        var animations: ArrayList<AnimationItem> = ArrayList<AnimationItem>(24)
        for (i in 0..lenAnims) {
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

    func setupAnimation(animItem: AnimationItem, element: CreateNS): Unit {
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

    public func setSpeed(val: Float64): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.setSpeed(val)
            }
        }
    }

    public func setDirection(val: Int64): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.setDirection(val)
            }
        }
    }

    public func play(animationName!: String = ""): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.play(name: animationName)
            }
        }
        _paused = false
    }

    func resume(nowTime: Int64): Unit {
        var elapsedTime: Int64 = nowTime - initTime
        for (i in 0..len) {
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
    }

    public func pause(animationName!: String = ""): Unit {
        _paused= true
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.pause(name: animationName)
            }
        }
    }

    public func goToAndStop(value: Float64, isFrame!: Bool = false, animationName!: String = ""): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.goToAndStop(value, isFrame: isFrame, name: animationName)
            }
        }
    }

    public func stop(animationName!: String = ""): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.stop(name: animationName)
            }
        }
    }

    public func togglePause(animationName!: String = ""): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.togglePause(name: animationName)
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
        //需要引入 @ohos.animator 的 AnimatorResult
        if (let Some(v) <- this._animator) {
            if (state == AnimationStatus.Paused) {
                v.pause()
            }
            if (state == AnimationStatus.Stopped) {
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

    public func destroy(animationName!: String = ""): Unit {
        var tag: Bool = false
        for (i in (len - 1)..=0:-1) {
            if (registeredAnimations.size > i) {
                if (!registeredAnimations[i].animation.isPaused && registeredAnimations[i].animation.name != animationName) {
                    //如果还有其他动画也在播放，则不需要停止
                    tag = true
                }
                registeredAnimations[i].animation.destroy(name:animationName)
            }
        }
        //判断动画是否全部销毁，如果animation全部销毁，则设置Animator的状态为Stopped
        if (animationName == "" || registeredAnimations.size == 0 || !tag) {
            setAnimatorState(AnimationStatus.Stopped)
            _stopped = true
            _isFrozen = false
            this._animator = None
        }
    }

    public func searchAnimations(animationData: AnimationData, standalone: Bool, renderer2: String): Unit {
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
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.setContentMode(contentMode)
            }
        }
    }

    public func resize(): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.resize()
            }
        }
    }

    func activate() {
        if (!_isFrozen && playingAnimationsNum != 0) {
            if (_stopped) {
                if (let Some(v) <- this._animator) {
                    v.finish()
                }

                initTime = SystemDateTime.getCurrentTime()
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

                let backAnimator: AnimatorResult = AnimatorResult(options)
                backAnimator.onframe = { value: Float64  =>
                    //AppLog.info("onframe called ${value}")
                    //返回自1970年1月1日午夜（UTC）以来经过的毫秒数
                    resume(SystemDateTime.getCurrentTime())
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

    public func setVolume(val: Int64, animationName: String): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.setVolume(val, animationName)
            }
        }
    }

    public func mute(animationName: String): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.mute(animationName)
            }
        }
    }

    public func unmute(animationName: String): Unit {
        for (i in 0..len) {
            if (registeredAnimations.size > i) {
                registeredAnimations[i].animation.unmute(animationName)
            }
        }
    }




    func readFile(context: Option<UIAbilityContext>, path: String): Array<Byte> {
        var buf: Array<Byte> = Array<Byte>()
        if(path.startsWith("/data/storage/")) {
            buf = FileUtils.readToEnd(path)
        } else if (this.params.pathSourceFrom == 2) {
            buf = FileUtils.readToEnd(FileUtils.phoneFolder + "/" + path)
        } else if(path.startsWith("file://") || path.startsWith("https:")) {
            /* 通过URL.openStream获取数据 */
        } else {
            buf = context.getOrThrow().resourceManager.getRawFileContent(path)
        }

        return buf
    }

    func clearSingleFileCache(path: String, container: Option<UIAbilityContext>): Unit {
        let isHttp = path.startsWith("http")
        if (isHttp) {
            let parts = path.split("/")
            let secondLastSegment = parts[parts.size - 2]
            let lastSegmentWithExtension = parts[parts.size - 1]

            var lastSegment: String = lastSegmentWithExtension
            if (lastSegmentWithExtension.endsWith(".zip")) {
                lastSegment = lastSegmentWithExtension.replace(".zip", "")
            } else if (lastSegmentWithExtension.endsWith(".tar.gz")) {//.tar.gz  //.gzip
                lastSegment = lastSegmentWithExtension.replace(".tar.gz", "")
            } else if (lastSegmentWithExtension.endsWith(".gz")) {
                lastSegment = lastSegmentWithExtension.replace(".gz", "")
            } else if (lastSegmentWithExtension.endsWith(".json")) {
                lastSegment = lastSegmentWithExtension.replace(".json", "")
            }

            var dirPath = FileUtils.downloadBase + "/lottie"  //getContext().filesDir
            let dirPathFirst = "${dirPath}/${secondLastSegment}"
            dirPath = "${dirPathFirst}/${lastSegment}"
            rmdir(dirPath)
        }
        if (let Some(context) <- container) {
            try {
                let arrayBuffer: Array<Byte> = readFile(container, path)
                if (arrayBuffer.size <= 0) { return }
                let bas: ByteArrayStream = ByteArrayStream(arrayBuffer.size)
                bas.write(arrayBuffer)

                // 解码的json数据
                let jsonObj: AnimationData = AnimationDataParser.parse(bas)

                let loadPath: String = FileUtils.downloadBase + "/lottie/loadImages/"   //getContext().filesDir

                var isExitNetworkAssets: Bool = false
                for (i in 0..jsonObj.assets.size) {
                    if (jsonObj.assets[i].p.startsWith("http")){
                        isExitNetworkAssets = true
                        break
                    }
                }

                if (isExitNetworkAssets) {
                    rmdir(loadPath, jsonObj: jsonObj)
                }
            } catch (err: Exception) {
                Hilog.error(0, "[AnimationManager]", "[clearSingleFileCache]-lottie delete file and assets failed with error message: ${err.message}")
            }
        }
    }

    public func clearFileCache(url!: String = "", container!: Option<UIAbilityContext> = None): Unit {
        if (url != "") {
            clearSingleFileCache(url, container)
            return
        }
        let fileDir = FileUtils.downloadBase + "/lottie"
        let cacheDir = FileUtils.downloadBase + "/lottie"
        rmdir(fileDir)
        rmdir(cacheDir)
    }

    func rmAssetsDir(path: String, assets: Asset, filenames: Array<String>): Unit {
        if (assets.p.startsWith("http")) {

            let index: Int64 = filenames.indexOf(assets.id + ".png") ?? -1
            if (index != -1) {
                try {
                    FileUtils.deleteFile(path + filenames[index])
                } catch (err: Exception) {
                    Hilog.error(0, "[AnimationManager]", "[rmAssetsDir]-lottie remove file failed with error message: ${err.message}")
                }
            }
        }
    }

    func rmDirByPath(path: String, filename: String, isDirectory!: Bool = true): Unit {
        let dirPath = path + "/" + filename
        // 判断是否文件夹
        try {
            if (isDirectory) {
                FileUtils.deleteDirectory(dirPath)
            } else {
                try {
                    FileUtils.deleteFile(dirPath)
                } catch (errs: Exception) {
                    Hilog.error(0, "[AnimationManager]", "[rmDirByPath]-lottie remove file failed with error message: ${errs.message}")
                }
            }
        } catch (err: Exception) {
            Hilog.error(0, "[AnimationManager]", "[rmDirByPath]-Method rmDirByPath execute error: ${err.message}")
        }
    }

    func rmdir(path: String, jsonObj!: AnimationData = AnimationData(isNull: true)): Unit {
        try {
            let files: ArrayList<FileInfo> = FileUtils.fileList(path)
            let filenames: Array<String> = Array<String>(files.size, item: "")
            for (i in 0..files.size) {
                let fileName: String = files[i].path.fileName ?? ""
                filenames[i] = fileName
            }

            if (!jsonObj.isNull && jsonObj.assets.size > 0 && filenames.size > 0) {
                for (i in 0..jsonObj.assets.size) {
                    rmAssetsDir(path, jsonObj.assets[i], filenames)
                }
            } else {
                for (i in 0..filenames.size) {
                    rmDirByPath(path, filenames[i], isDirectory: false)
                }

                let directorys: ArrayList<FileInfo> = FileUtils.directoryList(path)
                let directorynames: Array<String> = Array<String>(directorys.size, item: "")
                for (i in 0..directorys.size) {
                    let res: Array<String> = directorys[i].path.toString().split("/", removeEmpty: true)
                    let fileName = res[res.size - 1]
                    directorynames[i] = fileName
                }
                for (i in 0..directorynames.size) {
                    rmDirByPath(path, directorynames[i])
                }
            }
        } catch (err: Exception) {
            Hilog.error(0, "[AnimationManager]", "lottie rmdir: ${err.message}")
        }
    }

}
