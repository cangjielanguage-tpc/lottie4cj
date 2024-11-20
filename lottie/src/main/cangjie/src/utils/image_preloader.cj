/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.utils

internal import ohos.hilog.*
internal import ohos.system_date_time.*

internal import std.sync.*
internal import std.time.*

internal import lottie.inner.*

internal import ohos.image.Image as MultiImage
internal import ohos.image.Component as ImageComponent
internal import ohos.image.PixelMap
internal import ohos.image.createImageSource
internal import ohos.image.DecodingOptions
internal import ohos.image.Size
internal import ohos.image.PixelMapFormat
internal import ohos.image.Region
internal import ohos.image.ImageInfo
internal import ohos.image.InitializationOptions
internal import ohos.image.createPixelMap
internal import ohos.file_fs.*

internal import ohos.resource_manager.*
internal import ohos.ability.*

public class ImagePreloader {

    // 定时器ID
    private var timer: ?Timer = None
    private let emptyAnimationData: AnimationData = AnimationData()
    private let emptyCreateNS: CreateNS = CreateNS("")
    
    var _createImageData: (Asset) -> OB = default_Asset_To_OB_CreateNS

    var assetsPath: String = ""
    var path: String = ""
    var totalImages: Int64 = 0
    var totalFootages: Int64 = 0
    let loadedAssets: AtomicInt64 = AtomicInt64(0)
    let loadedFootagesCount: AtomicInt64 = AtomicInt64(0)

    var imagesLoadedCb: () -> Unit = default_Unit_To_Unit
    var imagesLoadedCbFlag: Bool = false
    //var images: ArrayList<(Asset) -> OB<CreateNS>> = ArrayList<(Asset) -> OB<CreateNS>>(24)
    var images: ArrayList<OB> = ArrayList<OB>(24)
    //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
    public var context: Option<AbilityContext> = Option<AbilityContext>.None
    
    //TODO: this._elementHelper 未确认成员变量中数据类型
    var _elementHelper: CreateNS = CreateNS("")
    
    // 使用空对象替代不支持动态创建的Canvas组件
    //let proxyImage: CreateNS = CreateNS("")
    let proxyImage: ImgOB = ImgOB(isNull: true)

    static let mtx = ReentrantMutex()

    /**
     * Create a ImagePreloader instance.
     */
    public init() {
        //this._imageLoaded = this.imageLoaded
        //this._footageLoaded = this.footageLoaded
    }

    /**
     * The image has been loaded.
     */
    public func imageLoaded(): Unit {
        //this.loadedAssets += 1
        synchronized(mtx) {
            this.loadedAssets.fetchAdd(1)
            if (this.loadedAssets.load() == this.totalImages && this.loadedFootagesCount.load() == this.totalFootages) {
                if (this.imagesLoadedCbFlag) {
                    //Hilog.error(0, "-----------", "[imageLoaded]: this.loadedAssets.load() = ${this.loadedAssets.load()}")
                    //Hilog.error(0, "-----------", "[imageLoaded]: this.totalImages = ${this.totalImages}")
                    this.imagesLoadedCb()
                }
            }
        }
    }

    /**
     * The footage has been loaded.
     */
    public func footageLoaded(): Unit {
        //this.loadedFootagesCount += 1
        this.loadedFootagesCount.fetchAdd(1)
        if (this.loadedAssets.load() == this.totalImages && this.loadedFootagesCount.load() == this.totalFootages) {
            if (this.imagesLoadedCbFlag) {
                this.imagesLoadedCb()
            }
        }
    }

    //TODO: assetData 未确认数据类型，暂定为 Asset
    func getAssetsPath(assetData: Asset, assetsPath: String, originalPath: String): String {
        var path: String = ""
        if (assetData.e != 0) {
            path = assetData.p
        } else if (assetsPath != "") {
            var imagePath: String = assetData.p
            if (imagePath.contains("images/")) {
                imagePath = imagePath.split("/")[1]
            }
            path = assetsPath + imagePath
        } else {
            path = originalPath
            path += assetData.u
            path += assetData.p
        }
        return path
    }

    func testImageLoaded(img: CreateNS): Unit {
        //var _count: Int64 = 0
        func inside(): Unit {
            /**
             * TODO: 未在 cj 找到 getBBox---------------------------------------------------------------------------2024.07.10
             * getBBox()过去svg中的元素位置
             * 在svg中一些标签无法获取他的元素和位置。所以用getBBox以返回一个 包含 x, y, width, height 的 SVGRect 对象, 
             * 表明 SVG 元素在 viewport 内部的宽高和左上角坐标, 不受到 SVG Transform 和 SMIL 动画影响.
             */
            //var box = img.getBBox()
            var box = Box()
            //if (box.width != 0.0 || _count > 500) {
            if (box.width != 0.0) {
                //this._imageLoaded()
                this.imageLoaded()
                //clearInterval(intervalId)
                if (let Some(v) <- this.timer) {
                    v.cancel()
                }
            }
            //_count += 1
        }

        //var intervalId = setInterval(.bind(this), 50)
        this.timer = Timer.repeatTimes(500, Duration.millisecond, Duration.millisecond * 50, inside)
    }

    //TODO: data 未确认数据类型，暂定为 Array<UInt8>
    //TODO: ob 未确认数据类型
    func generatePixelMapAndRefreshUI2(data: Array<UInt8>, ob: OB, callback: () -> Unit) {
        //TODO：image 系统 api 函数，暂时不联合编译
        let imageSource = createImageSource(data)
        //piexlmap 改成不可编辑状态，优化图形图像端读取速度
        let opts: DecodingOptions = DecodingOptions(
            editable: false,
            desiredPixelFormat: PixelMapFormat.RGBA_8888
        )
        //创建 pixel_map
        spawn {
            let pixelMap: PixelMap = imageSource.createPixelMap(options: opts)
            //TODO: OB.img 从元组改为对象？？？
            ob.img.pixel_map = pixelMap
            //获取解析出来的 pixel_map 的宽、高
            let imageInfo: ImageInfo = pixelMap.getImageInfo()
            ob.img.width = Int64(imageInfo.size.width)
            ob.img.height = Int64(imageInfo.size.height)
            callback()
        }
    }

    func generatePixelMapAndRefreshUI2(fid: Int32, ob: OB, callback: () -> Unit) {
        //TODO：image 系统 api 函数，暂时不联合编译
        let imageSource = createImageSource(fid)
        //piexlmap 改成不可编辑状态，优化图形图像端读取速度
        let opts: DecodingOptions = DecodingOptions(
            editable: false,
            desiredPixelFormat: PixelMapFormat.RGBA_8888
        )
        //创建 pixel_map
        spawn {
            let pixelMap: PixelMap = imageSource.createPixelMap(options: opts)
            ob.img.pixel_map = pixelMap
            //获取解析出来的 pixel_map 的宽、高
            let imageInfo: ImageInfo = pixelMap.getImageInfo()
            ob.img.width = Int64(imageInfo.size.width)
            ob.img.height = Int64(imageInfo.size.height)
            callback()
        }
    }

    func generatePixelMapAndRefreshUI2(uri: String, ob: OB, callback: (isOB: Bool) -> Unit) {
        //TODO：image 系统 api 函数，暂时不联合编译
        if (ob.isNull) {
        	callback(false)
        }

        let imageSource = createImageSource(uri)
        //piexlmap 改成不可编辑状态，优化图形图像端读取速度
        let opts: DecodingOptions = DecodingOptions(
            editable: false,
            desiredPixelFormat: PixelMapFormat.RGBA_8888
        )
        //创建 pixel_map
        spawn {
            let pixelMap: PixelMap = imageSource.createPixelMap(options: opts)
            ob.img.pixel_map = pixelMap
            //获取解析出来的 pixel_map 的宽、高
            let imageInfo: ImageInfo = pixelMap.getImageInfo()
            ob.img.width = Int64(imageInfo.size.width)
            ob.img.height = Int64(imageInfo.size.height)
            callback(true)
        }
    }

    /**
     * Create image data.
     * Applied to SVG environment.
     *
     * @param assetData - Type of Asset.
     * @return Type of BOB<CreateNS>.
     */
    //TODO: assetData 未确认数据类型，暂定为 Asset
    public func createImageData(assetData: Asset): OB {
        let paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        let imgCreateNS: CreateNS = CreateNS("image")
        if (isSafari) {
            this.testImageLoaded(imgCreateNS)
        } else {
            //TODO：未实现 imgCreateNS.addEventListener--------------------------------------------------------------2024.07.10
            //imgCreateNS.addEventListener("load", this._imageLoaded, false)
            imgCreateNS.addEventListener("load", this.imageLoaded, false)
        }
        
        let ob: OB = OB(
            img: ImgOB(createNS: imgCreateNS, isCreateNS: true),
            assetData: assetData
        )
        
        func inside() {
            //TODO: 需要确认空对象问题
            ob.img = proxyImage
            //this._imageLoaded()
            this.imageLoaded()
        }
        
        imgCreateNS.addEventListener("error", inside, false)
        imgCreateNS.setAttributeNS("http://www.w3.org/1999/xlink", "href", paths)
        
        //TODO: 在 JavaScript 中，append() 方法用于向 DOM（文档对象模型）中的元素末尾添加一个或多个子节点。
        //if (this._elementHelper.append) {
        //    this._elementHelper.append(imgCreateNS)
        //} else {
            this._elementHelper.appendChild(imgCreateNS)
        //}
        
        return ob
    }

    /**
     * Create image data.
     * Applied to non SVG environments.
     *
     * @param assetData - Type of Asset.
     * @return Type of BOB<CreateNS>.
     */
    //TODO: assetData 未确认数据类型，暂定为 Asset。------------------------------------------------------------2024.07.10
    //TODO:里面的 img 需要拆出来。-----------------------------------------------------------------------------2024.07.10
    public func createImgData(assetData: Asset): OB {
        var paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
        //var context = this.context
        //if (context == null) {
        //    //TODO：未实现 getContext------------------------------------------------------------------------2024.07.10
        //    context = getContext()
        //}
        //因OpenHarmony无法通过createTag创建html中的img标签，所以这里构造一个img对象，同进添加其使用到的addEventListener方法
        let imgCreateNS: CreateNS = CreateNS("imag")

        let ob: OB = OB(
            img: ImgOB(createNS: imgCreateNS, isCreateNS: true),
            assetData: assetData
        )
        
        func addEventListener(types: String, callback: () -> Unit, flag: Bool): Unit {
            if (types == "load") {
                if (assetData.e == 0 || assetData.e == TYPE_IMAGE_SOURCE_RAWFILE) { //rawfile资源图片
                    //拼接rawfile url
                    let res: String = assetData.u + assetData.p       //->common/image/lottie/icon.png
                    try {
                        //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
                        //let filePath: String = context.filesDir + "/" + res
                        let filePath: String =
                        if (let Some(v) <- context) {
                            v.filesDir + "/" + res
                        } else {
                            "/" + res
                        }

                        let isExist = FileFs.access(filePath) //判断图片资源是否存在
                        //let isExist: Bool = File.exists(filePath)
                        
                        if (isExist) {
                            spawn {
                                /* 直接读取文件中所有数据 */
                                try {
                                    //let arrayBuffer: Array<Byte> = File.readFrom(filePath)
                                    let file = FileFs.open(filePath, mode: READ_ONLY.mode)
                                    let stat = FileFs.stat(filePath)
                                    let arrayBuffer: Array<Byte> = Array<Byte>(stat.size, item: 0)

                                    FileFs.read(file.fd, arrayBuffer)
                                    FileFs.close(file)

                                    //TODO: 模拟器调试暂时注掉，因为调用 createPixelMap 会崩掉--------------------
                                    //callback()  //TODO: 测试用，后续删除。

                                    generatePixelMapAndRefreshUI2(arrayBuffer, ob, callback)
                                    //generatePixelMapAndRefreshUI2(file.fd, ob, callback)  //TODO: 测试用，后续删除。

                                } catch (e: Exception) {
                                    //加载依赖图片异常时，默认动画加载正常
                                    callback()
                                }
                            }
                        } else {
                            //获取rawfile的字节数组数据
                            //TODO: 参考 gifdrawable 库 ResourceLoader.loadMedia
                            if (let Some(v) <- context) {
                                //AppLog.info("get globalAbilityContext successfully")
                                let stageContext = getStageContext(v)
                                let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
                                spawn {
                                    try {
                                        //TODO: 模拟器调试暂时注掉，因为调用 createPixelMap 会崩掉--------------------
                                        //callback()  //TODO: 测试用，后续删除。
                                        let buffer: Array<UInt8> = rm.getRawFileContent(res)
                                        generatePixelMapAndRefreshUI2(buffer, ob, callback)
                                    } catch (e: Exception) {
                                        let message = e.message
                                        //Hilog.info("getRawFileContent failed, error code: ${code}, message: ${message}.")
                                        //加载依赖图片异常时，默认动画加载正常
                                        callback()
                                    }
                                }
                            }

                        }
                    } catch (e: Exception) {
                    }
                } else if (assetData.e == TYPE_IMAGE_SOURCE_BASE64) { //base64图片
                    //generatePixelMapAndRefreshUI的入参ob可能为undefined，所以这里需要每隔一段时间检测一下ob是否实例化好了
                    //let task_id = setInterval(() => , 10)
                    func inside(): Unit {
                        //TODO: 模拟器调试暂时注掉，因为调用 createPixelMap 会崩掉--------------------
                        generatePixelMapAndRefreshUI2(assetData.p, ob, {
                           isOB  =>
                             if (!isOB) { // 加载失败，重新触发
                                Timer.once(Duration.millisecond * 20, inside)
                             } else {
                             	callback()
                             }
                        })

                    }
                    Timer.once(Duration.millisecond * 20, inside)
                }
            }
        }

        imgCreateNS.addEventListener = addEventListener

        imgCreateNS.crossOrigin = "anonymous"
        //imgCreateNS.addEventListener("load", this._imageLoaded, false)
        imgCreateNS.addEventListener("load", this.imageLoaded, false)

        
        func insideError(){
            //TODO: 需要确认空对象问题-------------------------------------------------------------------------2024.07.10
            ob.img = proxyImage
            //this._imageLoaded()
            this.imageLoaded()
        }
        
        imgCreateNS.addEventListener("error", insideError, false)
        imgCreateNS.src = paths

        return ob
    }

    func createFootageData(data: Asset): OB {
        //TODO: 是否改为元组类型。(CreateNS, AnimationData, Bool)。Bool = true 代表 CreateNS；Bool = false 代表 AnimationData.
        let ob: OB = OB(assetData: data)
        let path: String = getAssetsPath(data, this.assetsPath, this.path)

        func onComplete(footageData: AnimationData): Unit {
            ob.img.animationData = footageData
            ob.img.isCreateNS = false
            //this._footageLoaded()
            this.footageLoaded()
        }
        func onError(): Unit {
            ob.img = ImgOB(isNull: true)
            //this._footageLoaded()
            this.footageLoaded()
        }
        
        //TODO: 此处初始化合适么？？？--------------------------------------------------------------------------2024.07.10
        DataManager().loadData(path, onComplete, onError)
        return ob
    }

    /**
     * load resources.
     *
     * @param assets - Type of Array<Asset>.
     * @param cb - Type of function () -> Unit.
     */
    //TODO: 在 json 中找不到 assets[i].t,此步执行无意义！--------------------------------------------------------2024.07.11
    public func loadAssets(assets: Array<Asset>, cb: () -> Unit): Unit {
        this.imagesLoadedCb = cb
        this.imagesLoadedCbFlag = true
        let len: Int64 = assets.size
        for (i in 0..len) {
            if (assets[i].layers.size <= 0) {
                //TODO: 在 json 中找不到 assets[i].t----------------------------------------------------------2024.07.11
                if (assets[i].t == "" || assets[i].t == "seq") {
                    this.totalImages += 1
                    this.images.append(this._createImageData(assets[i]))
                } else if (assets[i].t == "3") {
                    this.totalFootages += 1
                    this.images.append(this.createFootageData(assets[i]))
                }
            }
        }
    }

    /**
     * Set original path.
     *
     * @param path - Type of String, the original path.
     */
    public func setPath(path: String): Unit {
        this.path = path
    }

    /**
     * Set asset path.
     *
     * @param path - Type of String, the asset path.
     */
    public func setAssetsPath(path: String): Unit {
        this.assetsPath = path
    }

    /**
     * Get asset.
     *
     * @param assetData - Type of Asset.
     * @return Type of Option<T>.
     */
    //TODO: assetData 未确认数据类型，暂定为 Asset。------------------------------------------------------------2024.07.11
    //public func getAsset(assetData: Asset): CreateNS {
    public func getAsset(assetData: Asset): ImgOB {
        var i: Int64 = 0
        let len: Int64 = this.images.size
        while (i < len) {
            //TODO: Asset 的 == 功能未实现。------------------------------------------------------------------2024.07.11
            if (this.images[i].assetData == assetData) {
                return this.images[i].img
            }
            i += 1
        }
        return ImgOB(isNull: true)  //proxyImage: ImgOB = ImgOB(isNull: true)
    }

    /**
     * destroy the ImagePreloader.
     */
    public func destroy(): Unit {
        this.imagesLoadedCb = default_Unit_To_Unit
        this.imagesLoadedCbFlag = false
        this.images.clear()
    }

    /**
     * The image has been loaded and completed.
     *
     * @return Type of Bool.
     */
    public func loadedImages(): Bool {
        return this.totalImages == this.loadedAssets.load()
    }

    /**
     * The footages has been loaded and completed.
     *
     * @return Type of Bool.
     */
    public func loadedFootages(): Bool {
        return this.totalFootages == this.loadedFootagesCount.load()
    }

    /**
     * Set cache type.
     *
     * @param types - Type of String.
     * @param elementHelper - Type of CreateNS.
     * @param context - Type of AbilityContext.
     */
    //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
    public func setCacheType(types: String, elementHelper: CreateNS, context: Option<AbilityContext>) {
    //public func setCacheType(types: String, elementHelper: CreateNS): Unit {
        this.context = context
        if (types == "svg") {
            this._elementHelper = elementHelper
            this._createImageData = this.createImageData
        } else {
            this._createImageData = this.createImgData
        }
    }

}
