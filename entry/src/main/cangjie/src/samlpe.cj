/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.hilog.*

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
    private var animateName: String = "AnimationItem_Destroy_11"

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
                                Hilog.error(0, "lipei", "begin------------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
                                lottie.destroy("2016")
                                if (this.animateItem.isNone()) {
                                     this.animateItem = lottie.loadAnimation(AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        loop: -1,
                                        autoplay: true,
                                        name: this.animateName,
                                        contentMode: "Contain",
                                        //imagePath: "./images/",                 // 加载读取指定路径下的图片资源
                                        //path: "json_lottie/non_img/animation_008.json",
                                        //path: "json_lottie/banner.json",
                                        //path: "json_lottie/non_img/gatin.json", //帧率:25p/m 总帧数:80p
                                        //path: "datas2.json",  //周围点点缺失
                                        //path: "datas.json",  //周围点点缺失
                                        path: "data.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        //path: "/data/storage/el1/bundle/entry/resources/base/media/data.json",
                                        //path: "/data/storage/el2/base/files/entry/data.json",
                                        //pathSourceFrom: 2, //区别json文件来源：1.来自\resources\rawfile\， 2.来自手机中保存的json。（不填默认 1）
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                         }
                         Button("销毁--2016").onClick {
                             evt =>
                             this.animateItem.getOrThrow().destroy("")
                             this.animateItem = Option<AnimationItem>.None
                         }
                        }.margin(top: 5)


                        Row() {
                            Button("加载--网络zip").onClick {
                                evt =>
                                lottie.destroy("lf20_sF7uci.json")
                                Hilog.error(0, "lipei", "加载--网络json------------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
                                if (this.animateItem2.isNone()) {
                                     this.animateItem2 = lottie.loadAnimation(AnimationConfig(
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/1a8533870915012cf63396b40f8efdc4f5945af8/data.json",
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/cc299f5f461652e529bf576a2efc316982da4c83/animation_008.gzip",
                                        uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/cc299f5f461652e529bf576a2efc316982da4c83/animation_008.gz",
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/c7a064f35b4b31ef359f490863ec96be8d10191a/redbag.gz",
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/8142eb1b796d7db4e47db3d981c8cacc840b5eea/redbag.gz",
                                        //uri: "https://raw.gitcode.com/lipeifsxz/testlottie/blobs/36460c771d1471bab72f5a1afb19f39fb2c3a715/json2.zip",
                                        //uri: "https://gitcode.com/user-attachments/files/3804992/298424de7aba41d0bb35d5fa72b22bdb.zip",
                                        //uri: "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json",
                                        //uri: "https://smarthome-drcn.dbankcdn.com/device/guide/KW38/template/lottie/lottie.zip",
                                        isNetwork: true,
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.mainCanvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        //loop: true,
                                        autoplay: true,
                                        name: "lf20_sF7uci.json",
                                        contentMode: "Contain",
                                        path: "", // 路径加载动画只支持raw文件夹下的相对路径
                                        //path: "grunt.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                            }
                            Button("销毁--网络zip").onClick {
                                evt =>
                                this.animateItem2.getOrThrow().destroy("")
                                this.animateItem2 = Option<AnimationItem>.None
                            }
                        }.margin(top: 5)



                        Row() {
                            Button("侯召用例测试").onClick { evt =>

                                //测试 setSegment
                                if (!this.animateItem.isNone()) {
                                    let num1 = 20.0
                                    let num2 = this.animateItem.getOrThrow().getDuration(true)
                                    Hilog.error(0, "lipei", "begin----------------------------------setContentMode, num1 = ${num1}")
                                    Hilog.error(0, "lipei", "begin----------------------------------setContentMode, num2 = ${num2}")
                                    this.animateItem.getOrThrow().setSegment(num1, num2)
                                    //this.animateItem.getOrThrow().playSegments([[5.0, 15.0], [20.0, 30.0]], true)
                                    //this.animateItem.getOrThrow().setContentMode("Bottom")
                                }

                                //测试跳转播放
                                //if (!this.animateItem.isNone()) {
                                //    let num = 250.0
                                //    let falg = true
                                //    Hilog.error(0, "lipei", "begin----------------------------------goToAndStop, num = ${num}")
                                //    Hilog.error(0, "lipei", "begin----------------------------------goToAndStop, falg = ${falg}")
                                //    this.animateItem.getOrThrow().goToAndPlay(num, falg, this.animateName)
                                //    //this.animateItem.getOrThrow().goToAndPlay("1200ms", false, this.animateName)
                                //}

                                //测试跳转暂停
                                //if (!this.animateItem.isNone()) {
                                //    let num = 250.0
                                //    let falg = true
                                //    Hilog.error(0, "lipei", "begin----------------------------------goToAndStop, num = ${num}")
                                //    Hilog.error(0, "lipei", "begin----------------------------------goToAndStop, falg = ${falg}")
                                //    this.animateItem.getOrThrow().goToAndStop(num, falg, this.animateName)
                                //    //this.animateItem.getOrThrow().goToAndStop("1200ms", false, this.animateName)
                                //}


                                //测试播放
                                //if (!this.animateItem.isNone()) {
                                //    this.animateItem.getOrThrow().setDirection(1)//正向播放
                                //    this.animateItem.getOrThrow().play(name:this.animateName)
                                //}
                                //测试修改颜色
                                //if (!this.animateItem.isNone()) {
                                //    Hilog.error(0, "lipei", "begin----------------------------------changeColor([255,25, 232],[51,229, 135],0,0)")
                                //    this.animateItem.getOrThrow().changeColor([255,25, 232],[51,229, 135],0,0)
                                //    //this.animateItem.getOrThrow().changeColor([255, 203])
                                //    //this.animateItem.getOrThrow().changeColor([255, 25, 232],[51, 229, 135])
                                //}
                            }
                            Button("改变颜色").onClick {
                                evt =>

                                //测试 setSegment
                                if (!this.animateItem.isNone()) {
                                    let num1 = 20.0
                                    let num2 = 30.0
                                    Hilog.error(0, "lipei", "begin----------------------------------setSegment, num1 = ${num1}")
                                    Hilog.error(0, "lipei", "begin----------------------------------setSegment, num2 = ${num2}")
                                    //this.animateItem.getOrThrow().setSegment(num1, num2)
                                    this.animateItem.getOrThrow().playSegments([num1, num2], true)
                                }

                                //if (!this.animateItem.isNone()) {
                                //    this.animateItem.getOrThrow().destroy(this.animateName)
                                //    this.animateItem = None
                                //    Hilog.error(0, "lipei", "begin----------------------------------destroy, this.animateName = ${this.animateName}")
                                //    //this.animateItem.getOrThrow().changeColor([255, 203],[], 0, 0)
                                //    //this.animateItem.getOrThrow().changeColor([255,150,203],[], 0, 0)
                                //    this.animateItem.getOrThrow().changeColor([255,150,203],[51,229,135], 0, 0)
                                //    //this.animateItem.getOrThrow().changeColor([51,229,135],[])
                                //}
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
