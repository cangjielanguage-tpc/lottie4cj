/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is DataManager.
 */
package lottie.utils

internal import std.convert.*

internal import lottie.parser.*

import ohos.resource_manager.*
import ohos.ability.*


class WorkerProxy {

    var workerFn: (Data) -> Unit = default_Data_To_AnimationData
    
    /*
     * workerProxy.onmessage 实际的逻辑代码在后面 setupWorker 中 workerInstance.onmessage
     * 需要和 workerInstance 关联
     */
    var onmessage: (Data) -> Unit = default_Data_To_Unit
    
    init(){}
    init(workerFn: (Data) -> Unit){
        this.workerFn = workerFn
    }
    init(workerFn: (Data) -> Unit, onmessage: (Data) -> Unit){
        this.workerFn = workerFn
        this.onmessage = onmessage
    }

    func postMessage(data: Data) {
        workerFn(data)
    }
}

public class DataManager {
    var context:?AbilityContext = Option<AbilityContext>.None
    var _counterId: Int64 = 1
    var processes: HashMap<String, Processes> = HashMap<String, Processes>(24)
    var workerFn: (Data) -> Unit = default_Data_To_AnimationData

    var workerInstance: WorkerProxy = WorkerProxy()
    
    var workerInstanceFlag: Bool = false

    public var onSetupError: () -> Unit = { => return () }

    //区别json文件来源：1.来自\resources\rawfile\， 2.来自手机中保存的json。
    public var pathSourceFrom: Int8 = 1

    func postMessage(data: Data) {
        /* workerProxy未单独使用，可以直接等于 workerProxy = workerInstance */
        this.workerInstance.onmessage(data)
    }

    func createWorker(fn: (Data) -> Unit): WorkerProxy {
        this.workerFn = fn   /* workerFn = func workerStart */
        return WorkerProxy(fn)
    }

    /* [5]-参数 data 的成员变量 animationData，就是拿到解析 json 后封装好的 AnimationData。 */
    func onmessageWorkerInstance(data: Data) {
        let id: String = data.id
        if (this.processes.contains(id)) {
            let process: Processes = this.processes[id]
            this.processes.remove(id)
            if (data.status == "success") {
                /* [6]-解析 json 后封装好的 AnimationData，结果在回调函数 onComplete 中。 */
                process.onComplete(data.animation, data.isNetLoad)
            } else if (data.status == "error") {
                process.onError()
            }
        }
    }

    func loadImage(context: Option<AbilityContext>, isNetwork: Bool, jsonData: AnimationData, callback: (AnimationData, Bool) -> Unit, errorCallback: () -> Unit): Unit {
        // true 优先加载网络资源
        if (isNetwork) {
            try {
                downLoadImg(jsonData, context, callback)
                // 下载成功加载网络--handleAssets和callback的逻辑移入到 downLoadImg 中，下载完成后
            } catch (err: Exception) {
                // 处理网络异常加载缓存
                let imgRouterFilesDir = createImageFilesDir(context)
                let isImg = isHaveImg(imgRouterFilesDir) // 沙箱中是否有下载的图片资源
                if (isImg) {
                    handleAssets(jsonData)
                    callback(jsonData, false)
                } else {
                    // 缓存无资源，返回加载异常
                    errorCallback()
                }
            }

        } else {
            // false 优先加载缓存资源
            let imgRouterFilesDir = createImageFilesDir(context)
            let isImg = isHaveImg(imgRouterFilesDir) // 沙箱中是否有下载的图片资源
            if (isImg) {
                handleAssets(jsonData)
                callback(jsonData, false)
            } else {
                try {
                    downLoadImg(jsonData, context, callback)
                    // 下载成功加载网络--handleAssets和callback的逻辑移入到 downLoadImg 中，下载完成后
                } catch (err: Exception) {
                    // 下载失败,返回加载异常
                    errorCallback()
                }

            }
        }
    }


    /* 2. */
    func setupWorker(): Unit {
        if (!workerInstanceFlag) {
            this.workerInstanceFlag = true
            
            /* 3.  workerStart 中的代码，是在 loadAnimation/loadData/completeAnimation中最后一步执行 */
            this.workerInstance = this.createWorker(this.workerStart)
            
            /* workerProxy.onmessage 实际的逻辑代码此处。 workerProxy/workerInstance.onmessage */
            this.workerInstance.onmessage = this.onmessageWorkerInstance
        }
    }

    func workerStart(data: Data): Unit {
        if (data.types == "loadAnimation") {
            /* [3]-回调函数 callback 的参数 animationData，就是拿到解析 json 后封装好的 AnimationData。 */
            func callback(animationData: AnimationData, isNetwork: Bool): Unit {
                completeData(animationData)
                postMessage(Data(id: data.id, animation: animationData, isNetwork: isNetwork, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }
            
            /* [1]-在此函数调用时，拿到解析 json 后封装好的 AnimationData，结果在回调函数 callback 中。 */
            load(
                this.context,
                data.path,
                data.isNetwork,
                data.fullPath,
                /* [2]-回调函数 callback 的参数 animationData，就是拿到解析 json 后封装好的 AnimationData。 */
                callback,
                errorCallback
            )
        } else if (data.types == "complete") {
            let animation: AnimationData = data.animation
            completeData(animation)
            postMessage(Data(
              id: data.id,
              animation: animation,
              isNetwork: data.isNetwork,
              status: "success"
            ))
        } else if (data.types == "loadData") {
            func callback(animationData: AnimationData, isNetwork: Bool): Unit {
                postMessage(Data(id: data.id, animation: animationData, isNetwork: data.isNetwork, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }

            load(
                this.context,
                data.path,
                false,        // isNetwork
                data.fullPath,
                callback,
                errorCallback
            )
        }
    }

    func completeLayers(layers: Array<Layer>, comps: Array<Asset>): Unit {
        let len: Int64 = layers.size
        if (len <= 0) {
            return
        }
        var layerData: Layer = empty_layer
        var jLen: Int64 = 0
        var kLen: Int64 = 0
        for (i in 0..len) {
            layerData = layers[i]
            if (!layerData.ks.isNull() && !layerData.completed) {
                layerData.completed = true
                if (layerData.hasMask) {
                    var maskProps: Array<Mask> = layerData.masksProperties
                    
                    var mask: Mask = Mask()

                    jLen = maskProps.size
                    for (j in 0..jLen) {
                        /**
                         * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
                         * 而在 cj 中:
                         * 1. masksProperties.pt.k 如果是对象，解析后 masksProperties.pt(Array<Keyframe<ShapeData>>) 数组中只有一个 Keyframe<ShapeData>，解析的结果在 Keyframe.k 中
                         * 2. masksProperties.pt.k 如果是数组，解析后 masksProperties.pt(Array<Keyframe<ShapeData>>)  数组中有多个 Keyframe<ShapeData>，解析的结果在 Keyframe 中
                         * 备注：见用例 test_layer_03.cj
                         */
                        mask = maskProps[j]
                        /* 把 maskProps[j].pt.k 提前处理 */
                        if (mask.pt.size == 1) { /* json 中 k 是一个对象 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [中] */ 
                            if (let Some(v) <- mask.pt[0].k) {
                                convertPathsToAbsoluteValues(v)
                            }
                        } else if (mask.pt.size > 1) { /* json 中 k 是一个数组 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [外] */
                            kLen = mask.pt.size
                            for (k in 0..kLen) {
                                if (let Some(v) <- mask.pt[k].s) {
                                    convertPathsToAbsoluteValues(v)
                                }
                                if (let Some(v) <- mask.pt[k].e) {
                                    convertPathsToAbsoluteValues(v)
                                }
                            }
                        }
                    }
                }
                if (layerData.ty == 0) {
                    layerData.layers = findCompLayers(layerData.refId, comps)
                    completeLayers(layerData.layers, comps)
                } else if (layerData.ty == 4) {
                    completeShapes(layerData.shapes)
                } else if (layerData.ty == 5) {
                    /* 在 json 中找不到 layers[i].t.p,此步执行无意义！  
                     * completeText(layerData)
                     */
                }
            }
        }
    }


    func completeChars(chars: Array<FontCharacter>, assets: Array<Asset>): Unit {
        if (chars.size > 0) {
            let len: Int64 = chars.size
            for (i in 0..len) {
                /* 在 json 中找不到 chars[i].t */
                if (chars[i].t == 1) {
                    chars[i].data.layers = findCompLayers(chars[i].data.refId, assets)
                    completeLayers(chars[i].data.layers, assets)
                }
            }
        }
    }


    func findComp(id: String, comps: Array<Asset>): Asset {
        let len: Int64 = comps.size
        for (i in 0..len) {
            if (comps[i].id == id) {
                return comps[i]
            }
        }
        return Asset("", Array<Layer>(), 0, 0, "", "", 0)
    }

    func findCompLayers(id: String, comps: Array<Asset>): Array<Layer> {
        let comp: Asset = findComp(id, comps)
        if (!comp.isNull()) {
            return comp.layers
        }
        return Array<Layer>()
    }

    func completeShapes(arr: ArrayList<ContentModel>): Unit {
        let len: Int64 = arr.size
        var jLen: Int64 = 0
        var shape: ContentModel = ContentModel()
        for (i in (len - 1)..=0:-1) {
            shape = arr[i]
            if (shape.ty == "sh") {
                let sh: ShapePath = (shape as ShapePath).getOrThrow()
                /**
                 * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
                 * 而在 cj 中:
                 * 1. "shapes".{"ty": "sh"}.ks.k 如果是对象，解析后 ShapePath.ks(Array<Keyframe<ShapeData>>) 数组中只有一个 Keyframe<ShapeData>，解析的结果在 Keyframe.k 中
                 * 2. "shapes".{"ty": "sh"}.ks.k 如果是数组，解析后 ShapePath.ks(Array<Keyframe<ShapeData>>) 数组中有多个 Keyframe<ShapeData>，解析的结果在 Keyframe 中
                 * 备注：见用例 test_shapes_07.cj
                 */
                if (sh.ks.size == 1) { /* k 是一个对象 */
                    if (let Some(v) <- sh.ks[0].k) {
                        convertPathsToAbsoluteValues(v)
                    }
                } else if (sh.ks.size > 1) { /* json 中 k 是一个数组 */
                    jLen = sh.ks.size
                    for (j in 0..jLen) {
                        if (let Some(v) <- sh.ks[j].s) {
                            convertPathsToAbsoluteValues(v)
                        }
                        if (let Some(v) <- sh.ks[j].e) {
                            convertPathsToAbsoluteValues(v)
                        }
                    }
                }
            } else if (shape.ty == "gr") {
                completeShapes((shape as ShapeGroup).getOrThrow().it)
            }
        }
    }

    func convertPathsToAbsoluteValues(path: ShapeData): Unit {
        let len: Int64 = path.i.size
        for (i in 0..len) {
            path.i[i].x += path.v[i].x
            path.i[i].y += path.v[i].y
            path.o[i].x += path.v[i].x
            path.o[i].y += path.v[i].y
        }
    }

    func completeData(animationData: AnimationData): Unit {
        if (animationData.__complete) {
            return
        }
        checkColors(animationData)
        checkText(animationData)
        checkChars(animationData, completeShapes)
        /* 在 json 中找不到 layers[i].t.p,此步执行无意义！
         * checkPathProperties(animationData)
         */
        checkShapes(animationData, completeShapes, convertPathsToAbsoluteValues)
        
        completeLayers(animationData.layers, animationData.assets)
        completeChars(animationData.chars, animationData.assets)
        animationData.__complete = true
    }
    
    func completeText(data: Layer) {
        /* 在 json 中找不到 layers[i].t.p,此步执行无意义！ */
    }

    func createProcess(onComplete: (AnimationData, Option<Bool>) -> Unit, onError: () -> Unit): String {
        _counterId += 1
        let id: String = "processId_" + _counterId.toString()
        let p: Processes = Processes(onComplete, onError)
        processes.put(id, p)
        return id
    }

    /* [7]-解析 json 后封装好的 AnimationData，结果在回调函数 onComplete 参数中。 */
    public func loadAnimation(context: Option<AbilityContext>, path: String, isNetwork: Bool, onComplete: (AnimationData, Option<Bool>) -> Unit, onError: () -> Unit) {
        this.context = context
        setupWorker()
        let processId: String = createProcess(onComplete, onError)

        workerInstance.postMessage(Data(
            types: "loadAnimation",
            path: path,
            isNetwork: isNetwork,
            fullPath: "",
            id: processId
        ))
    }

    public func loadData(path: String, onComplete: (AnimationData, Option<Bool>) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        workerInstance.postMessage(Data(
            types: "loadData",
            path: path,
            fullPath: "",
            id: processId
        ))
    }

    public func completeAnimation(anim: AnimationData, onComplete: (AnimationData, Option<Bool>) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        workerInstance.postMessage(Data(
            types: "complete",
            animation: anim,
            id: processId
        ))
    }

    func loadAsset(context: Option<AbilityContext>, path: String, isNetwork: Bool, fullPath: String, callback: (AnimationData, Bool) -> Unit, errorCallback: () -> Unit): Unit {
        Timer.once(Duration.Zero, { =>
            let arrayBuffer: Array<Byte> = readFile(context, path)
            var jsonData: AnimationData = AnimationData(isNull: true)
            if (arrayBuffer.size > 0) {
                /**
                 * 将字符串转为 json 对象.
                 * cj 直接调用 AnimationDataParser.parse(reader: String): AnimationData
                 */
                let bas: ByteArrayStream = ByteArrayStream(arrayBuffer.size)
                bas.write(arrayBuffer)

                // 解码的json数据
                jsonData = AnimationDataParser.parse(bas)
                /* 不用判断 jsonData 是否是 null，cj中如果解析封装失败会抛出异常。 */

                if (!jsonData.isNull) {
                    var isExitNetworkAssets: Bool = false
                    for (i in 0..jsonData.assets.size) {
                        if (jsonData.assets[i].p.startsWith("http")) {
                            isExitNetworkAssets = true
                            break
                        }
                    }

                    if (jsonData.assets.size != 0 && isExitNetworkAssets) {
                        loadImage(context, isNetwork, jsonData, callback, this.onSetupError)
                    } else {
                        // 无网络图片
                        callback(jsonData, false)
                    }
                }

            } else {
                errorCallback()
            }
        })
    }
    
    func readFile(context: Option<AbilityContext>, path: String): Array<Byte> {
        var buf: Array<Byte> = Array<Byte>()
        if(path.startsWith("/data/storage/")) {
            buf = FileUtils.readToEnd(path)
        } else if (this.pathSourceFrom == 2) {
            buf = FileUtils.readToEnd(FileUtils.phoneFolder + "/" + path)
        } else if(path.startsWith("file://") || path.startsWith("https:")) {
            /* 通过URL.openStream获取数据 */
        } else {
            let stageContext = getStageContext(context.getOrThrow())
            let resMgr = ResourceManager.getResourceManager(stageContext)
            buf = resMgr.getRawFileContent(path)
        }

        return buf
    }
    
    func load(context: Option<AbilityContext>, path: String, isNetwork: Bool, fullPath: String, callback: (AnimationData, Bool) -> Unit, errorCallback: () -> Unit): Unit {
        this.loadAsset(context, path, isNetwork, fullPath, callback, errorCallback)
    }

}
