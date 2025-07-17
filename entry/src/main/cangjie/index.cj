package ohos_app_cangjie_entry

internal import ohos.ark_interop.*
internal import ohos.ark_interop_helper.*
import ohos.hilog.Hilog
import lottie.utils.globContext

//public class GlobalContext {
//	static var _context: Option<StageContext> = None
//    public static func setContext(context: StageContext) {
//    	_context = context
//    }
//    public static func getContext(): Option<StageContext> {
//    	return _context
//    }
//}

// 全局函数，提供给arkTs调用，传递context参数
func setContext(runtime: JSContext, callInfo: JSCallInfo): JSValue {
	let jsEnv = runtime.getNapiEnv()
    let jsValue = arkTsValuetoNapiValue(jsEnv, callInfo[0])
    if (isStageMode(jsEnv, jsValue)) {
        // getContextStageMode(jsEnv, jsValue)方法返回StageContext，赋值给lottie库里的全局context即可
        globContext.stageContext = getContextStageMode(jsEnv, jsValue)
//        globContext.filesDir = callInfo[0].asObject()["filesDir"].toString()
        Hilog.error(0xFFFF, "setContext", "[setContext]------------ 是否接收到StageContext：${globContext.stageContext.isNone()}")
    }
    runtime.undefined().toJSValue()
}

func testCJ(runtime: JSContext, callInfo: JSCallInfo): JSValue {
    let result = "Hello ${callInfo[0].toString(runtime)}"
    runtime.string(result).toJSValue()
}

let EXPORT_MODULE = JSModule.registerModule {
    runtime, exports =>
        exports["testCJ"] = runtime.function(testCJ).toJSValue()
        exports["setContext"] = runtime.function(setContext).toJSValue()
}
