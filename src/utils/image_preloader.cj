/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils

internal import std.sync.*
internal import std.time.*

internal import lottie4cj.inner.*

//TODO：image 是系统 api，暂时不联合编译   //import ohos.image.*


public class ImagePreloader<T> where T <: ToString {

    // 定时器ID
    private var timer: ?Timer = None
    
    var _createImageData: (Asset) -> OB<CreateNS> = default_Asset_To_OB_CreateNS
    
    var assetsPath: String = ""
    var path: String = ""
    var totalImages: Int64 = 0
    var totalFootages: Int64 = 0
    var loadedAssets: Int64 = 0
    var loadedFootagesCount: Int64 = 0
    
    //TODO: 未确认成员变量中数据类型
    var imagesLoadedCb: () -> Unit = default_Unit_To_Unit
    var imagesLoadedCbFlag: Bool = false
    var images: ArrayList<OB<T>> = ArrayList<OB<T>>(24)
    //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译  //var context: Option<AbilityContext> = Option<AbilityContext>.None
    
    //TODO: this._elementHelper 未确认成员变量中数据类型
    var _elementHelper: CreateNS = CreateNS("")
    
    // 使用空对象替代不支持动态创建的Canvas组件
    let proxyImage: CreateNS = CreateNS("")
    
    //generatePixelMapAndRefreshUI的入参ob可能为undefined，所以这里需要每隔一段时间检测一下ob是否实例化好了
    var isOB: Bool = false

    /**
     * Create a ImagePreloader instance.
     */
    public init() { }

    /**
     * The image has been loaded.
     */
    public func imageLoaded(): Unit {
        this.loadedAssets += 1
        if (this.loadedAssets == this.totalImages && this.loadedFootagesCount == this.totalFootages) {
            if (this.imagesLoadedCbFlag) {
                this.imagesLoadedCb()
            }
        }
    }

    /**
     * The footage has been loaded.
     */
    public func footageLoaded(): Unit {
        this.loadedFootagesCount += 1
        if (this.loadedAssets == this.totalImages && this.loadedFootagesCount == this.totalFootages) {
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
        func inside(): Unit {
            /**
             * TODO: 未在 cj 找到 getBBox
             * getBBox()过去svg中的元素位置
             * 在svg中一些标签无法获取他的元素和位置。所以用getBBox以返回一个 包含 x, y, width, height 的 SVGRect 对象, 
             * 表明 SVG 元素在 viewport 内部的宽高和左上角坐标, 不受到 SVG Transform 和 SMIL 动画影响.
             */
            var box = Box()
            if (box.width != 0.0) {
                this.imageLoaded()
                if (let Some(v) <- this.timer) {
                    v.cancel()
                }
            }
        }

        this.timer = Timer.repeatTimes(500, Duration.millisecond, Duration.millisecond * 50, inside)
    }

    func generatePixelMapAndRefreshUI2(data: Array<UInt8>, ob: OB<CreateNS>, callback: () -> Unit) {
        //TODO：image 系统 api 函数，暂时不联合编译
        /*
        this.isOB = true
        let imageSource = image.createImageSource(data)
        // piexlmap 改成不可编辑状态，优化图形图像端读取速度
        let opts: image.DecodingOptions = DecodingOptions(
            editable: false,
            desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        )
        // 创建 pixel_map
        let pixelMap: PixelMap = imageSource.createPixelMap(options: opts)
        ob.img.pixel_map = pixelMap
        // 获取解析出来的 pixel_map 的宽、高
        let imageInfo: ImageInfo = pixelMap.getImageInfo()
        ob.img.width = imageInfo.size.width
        ob.img.height = imageInfo.size.height
        callback()
        */
    }
    func generatePixelMapAndRefreshUI2(uri: String, ob: OB<CreateNS>, callback: () -> Unit) {
        //TODO：image 系统 api 函数，暂时不联合编译
        /*
        this.isOB = true
        let imageSource = image.createImageSource(uri)
        // piexlmap 改成不可编辑状态，优化图形图像端读取速度
        let opts: image.DecodingOptions = DecodingOptions(
            editable: false,
            desiredPixelFormat: image.PixelMapFormat.RGBA_8888
        )
        // 创建 pixel_map
        let pixelMap: PixelMap = imageSource.createPixelMap(options: opts)
        ob.img.pixel_map = pixelMap
        // 获取解析出来的 pixel_map 的宽、高
        let imageInfo: ImageInfo = pixelMap.getImageInfo()
        ob.img.width = imageInfo.size.width
        ob.img.height = imageInfo.size.height
        callback()
        */
    }

    /**
     * Create image data.
     * Applied to SVG environment.
     *
     * @param assetData - Type of Asset.
     * @return Type of BOB<CreateNS>.
     */
    public func createImageData(assetData: Asset): OB<CreateNS> {
        let paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        let img: CreateNS = CreateNS("image")
        if (isSafari) {
            this.testImageLoaded(img)
        } else {
            img.addEventListener("load", this.imageLoaded, false)
        }
        
        let ob: OB<CreateNS> = OB<CreateNS>(
            img: img,
            assetData: assetData
        )
        
        func inside() {
            //TODO: 需要确认空对象问题
            ob.img = proxyImage
            this.imageLoaded()
        }
        
        img.addEventListener("error", inside, false)
        img.setAttributeNS("http://www.w3.org/1999/xlink", "href", paths)
        
        //TODO: 在 JavaScript 中，append() 方法用于向 DOM（文档对象模型）中的元素末尾添加一个或多个子节点。
        this._elementHelper.appendChild(img)
        
        return ob
    }

    /**
     * Create image data.
     * Applied to non SVG environments.
     *
     * @param assetData - Type of Asset.
     * @return Type of BOB<CreateNS>.
     */
    //TODO:里面的 img 需要拆出来。
    public func createImgData(assetData: Asset): OB<CreateNS> {
        var paths: String = getAssetsPath(assetData, this.assetsPath, this.path)
        //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
        //因OpenHarmony无法通过createTag创建html中的img标签，所以这里构造一个img对象，同进添加其使用到的addEventListener方法
        let img: CreateNS = CreateNS("imag")

        let ob: OB<CreateNS> = OB<CreateNS>(
            img: img,
            assetData: assetData
        )
        
        func addEventListener(types: String, callback: () -> Unit, flag: Bool): Unit {
            if (types == "load") {
                if (assetData.e == 0 || assetData.e == TYPE_IMAGE_SOURCE_RAWFILE) { //rawfile资源图片
                    //拼接rawfile url
                    let res: String = assetData.u + assetData.p       //->common/image/lottie/icon.png
                    try {
                        //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译  //let filePath: String = context.filesDir + "/" + res
                        let filePath: String = "/" + res
                        
                        //判断图片资源是否存在
                        let isExist: Bool = File.exists(filePath)
                        
                        if (isExist) {
                            // 直接读取文件中所有数据
                            try {
                                let arrayBuffer: Array<Byte> = File.readFrom(filePath)
                                generatePixelMapAndRefreshUI2(arrayBuffer, ob, callback)
                            } catch (e: Exception) {
                                //加载依赖图片异常时，默认动画加载正常
                                callback()
                            }
                        } else {
                            //获取rawfile的字节数组数据
                            //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译
                            /*
                            //参考 gifdrawable 库 ResourceLoader.loadMedia
                            if (let Some(v) <- context) {
                                let stageContext = getStageContext(v)
                                let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
                                try {
                                    let buffer: Array<UInt8> = rm.getRawFileContent(res)
                                    generatePixelMapAndRefreshUI2(buffer, ob, callback)
                                } catch (e: Exception) {
                                    //加载依赖图片异常时，默认动画加载正常
                                    callback()
                                }
                            }
                            */      
                        }
                    } catch (e: Exception) {
                    }
                } else if (assetData.e == TYPE_IMAGE_SOURCE_BASE64) { //base64图片
                    //generatePixelMapAndRefreshUI的入参ob可能为undefined，所以这里需要每隔一段时间检测一下ob是否实例化好了
                    func inside() {
                        if (!this.isOB) {
                            return
                        }
                        generatePixelMapAndRefreshUI2(assetData.p, ob, callback)
                        //取消循环检测
                        if (let Some(v) <- this.timer) {
                            v.cancel()
                        }
                    }
                    
                    this.timer = Timer.repeat(Duration.millisecond, Duration.millisecond * 10, inside)
                }
            }
        }
        
        img.addEventListener = addEventListener

        img.crossOrigin = "anonymous"
        img.addEventListener("load", this.imageLoaded, false)
        
        func insideError(){
            //TODO: 需要确认空对象问题
            ob.img = proxyImage
            this.imageLoaded()
        }
        
        img.addEventListener("error", insideError, false)
        img.src = paths

        return ob
    }

    func createFootageData(data: Asset): OB<AnimationData> {
        let ob = OB<AnimationData>(img: AnimationData(), assetData: data)
        let path = getAssetsPath(data, this.assetsPath, this.path)

        func onComplete(footageData: AnimationData): Unit {
            ob.img = footageData
            this.footageLoaded()
        }
        func onError(): Unit {
            this.footageLoaded()
        }
        
        //TODO: 此处初始化合适么？？？
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
        let len: Int64 = assets.size
        for (i in 0..len) {
            if (assets[i].layers.size <= 0) {
                //TODO: 在 json 中暂时找不到 assets[i].t
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
    public func getAsset(assetData: Asset): Option<T> {
        var i: Int64 = 0
        let len: Int64 = this.images.size
        while (i < len) {
            if (this.images[i].assetData == assetData) {
                return this.images[i].img
            }
            i += 1
        }
        return None
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
      return this.totalImages == this.loadedAssets
    }

    /**
     * The footages has been loaded and completed.
     *
     * @return Type of Bool.
     */
    public func loadedFootages(): Bool {
      return this.totalFootages == this.loadedFootagesCount
    }

    /**
     * Set cache type.
     *
     * @param types - Type of String.
     * @param elementHelper - Type of CreateNS.
     * @param context - Type of AbilityContext.
     */
    //TODO：AbilityContext 是仓颉 UI 中的系统组件 api，暂时不联合编译    //context: AbilityContext
    public func setCacheType(types: String, elementHelper: CreateNS): Unit {
        if (types == "svg") {
            this._elementHelper = elementHelper
            this._createImageData = this.createImageData
        } else {
            this._createImageData = this.createImgData
        }
    }

}
