/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.utils
import tpc.BasicServicesKit.request.agent.*
import tpc.BasicServicesKit.*
import ohos.hilog.*
func getContext(): String {
    return FileUtils.downloadFolderLottie
}

func getContext(context: Option<UIAbilityContext>, ty: String): String {
    if (let Some(v) <- context) {
        if (ty == "cacheDir") {
            //暂时找不到 v.cacheDir  //return v.cacheDir
            return v.filesDir
        } else if (ty == "filesDir") {
            return v.filesDir
        }
    }
    return ""
}

public class ProgressCallback <: Callback1Argument<Progress> {
    let completeCallBackInside: () -> Unit
    var task: Option<Task> = Option<Task>.None
    public init(completeCallBackInside: () -> Unit, task: Task) {
        this.completeCallBackInside = completeCallBackInside
        this.task = task
    }
    public open func invoke(arg: Progress): Unit {
        this.completeCallBackInside()
        if (let Some(v) <- this.task) {
            try {
                remove(v.tid,{err,tas =>()})
            } catch (err: Exception) {
                Hilog.error(0, "[DownLoadSourceUtil]","[ProgressCallback] remove task error: ${err.message}")
            }
            this.task = Option<Task>.None
        }
    }
}
