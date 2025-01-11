/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.utils
import tpc.AbilityKit.*
import tpc.BasicServicesKit.request.agent.*
import tpc.BasicServicesKit.request.agent.Progress as AgentProgress
import ohos.hilog.*
public class DownLoadSource {
    let downloadUri: HashMap<String, Bool> = HashMap<String, Bool>()

    public func downLoadNetworkSource(
        uri: String, 
        configAnimation: (AnimationData, Bool) -> Unit, 
        resultDir: JsonFilesDir,
        errCallBack: (String, Exception) -> Unit,
        cacheFlag: Bool,
        context: Option<UIAbilityContext>
    ): Unit {
        let flag: Bool = downloadUri.contains(uri)
        if (flag) {
            func inside(): Unit {
                let existResult: FilePathObject = isCacheExist(uri, resultDir.route)
                if (!existResult.isExist) {
                    // 加载失败，重新触发
                    Timer.once(Duration.millisecond * 100, inside)
                }
                
                let newData: AnimationData = readJson(uri, resultDir.route)
                if (!(uri.endsWith(".json") || uri.endsWith(".js"))) {
                    handleZipAssets(newData, resultDir.route)
                }
                configAnimation(newData, false)
            }
            Timer.once(Duration.millisecond * 100, inside)
        } else {
            // 将URI添加到Map中，表示下载已经开始
            downloadUri.put(uri, true)

            let downloadConfig = Config(
                Action.DOWNLOAD,
                uri,
                mode: Mode.FOREGROUND,
                overwrite: true,
                method: "GET",
                saveas: "${resultDir.route}/${resultDir.dataName}",
                gauge: true
            )

            try {
                create(context.getOrThrow(), downloadConfig,{err,task =>
                let downloadPath: String = downloadConfig.saveas ?? ""

                func completeCallBackInside() {
                    loadSuccess(downloadPath, uri, resultDir, configAnimation, errCallBack, context)
                }
                let createOnCallback = ProgressCallback(completeCallBackInside, task.getOrThrow())
                task.getOrThrow().on("completed", createOnCallback)
                func failedCallBack(){
                    loadFail(uri, resultDir, configAnimation, errCallBack, cacheFlag)
                }
                let failedCallback: ProgressCallback = ProgressCallback(failedCallBack, task.getOrThrow())
                task.getOrThrow().on("failed", failedCallback)

                task.getOrThrow().start({err,tas =>
                        if (let Some(e) <- err) {
                            errCallBack("error", e)
                        }
                   })
                })
            } catch (err: Exception) {
                // 下载失败
                Hilog.error(0, "[DownLoadSource]","[downLoadNetworkSource] Download error: ${err.message}")
                downloadUri.remove(uri)
                errCallBack("error", err)
            }
        }
    }

    func loadSuccess(destPath: String, uri: String, resultDir: JsonFilesDir, 
        configAnimation: (AnimationData, Bool) -> Unit, 
        errCallBack: (String, Exception) -> Unit,context: Option<UIAbilityContext>
    ): Unit {
        if (uri.endsWith(".json") || uri.endsWith(".js")) {
            let lottieData: AnimationData = readJson(uri, destPath)

            // 判断assets是否有图片 且 图片的p地址是否是以http或者https开头的
            var isExitNetworkAssets: Bool = false
            for (i in 0..lottieData.assets.size) {
                if (lottieData.assets[i].p.startsWith("http")){
                    isExitNetworkAssets = true
                    break
                }
            }
            if (lottieData.assets.size > 0 && isExitNetworkAssets) {
                try {
                    let downloadTasks: ArrayList<Future<Unit>> = downLoadImg(lottieData, context)
                    for (future in downloadTasks) {
                        future.get()
                    }
                    
                    // 下载成功加载网络
                    handleAssets(lottieData)
                    configAnimation(lottieData, true)
                } catch (err: Exception) {
                    // 下载失败加载缓存
                    Hilog.error(0, "[loadSuccess]"," Download error: ${err.message}")
                    errCallBack("error", err)
                    handleAssets(lottieData)
                    configAnimation(lottieData, false)
                }
            } else {
                // 读取成功从Map中移除条目
                // uri方式无图片的json网络资源
                downloadUri.remove(uri)
                configAnimation(lottieData, true)
            }
        } else if (uri.endsWith(".zip") || uri.endsWith(".gz")) {
            // 要改为异步调用吗？？？
            try {
                let ad: AnimationData = decompressAndReadJson(uri, destPath, resultDir)
                // 解压成功，从Map中移除条目
                downloadUri.remove(uri)
                configAnimation(ad, true)
            } catch (err: Exception) {
                // 解压失败，从Map中移除条目
                Hilog.error(0, "[DownLoadSource]","[loadSuccess]- decompress error: ${err.message}")
                downloadUri.remove(uri)
                errCallBack("error", err)
            }
        }
    }

    func loadFail(uri: String, resultDir: JsonFilesDir,
        configAnimation: (AnimationData, Bool) -> Unit, errCallBack: (String, Exception) -> Unit,
        cacheFlag: Bool
    ): Unit {
        // 处理网络异常加载缓存
        let existResult: FilePathObject = isCacheExist(uri, resultDir.route)
        if (existResult.isExist && cacheFlag) {
            downloadUri.remove(uri)
            let cacheData: AnimationData = readJson(uri, resultDir.route)
            if (!(uri.endsWith(".json") || uri.endsWith(".js"))) {
                handleZipAssets(cacheData, resultDir.route)
            }
            configAnimation(cacheData, false)
        } else {
            // 缓存无资源，给用户返回加载异常
            Hilog.error(0, "[DownLoadSource]","[loadFail]- the file is not exist in cache.")
            downloadUri.remove(uri)
            errCallBack("error", Exception("download fail: ${uri}"))
        }
    }

}
