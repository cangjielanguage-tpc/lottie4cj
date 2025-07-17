/**
 * Created on 2024/12/3
 */
package lottie.utils

import ohos.ark_interop_helper.*
import ohos.hilog.Hilog

public class GlobalContext {
    public var stageContext: ?StageContext = None
    public var filesDir: String = ""
}

public var globContext = GlobalContext()