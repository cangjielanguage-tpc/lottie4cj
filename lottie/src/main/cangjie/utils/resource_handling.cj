/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.utils

internal import std.io.{InputStream, ByteArrayStream}



import tpc.BasicServicesKit.request.agent.*
import tpc.BasicServicesKit.request.agent.Progress as AgentProgress
internal import zip4cj.ZipFile
internal import compress.zlib.*
import tpc.BasicServicesKit.AsyncCallback
import tpc.AbilityKit.*
import tpc.BasicServicesKit.BusinessException
import ohos.hilog.*
import tpc.ArkData.distributedDataObject.*
// 筛选.json资源
func filterJson(way: String): String {
    let files: ArrayList<FileInfo> = FileUtils.fileList(way)
    for (item in files) {
        let fileNames: String = item.path.fileName ?? ""
        if (fileNames.endsWith(".json")) {
            return fileNames
        }
    }
    return ""
}

// 判断解压之后的zip中是否有其他文件夹
func isHaveDirectory(way: String): String {
    let files: ArrayList<FileInfo> = FileUtils.directoryList(way)
    for (i in 0..files.size) {
        let res: Array<String> = files[i].path.toString().split("/", removeEmpty: true)
        let fileName = res[res.size - 1]
        if (fileName != "__MACOSX" && fileName != "images") {
            if (filterJson("${way}/${fileName}") != "" && isImagesDir("${way}/${fileName}")) {
                return fileName
            }
        }
    }
    return ""
}

// 判断是否是images文件夹
func isImagesDir(way: String): Bool {
    let files: ArrayList<FileInfo> = FileUtils.directoryList(way)
    for (i in 0..files.size) {
        let res: Array<String> = files[i].path.toString().split("/", removeEmpty: true)
        let fileName = res[res.size - 1]
        if (fileName == "images" && isHaveImg("${way}/${fileName}")) {
            return true
        }
    }
    return false
}

// 移动解压之后的文件中带有文件夹的image
func moveImages(routerDir: String, way: String): Unit {
    // files创建新images文件夹
    let dirPath: String = routerDir + "/images"
    try {
        FileUtils.createFolder(dirPath, recursive: true)
    } catch (err: Exception) {
        Hilog.error(0, "[moveImages]", "mkdir err: ${err.message}")
    }
    let newWay = "${routerDir}/${way}/images"

    let directorys: ArrayList<FileInfo> = FileUtils.directoryList(newWay)
    for (item in directorys) {
        let res: Array<String> = item.path.toString().split("/", removeEmpty: true)
        let fileName = res[res.size - 1]
        if (fileName == "images" && isHaveImg("${way}/${fileName}")) {
            let srcPath = "${newWay}/${fileName}"
            let destPath = "${dirPath}/${fileName}"
            try {
                // 移动文件加
                if (srcPath == destPath) { continue }
                FileUtils.moveDirectory(srcPath, destPath, true)
            } catch (err: Exception) {
                Hilog.error(0, "[createFilesDir]", "moveDirectory err: ${err.message}")
            }
        }
    }

    let files: ArrayList<FileInfo> = FileUtils.fileList(way)
    for (item in files) {
        let fileNames: String = item.path.fileName ?? ""
        if (!fileNames.endsWith(".png")) { continue }
        let srcPath = "${newWay}/${fileNames}"
        let destPath = "${dirPath}/${fileNames}"
        try {
            // 移动文件
            if (srcPath == destPath) { continue }
            FileUtils.moveFile(srcPath, destPath, true)
        } catch (err: Exception) {
            Hilog.error(0, "[createFilesDir]", "moveFile err: ${err.message}")
        }
    }
}

// 移动解压之后的文件中带有文件夹的json
func moveJson(routerDir: String, way: String): Unit {
    let jsonWay = "${routerDir}/${way}"
    let files: ArrayList<FileInfo> = Directory(jsonWay).fileList()
    var newJson: String = ""
    for (item in files) {
        let fileNames: String = item.path.fileName ?? ""
        if (fileNames.endsWith(".json")) {
            newJson = fileNames
            break
        }
    }

    let srcPath = "${jsonWay}/${newJson}"
    let destPath = "${routerDir}/${newJson}"
    try {
        // 移动文件
        if (srcPath == destPath) { return }
        FileUtils.moveFile(srcPath, destPath, true)
    } catch (err: Exception) {
        Hilog.error(0, "[moveJson]", "moveJson err: ${err.message}")
    }
}

func decompressZipFile(inFile: String, outFile: String): Int64 {
    let zipFile = ZipFile(inFile)          // 创建ZipFile类
    zipFile.setRunInThread(false)          // 设置是否用子线程运行任务
    zipFile.extractAll(outFile)            // 解压到 output 文件夹, 文件夹不存在则创建
    zipFile.close()                        // 资源关闭

    return 0
}

func decompressGzipFile(srcFileName: String, resultDir: JsonFilesDir): Int64 {
    try {
        var destFileName = resultDir.route
        var lastSegment: String = resultDir.dataName
        if (lastSegment.endsWith(".tar.gz")) {//.tar.gz  //.gzip
            lastSegment = lastSegment.replace(".tar.gz", "")
        } else if (lastSegment.endsWith(".gz")) {
            lastSegment = lastSegment.replace(".gz", "")
        }
        destFileName = destFileName + "/" + lastSegment + ".json"

        var count: Int64 = 0

        let srcFile: File = File(srcFileName, OpenOption.Open(true, false))
        let destFile: File = File(destFileName, OpenOption.CreateOrTruncate(false))

        var tempBuf: Array<UInt8> = Array<UInt8>(1024, item: 0)
        let decompressInputStream: DecompressInputStream = DecompressInputStream(srcFile, wrap: GzipFormat, bufLen: 10000)
        var isFirst: Bool = true
        var isStartJson: Bool = false //开始写入json文件中。
        var startIndex: Int64 = 0 //开始写入json文件的数组下标。
        while (true) {
            var readNum = decompressInputStream.read(tempBuf)
            if (readNum <= 0) {
                break
            }
            startIndex = 0
            if (isFirst) {
                isFirst = false
                if (tempBuf[0] == 123){
                    isStartJson = true
                }
            }
            if (!isStartJson) {
                let index: Int64 = tempBuf.indexOf(123) ?? -1
                if (index != -1) {
                    // { 之后的字符是： \r\n  ||  \n  ||  空格  ||  双引号 "
                    if ((tempBuf[index + 1] == 13 && tempBuf[index + 2] == 10) || tempBuf[index + 1] == 10 || tempBuf[index + 1] == 32 || tempBuf[index + 1] == 34) {
                        startIndex = index
                        isStartJson = true
                    }
                }
            }
            if (isStartJson) {
                destFile.write(tempBuf.slice(startIndex, readNum - startIndex).toArray())
                count += (readNum - startIndex)
            }
        }
        decompressInputStream.close()

        srcFile.close()
        destFile.close()

        return count
    } catch (e: Exception) {
        // This happens in the Android Studio layout preview.
        Hilog.error(0, "[decompressGzipFile]","has a error in decompressGzipFile. eror.message: ${e.message}")
        return 0
    }
}

private let ZIP_MAGIC: Array<UInt8> = [0x50, 0x4b, 0x03, 0x04]
private let GZIP_MAGIC: Array<UInt8> = [0x1f, 0x8b, 0x08]

func isZipCompressed(srcFileName: String): Bool {
    return matchesMagicBytes(srcFileName, ZIP_MAGIC)
}
func isGzipCompressed(srcFileName: String): Bool {
    return matchesMagicBytes(srcFileName, GZIP_MAGIC)
}
private func matchesMagicBytes(srcFileName: String, magic: Array<UInt8>): Bool {
    try {
        let buf: Array<Byte> = FileUtils.readLenToBuffer(srcFileName, magic.size)
        return buf == magic
    } catch (e: Exception) {
        // This happens in the Android Studio layout preview.
        Hilog.error(0, "[matchesMagicBytes]","has a error in matchesMagicBytes. eror.message: ${e.message}")
        return false
    }
}

// 解压和读取
public func decompressAndReadJson(url: String, cacheDir: String, resultDir: JsonFilesDir): AnimationData {
    let inFile: String = cacheDir
    let fileDir = resultDir.route
    let outFile: String = fileDir

    if (isZipCompressed(inFile)) {
        decompressZipFile(inFile, outFile)
    } else if (isGzipCompressed(inFile)) {
        decompressGzipFile(inFile, resultDir)
    }

    // 解压完成之后读取 json 数据
    if (isHaveDirectory(fileDir) != "") {
        let newFileDir: String = isHaveDirectory(fileDir)
        moveImages(fileDir, newFileDir)
        moveJson(fileDir, newFileDir)
        let zipData: AnimationData = readJson(url, fileDir)
        // 修改u路径
        handleZipAssets(zipData, fileDir)
        return zipData
    } else {
        let zipData: AnimationData = readJson(url, fileDir)
        // 修改u路径
        handleZipAssets(zipData, fileDir)
        return zipData
    }

}

// 判断沙箱中是否有下载的zip资源
public func isHaveZip(url: String, readPath: String) {
    let lastIndex: Int64 = url.lastIndexOf("/") ?? -1
    let result: String = url[(lastIndex + 1)..url.size]
    // 通过沙箱中下载或者解压的文件名来找到文件所在路径
    let filePath = readPath + "/" + result
    //同步方法判断沙箱里的文件是否存在
    let isExist: Bool = FileUtils.accessSync(filePath)
    return isExist
}

// 读取json数据
public func readJson(url: String, readPath: String, errCallBack!: Option<(String, Exception) -> Unit> = None): AnimationData {
    try {
        let existResult: FilePathObject = isCacheExist(url, readPath)
        if (existResult.isExist) {
            let arrayBuffer: Array<Byte> = FileUtils.readToEnd(existResult.filePath)
            let bas: ByteArrayStream = ByteArrayStream(arrayBuffer.size)
            bas.write(arrayBuffer)

            // 解码的json数据
            return AnimationDataParser.parse(bas)
        }
    } catch (err: Exception) {
        Hilog.error(0, "[readJson]", "readJson error, err.message = ${err.message}")
        if (let Some(v) <- errCallBack) {
            v("error", err)
        }
    }
    return AnimationData(isNull: true)
}

// 判断沙箱里的文件是否存在
public func isCacheExist(url: String, readPath: String): FilePathObject {

    let filePath: String 
    if (readPath.endsWith(".js") || readPath.endsWith(".json")) {
        filePath = readPath
    } else {
        let lastIndex: Int64 = url.lastIndexOf("/") ?? -1
        let result: String = url[(lastIndex + 1)..url.size] //最后一个斜杠后的字符串
        // 通过沙箱中下载或者解压的文件名来找到文件所在路径
        // 获取uri后缀
        let suffix: String = getSuffix(url)

        if (suffix == ".js" || suffix == ".json") {
            filePath = readPath + "/" + result
        } else {
            filePath = readPath + "/" + filterJson(readPath)
        }
    }

    //同步方法判断沙箱里的文件是否存在
    let isExist: Bool = FileUtils.accessSync(filePath)
    return FilePathObject(isExist, filePath)
}

//改为并发异步调用 ???
// 下载图片至files
public func downLoadImg(lottieData: AnimationData, context: Option<UIAbilityContext>): ArrayList<Future<Unit>> {
    let imgRouterFilesDir: String = createImageFilesDir(context)
    let downloadTasks: ArrayList<Future<Unit>> = ArrayList<Future<Unit>>(lottieData.assets.size)
    for (i in 0..lottieData.assets.size){
        let item = lottieData.assets[i]
        if (item.id != "" && item.p.startsWith("http")) {
            item.sourceFrom = 3  //区别图片来源：1.来自\resources\rawfile\， 2.来自手机中保存的图片，3.来自网络下载。
            //let promise = JSPromiseCapability()
            let future: Future<Unit> = spawn {
                let downloadConfig = Config(
                    Action.DOWNLOAD,
                    item.p,
                    mode: Mode.FOREGROUND,
                    method: "GET",
                    overwrite: true,
                    saveas: "./${item.id}.png",
                    gauge: true
                )

                //let stageContext = getStageContext(context.getOrThrow())
                create(context.getOrThrow(), downloadConfig,{err,task =>
                   if (let Some(e) <- err) {
                        Hilog.error(0xFF00,"lottie_ohos","Failed to request the upload. Code: ${e.code}, message: ${e.message}");
                        //promise.reject(e.toJSValue())
                        return
                   }
                   func completeCallBackInside() {
                        let srcPath = getContext() + "/${item.id}.png"
                        let destPath = "${imgRouterFilesDir}/${item.id}.png"
                        try {
                            // 移动文件
                            if (srcPath != destPath) {
                                FileUtils.moveFile(srcPath, destPath, true)
                            }
                        } catch (err: Exception) {
                            Hilog.error(0, "[downLoadImg]", "moveFile err: ${err.message}")
                        }
                    }
                    let createOnCallback = ProgressCallback(completeCallBackInside, task.getOrThrow())
                    task.getOrThrow().on("completed",createOnCallback)
                    task.getOrThrow().start({err,tas =>
                        if (let Some(e) <- err) {
                            Hilog.error(0xFF00,"lottie_ohos","Failed to request the upload. Code: ${e.code}, message: ${e.message}");
                        //promise.reject(e.toJSValue())
                            return
                        }
                   })
                })
//                func completeCallBackInside() {
//                    let srcPath = getContext() + "/${item.id}.png"
//                    let destPath = "${imgRouterFilesDir}/${item.id}.png"
//                    try {
//                        // 移动文件
//                        if (srcPath != destPath) {
//                            FileUtils.moveFile(srcPath, destPath, true)
//                        }
//                    } catch (err: Exception) {
//                        Hilog.error(0, "[downLoadImg]", "moveFile err: ${err.message}")
//                    }
//                }
//                let createOnCallback = ProgressCallback(completeCallBackInside, downloadTask)
//                downloadTask.on("completed", createOnCallback)
//                downloadTask.start()
            }
            
            downloadTasks.append(future)
        }
    }
    return downloadTasks
}

// 判断files目录下是否有下载的图片
public func isHaveImg(way: String): Bool {
    let files: ArrayList<FileInfo> = Directory(way).fileList()
    for (item in files) {
        let fileNames: String = item.path.fileName ?? ""
        if (fileNames.endsWith(".png")) {
            return true
        }
    }
    return false
}

// 获取uri后缀
public func getSuffix(url: String): String {
    let lastDotIndex: Int64 = url.lastIndexOf(".") ?? -1
    if (lastDotIndex != -1 && lastDotIndex < url.size - 1) {
        return url[lastDotIndex..url.size]
    } else {
        return "url中没有找到合适的扩展名"
    }
}

// 处理下载有图片json中的assets
public func handleAssets(lottieData: AnimationData): Unit {
    for(item in lottieData.assets) {
        if (item.id != "" && item.p.startsWith("http")) {
            item.p = "${item.id}.png"
            if (item.u == "") {
                item.u = "lottie/loadImages/"
                item.e = 0
            }
        }
    }
}

// 处理下载的zip资源图片路径
public func handleZipAssets(lottieData: AnimationData, zipRoute: String): Unit {
    let parts: Array<String> = zipRoute.split("/")
    let lastPart: Array<String> = parts.slice(parts.size-3, 3)
    let lastPartStr: String = String.join(lastPart, delimiter: "/")
    // 修改u路径
    for(i in 0..lottieData.assets.size){
        let item: Asset = lottieData.assets[i]
        item.sourceFrom = 3  //区别图片来源：1.来自\resources\rawfile\， 2.来自手机中保存的图片，3.来自网络下载。
        if (!item.id.isEmpty() && !item.u.isEmpty()) {
            item.u = "${lastPartStr}/images/"
        }
    }
}

// 创建zip和json文件目录
public func createFilesDir(url: String, context: Option<UIAbilityContext>): JsonFilesDir {
    let parts: Array<String> = url.split("/")
    let secondLastSegment: String = parts[parts.size - 2]
    let lastSegmentWithExtension: String = parts[parts.size - 1]
    //去除后缀 .zip / .json
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

    let dirPath = FileUtils.downloadFolderLottie

    let dirPathFirst: String = String.join([dirPath, secondLastSegment], delimiter: "/")
    let dirPathSecond: String = String.join([dirPathFirst, lastSegment], delimiter: "/")
    let dirArray: Array<String> = [dirPath, dirPathFirst, dirPathSecond]
    try {
        for(str in dirArray){
            let res: Bool = Directory.exists(str)
            if (!res) {
                FileUtils.createFolder(str, recursive: true)
            }
        }
    } catch (err: Exception) {
        Hilog.error(0, "[createFilesDir]", "mkdir err: ${err.message}")
    }
    return JsonFilesDir(dataName: lastSegmentWithExtension, route: dirPathSecond)
}

// 创建images数据的文件夹
public func createImageFilesDir(context: Option<UIAbilityContext>): String {
    let dirImgPath = getContext()

    let dirImgPathFirst: String = FileUtils.downloadFolderImage
    let dirImagesArray: Array<String> = [dirImgPath, dirImgPathFirst]
    try {
        for(str in dirImagesArray){
            let res: Bool = Directory.exists(str)
            if (!res) {
                FileUtils.createFolder(str, recursive: true)
            }
        }
    } catch (err: Exception) {
        Hilog.error(0, "[createFilesDir]", "mkdir imgFiles err: ${err.message}")
    }
    return dirImgPathFirst
}
