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

func parseAnimationData(filename: String): AnimationData {
    let buf: Array<Byte> = readFile(filename)
    let str: String = String.fromUtf8(buf)
    let data: AnimationData = AnimationDataParser.parse(str)
    return data
}

public func readFile(path: String): Array<Byte> {
    return File.readFrom(path)
}

public func loadPath(src: String, context: Option<AbilityContext>): Array<UInt8> {
    //获取rawfile的字节数组数据
    if (let Some(v) <- context) {
        let stageContext = getStageContext(v)
        let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
        try {
            let buffer: Array<UInt8> = rm.getRawFileContent(src)
            return buffer
        } catch (e: Exception) {
            Hilog.error(0, "lipei", "begin------------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
        }
    }
    return Array<UInt8>()
}

public func loadMedia(resId: Int32, context: Option<AbilityContext>): Array<UInt8> {
    if (let Some(v) <- context) {
        let stageContext = getStageContext(v)
        let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
        return rm.getMediaContent(resId, 0)
    }
    ////Hilog.error(0, "", "[loadMedia]: the globalAbilityContext is None.")
    return Array<UInt8>()
}

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
//    private var animateName: String = "grunt"
//    private var animateItem2: String = "grunt"

    //var filePath: String = "/data/storage/el2/base/files/dengdaitu.gif"
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
                                let buffer: Array<UInt8> = loadMedia(Int32(sourceId), globalAbilityContext)
                                let str: String = String.fromUtf8(buffer)
                                let animationData: AnimationData = AnimationDataParser.parse(str)
                                let ai: AnimationItem = lottie.loadAnimation(
                                    AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        loop: 1,
                                        autoplay: true,
                                        name: "2016",
                                        contentMode: "Contain",
                                        //path: "common/lottie/data.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                        // path: "common/lottie/data_rawfile.json"
                                        // path: "common/lottie/data_base64.json"
                                        path: "",
                                        animationData: animationData,
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
                                        //                                        loop: TEUE,
                                        autoplay: true,
                                        name: "grunt",
                                        contentMode: "Contain",
                                        path: "common/lottie/grunt.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                        // path: "common/lottie/data_rawfile.json"
                                        // path: "common/lottie/data_base64.json"
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
                                        //                                        loop: TEUE,
                                        autoplay: true,
                                        name: "navidad",
                                        contentMode: "Contain",
                                        path: "common/lottie/navidad.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                        // path: "common/lottie/data_rawfile.json"
                                        // path: "common/lottie/data_base64.json"
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    )
                                )
                                this.animateItem3 = ai
                            }
                        }
                }

            }
        }
    }
}
