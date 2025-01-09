package ohos_app_cangjie_entry
//
//import tpc.UIKit.Text
//import tpc.UIKit.Button
//import tpc.UIKit.Column
//import tpc.UIKit.CustomView
//import tpc.UIKit.Row
//import tpc.UIKit.Visibility
//import ohos.state_macro_manage.State
//import ohos.state_macro_manage.Component
//import ohos.state_manage.LocalStorage
//import ohos.state_manage.ObservedProperty
//import ohos.state_manage.SubscriberManager
//import ohos.state_manage.ViewStackProcessor
//import ohos.state_macro_manage.HybridComponentEntry
//import ohos.hybrid_base.CJPageEntry
//import ohos.ark_interop.*
//import ohos.hybrid_base.HybridComponentBase
//import cj_res_entry.app
//internal import lottie.model.*
//internal import lottie.parser.*
//internal import lottie.animation.*
//internal import lottie.utils.helpers.*
//import ohos.state_macro_manage.*
//import ohos.ark_interop_helper.*
//import lottie.utils.globContext
//@HybridComponentEntry
//@Component
//class Index {
//    @State
//    var msg: String = "Hello"
//    @State
//    var animateName: String = "2016"
//    var globalAbilityContext: Option<Context> = Option<Context>.None
//    @State var appleVisible: Visibility = Visibility.Visible
////    private var renderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
////    private var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.renderingSettings)
//
//    //private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
//    private var animateItem: Option<AnimationItem> = None
//    public func build() {
//        Column {
//            Row {
//                //Canvas(this.canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).visibility(this.appleVisible)
//            }
//            Row {
////                Button("加载2016-ui").onClick {
////                    evt =>
////                        spawn {
////                            if (this.animateItem.isNone()) {
////                                let ai: AnimationItem = lottie.loadAnimation(
////                                    AnimationConfig(
////                                        wrapper_ns: CreateNS("doc"),
////                                        container: this.canvasRenderingContext,
////                                        renderer: "canvas", // canvas 渲染模式
////                                        autoplay: true,
////                                        name: this.animateName,
////                                        contentMode: "Contain",
////                                        path: "data.json",
////                                        animationData: AnimationData(isNull: true),
////                                        context: globalAbilityContext
////                                    )
////                                )
////                                this.animateItem = ai
////                            }
////                        }
////                }
//
//            }
//        }
//    }
//}
//
//func setContext(ctx: JSContext, callInfo: JSCallInfo) {
//    let jsEnv = ctx.getNapiEnv()
//    let jsValue = arkTsValuetoNapiValue(jsEnv, callInfo[0])
//    if (isStageMode(jsEnv, jsValue)) {
//        globContext.stageContext = getContextStageMode(jsEnv, jsValue)
//        globContext.filesDir = callInfo[0].asObject()["filesDir"].toString()
//    }
//    ctx.undefined().toJSValue()
//}
