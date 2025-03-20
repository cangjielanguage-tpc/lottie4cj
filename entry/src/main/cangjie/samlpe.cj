/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.hilog.*

@Entry
@Component
class LottieSample {
    @State var isCanvasVisible: Visibility = Visibility.Visible
    var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)
    var mainRenderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var mainCanvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)
    private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
    private var animateItem: Option<AnimationItem> = None
    private var animateItem2:Option<AnimationItem> = None
    private var animateName: String = "AnimationItem_Destroy_11"

    protected override func onBackPress(): Bool {
        lottie.destroy()
        return false
    }

    func build() {
        Scroll() {
            Flex(
                FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center)) {
                Column() {
                    Row(10) {
                        Canvas(this.canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).
                            onReady({ =>
                        }).onDisAppear({=>
                        })

                        Canvas(this.mainCanvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).
                            onReady({ =>
                            Hilog.error(0, "", "2-Canvas is onReady")
                            this.mainCanvasRenderingContext.imageSmoothingEnabled(true)
                            this.mainCanvasRenderingContext.imageSmoothingQuality(QualityType.Medium)
                        }).onDisAppear({=>
                            Hilog.error(0, "", "2-Canvas is destroy")
                        }).visibility(this.isCanvasVisible).onVisibleAreaChange(
                            [0.0],
                            {
                                isVisible, currentRatio => if (isVisible) {
                                    Hilog.error(0, "", "2-Canvas Visible")
                                } else {
                                    Hilog.error(0, "", "2-Canvas is not visible")
                                }
                            }
                        )

                    }.backgroundColor(0xF0F0F0).justifyContent(FlexAlign.Center).width(100.percent)

                    Row() {
//                        Text()

                    }.backgroundColor(0xF0F0F0).justifyContent(FlexAlign.Center).width(100.percent)

                }.height(30.percent).width(100.percent)

                Scroll() {
                    Column() {

                        Row() {
                            Button("加载2016-3").onClick {
                                evt =>
                                Hilog.error(0, "lipei", "begin------------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
                                if (!this.animateItem.isNone()) {
                                    this.animateItem.getOrThrow().destroy()
                                    this.animateItem = Option<AnimationItem>.None
                                }
                                if (this.animateItem.isNone()) {
                                    this.animateItem = lottie.loadAnimation(AnimationConfig(
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/c1c81ce5ef299171dc0a214ab8cc883a92d55773/animation_008.json",
                                        isNetwork: true,
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        loop: -1,
                                        autoplay: true,
                                        name: this.animateName,
                                        contentMode: "Contain",
                                        path: "data.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                         }
                         Button("销毁").onClick {
                             evt =>
                                if (let Some(v) <- this.animateItem) {
                                    v.destroy()
                                    this.animateItem = Option<AnimationItem>.None
                                }
                            }
                         Button("暂停").onClick {
                             evt =>
                                if (let Some(v) <- this.animateItem) {
                                    v.pause() //当前指定animationItem动画暂停
                                }
                            }
                         Button("播放").onClick {
                             evt =>
                                if (let Some(v) <- this.animateItem) {
                                    v.play() //当前指定animationItem动画播放
                                }
                            }
                        }.margin(top: 5)


                        Row() {
                            Button("加载--网络zip").onClick {
                                evt =>
                                Hilog.error(0, "lipei", "加载--网络json------------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
                                if (!this.animateItem2.isNone()) {
                                    this.animateItem2.getOrThrow().destroy()
                                    this.animateItem2 = Option<AnimationItem>.None
                                }
                                if (this.animateItem2.isNone()) {
                                    this.animateItem2 = lottie.loadAnimation(AnimationConfig(
                                        uri: "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json",
                                        isNetwork: true,
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.mainCanvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        autoplay: true,
                                        name: "lf20_sF7uci.json",
                                        contentMode: "Contain",
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                            }
                            Button("销毁--网络zip").onClick {
                                evt =>
                                if (let Some(v) <- this.animateItem2) {
                                    v.destroy()
                                    this.animateItem2 = Option<AnimationItem>.None
                                }
                            }
                        }.margin(top: 5)


                        Row() {
                            Button("clearFileCache").onClick {
                                lottie.clearFileCache(url: "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json", container: globalAbilityContext)
                            }.margin(top:40)
                        }.margin(top: 5)
                        Row() {
                            Button("togglePause---2016").onClick {
                                this.animateItem.getOrThrow().togglePause(name: this.animateName)
                            }.margin(top:40)
                        }.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                        Row() {}.margin(top: 5)
                    }
                }.nestedScroll(NestedScrollOptions(NestedScrollMode.SELF_FIRST, NestedScrollMode.PARENT_FIRST)).
                    scrollBar(BarState.Off).height(75.percent)

            }
        }.scrollBar(BarState.Off).width(100.percent)
    }
}
