/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

import ohos.hilog.*

internal import ohos.image.Image as MultiImage
internal import ohos.image.Component as ImageComponent
internal import ohos.image.PixelMap
internal import ohos.image.createImageSource
internal import ohos.image.DecodingOptions
internal import ohos.image.Size
internal import ohos.image.PixelMapFormat
internal import ohos.image.Region
internal import ohos.image.ImageInfo
internal import ohos.image.InitializationOptions
internal import ohos.image.createPixelMap

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
    private var animateName: String = "grunt"

    var fId: UInt32 = UInt32(@r(app.media.img_0).id)

    protected override func onBackPress(): Bool {
        lottie.destroy("")
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
                        //                    this.animateItem?.resize()
                        }).onDisAppear({=>
                            // 组件移除时，可销毁动画资源
                            //            lottie.destroy("2016")
                        })

                        Canvas(this.mainCanvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY).
                            onReady({ =>
                            this.mainCanvasRenderingContext.imageSmoothingEnabled(true)
                            this.mainCanvasRenderingContext.imageSmoothingQuality(QualityType.Medium)
                        //                    this.animateItem?.resize()
                        }).onDisAppear({=>
                            // 组件移除时，可销毁动画资源
                            lottie.destroy(this.animateName)
                        }).visibility(this.isCanvasVisible).onVisibleAreaChange(
                            [0.0],
                            {
                                isVisible, currentRatio => if (isVisible) {
                                    Hilog.info(0, "", "Canvas Visible")
                                // this.animateItem?.play()
                                } else {
                                    Hilog.info(0, "", "Canvas is not visible")
                                    // this.animateItem?.pause() //在画布不可见时尝试暂停动画
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
                            Button("加载2016").onClick {
                                evt =>
                                //lottie.destroy("phonemoney")
                                if (this.animateItem.isNone()) {
                                     this.animateItem = lottie.loadAnimation(AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        //loop: true,
                                        autoplay: true,
                                        name: "2016",
                                        contentMode: "Contain",
                                        path: "data.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                         }
                        }.margin(top: 5)

                        Row() {
                            Button("加载phonemony").onClick {
                                evt =>
                                //lottie.destroy("phonemoney")
                                if (this.animateItem2.isNone()) {
                                     this.animateItem2 = lottie.loadAnimation(AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.mainCanvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        //loop: true,
                                        autoplay: true,
                                        name: "phonemoney",
                                        contentMode: "Contain",
                                        path: "phonemoney/phonemoney.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                            }
                        }.margin(top: 5)
                        Row() {
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
                        Row() {}.margin(top: 5)
                    }
                }.nestedScroll(NestedScrollOptions(NestedScrollMode.SELF_FIRST, NestedScrollMode.PARENT_FIRST)).
                    scrollBar(BarState.Off).height(75.percent)

            }
        }.scrollBar(BarState.Off).width(100.percent)
    }
}
