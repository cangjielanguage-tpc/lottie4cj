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

internal import std.sync.*
import ohos.prompt_action.*
@Entry
@Component
class MyView1 {
    @State
    var animateName: String = "2016"
    @State var appleVisible: Visibility = Visibility.Visible
    @State
    var animationDuration: String = "获取动画时长"
    @State
    var pauseState: String = "判断当前动画是否正在运行"
    @State
    var isCanvasVisible: Visibility = Visibility.Visible
    private var renderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    private var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.renderingSettings)

    private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
    private var animateItem: Option<AnimationItem> = None //AnimationItem(animationManager)
    func build() {
        Column() {
            Row {
                Canvas(this.canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).visibility(this.appleVisible)
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
                                        autoplay: true,
                                        name: this.animateName,
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

            }
            Row() {
                Button("播放").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.play()
                        }
                }
                Button("暂停").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.pause()
                        }
                }
                Button("销毁").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.destroy(name: "2016")
                        }
                    this.animateItem = None
                }
            }
            Row() {
                Button("Fill").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setContentMode("Fill")
                        }
                }
                Button("Cover").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setContentMode("Cover")
                        }
                }
                Button("Top").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setContentMode("Top")
                        }
                }
                Button("Bottom").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setContentMode("Bottom")
                        }
                }
                Button("Contain").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setContentMode("Contain")
                        }
                }

            }.margin(top: 5 )
            Row() {
                Button("结束，并回到第0帧").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.stop(name: "2016")
                        }
                }
                Button("切换暂停").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.togglePause(name: "2016")
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("跳到某一帧并停止").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.goToAndStop(250.0, isFrame: true)
                        }
                }
                Button("跳到某一秒并停止").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.goToAndStop(5000.0, isFrame: false)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("跳到某一帧并播放").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.goToAndPlay(250.0, isFrame: true)
                        }
                }
                Button("跳到某一秒并播放").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.goToAndPlay(12000.0, isFrame: false)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("设置片段:5-15帧").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setSegment(5.0, 15.0)
                        }
                }
                Button("设置片段:20-30帧").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setSegment(20.0, 30.0)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("播放5-15帧和20-30帧").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.playSegments([[5.0, 15.0], [20.0, 30.0]],true)
                        }
                }
                Button("重置动画").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.resetSegments(false)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button(this.animationDuration).onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            this.animationDuration = "获取动画时长" + "${v.getDuration(false)} s"
                        }
                }
                Button(this.pauseState).onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            this.pauseState = "是否暂停：" + "${v.isPaused}"
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("隐藏").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.pause(name: this.animateName)
                        }
                        this.appleVisible = Visibility.Hidden
                }
                Button("显示").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.play(name: this.animateName)
                        }
                        this.appleVisible = Visibility.Visible
                }
                Button("动态更改颜色").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.changeColor([255, 203],Array<Int64>(),0,0)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("添加监听").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.addEventListener("loopComplete",AnimationEventCallback(removeElement))
                        }
                }
                Button("移除监听").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.removeEventListener("loopComplete",AnimationEventCallback(removeElement))
                        }
                }
                Button("播放速度6").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setSpeed(6.0)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("播放速度1").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setSpeed(1.0)
                        }
                }
                Button("播放速度-1").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setSpeed(-1.0)
                        }
                }
                Button("正向播放").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setDirection(1)
                        }
                }
              }.margin(top: 5 )
            Row() {
                Button("反向播放").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setDirection(-1)
                        }
                }
                Button("设置动画刷帧率").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            v.setFrameRate(1.0)
                        }
                }
                Button("清除文件缓存").onClick{
                    evt =>
                        if (let Some(v) <- this.animateItem) {
                            lottie.clearFileCache()
                        }
                }
              }.margin(top: 5 )
        }
    }
}

public func removeElement(ev2: Option<BMEvent>): Unit {
    Hilog.error(0, "cwl", "2016 loopComplete")
    PromptAction.showToast(message:"2016 loopComplete")
}
