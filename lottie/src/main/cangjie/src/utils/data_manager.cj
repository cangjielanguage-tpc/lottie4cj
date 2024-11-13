/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils

//internal import std.fs.*
internal import std.convert.*

import lottie.parser.*

import ohos.resource_manager.*
internal import ohos.ability.*


class WorkerProxy {

    //TODO：参数 e 没有直接用，一直用的是 e.data，参数直接改成 e.data-----------------------------------------------2024.07.08
    //var workerFn: (e) -> Unit
    var workerFn: (Data) -> Unit = default_Data_To_AnimationData
    
    //workerProxy.onmessage 实际的逻辑代码在后面 setupWorker 中 workerInstance.onmessage
    //TODO: 需要和 workerInstance 关联
    var onmessage: (Data) -> Unit = default_Data_To_Unit
    
    init(){}
    init(workerFn: (Data) -> Unit){
        this.workerFn = workerFn
    }
    init(workerFn: (Data) -> Unit, onmessage: (Data) -> Unit){
        this.workerFn = workerFn
        this.onmessage = onmessage
    }
    
    //TODO: 把 workerInstance.postMessage 改为多参函数？？？
    //(type: String, path: String, fullPath: String, id: String, context2D: CanvasRenderingContext2D, animation: AnimationData)
    //func postMessage(path) {
    //    //TODO: 调用 DataManager 的成员变量 workerFn
    //    workerFn({ data: path })  //workerFn = func workerStart
    //}
    func postMessage(data: Data) {
        workerFn(data)
    }
}

//TODO:未实现
public class DataManager {
    var context:?AbilityContext = Option<AbilityContext>.None
    var _counterId: Int64 = 1
    var processes: HashMap<String, Processes> = HashMap<String, Processes>(24)
    //TODO: 未确认 e 的数据类型
    //TODO：参数 e 没有直接用，一直用的是 e.data，参数直接改成 e.data-----------------------------------------------2024.07.08
    var workerFn: (Data) -> Unit = default_Data_To_AnimationData
    
    //TODO：需要增加一个 WorkerProxy 的无参构造 -- 调整后不需要无参构造
    var workerInstance: WorkerProxy = WorkerProxy()
    
    var workerInstanceFlag: Bool = false
    
    var assetLoader: AssetLoader = AssetLoader()
    
    ////TODO：setupWorker 改为 init，并和 createWorker 合并
    //public init(){
    //    this.workerFn = this.workerStart
    //    this.workerInstance = WorkerProxy(this.workerStart, this.onmessageWorkerInstance)
    //}

    //TODO: 未实现
    //[4]-参数 data 的成员变量 animationData，就是拿到解析 json 后封装好的 AnimationData。
    func postMessage(data: Data) {
        //workerProxy未单独使用，可以直接等于 workerProxy = workerInstance
        //workerProxy.onmessage({ data: data })
        this.workerInstance.onmessage(data)
    }

    //4.
    //TODO：createWorker 和 init 合并？？？
    func createWorker(fn: (Data) -> Unit): WorkerProxy {
        this.workerFn = fn   //workerFn = func workerStart
        //5.
        //TODO: workerProxy 独立成一个对象，还是拆开融入到 DataManager 中 ？？？
        return WorkerProxy(fn)
    }
    
    //TODO: 未确认 event 数据类型。可能是
    //[5]-参数 data 的成员变量 animationData，就是拿到解析 json 后封装好的 AnimationData。
    func onmessageWorkerInstance(data: Data) {
        //var data = event.data
        //let data: Data = data
        let id: String = data.id
        if (this.processes.contains(id)) {
            let process: Processes = this.processes[id]
            this.processes.remove(id)
            if (data.status == "success") {
                //[6]-解析 json 后封装好的 AnimationData，结果在回调函数 onComplete 中。
                //process.onComplete(data.payload)
                process.onComplete(data.animation)
            } else if (data.status == "error") {
                process.onError()
            }
        }
    }

    //2.
    //TODO：setupWorker 改为 init？？？
    func setupWorker(): Unit {
        //TODO：setupWorker只执行一次，是否融入到 init 中？？？
        if (!workerInstanceFlag) {
            this.workerInstanceFlag = true
            
            //3.    //workerInstance = workerProxy
            // workerStart 中的代码，是在 loadAnimation/loadData/completeAnimation中最后一步执行
            this.workerInstance = this.createWorker(this.workerStart)
            
            //workerProxy.onmessage 实际的逻辑代码此处。 workerProxy/workerInstance.onmessage
            this.workerInstance.onmessage = this.onmessageWorkerInstance
        }
    }


    //在开发此函数--20240708
    //TODO：参数 e 没有直接用，一直用的是 e.data，参数直接改成 e.data-----------------------------------------------2024.07.08
    func workerStart(data: Data): Unit {
        //var animationData: AnimationData = AnimationData(isNull: true)
        if (data.types == "loadAnimation") {

            //[3]-回调函数 callback 的参数 animationData，就是拿到解析 json 后封装好的 AnimationData。
            func callback(animationData: AnimationData): Unit {
                completeData(animationData)
                //postMessage(Data(id: data.id, payload: data, status: "success"))
                postMessage(Data(id: data.id, animation: animationData, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }
            
            //TODO：assetLoader 只在 workerStart 函数内部调用，是否将 assetLoader 融入到 DataManager 中？？？
            //[1]-在此函数调用时，拿到解析 json 后封装好的 AnimationData，结果在回调函数 callback 中。
            assetLoader.load(
                this.context,
                //TODO：context2D 在 cj 的 assetLoader.load 函数中用不上。
                //data.context2D,
                data.path,
                data.fullPath,
                //[2]-回调函数 callback 的参数 animationData，就是拿到解析 json 后封装好的 AnimationData。
                callback,
                errorCallback
            )
        } else if (data.types == "complete") {
            let animation: AnimationData = data.animation
            completeData(animation)
            postMessage(Data(
              id: data.id,
              //payload: animation,
              animation: animation,
              status: "success"
            ))
            //animationData = animation
        } else if (data.types == "loadData") {
            func callback(animationData: AnimationData): Unit {
                //postMessage(Data(id: e.data.id, payload: animationData, status: "success"))
                postMessage(Data(id: data.id, animation: animationData, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }
            
            assetLoader.load(
                this.context,
                data.path,
                data.fullPath,
                callback,
                errorCallback
            )
        }
        //return animationData
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
            //TODO：要不要增加一个成员变量 hasKS ？？？----------------------------------------------------------2024.07.03
            //if (('ks' in layerData) && !layerData.completed)
            if (!layerData.ks.isNull() && !layerData.completed) {
                layerData.completed = true
                if (layerData.hasMask) {
                    var maskProps: Array<Mask> = layerData.masksProperties
                    
                    var mask: Mask = Mask()
                    //var pt_k: Bool = false
                    //var shapeData: ShapeData = ShapeData()
                    
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
                        // 把 maskProps[j].pt.k 提前处理
                        //if (mask.pt.size > 0) {
                        //    if (let Some(v) <- mask.pt[0].k) {  //"k"
                        //        pt_k = true
                        //        shapeData = v
                        //    }
                        //}
                        //if (pt_k && shapeData.i.size > 0) { // json 中 k 是一个对象
                        if (mask.pt.size == 1) { // json 中 k 是一个对象 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [中] 
                            if (let Some(v) <- mask.pt[0].k) { //"k"
                                convertPathsToAbsoluteValues(v)
                            }
                        } else if (mask.pt.size > 1) { // json 中 k 是一个数组 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [外]
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
                    //TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！
                    //completeText(layerData)
                }
            }
        }
    }


    func completeChars(chars: Array<FontCharacter>, assets: Array<Asset>): Unit {
        if (chars.size > 0) {
            let len: Int64 = chars.size
            for (i in 0..len) {
                //TODO: 在 json 中找不到 chars[i].t-----------------------------------------------------------2024.07.04
                if (chars[i].t == 1) {
                    // var compData = findComp(chars[i].data.refId, assets)
                    //TODO: 此处的 chars[i].data 是 layer ---------------------------------------------------2024.07.04
                    chars[i].data.layers = findCompLayers(chars[i].data.refId, assets)
                    // chars[i].data.ip = 0
                    // chars[i].data.op = 99999
                    // chars[i].data.st = 0
                    // chars[i].data.sr = 1
                    // chars[i].w = compData.w
                    // chars[i].data.ks = {
                    //   a: { k: [0, 0, 0], a: 0 },
                    //   p: { k: [0, -compData.h, 0], a: 0 },
                    //   r: { k: 0, a: 0 },
                    //   s: { k: [100, 100], a: 0 },
                    //   o: { k: 100, a: 0 },
                    // }
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
            //comp.layers.__used 是确认 "assets"."layers" 是否被从 json 处理成对象格式。cj 不存在此情况。
            return comp.layers
            //if (!comp.__used) {
            //    //comp.layers.__used = true
            //    //comp.layers.__used = true
            //    comp.__used = true
            //    return comp.layers
            //}
            //return JSON.parse(JSON.stringify(comp.layers))
        }
        return Array<Layer>()
    }

    func completeShapes(arr: Array<ContentModel>): Unit {
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
                if (sh.ks.size == 1) { // k 是一个对象
                    if (let Some(v) <- sh.ks[0].k) { //"k"
                        convertPathsToAbsoluteValues(v)
                    }
                } else if (sh.ks.size > 1) { // json 中 k 是一个数组
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

    /*
    func checkVersion(minimum: Array<Int64>, animVersionString: String): Bool {
        //var animVersion = animVersionString ? animVersionString.split('.') : [100, 100, 100]
        
        var animVersion: Array<Int64> = [100, 100, 100]
        let lines: Array<String> = animVersionString.split("\r\n", removeEmpty: true)
        if (lines.size >= 3) {
            animVersion[0] = Int64.parse(lines[0])
            animVersion[1] = Int64.parse(lines[1])
            animVersion[2] = Int64.parse(lines[2])
        }
        
        if (minimum[0] > animVersion[0]) {
            return true
        } else if (animVersion[0] > minimum[0]) {
            return false
        }
        if (minimum[1] > animVersion[1]) {
            return true
        } else if (animVersion[1] > minimum[1]) {
            return false
        }
        if (minimum[2] > animVersion[2]) {
            return true
        } else if (animVersion[2] > minimum[2]) {
            return false
        }
        //后续使用都是 if(checkVersion(minimum, animVersionString)), 在 if 判断中，if(null) = if(false)，故返回 false
        return false
    }
    */
    
//-----------------------------------------------------------------------------------------------------------------
    
    func completeData(animationData: AnimationData): Unit {
        if (animationData.__complete) {
            return
        }
        //TODO: 以下 5 个，需要考虑是转成函数内函数？还是改为引用对象内函数
        checkColors(animationData)
        checkText(animationData)
        checkChars(animationData, completeShapes)
        //TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！
        //checkPathProperties(animationData)
        checkShapes(animationData, completeShapes, convertPathsToAbsoluteValues)
        
        completeLayers(animationData.layers, animationData.assets)
        completeChars(animationData.chars, animationData.assets)
        animationData.__complete = true
    }
    
    func completeText(data: Layer) {
        //TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！
        //if (data.t.a.size == 0 && !("m" in data.t.p)) {
        //    // data.singleShape = true
        //}
    }

    ////TODO: 在开发此函数--20240707
    //var moduleOb = {}
    //moduleOb.completeData = completeData
    //moduleOb.checkColors = checkColors
    //moduleOb.checkChars = checkChars
    //moduleOb.checkPathProperties = checkPathProperties
    //moduleOb.checkShapes = checkShapes
    //moduleOb.completeLayers = completeLayers
    //return moduleOb


//-----------------------------------------------------------------------------------------------------------------

    func createProcess(onComplete: (AnimationData) -> Unit, onError: () -> Unit): String {
        _counterId += 1
        let id: String = "processId_" + _counterId.toString()
        let p: Processes = Processes(onComplete, onError)
        processes.put(id, p)
        return id
    }
  
//-----------------------------------------------------------------------------------------------------------------

    //[7]-解析 json 后封装好的 AnimationData，结果在回调函数 onComplete 参数中。
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //public func loadAnimation(context2D: CanvasRenderingContext2D, path: String, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
    public func loadAnimation(context: Option<AbilityContext>, path: String, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        this.context = context
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        //TODO: 把 workerInstance.postMessage 改为多参函数？？？
        // async 异步
        workerInstance.postMessage(Data(
            types: "loadAnimation",
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
            //context2D: context2D,
            path: path,
            fullPath: "",
            id: processId
        ))
    }

    public func loadData(path: String, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        //TODO: 把 workerInstance.postMessage 改为多参函数？？？
        workerInstance.postMessage(Data(
            types: "loadData",
            path: path,
            fullPath: "",
            id: processId
        ))
    }

    public func completeAnimation(anim: AnimationData, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        //TODO: 把 workerInstance.postMessage 改为多参函数？？？
        workerInstance.postMessage(Data(
            types: "complete",
            animation: anim,
            id: processId
        ))
    }


}

//TODO：assetLoader 只在 workerStart 函数内部调用，是否将 assetLoader 融入到 DataManager 中？？？
class AssetLoader {
    //TODO: 应该是解析其他格式的json数据，用不到，不实现。
    //func formatResponse(xhr) {
    //  //使用 typeof 会使此方法的执行时间翻倍，因此如果可用，最好使用头来验证类型
    //  var contentTypeHeader = xhr.getResponseHeader('content-type')
    //  if (contentTypeHeader && xhr.responseType === 'json' && contentTypeHeader.indexOf('json') !== -1) {
    //    return xhr.response
    //  }
    //  if (xhr.response && typeof xhr.response === 'object') {
    //    return xhr.response
    //  } if (xhr.response && typeof xhr.response === 'string') {
    //    return JSON.parse(xhr.response)
    //  } if (xhr.responseText) {
    //    return JSON.parse(xhr.responseText)
    //  }
    //  return null
    //}

    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //TODO：context2D 在 cj 的此函数中用不上。
    //func loadAsset(context2D: CanvasRenderingContext2D, path: String, fullPath: String, callback: (AnimationData) -> Unit, errorCallback: () -> Unit) {
    func loadAsset(context: Option<AbilityContext>, path: String, fullPath: String, callback: (AnimationData) -> Unit, errorCallback: () -> Unit): Unit {
        //根据 path 获取 json 文件中信息，转为 String 类型
//        var jsonString = context2D.getJsonData(path)
        Timer.once(Duration.Zero, { =>
            let jsonString: String = readFile(context, path)
            var jsonData: AnimationData = AnimationData(isNull: true)
            if (jsonString != "") {
                /**
                 * 将字符串转为 json 对象.
                 * cj 直接调用 AnimationDataParser.parse(reader: String): AnimationData
                 */
                //var jsonData = JSON.parse(jsonString)
                jsonData = AnimationDataParser.parse(jsonString)
                //不用判断 jsonData 是否是 null，cj中如果解析封装失败会抛出异常。
                //if (jsonData) {
                    callback(jsonData)
                //}
            } else {
                //errorCallback("Lottie4cj: the path has no data!")
                errorCallback()
            }
            //return jsonData
        })
    }
    
    func readFile(context: Option<AbilityContext>, path: String): String {
        var buf: Array<Byte> = Array<Byte>(1024, item: 0)
        if(path.startsWith("file://") || path.startsWith("https:")) {
            //通过URL.openStream获取数据
        } else {
            let stageContext = getStageContext(context.getOrThrow())
            let resMgr = ResourceManager.getResourceManager(stageContext)
            buf = resMgr.getRawFileContent(path)
        }

//        let file: File = File(path, OpenOption.Open(true, true))
//        let len: Int64 = file.length
//        var buf: Array<Byte> = Array<Byte>(len, item: 0)
//        file.read(buf)
//        file.close()
        return String.fromUtf8(buf)
    }
    
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //TODO：context2D 在 cj 的此函数中用不上。
    //func load(context2D!: CanvasRenderingContext2D, path!: String, fullPath!: String, callback!: (AnimationData) -> Unit, errorCallback!: () -> Unit) {
    func load(context: Option<AbilityContext>, path: String, fullPath: String, callback: (AnimationData) -> Unit, errorCallback: () -> Unit): Unit {
        this.loadAsset(context, path, fullPath, callback, errorCallback)
    }

    //return {
    //  load: loadAsset,
    //}
}

