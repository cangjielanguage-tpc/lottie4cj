/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.utils

func getContext(): String {
    return FileUtils.downloadFolderLottie
}

func getContext(context: Option<AbilityContext>, ty: String): String {
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
    public init(completeCallBackInside: () -> Unit) {
        this.completeCallBackInside = completeCallBackInside
    }
    public open func invoke(arg: Progress): Unit {
        this.completeCallBackInside()
    }
}
