/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is AnimationItem.
 */
package lottie.animation

public class AnimationItem <: BaseEvent {
 
    public var _animationManager: AnimationManager
    public var name: String = ""
    public var path: String = ""
    public var source: String = ""
    public var isLoaded: Bool = false
    public var currentFrame: Float64 = 0.0
    public var currentRawFrame: Float64 = 0.0

    public var firstFrame: Float64 = 0.0            //the number of the started frame which is in playing segments
    public var endFrame: Float64 = 0.0
    public var offsetFrame: Float64 = 0.0           //the minimum number of segment frames. Note that it's not certainly firstFrame

    public var totalFrames: Float64 = 0.0
    public var frameRate: Float64 = 0.0
    public var frameMult: Float64 = 0.0
    public var _direction: Float64 = 1.0
    public var playSpeed: Float64 = 1.0
    public var playDirection: Int64 = 1
    public var playCount: Int64 = 0
    public var animationData: AnimationData = AnimationData()
    public var assets: Array<Asset> = Array<Asset>()
    public var isPaused: Bool = true
    public var autoplay: Bool = false
    /**
     * 动画播放结束后, 是否循环播放，默认值true, 值为true时无限循环播放 值类型为number, 且>=1时为设置重复播放的次数
     * 定为 Int64 数据类型，-1 表示true，-2 表示false。
     */
    /**
     * 动画播放结束后, 是否循环播放。默认值 -1, 值为 -1 时代表无限循环播放, 值 >=1 时为设置重复播放的次数
     * 定为 Int64 数据类型，< 0 表示无限循环播放；= 0 表示不循环播放；> 0 为设置重复播放的次数。
     */
    public var loop: Int64 = 0

    let TRUE = -1
    let FALSE = 0

    //是否已经初始化指定的渲染器。
    var hasRenderer: Bool = false
    public var renderer: BaseRenderer

    public var animationID: String = ""
    public var assetsPath: String = ""
    public var timeCompleted: Float64 = 0.0
    public var segmentPos: Int64 = 0
    public var isSubframeEnabled: Bool = false

    //动画片段声明 AnimationSegment = [number, number] => Array<Float64>
    public var segments: ArrayList<Array<Float64>> = ArrayList<Array<Float64>>(24)

    public var _idle: Bool = true
    public var _completedLoop: Bool = false

    public var imagePreloader: ImagePreloader = ImagePreloader()
    public var audioController: AudioControllerFactory = AudioControllerFactory()

    public var markers: Array<MarkerData> = Array<MarkerData>()

    public var drawnFrameEvent: BMEnterFrameEvent
    public var context: Option<AbilityContext> = None

    public var packageName: String = ""
    public var contentMode: String = ""

    public var userPlayingFrameRate: Float64 = 0.0    // the max playing frame rate of this animation
    public var isNetLoad: Bool = false
    public var downLoadSource: DownLoadSource = DownLoadSource()
    
    public var _isFirstFrame: Float64 = -1.0
    public var frameModifier: Float64 = 0.0

    public var wrapper: LottieCanvasRenderingContext2D

    /*
     * 初始化动画资源播放时的整体帧范围
     * 动画片段声明 AnimationSegment = [number, number] => Array<Float64>
     */
    public var initialSegment: Array<Float64> = Array<Float64>()
    public var autoloadSegments: Bool = true

    var animType: String = ""
    var fileName: String = ""
    
    var onError: (BMEvent) -> Unit = onErrorEmpty
    var hasOnError: Bool = false
    var dataManager: DataManager = DataManager()

    var onEnterFrame: (BMEnterFrameEvent) -> Unit = onErrorEmpty
    var hasOnEnterFrame: Bool = false
    var onLoopComplete: (BMCompleteLoopEvent) -> Unit = onErrorEmpty
    var hasOnLoopComplete: Bool = false
    var onComplete: (BMCompleteEvent) -> Unit = onErrorEmpty
    var hasOnComplete: Bool = false
    var onSegmentStart: (BMSegmentStartEvent) -> Unit = onErrorEmpty
    var hasOnSegmentStart: Bool = false
    var onDestroy: (BMDestroyEvent) -> Unit = onErrorEmpty
    var hasOnDestroy: Bool = false

    public init(animationManager: AnimationManager){
        this._animationManager = animationManager
        this.animationID = CreateElementID.createID()
        
        this.isSubframeEnabled = getSubframeEnabled()

        this.drawnFrameEvent = BMEnterFrameEvent("drawnFrame", 0.0, 0.0, 0.0)

        //初始化一个或许为空的 CanvasRenderingContext2D，实际 this.wrapper 赋值是在 AnimationItem.setParams 函数中。
        this.wrapper = animationManager.params.container
        //初始化一个或许为空的 BaseRenderer，实际 this.renderer 赋值是在 AnimationItem.setParams 函数中。
        this.renderer = BaseRenderer(animationManager.params.container)
    }

    public func readCacheData(uri: String, resultDir: JsonFilesDir) {
        func errCallBack(str: String, e: Exception): Unit {
            this.triggerEvent(str, BMLoadAnimationErrorEvent(e))
        }
        let existResult: FilePathObject = isCacheExist(uri, resultDir.route) // 沙箱中是否有下载的资源
        if (existResult.isExist) {
            let cacheData: AnimationData = readJson(uri, resultDir.route, errCallBack: errCallBack)
            // 优先读取缓存
            if (uri.endsWith(".json") || uri.endsWith(".js")) {
                var isExitNetworkAssets: Bool = false
                for (i in 0..cacheData.assets.size) {
                    if (cacheData.assets[i].p.startsWith("http")) {
                        isExitNetworkAssets = true
                        break
                    }
                }

                if (cacheData.assets.size != 0 && isExitNetworkAssets) {
                    handleAssets(cacheData)
                    this.setupAnimation(cacheData) // 加载有图片资源的json资源
                } else {
                    this.setupAnimation(cacheData) // 加载无图片资源的json资源
                }
            } else if (uri.endsWith(".zip")) {
                // 修改u路径
                handleZipAssets(cacheData, resultDir.route)
                this.setupAnimation(cacheData)
            }
            this.isNetLoad = false
        } else {
            func inside(jsonData: AnimationData, isNetLoad: Bool): Unit {
                this.isNetLoad = isNetLoad
                this.setupAnimation(jsonData)
            }
            // 若缓存无资源，加载网络资源
            downLoadSource.downLoadNetworkSource(uri, inside, resultDir, errCallBack, false, this.context)
        }
    }

    public func loadAnimationData(jsonData: AnimationData, isNetwork: Bool): Unit {
        try {
            var isExitNetworkAssets: Bool = false
            for (i in 0..jsonData.assets.size) {
                if (jsonData.assets[i].p.startsWith("http")) {
                    isExitNetworkAssets = true
                    break
                }
            }

            if (jsonData.assets.size != 0 && isExitNetworkAssets) {
                this.loadImage(jsonData, isNetwork)
            } else {
                // 无网络图片
                this.setupAnimation(jsonData)
            }
        } catch (eror: Exception) {
            Hilog.error(0, "[loadAnimationData]","${this.packageName}-${this.name}--lottie animation eror.message: ${eror.message}")
        }
    }

    public func loadImage(jsonData: AnimationData, isNetwork: Bool): Unit {
        if (isNetwork) {
            try {
                downLoadImgAnimationItem(jsonData, this.context, this.setupAnimation)
                // 下载成功加载网络--handleAssets和setupAnimation的逻辑移入到 downLoadImg 中，下载完成后
            } catch (err: Exception) {
                // 处理网络异常加载缓存
                let imgRouterFilesDir = createImageFilesDir(this.context)
                let isImg = isHaveImg(imgRouterFilesDir) // 沙箱中是否有下载的图片资源
                if (isImg) {
                    handleAssets(jsonData)
                    this.setupAnimation(jsonData)
                } else {
                    // 缓存无资源，返回加载异常
                    this.triggerEvent("error", BMLoadImageErrorEvent(err))
                }
            }
        } else {
            // false 优先加载缓存资源
            let imgRouterFilesDir = createImageFilesDir(this.context)
            let isImg = isHaveImg(imgRouterFilesDir) // 沙箱中是否有下载的图片资源
            if (isImg) {
                handleAssets(jsonData)
                this.setupAnimation(jsonData)
            } else {
                try {
                    downLoadImgAnimationItem(jsonData, this.context, this.setupAnimation)
                    // 下载成功加载网络--handleAssets和setupAnimation的逻辑移入到 downLoadImg 中，下载完成后
                } catch (err: Exception) {
                    // 下载失败,返回加载异常
                    this.triggerEvent("error", BMLoadImageErrorEvent(err))
                }
            }
        }
    }

    func _isFirstFrameInAnimationItem(): Float64 {
        return this._isFirstFrame
    }

    func contentModeInAnimationItem(): String {
        this.contentMode
    }

    public func setParams(params: AnimationConfig) {
        this.wrapper = params.container

        var animTypes: String = "svg"
        if (params.animType != "") {
            animTypes = params.animType
        } else if (params.renderer != "") {
            animTypes = params.renderer
        }

        //根据 animTypes 选择对应的 Renderer。CanvasRenderer/SVGRenderer/HybridRenderer
        if (animTypes == "canvas") {
            let cvRenderer = CanvasRenderer(params.rendererSettings, params.container)
            this.hasRenderer = true

            cvRenderer.globalData.save = cvRenderer.save
            cvRenderer.globalData.ctxTransform = cvRenderer.ctxTransform
            cvRenderer.globalData.ctxOpacity = cvRenderer.ctxOpacity
            cvRenderer.globalData.restore = cvRenderer.restore
            cvRenderer.globalData.hasRenderer = true

            cvRenderer.globalData.renderedFrameInRendered = cvRenderer.getRenderedFrame

            this.renderer = cvRenderer
            this.hasRenderer = true
        } else if (animTypes == "svg") {
            this.hasRenderer = true
        } else if (animTypes == "html") {
            this.hasRenderer = true
        }
        if (this.hasRenderer) {
            this.renderer.wrapperInAnimationItem = this.wrapper
            this.renderer._isFirstFrameInAnimationItem = this._isFirstFrameInAnimationItem
            this.renderer.contentModeInAnimationItem = this.contentModeInAnimationItem

            this.renderer.globalData.getAssetData = this.getAssetData
            this.renderer.globalData.getAssetsPath = this.getAssetsPath
            this.renderer.globalData.imageLoader = this.imagePreloader
        }

        this.context = params.context
        this.dataManager.pathSourceFrom = params.pathSourceFrom
        this.dataManager.onSetupError = onSetupError

        //数据来源分析：SVGRenderer  =>  var defs = createNS("defs")
        var imagePath: String = params.imagePath
        this.imagePreloader.pathSourceFrom = params.pathSourceFrom
        if (params.pathSourceFrom == 2 && params.path != "") {
            var str: String = ""
            let index1: Int64 = params.path.lastIndexOf("\\") ?? -1
            let index2: Int64 = params.path.lastIndexOf("/") ?? -1
            if (index1 != -1) {
                //substr() 方法可在字符串中抽取从 开始 下标开始的指定数目的字符。
                str = params.path[0..(index1 + 1)]
            } else if (index2 != -1) {
                str = params.path[0..(index2 + 1)]
            }
            if (params.imagePath != "") {
                str += params.imagePath
            }
            imagePath = str
        }
        this.imagePreloader.setCacheType(animTypes, this.renderer.globalData.defs, params.context, imagePath)
 
        this.animType = animTypes
        this.loop = params.loop

        this.contentMode = params.contentMode
        this.packageName = params.packageName
        //把应用包名传到 animationManager 对象里用于日志打印
        this._animationManager.setPackageName(this.packageName)

        this.autoplay = params.autoplay
        this.name = params.name
        this.autoloadSegments = params.autoloadSegments
        this.assetsPath = params.assetsPath
        this.initialSegment = params.initialSegment

        if (params.hasAudioFactory) {
            this.audioController.setAudioFactory(params.audioFactory)
        }
        // hasAudioFactory 表示 audioFactory 是否有实际代码逻辑。
        if (!params.animationData.isNull) {
            this.source = "data"
            this.loadAnimationData(params.animationData, params.isNetwork)
        } else if (params.path != "") {
            let index1: Int64 = params.path.lastIndexOf("\\") ?? -1
            let index2: Int64 = params.path.lastIndexOf("/") ?? -1
            if (index1 != -1) {
                //substr() 方法可在字符串中抽取从 开始 下标开始的指定数目的字符。
                this.path = params.path[0..(index1 + 1)]
            } else if (index2 != -1) {
                this.path = params.path[0..(index2 + 1)]
            } else {
                this.path = ""
            }
            if (index2 + 1 < params.path.size) {
                this.fileName = params.path[(index2 + 1) .. params.path.size]
            }
            let index3: Int64 = this.fileName.lastIndexOf(".json") ?? -1
            if (index3 != -1) {
                this.fileName = this.fileName[0 .. index3]
            }

            try {
                dataManager.loadAnimation(
                    params.context,
                    params.path,
                    params.isNetwork,
                    this.configAnimation,
                    this.onSetupError
                )
            } catch (err: Exception) {
                this.triggerEvent("error", BMLoadAnimationErrorEvent(err))
            }
        } else if (params.uri != "") {
            this.loadNetworkResource(params.uri, params.isNetwork, params.context)
        }

    }
    
    public func loadNetworkResource(uri: String, isNetwork: Bool, acontext: Option<AbilityContext>) {
        let resultDir: JsonFilesDir = createFilesDir(uri, acontext)
        if (isNetwork) {
            func inside(jsonData: AnimationData, isNetLoad: Bool): Unit {
                this.isNetLoad = isNetLoad
                this.setupAnimation(jsonData)
            }
            func errCallBack(str: String, e: Exception): Unit {
                this.triggerEvent(str, BMLoadAnimationErrorEvent(e))
            }
            // true 优先加载网络资源
            downLoadSource.downLoadNetworkSource(uri, inside, resultDir, errCallBack, true, acontext)
        } else {
            // false 优先加载缓存资源
            this.readCacheData(uri, resultDir)
        }
    }

    public func onSetupError(): Unit {
        
        this.trigger("data_failed")
    }

    public func setupAnimation(data: AnimationData): Unit {
        dataManager.completeAnimation(
          data,
          this.configAnimation,
          { => ()}
        )
    }

    public func setData(wrapper: CanvasRenderingContext2D, str: String, wrapper_ns: CreateNS) {
        let animationData: AnimationData = AnimationDataParser.parse(str)
        this.setData(wrapper, animationData, wrapper_ns: wrapper_ns)
    }

    public func setData(wrapper: CanvasRenderingContext2D, animationData: AnimationData, wrapper_ns!: CreateNS = CreateNS("")) {
        let params: AnimationConfig = AnimationConfig(
            wrapper_ns: wrapper_ns,
            container: wrapper,
            animationData: animationData
        )
        
        this.setParams(params)
    }

    public func includeLayers(data: AnimationData, isNetLoad: Option<Bool>): Unit {
        if (data.op > this.animationData.op) {
            this.animationData.op = data.op
            this.totalFrames = floor(data.op - this.animationData.ip)
        }
        let layers: Array<Layer> = this.animationData.layers

        var len: Int64 = layers.size
        let newLayers: Array<Layer> = data.layers
        let jLen: Int64 = newLayers.size
        for (j in 0..jLen) {
            for (i in 0..len) {
                if (layers[i].ind == newLayers[j].ind) {
                    layers[i] = newLayers[j]
                    break
                }
            }
        }
        if (this.hasRenderer) {
            if (data.chars.size > 0 || !data.fonts.isEmpty()) {
                this.renderer.globalData.fontManager.addChars(data.chars)
                this.renderer.globalData.fontManager.addFonts(data.fonts, this.renderer.globalData.defs)
            }
        }
        if (data.assets.size > 0) {
            len = data.assets.size
            //循环在 this.animationData.assets 中添加 data.assets[i] 元素，改为一次性 concat 生成一个新数组。
            this.animationData.assets = this.animationData.assets.concat(data.assets)
        }
        this.animationData.__complete = false

        dataManager.completeAnimation(
            this.animationData,
            this.onSegmentComplete,
            { => ()}
        )
    }

    public func onSegmentComplete(data: AnimationData, isNetLoad: Option<Bool>): Unit {
        this.animationData = data
        this.loadNextSegment()
    }
    
    public func loadNextSegment(): Unit {
        let segments: ArrayList<Array<Float64>> = this.animationData.segments
        if (segments.size == 0 || !this.autoloadSegments) {
            
            this.trigger("data_ready")
            this.timeCompleted = this.totalFrames
            return
        }
        //shift: 删除并返回数组的第一个元素。
        let segment: Array<Float64> = segments.remove(0)

        let strArray: Array<String> = [this.path, this.fileName, "_", this.segmentPos.toString(), ".json"]
        let segmentPath: String = String.join(strArray)
        this.segmentPos += 1

        dataManager.loadData(segmentPath, this.includeLayers, { => this.trigger("data_failed")} )
    }

    public func loadSegments(): Unit {
        let segments: ArrayList<Array<Float64>> = this.animationData.segments
        if (segments.size == 0) {
            this.timeCompleted = this.totalFrames
        }
        this.loadNextSegment()
    }
    
    public func imagesLoaded(): Unit {
        this.trigger("loaded_images")
        this.checkLoaded()
    }

    public func preloadImages() {
        this.imagePreloader.setAssetsPath(this.assetsPath)
        this.imagePreloader.setPath(this.path)
        this.imagePreloader.loadAssets(this.animationData.assets, this.imagesLoaded)
    }
    
    public func configAnimation(animData: AnimationData, isNetLoad: Option<Bool>): Unit {
        if (let Some(v) <- isNetLoad) {
            this.isNetLoad = v
        }
        if (!hasRenderer) {
            return
        }
        this.animationData = animData
        if (this.initialSegment.size >= 2) {
            this.totalFrames = floor(this.initialSegment[1] - this.initialSegment[0])
            this.firstFrame = round(this.initialSegment[0])
        } else {
            this.totalFrames = floor(this.animationData.op - this.animationData.ip)
            this.firstFrame = round(this.animationData.ip)
        }

        this.renderer.configAnimation(animData)


        this.assets = this.animationData.assets
        this.frameRate = this.animationData.fr
        this.frameMult = this.animationData.fr / 1000.0

        this.renderer.searchExtraCompositions(animData.assets)
        this.markers = markerParser(animData.markers)

        this.trigger("config_ready")
        this.preloadImages()
        this.loadSegments()
        this.updateFrameModifier()
        this.waitForFontsLoaded()
        if (this.isPaused) {
            this.audioController.pause()
        }
    }

    public func waitForFontsLoaded(): Unit {
        if (!hasRenderer) {
            return
        }
        if (this.renderer.globalData.fontManager.isLoaded) {
            this.checkLoaded()
        } else {
            Timer.once(Duration.millisecond * 20, this.waitForFontsLoaded)
        }
    }
    
    public func checkLoaded(): Unit {
        if (!hasRenderer) {
            return
        }
        if (!this.isLoaded
            && this.renderer.globalData.fontManager.isLoaded
              && (this.imagePreloader.loadedImages() || this.renderer.rendererType != "canvas")
              && (this.imagePreloader.loadedFootages())
        ) {
            this.isLoaded = true
            // 初始化所有元素
            this.renderer.initItems()//初始化所有图层

            Timer.once(Duration.second * 0, {=>
                this.trigger("DOMLoaded")
            })

            // 渲染第一帧
            this.gotoFrame()

            // 自动播放
            if (this.autoplay) {
                this.play() //播放动画
            }
        }
    }
    
    public func setContentMode(contentMode: String): Unit {
        //防止this.renderer为null，导致读取updateContentMode属性失败
        if (hasRenderer && contentMode != "") {
            this.renderer.updateContentMode(contentMode)
        }
    }

    /*
     * 注意：这里虽然叫setFrameRate, 但本质是为了设置"播放帧率", 而不是动画源帧率. 动画源帧率是固定值.
     */
    public func setFrameRate(playingFrameRate: Float64): Unit {
        this.userPlayingFrameRate = playingFrameRate
    }

    /*
     * 注意：这里虽然叫getFrameRate, 但本质是为了获取"播放帧率", 而不是动画源帧率. 在获取动画源帧率时不可调用此接口.
     * 此处保持与setFrameRate命名风格一致是为了保持对称. 由于setFrameRate接口已经开出去了, 不能再更改.
     */
    public func getFrameRate(): Float64 {
        // 当用户指定更低帧率时，以用户的设置为准，否则以动画源为准，高于动画源帧率运行并无意义
        if (this.userPlayingFrameRate > 0.0 &&  this.userPlayingFrameRate < this.frameRate) {
            return this.userPlayingFrameRate
        } else {
            return this.frameRate
        }
    }

    public func resize(width!: Int64 = 0, height!: Int64 = 0): Unit {
        //添加此验证以实现向后兼容性，以防传递事件对象。
        //防止 this.renderer 为 null，导致读取 updateContainerSize 属性失败
        if (hasRenderer) {
            this.renderer.updateContainerSize(width, height)
        }
    }

    public func setSubframe(flag: Bool): Unit {
        this.isSubframeEnabled = flag
    }
    
    public func gotoFrame(): Unit {
        if (this.isSubframeEnabled) {/*  eslint-disable-line  no-bitwise*/
            this.currentFrame = this.currentRawFrame
        } else {
            //~~ 和对 Bool 类型的做两次 ! 操作是一个意思，只不过是把小数位给去掉了，即取整数。等同于 floor
            this.currentFrame = floor(this.currentRawFrame)
        }
    
        if (this.timeCompleted != this.totalFrames && this.currentFrame > this.timeCompleted) {
            this.currentFrame = this.timeCompleted
        }
        
        this.trigger("enterFrame")
        this.renderFrame()
        
        this.trigger("drawnFrame")
    }

    //修改整个动画的颜色
    public func changeColor(color: Array<Int64>): Unit {
        this.changeColor(color, [], 0, 0)
    }

    //修改该动画第 layer 层的颜色
    public func changeColor(color: Array<Int64>, layer: Int64): Unit {
        this.changeColor(color, [], layer, 0)
    }

    //修改该动画第 layer 层第 index 个元素的颜色
    public func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit {
        this.changeColor(color, [], layer, index)
    }

    //修改整个动画的颜色
    public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>): Unit {
        this.changeColor(startColor, endColor, 0, 0)
    }

    //修改该动画第 layer 层的颜色
    public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>, layer: Int64): Unit {
        this.changeColor(startColor, endColor, layer, 0)
    }

    //修改该动画第 layer 层第 index 个元素的颜色
    public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit {
        if (!this.hasRenderer) {
            return
        }
        try {
            this.renderer.changeColor(startColor, endColor, layer, index)
            //替换play函数为gotoFrame,防止play方法创建Animator对象，导致修改颜色后刷帧问题
            this.gotoFrame()
            this.renderer.renderFrame(0.0, true)
        } catch (error: Exception) {
            Hilog.error(0, "[changeColor]","${this.packageName}-${this.name}--lottie animation exception in changeColor: ${error.message}")
            //decide how to handle catch case
        }
    }

    public func renderFrame(): Unit {
        if (this.isLoaded == false || !this.hasRenderer) {
            return
        }
        this.renderer.renderFrame(this.currentFrame + this.firstFrame, false)
    }
    
    public func play(name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        if (this.isPaused) {
            this.isPaused = false
            this._animationManager.setPauseState(false)
            
            this.trigger("_pause")
            this.audioController.resume()
            if (this._idle) {
                this._idle = false
                
                this.trigger("_active")
            }
        }
    }
    
    public func pause(name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        if (this.isPaused == false) {
            this.isPaused = true
            this._animationManager.setPauseState(true)
            this.trigger("_play")
            this._idle = true
            this.trigger("_idle")
            this.audioController.pause()
        }
    }
    
    public func togglePause(name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        if (this.isPaused == true) {
            this.play()
        } else {
            this.pause()
        }
    }

    public func getNextFrameToPlay(framesNum: Float64): Float64 {
        var frames: Float64 = framesNum
        if(frames < 0.0) {
            frames = -frames
        }
    
        var nextFrame: Float64 = frames
        // 逆序segment且正向播放 || 正序segment且逆向播放
        if((this._direction > 0.0 && this.firstFrame > this.endFrame) || (this._direction < 0.0 && this.firstFrame < this.endFrame)) {
            //改为用大值(初始值)作为起点
            nextFrame = this.totalFrames - 1.0 - frames
        }
    
        return nextFrame
    }

    public func stop(name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        this.pause()
        this.playCount = 0
        this._completedLoop = false
        this.setCurrentRawFrameValue(0.0)
    }

    public func getMarkerData(markerName: Float64): MarkerData {
        return this.getMarkerData(markerName.toString())
    }

    public func getMarkerData(markerName: String): MarkerData {
        var marker: MarkerData = MarkerData()
        for (i in 0..this.markers.size) {
            marker = this.markers[i]
            if (!marker.payload.isNull && marker.payload.name == markerName) {
                return marker
            }
        }
        return marker
    }

    public func goToAndStop(value: String, isFrame!: Bool = false, name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        //使用isNaN()函数来判断一个值是否是NaN值。如果该值为非数字值或NaN值，返回true，否则返回false。
        let marker: MarkerData = this.getMarkerData(value)
        if (!marker.isNull) {
            this.goToAndStop(marker.time, isFrame: true, name: "")
        }
        this.pause()
    }

    public func goToAndStop(value: Float64, isFrame!: Bool = false, name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        //使用isNaN()函数来判断一个值是否是NaN值。如果该值为非数字值或NaN值，返回true，否则返回false。
        if (isFrame) {
            this.setCurrentRawFrameValue(value)
        } else {
            this.setCurrentRawFrameValue(value * this.frameModifier)
        }
        this.pause()
    }
    
    public func goToAndPlay(value: String, isFrame!: Bool = false, name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        //使用isNaN()函数来判断一个值是否是NaN值。如果该值为非数字值或NaN值，返回true，否则返回false。
        var marker: MarkerData = this.getMarkerData(value)
        if (!marker.isNull) {
            if (marker.duration == 0.0) {
                this.goToAndStop(marker.time, isFrame: true, name: "")
            } else {
                this.playSegments([marker.time, marker.time + marker.duration], true)
            }
        }
        this.play()
    }

    public func goToAndPlay(value: Float64, isFrame!: Bool = false, name!: String = ""): Unit {
        if (name != "" && this.name != name) {
            return
        }
        //使用isNaN()函数来判断一个值是否是NaN值。如果该值为非数字值或NaN值，返回true，否则返回false。
        this.goToAndStop(value, isFrame: isFrame, name: name)
        this.play()
    }

    public func advanceTime(value2: Float64): Unit {
        if (this.isPaused == true || this.isLoaded == false) {
            return
        }
        var value: Float64 = value2
        //处理下一帧时间空隙过长的异常
        var maxtime = 400.0
        if (value > maxtime) {
            value = 10.0
        }
        var nextValue: Float64 = this.currentRawFrame + value * this.frameModifier
        var _isComplete: Bool = false
        //检查nextValue>totalFrames-1是否用于处理非循环和循环动画。
        //如果动画不循环，它应该停止在totalFrames-1。如果它要循环，它应该完成最后一帧，然后循环。
        if (nextValue >= this.totalFrames - 1.0 && this.frameModifier > 0.0) {
            if (this.loop == FALSE || this.playCount == this.loop) {
                var num: Int64 = 0
                if (nextValue > this.totalFrames) {
                    num = Int64(nextValue) % Int64(this.totalFrames)
                }
                if (!this.checkSegments(num)) {
                    _isComplete = true
                    nextValue = this.totalFrames - 1.0
                }
            } else if (nextValue >= this.totalFrames) {
                this.playCount += 1
                var num: Int64 = 0
                if (this.totalFrames != 0.0) {
                    num = Int64(nextValue) % Int64(this.totalFrames)
                }
                if (!this.checkSegments(num)) {
                    this.setCurrentRawFrameValue(Float64(num))
                    this._completedLoop = true
                    this.trigger("loopComplete")
                }
            } else {
                this.setCurrentRawFrameValue(nextValue)
            }
        } else if (nextValue < 0.0) {
            let num: Int64 = Int64(nextValue) % Int64(this.totalFrames)
            if (!this.checkSegments(num)) {
                //loop 表示是否循环; loopNum 定为 Int64 数据类型，<= 1 表示不循环，相当于 false。
                this.playCount--
                if ((this.loop == TRUE) && !(this.playCount <= 0 && this.loop != TRUE)) { /*  eslint-disable-line  no-plusplus */
                    this.setCurrentRawFrameValue(this.totalFrames + Float64(num))
                    if (!this._completedLoop) {
                        this._completedLoop = true
                    } else {
                        this.trigger("loopComplete")
                    }
                } else {
                    _isComplete = true
                    nextValue = 0.0
                }
            }
        } else {
            this.setCurrentRawFrameValue(nextValue)
        }
        if (_isComplete) {
            this.setCurrentRawFrameValue(nextValue)
            this.pause()
            this.trigger("complete")
        }
    }

    public func adjustSegment(arr: Array<Float64>, offset: Float64): Unit {
        this.playCount = 0
        if (arr[1] < arr[0]) {
            if (this.frameModifier > 0.0) {
                if (this.playSpeed < 0.0) {
                    this.setSpeed(-this.playSpeed)
                } else {
                    this.setDirection(-1)
                }
            }
            this.totalFrames = arr[0] - arr[1]
            this.timeCompleted = this.totalFrames
            this.firstFrame = arr[1]
            this.setCurrentRawFrameValue(this.totalFrames - 0.001 - offset)
        } else if (arr[1] > arr[0]) {
            if (this.frameModifier < 0.0) {
                if (this.playSpeed < 0.0) {
                    this.setSpeed(-this.playSpeed)
                } else {
                    this.setDirection(1)
                }
            }
            this.totalFrames = arr[1] - arr[0]
            this.timeCompleted = this.totalFrames
            this.firstFrame = arr[0]
            this.setCurrentRawFrameValue(0.001 + offset)
        }
        this.trigger("segmentStart")
    }

    public func setSegment(initNum: Float64, end: Float64): Unit {
        if (initNum == end) {
             Hilog.error(0, "[AnimationItem]", "[setSegment]- initNum == end, the setSegment function are not executed.")
            return
        }
        var pendingFrame: Float64 = -1.0
        if (this.isPaused) {
            if (this.currentRawFrame + this.firstFrame < initNum) {
                pendingFrame = initNum
            } else if (this.currentRawFrame + this.firstFrame > end) {
                pendingFrame = end - initNum
            }
        }
    
        this.firstFrame = initNum
        this.totalFrames = end - initNum
        this.timeCompleted = this.totalFrames
        if (pendingFrame != -1.0) {
            this.goToAndStop(0.0, isFrame: true, name: "")
        }
    }

    public func playSegments(arr: Array<Array<Float64>>, forceFlag: Bool): Unit {
        for (i in 0..arr.size) {
            if (arr[i].size != 2) {
                Hilog.error(0, "[AnimationItem]", "[playSegments]- The incoming playback segment data is not compliant. Each set of data must be 2.")
                return
            }
        }
        if (forceFlag) {
            this.segments.clear()
        }
        this.segments.appendAll(arr)
        if (this.segments.size > 0 && forceFlag) {
            //shift: 删除并返回数组的第一个元素。
            let segment: Array<Float64> = this.segments.remove(0)
            this.adjustSegment(segment, 0.0)
        }
        if (this.isPaused) {
            this.play()
        }
    }

    public func playSegments(arr: Array<Float64>, forceFlag: Bool): Unit {
        if (arr.size != 2) {
            Hilog.error(0, "[AnimationItem]", "[playSegments]- The incoming playback segment data is not compliant. The length of the array must be 2.")
            return
        }
        if (forceFlag) {
            this.segments.clear()
        }
        this.segments.append(arr)
        if (this.segments.size > 0 && forceFlag) {
            //shift: 删除并返回数组的第一个元素。
            let segment: Array<Float64> = this.segments.remove(0)
            this.adjustSegment(segment, 0.0)
        }
        if (this.isPaused) {
            this.play()
        }
    }

    public func resetSegments(forceFlag: Bool): Unit {
        this.segments.clear()
        this.segments.append([this.animationData.ip, this.animationData.op])
        if (forceFlag) {
            this.checkSegments(0)
        }
    }

    public func checkSegments(offset: Int64): Bool {
        if (this.segments.size > 0) {
            //shift: 删除并返回数组的第一个元素。
            let segment: Array<Float64> = this.segments.remove(0)
            this.adjustSegment(segment, Float64(offset))
            return true
        }
        return false
    }

    public func destroy(name!: String = ""): Unit {
        if ((name != "" && this.name != name) || !hasRenderer) {
            return
        }
        this.renderer.destroy()
        this.imagePreloader.destroy()
        this.trigger("destroy")
        this._cbs.clear()
        
        this.hasOnEnterFrame = false
        this.hasOnLoopComplete = false
        this.hasOnComplete = false
        this.hasOnSegmentStart = false
        this.hasOnDestroy = false

        this.hasRenderer = false
    }

    public func setCurrentRawFrameValue(value: Float64): Unit {
        this.currentRawFrame = value
        this.gotoFrame()
    }
    
    public func setSpeed(val: Float64): Unit {
        this.playSpeed = val
        this.updateFrameModifier()
    }

    public func setDirection(val: Int64): Unit {
        if (val < 0) {
            this.playDirection = -1
        } else {
            this.playDirection = 1
        }
        this.updateFrameModifier()
    }

    public func setLoop(isLooping: Bool): Unit {
        this.loop = if (isLooping) {
            TRUE
        } else {
            FALSE
        }
    }
    
    public func setVolume(val: Int64, name: String): Unit {
        if (name != "" && this.name != name) {
            return
        }
        this.audioController.setVolume(val)
    }

    public func getVolume(): Int64 {
        return this.audioController.getVolume()
    }
    
    public func mute(name: String): Unit {
        if (name != "" && this.name != name) {
            return
        }
        this.audioController.mute()
    }

    public func unmute(name: String): Unit {
        if (name != ""  && this.name != name) {
            return
        }
        this.audioController.unmute()
    }
    
    public func updateFrameModifier(): Unit {
        this.frameModifier = this.frameMult * this.playSpeed * Float64(this.playDirection)
        this.audioController.setRate(this.playSpeed * Float64(this.playDirection))
    }

    public func getPath(): String {
        return this.path
    }

    public func getAssetsPath(assetData: Asset): String {
        var path: String = ""
        if (assetData.e != 0) {
            path = assetData.p
        } else if (this.assetsPath != "") {
            var imagePath: String = assetData.p
            if (imagePath.contains("images/")) {
                imagePath = imagePath.split("/")[1]
            }
            path = this.assetsPath + imagePath
        } else {
            path = this.path
            path += assetData.u
            path += assetData.p
        }
        return path
    }

    public func getAssetData(id: String): Asset {
        let len: Int64 = this.assets.size
        for (i in 0..len) {
            if (id == this.assets[i].id) {
                return this.assets[i]
            }
        }
        return empty_asset
    }

    public func hide(): Unit {
        if (!hasRenderer) {
            return
        }
        this.renderer.hide()
    }
    
    public func show(): Unit {
        if (!hasRenderer) {
            return
        }
        this.renderer.show()
    }

    public func getDuration(isFrame: Bool): Float64 {
        if (isFrame) {
            return this.totalFrames
        }
        return this.totalFrames / this.frameRate
    }

    public func updateDocumentData(path: Array<Int64>, documentData: DocumentData, index: Int64): Unit {
        if (!hasRenderer) {
            return
        }
        let element: Option<BaseElement> = this.renderer.getElementByPath(path)
        if (let Some(v) <- element) {
            v.updateDocumentData(documentData, index)
        }
    }

    public func updateDocumentData(path: Array<String>, documentData: DocumentData, index: Int64): Unit {
        if (!hasRenderer) {
            return
        }

        let element: Option<BaseElement> = this.renderer.getElementByPath(path)
        if (let Some(v) <- element) {
            v.updateDocumentData(documentData, index)
        }
    }

    public func trigger(name: String): Unit {
        if (this._cbs.size > 0 && this._cbs.contains(name)) {
            if (name == "enterFrame") {
                this.triggerEvent(name, BMEnterFrameEvent(name, this.currentFrame, this.totalFrames, this.frameModifier))
            } else if (name == "drawnFrame") {
                this.drawnFrameEvent.currentTime = this.currentFrame
                this.drawnFrameEvent.totalTime = this.totalFrames
                this.drawnFrameEvent.direction = this.frameModifier
                this.triggerEvent(name, this.drawnFrameEvent)
            } else if (name == "loopComplete") {
                this.triggerEvent(name, BMCompleteLoopEvent(name, this.loop, this.playCount, this.frameMult))
            } else if (name == "complete") {
                this.triggerEvent(name, BMCompleteEvent(name, this.frameMult))
            } else if (name == "segmentStart") {
                this.triggerEvent(name, BMSegmentStartEvent(name, this.firstFrame, this.totalFrames))
            } else if (name == "destroy") {
                this.triggerEvent(name, BMDestroyEvent(name, this))
            } else {
                this.triggerEvent(name, BMEvent(""))
            }
        }
        if (name == "enterFrame" && this.hasOnEnterFrame) {
            this.onEnterFrame(BMEnterFrameEvent(name, this.currentFrame, this.totalFrames, this.frameMult))
        }
        if (name == "loopComplete" && this.hasOnLoopComplete) {
            this.onLoopComplete(BMCompleteLoopEvent(name, this.loop, this.playCount, this.frameMult))
        }
        if (name == "complete") {
            if (this.hasOnComplete) {
                this.onComplete(BMCompleteEvent(name, this.frameMult))
            }

            var registeredAnimations = this._animationManager.getRegisteredAnimations()
            // 在registeredAnimations不为空和Animator的状态是Running的前提下，判断动画是否全部播放结束
            if (registeredAnimations.size > 0 && this._animationManager.getAnimatorState() == AnimationStatus.Running) {
                var isAllComplete = true
                // 遍历循环判断每个animationItem是否暂停，
                for (i in 0..registeredAnimations.size) {
                    var animationItem = registeredAnimations[i]
                    if (!animationItem.isPaused) {
                        isAllComplete = false
                        break
                    }
                }
                //判断动画是否全部播放结束，如果是则通知更改Animator的状态为Paused
                if (isAllComplete) {
                    this._animationManager.setAnimatorState(AnimationStatus.Paused)
                }
            }
        }
        if (name == "segmentStart" && this.hasOnSegmentStart) {
            this.onSegmentStart(BMSegmentStartEvent(name, this.firstFrame, this.totalFrames))
        }
        if (name == "destroy" && this.hasOnDestroy) {
            this.onDestroy(BMDestroyEvent(name, this))
        }
    }

    public func triggerRenderFrameError(nativeError: Exception): Unit {
        let error: BMRenderFrameErrorEvent = BMRenderFrameErrorEvent(nativeError, Int64(this.currentFrame))
        this.triggerEvent("error", error)
    
        if (this.hasOnError) {
            this.onError(error)
        }
    }
    
    public func triggerConfigError(nativeError: Exception): Unit {
        let error: BMConfigErrorEvent = BMConfigErrorEvent(nativeError)
        this.triggerEvent("error", error)

        if (this.hasOnError) {
            this.onError(error)
        }
    }

}
