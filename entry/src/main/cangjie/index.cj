package ohos_app_cangjie_entry

import ohos.state_macro_manage.*
import ohos.state_manage.*

//import ohos.hybrid_base.*
import cj_res_entry.app

import tpc.UIKit.*

//import ohos.ark_interop.JSInteropNativeError
import ohos.ark_interop.*
import ohos.ark_interop_helper.*

import std.time.Duration
import std.time.DurationExtension

internal import lottie.model.*
internal import lottie.parser.*
internal import lottie.animation.*
internal import lottie.utils.helpers.*

//import ohos.prompt_action.*
//import refreshlayout.base.*
//import refreshlayout.bezierradar.*
//import ohos_app_cangjie_entry.pages.*

@HybridComponentEntry
@Component
class Index {
    @State
    var msg: String = "Hello"

    var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(settings)
//    var lottie = AnimationManager(canvasRenderingContext)
//    var currentLottieName = ""

    public func build() {

        Column {
            Canvas(canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).onReady({
                =>
            }).onDisAppear({
                =>
            })

            Button("加载").onClick {
                =>
                    var lottie = AnimationManager(canvasRenderingContext)
                    lottie.loadAnimation(
                            AnimationConfig(
                                wrapper_ns: CreateNS("doc"),
                                container: canvasRenderingContext,
                                name: "2016", // 加载 rawfile 下面的数据
                                contentMode: "Contain",
                                path: "data.json",
                                animationData: AnimationData(isNull: true),
                                context: getContext()
                            )
                    )
            }
        }.width(100.percent).height(30.percent)



//        Navigation(routerStack) {
//
//        }
//        .navDestination(bind<String>(pageMap, this))
    }
}

//func setContext(ctx: JSContext, callInfo: JSCallInfo) {
//    let jsEnv = ctx.getNapiEnv()
//    let jsValue = arkTsValuetoNapiValue(jsEnv, callInfo[0])
//    if (isStageMode(jsEnv, jsValue)) {
//        globContext.stageContext = getContextStageMode(jsEnv, jsValue)
//        globContext.filesDir = callInfo[0].asObject()["filesDir"].toString()
//    }
//    ctx.undefined().toJSValue()
//}