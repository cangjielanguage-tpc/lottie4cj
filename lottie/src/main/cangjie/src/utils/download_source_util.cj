
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

public class ProgressCallback <: Callback1Argument<AgentProgress> {
    let completeCallBackInside: () -> Unit
    var task: Option<Task> = Option<Task>.None
    public init(completeCallBackInside: () -> Unit, task: Task) {
        this.completeCallBackInside = completeCallBackInside
        this.task = task
    }
    public open func invoke(arg: AgentProgress): Unit {
        this.completeCallBackInside()
        if (let Some(v) <- this.task) {
            try {
                removeAgent(v.tid)
            } catch (err: Exception) {
                Hilog.error(0, "[DownLoadSourceUtil]","[ProgressCallback] remove task error: ${err.message}")
            }
            this.task = Option<Task>.None
        }
    }
}
