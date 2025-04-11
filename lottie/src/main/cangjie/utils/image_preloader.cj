/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

package lottie.utils


import std.regex.*
import lottie.inner.*

public class ImagePreloader {

    // 定时器ID
    //private var timer: ?Timer = None
    private let emptyAnimationData: AnimationData = AnimationData()
    private let emptyCreateNS: CreateNS = CreateNS("")
    
    var _createImageData: (Asset) -> OB = default_Asset_To_OB_CreateNS

    var assetsPath: String = ""
    var imagePath: String = ""
    var path: String = ""
    //区别json文件来源：1.来自\resources\rawfile\， 2.来自手机中保存的json。
    public var pathSourceFrom: Int8 = 1

    var totalImages: Int64 = 0
    var totalFootages: Int64 = 0
    let loadedAssets: AtomicInt64 = AtomicInt64(0)
    let loadedFootagesCount: AtomicInt64 = AtomicInt64(0)

    var imagesLoadedCb: () -> Unit = default_Unit_To_Unit
    var imagesLoadedCbFlag: Bool = false
    var images: ArrayList<OB> = ArrayList<OB>(24)
    public var context: Option<UIAbilityContext> = Option<UIAbilityContext>.None

    var _elementHelper: CreateNS = CreateNS("")
    
    // 使用空对象替代不支持动态创建的Canvas组件
    let proxyImage: ImgOB = ImgOB(isNull: true)

    static let mtx = ReentrantMutex()

    /**
     * Create a ImagePreloader instance.
     */
    public init() { }

    /**
     * The image has been loaded.
     */
    public func imageLoaded(): Unit {
        synchronized(mtx) {
            this.loadedAssets.fetchAdd(1)
            if (this.loadedAssets.load() == this.totalImages && this.loadedFootagesCount.load() == this.totalFootages) {
                if (this.imagesLoadedCbFlag) {
                    this.imagesLoadedCb()
                }
            }
        }
    }

    /**
     * The footage has been loaded.
     */
    public func footageLoaded(): Unit {
        this.loadedFootagesCount.fetchAdd(1)
        if (this.loadedAssets.load() == this.totalImages && this.loadedFootagesCount.load() == this.totalFootages) {
            if (this.imagesLoadedCbFlag) {
                this.imagesLoadedCb()
            }
        }
    }

    func getAssetsPath(assetData: Asset, assetsPath: String, originalPath: String): String {
        var path: String = ""
        if (assetData.e != 0) {
            path = assetData.p
        } else if (assetsPath != "") {
            var imagePaths: String = assetData.p
            if (imagePaths.contains("images/")) {
                imagePaths = imagePaths.split("/")[1]
            }
            path = assetsPath + imagePaths
        } else {
            path = originalPath
            path += assetData.u
            path += assetData.p
        }
        return path
    }

    func testImageLoaded(img: CreateNS): Unit {
        func inside(): Unit {
            /**
             * 未在 cj 找到 getBBox。//var box = img.getBBox()
             * getBBox()过去svg中的元素位置
             * 在svg中一些标签无法获取他的元素和位置。所以用getBBox以返回一个 包含 x, y, width, height 的 SVGRect 对象, 
             * 表明 SVG 元素在 viewport 内部的宽高和左上角坐标, 不受到 SVG Transform 和 SMIL 动画影响.
             */
            var box = Box()
            if (box.width != 0.0) {
                this.imageLoaded()
//                if (let Some(v) <- this.timer) {
//                    v.cancel()
//                }
            }
        }

//        this.timer = Timer.repeatTimes(500, Duration.millisecond, Duration.millisecond * 50, inside)
    }

    func generatePixelMapAndRefreshUI2(data: Array<UInt8>, ob: OB, callback: () -> Unit) {
        let imageSource = createImageSource(data)
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

    func generatePixelMapAndRefreshUI2(fid: Int32, ob: OB, callback: () -> Unit) {
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
    public func createImageData(assetData: Asset): OB {
        let paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        let imgCreateNS: CreateNS = CreateNS("image")
        if (isSafari) {
            this.testImageLoaded(imgCreateNS)
        } else {
            imgCreateNS.addEventListener("load", this.imageLoaded, false)
        }
        
        let ob: OB = OB(
            img: ImgOB(createNS: imgCreateNS, isCreateNS: true),
            assetData: assetData
        )
        
        func inside() {
            ob.img = proxyImage
            this.imageLoaded()
        }
        
        imgCreateNS.addEventListener("error", inside, false)
        imgCreateNS.setAttributeNS("http://www.w3.org/1999/xlink", "href", paths)

        this._elementHelper.appendChild(imgCreateNS)
        
        return ob
    }

    /**
     * Create image data.
     * Applied to non SVG environments.
     *
     * @param assetData - Type of Asset.
     * @return Type of BOB<CreateNS>.
     */
    public func createImgData(assetData: Asset): OB {
        var paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        //因OpenHarmony无法通过createTag创建html中的img标签，所以这里构造一个img对象，同进添加其使用到的addEventListener方法
        let imgCreateNS: CreateNS = CreateNS("imag")

        let ob: OB = OB(
            img: ImgOB(createNS: imgCreateNS, isCreateNS: true),
            assetData: assetData
        )
        
        func addEventListener(types: String, callback: () -> Unit, flag: Bool): Unit {
            if (types == "load") {
                //assetData.e值是不唯一的参数，所以由assetData.p值来判断图片资源是base64图片资源，还是外部图片资源
                if (let Some(v) <- Regex(SOURCE_BASE64).matcher(assetData.p).find()) { //正则表达式判断是否含有data:image/;base64字段
                    readBase64(assetData, ob, callback) //base64图片
                } else { //rawfile资源图片
                    readRawFile(assetData, ob, callback)
                }
            }
        }

        imgCreateNS.addEventListener = addEventListener

        imgCreateNS.crossOrigin = "anonymous"
        imgCreateNS.addEventListener("load", this.imageLoaded, false)

        func insideError(){
            ob.img = proxyImage
            this.imageLoaded()
        }
        
        imgCreateNS.addEventListener("error", insideError, false)
        imgCreateNS.src = paths

        return ob
    }

    func readBase64(assetData: Asset, ob: OB, callback: () -> Unit): Unit {
        //generatePixelMapAndRefreshUI的入参ob可能为undefined，所以这里需要每隔一段时间检测一下ob是否实例化好了
        func inside(): Unit {
            generatePixelMapAndRefreshUI2(assetData.p, ob, {
               isOB  =>
                 if (!isOB) { // 加载失败，重新触发
//                    Timer.once(Duration.millisecond * 20, inside)
                 } else {
                 	callback()
                 }
            })

        }
//        Timer.once(Duration.millisecond * 20, inside)
    }

    func readRawFile(assetData: Asset, ob: OB, callback: () -> Unit): Unit {
        //拼接rawfile url
        let res: String = assetData.u + assetData.p       //->common/image/lottie/icon.png
        try {
            //Asset.sourceFrom: 区别图片来源：1.来自\resources\rawfile\， 2.来自手机中保存的图片，3.来自网络下载。
            let filePath: String =
            if (this.pathSourceFrom == 2) {
                if (res.startsWith("/data/storage/")) {
                    res
                } else {
                    FileUtils.phoneFolder + "/" + res
                }
            } else if (assetData.sourceFrom == 3) {
                FileUtils.downloadFolder + "/" + res
            } else if (let Some(v) <- context) {
                v.filesDir + "/" + res
            } else {
                "/" + res
            }

            let isExist = FileUtils.accessSync(filePath) //判断图片资源是否存在
            if (isExist) {
                spawn {
                    /* 直接读取文件中所有数据 */
                    try {
                        let arrayBuffer: Array<Byte> = FileUtils.readToEnd(filePath)
                        generatePixelMapAndRefreshUI2(arrayBuffer, ob, callback)
                    } catch (e: Exception) {
                        //加载依赖图片异常时，默认动画加载正常
                        callback()
                    }
                }
            } else {
                //获取rawfile的字节数组数据
                if (let Some(v) <- context) {
//                    let stageContext = getStageContext(context.getOrThrow())
//                    let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
                    let rm = v.resourceManager
                    spawn {
                        try {
                            let buffer: Array<UInt8> = rm.getRawFileContent(res)
                            generatePixelMapAndRefreshUI2(buffer, ob, callback)
                        } catch (e: Exception) {
                            let message = e.message
                            //加载依赖图片异常时，默认动画加载正常
                            callback()
                        }
                    }
                }

            }
        } catch (e: Exception) {
        }
    }


    func createFootageData(data: Asset): OB {
        let ob: OB = OB(assetData: data)
        let path: String = getAssetsPath(data, this.assetsPath, this.path)

        func onComplete(footageData: AnimationData, isNetLoad: Option<Bool>): Unit {
            ob.img.animationData = footageData
            ob.img.isCreateNS = false
            this.footageLoaded()
        }
        func onError(): Unit {
            ob.img = ImgOB(isNull: true)
            this.footageLoaded()
        }
        
        DataManager().loadData(path, onComplete, onError)
        return ob
    }

    /**
     * load resources.
     *
     * @param assets - Type of Array<Asset>.
     * @param cb - Type of function () -> Unit.
     */
    public func loadAssets(assets: Array<Asset>, cb: () -> Unit): Unit {
        this.imagesLoadedCb = cb
        this.imagesLoadedCbFlag = true
        let len: Int64 = assets.size
        for (i in 0..len) {
            if (assets[i].layers.size <= 0) {
                if (this.imagePath != "") {
                    assets[i].u = this.imagePath
                }
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
    public func getAsset(assetData: Asset): ImgOB {
        var i: Int64 = 0
        let len: Int64 = this.images.size
        while (i < len) {
            if (this.images[i].assetData == assetData) {
                return this.images[i].img
            }
            i += 1
        }
        return ImgOB(isNull: true)
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
     * @param context - Type of Context.
     */
    public func setCacheType(types: String, elementHelper: CreateNS, context: Option<UIAbilityContext>, imagePath: String) {
        this.context = context
        this.imagePath = imagePath
        if (types == "svg") {
            this._elementHelper = elementHelper
            this._createImageData = this.createImageData
        } else {
            this._createImageData = this.createImgData
        }
    }

}
