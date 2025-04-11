package ohos_app_cangjie_entry

//import tpc.UIKit.Text
//import tpc.UIKit.Button
//import tpc.UIKit.Column
//import tpc.UIKit.CustomView
//import tpc.UIKit.Row
//import tpc.UIKit.*
//
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
//internal import tpc.UIKit.component_interop.RenderingContextSettings
//internal import tpc.UIKit.component_interop.CanvasRenderingContext2D
//internal import tpc.UIKit.component_interop.Canvas
//import ohos.ark_interop.*

/*
var animationManager: Option<AnimationManager> = None
var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(settings)
var currentLottieName = ""

@HybridComponentEntry
@Component
class CJLottieComp {
    @State
    var lottie: AnimationManager = AnimationManager(canvasRenderingContext)

    public func aboutToAppear() {
        animationManager = lottie
    }

    private var animateItem: Option<AnimationItem> = None
    public func build() {
        Column {
            Canvas(canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).onReady({
                =>
            }).onDisAppear({
                =>
            })
        }.width(100.percent).height(30.percent)
    }
}

//@Interop[ArkTS]
public func setAnimationConfig(name: String, path: String, pathType: Int64, loop: Int64, autoPlay: Bool): Unit {
    currentLottieName = name
    if (let Some(manager) <- animationManager) {
        manager.destroy(animationName:currentLottieName)
        if (pathType == 3) {
            manager.loadAnimation(
                AnimationConfig(
                    uri: path,
                    isNetwork: true,
                    wrapper_ns: CreateNS("doc"),
                    container: canvasRenderingContext,
                    renderer: "canvas", // canvas 渲染模式
                    autoplay: autoPlay,
                    name: name,
                    contentMode: "Contain",
                    path: "", // 路径加载动画只支持raw文件夹下的相对路径
                    animationData: AnimationData(isNull: true),
                    context: globContext
                )
            )
        } else {
            manager.loadAnimation(
                AnimationConfig(
                    wrapper_ns: CreateNS("doc"),
                    container: canvasRenderingContext,
                    name: name, // 加载 rawfile 下面的数据
                    contentMode: "Contain",
                    path: path,
                    animationData: AnimationData(isNull: true),
                    context: globContext
                )
            )
        }
    }
}

//@Interop[ArkTS]
public func pauseAnimation(lottieName: String): Unit {
    if (let Some(manager) <- animationManager) {
        manager.pause(animationName:lottieName)
    }
}

//@Interop[ArkTS]
public func playAnimation(lottieName: String): Unit {
    if (let Some(manager) <- animationManager) {
        manager.play(animationName:lottieName)
    }
}

//@Interop[ArkTS]
public func stopAnimation(lottieName: String): Unit {
    if (let Some(manager) <- animationManager) {
        manager.stop(animationName:lottieName)
    }
}

//@Interop[ArkTS]
public func destroyAnimation(lottieName: String): Unit {
    if (let Some(manager) <- animationManager) {
        manager.destroy(animationName:lottieName)
    }
}
*/