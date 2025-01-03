/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

internal import ohos.base.LengthProp
internal import ohos.component.Column
internal import ohos.component.Row
internal import ohos.component.Button
internal import ohos.component.Text
internal import ohos.component.CustomView
internal import ohos.component.CJEntry
internal import ohos.component.loadNativeView
internal import ohos.state_manage.SubscriberManager
internal import ohos.state_manage.ObservedProperty
internal import ohos.state_manage.LocalStorage
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r

import ohos.hilog.*

internal import ohos.ability.*
internal import ohos.resource_manager.*
internal import ohos.bundle_manager.*

internal import lottie.utils.helpers.*
internal import lottie.model.*
internal import lottie.parser.*

//internal import ohos.file_fs.*
internal import std.fs.*
internal import std.sync.*

@Entry
@Component
class MyView {
    @State
    var message: String = "Hello Cangjie"

    @State
    var animationDuration: String = "获取动画时长"
    @State
    var pauseState: String = "判断当前动画是否正在运行"
    @State
    var isCanvasVisible: Visibility = Visibility.Visible
    private var renderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.renderingSettings)

    private var mainRenderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var mainCanvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(
        this.mainRenderingSettings)

    private var navidadRenderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var navidadCanvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(
        this.navidadRenderingSettings)

    private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
    private var animateItem: Option<AnimationItem> = None //AnimationItem(animationManager)
    private var animateItem2: Option<AnimationItem> = None //AnimationItem(animationManager)
    private var animateItem3: Option<AnimationItem> = None //AnimationItem(animationManager)
    var sourceId: UInt32 = UInt32(@r(app.media.data).id)

    func build() {
        Column() {
            Row {
                Canvas(this.canvasRenderingContext).width(45.percent).height(20.percent).backgroundColor(Color.WHITE)
                Canvas(this.mainCanvasRenderingContext).width(45.percent).height(20.percent).backgroundColor(Color.WHITE)
            }
            Row {
                Button("加载2016-ui").onClick {
                    evt =>
                        spawn {
                            if (this.animateItem.isNone()) {
                                let ai: AnimationItem = lottie.loadAnimation(
                                    AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        loop: 1,
                                        autoplay: true,
                                        name: "2016",
                                        contentMode: "Contain",
                                        path: "data.json",
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    )
                                )
                                this.animateItem = ai
                            }
                        }
                }
                Button("加载牛").onClick {
                    evt =>
                        spawn {
                            if (this.animateItem2.isNone()) {
                                let ai: AnimationItem = lottie.loadAnimation(
                                    AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.mainCanvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        autoplay: true,
                                        name: "grunt",
                                        contentMode: "Contain",
                                        path: "grunt.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    )
                                )
                                this.animateItem2 = ai
                            }
                        }
                }
            }
            Row {
                Button("销毁2016").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.destroy(name: "2016")
                        }
                    this.animateItem = None
                }
                Button("销毁牛").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem2) {
                            v.destroy(name: "grunt")
                        }
                    this.animateItem2 = None
                }
            }
            Row {
                Canvas(this.navidadCanvasRenderingContext).width(45.percent).height(20.percent).backgroundColor(Color.WHITE)
            }
            Row {
                Button("加载navidad").onClick {
                    evt =>
                        spawn {
                            if (this.animateItem3.isNone()) {
                                let ai: AnimationItem = lottie.loadAnimation(
                                    AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.navidadCanvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        autoplay: true,
                                        name: "navidad",
                                        contentMode: "Contain",
                                        path: "navidad.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    )
                                )
                                this.animateItem3 = ai
                            }
                        }
                }

            }
            Row {
                Button("销毁navidad").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem3) {
                            v.destroy(name: "navidad")
                        }
                    this.animateItem3 = None
                }
            }
        }
    }
}
