package ohos_app_cangjie_entry


import tpc.UIKit.*
internal import tpc.AbilityKit.UIAbilityContext
import ohos.state_macro_manage.State
import ohos.state_macro_manage.Component
import ohos.state_manage.LocalStorage
import ohos.state_manage.ObservedProperty
import ohos.state_manage.SubscriberManager
import ohos.state_manage.ViewStackProcessor
import ohos.state_macro_manage.HybridComponentEntry

import ohos.hybrid_base.HybridComponentBase
import cj_res_entry.app

import lottie.model.*
import lottie.parser.*
import lottie.animation.*
import lottie.utils.helpers.*

@HybridComponentEntry
@Component
class Index {
    @State
    var msg: String = "Hello"

    var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(settings)

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


    }
}
func getContext(): UIAbilityContext {
    match (globalcontext) {
        case Some(context)  => context
    	case _=> throw Exception("can not get globalcontext")
    }
}

