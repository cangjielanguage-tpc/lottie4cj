/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils

internal import std.fs.*
internal import std.convert.*

internal import lottie4cj.parser.*


class WorkerProxy {

    //TODO：参数 e 没有直接用，一直用的是 e.data，参数直接改成 e.data
    var workerFn: (Data) -> Unit = default_Data_To_Unit
    
    //workerProxy.onmessage 实际的逻辑代码在后面 setupWorker 中 workerInstance.onmessage
    var onmessage: (Data) -> Unit = default_Data_To_Unit
    
    init(){}
    init(workerFn: (Data) -> Unit){
        this.workerFn = workerFn
    }
    init(workerFn: (Data) -> Unit, onmessage: (Data) -> Unit){
        this.workerFn = workerFn
        this.onmessage = onmessage
    }

    /* 把 workerInstance.postMessage 多参函数 改为 参数对象 */
    func postMessage(data: Data) {
        /* 调用 DataManager 的成员变量 workerFn */
        workerFn(data)
    }
}

public class DataManager {

    var _counterId: Int64 = 1
    var processes: HashMap<String, Processes> = HashMap<String, Processes>(24)
    //TODO：参数 e 没有直接用，一直用的是 e.data，参数直接改成 e.data
    var workerFn: (Data) -> Unit = default_Data_To_Unit
    
    var workerInstance: WorkerProxy = WorkerProxy()
    
    var workerInstanceFlag: Bool = false
    
    var assetLoader: AssetLoader = AssetLoader()

    func postMessage(data: Data) {
        //workerProxy未单独使用，可以直接等于 workerProxy = workerInstance
        this.workerInstance.onmessage(data)
    }

    func createWorker(fn: (Data) -> Unit): WorkerProxy {
        this.workerFn = fn   //workerFn = func workerStart
        return WorkerProxy(fn)
    }

    func onmessageWorkerInstance(data: Data) {
        let id: String = data.id
        if (processes.contains(id)) {
            let process: Processes = processes[id]
            processes.remove(id)
            if (data.status == "success") {
                process.onComplete(data.animation)
            } else if (data.status == "error") {
                process.onError()
            }
        }
    }

    func setupWorker(): Unit {
        if (!workerInstanceFlag) {
            this.workerInstanceFlag = true
            
            /* workerInstance = workerProxy =》 workerStart 中的代码，是在 loadAnimation/loadData/completeAnimation中最后一步执行 */
            this.workerInstance = this.createWorker(this.workerStart)
            
            /* workerProxy.onmessage 实际的逻辑代码此处。 workerProxy/workerInstance.onmessage */
            this.workerInstance.onmessage = this.onmessageWorkerInstance
        }
    }

    func workerStart(data: Data): Unit {
        if (data.types == "loadAnimation") {

            func callback(animationData: AnimationData): Unit {
                completeData(animationData)
                //postMessage(Data(id: data.id, payload: data, status: "success"))
                postMessage(Data(id: data.id, animation: animationData, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }

            assetLoader.load(
                //TODO：context2D 在 cj 的 assetLoader.load 函数中用不上。
                //data.context2D,
                data.path,
                data.fullPath,
                callback,
                errorCallback
            )
        } else if (data.types == "complete") {
            let animation: AnimationData = data.animation
            completeData(animation)
            postMessage(Data(
              id: data.id,
              animation: animation,
              status: "success"
            ))
        } else if (data.types == "loadData") {
            func callback(animationData: AnimationData): Unit {
                postMessage(Data(id: data.id, animation: animationData, status: "success"))
            }
            func errorCallback(): Unit {
                postMessage(Data(id: data.id, status: "error"))
            }
            
            assetLoader.load(
                data.path,
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
        var layerData: Layer = Layer()
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
                        // 把 maskProps[j].pt.k 提前处理
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
                    //TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！   //completeText(layerData)
                }
            }
        }
    }


    func completeChars(chars: Array<FontCharacter>, assets: Array<Asset>): Unit {
        if (chars.size > 0) {
            let len: Int64 = chars.size
            for (i in 0..len) {
                //TODO: 在 json 中找不到 chars[i].t
                if (chars[i].t == 1) {
                    //TODO: 此处的 chars[i].data 是 layer
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
            /* comp.layers.__used 是确认 "assets"."layers" 是否被从 json 处理成对象格式。cj 不存在此情况。 */
            return comp.layers
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

    
//-----------------------------------------------------------------------------------------------------------------
    
    func completeData(animationData: AnimationData): Unit {
        if (animationData.__complete) {
            return
        }
        checkColors(animationData)
        checkText(animationData)
        checkChars(animationData, completeShapes)
        
        //TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！    //checkPathProperties(animationData)
        
        checkShapes(animationData, completeShapes, convertPathsToAbsoluteValues)
        completeLayers(animationData.layers, animationData.assets)
        completeChars(animationData.chars, animationData.assets)
        animationData.__complete = true
    }
    
    func completeText(data: Layer) {
        //TODO: 在 json 中找不到 layers[i].t.p
        if (data.t.a.size == 0 && !data.t.p.contains("m")) {
            //TODO: 暂无执行逻辑   // data.singleShape = true
        }
    }


//-----------------------------------------------------------------------------------------------------------------

    func createProcess(onComplete: (AnimationData) -> Unit, onError: () -> Unit): String {
        _counterId += 1
        let id: String = "processId_" + _counterId.toString()
        let p: Processes = Processes(onComplete, onError)
        processes.put(id, p)
        return id
    }
  
//-----------------------------------------------------------------------------------------------------------------

    public func loadAnimation(path: String, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
        workerInstance.postMessage(Data(
            types: "loadAnimation",
            //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译   //context2D: context2D,
            path: path,
            fullPath: "",
            id: processId
        ))
    }

    public func loadData(path: String, onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        setupWorker()
        let processId: String = createProcess(onComplete, onError)
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
        workerInstance.postMessage(Data(
            types: "complete",
            animation: anim,
            id: processId
        ))
    }

}

//TODO：assetLoader 只在 workerStart 函数内部调用，是否将 assetLoader 融入到 DataManager 中？？？
class AssetLoader {

    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译   //context2D: CanvasRenderingContext2D
    //TODO：context2D 在 cj 的此函数中用不上。
    func loadAsset(path: String, fullPath: String, callback: (AnimationData) -> Unit, errorCallback: () -> Unit) {
        //根据 path 获取 json 文件中信息，转为 String 类型
        let jsonString: String = readFile(path)
        if (jsonString != "") {
            /**
             * 将字符串转为 json 对象.
             * cj 直接调用 AnimationDataParser.parse(reader: String): AnimationData
             */
            let jsonData: AnimationData = AnimationDataParser.parse(jsonString)
            //不用判断 jsonData 是否是 null，cj中如果解析封装失败会抛出异常。      //if (jsonData) { callback(jsonData) }
        } else {
            /* Lottie4cj: the path has no data! */
            errorCallback()
        }
    }
    
    func readFile(path: String): String {
        let file: File = File(path, OpenOption.Open(true, true))
        let len: Int64 = file.length
        var buf: Array<Byte> = Array<Byte>(len, item: 0)
        file.read(buf)
        file.close()
        return String.fromUtf8(buf)
    }
    
    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译   //context2D!: CanvasRenderingContext2D
    //TODO：context2D 在 cj 的此函数中用不上。
    func load(path: String, fullPath: String, callback: (AnimationData) -> Unit, errorCallback: () -> Unit) {
        this.loadAsset(path, fullPath, callback, errorCallback)
    }

}
