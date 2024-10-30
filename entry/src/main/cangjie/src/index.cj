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

internal import ohos.file_fs.*
internal import std.sync.*

func parseAnimationData(filename: String): AnimationData {
    let buf: Array<Byte> = readFile(filename)
    let str: String = String.fromUtf8(buf)
    let data: AnimationData = AnimationDataParser.parse(str)
    return data
}

public func readFile(path: String): Array<Byte> {
    return readFileWithError(path, "FileUtils readFile Method has error, err msg=")
}

private func readFileWithError(path: String, err: String): Array<Byte> {
    var buf: Array<Byte> = Array<Byte>()
    let fd: Int32
    try {
        fd = FileFs.open(path, mode: READ_WRITE.mode).fd
    } catch (e: Exception) {
        ////Hilog.error(0, "", err + e.message)
        return buf
    }
    try {
        let len: Int64 = FileFs.stat(fd).size
        buf = Array<Byte>(len, item: 0)
        FileFs.read(fd, buf)
    } catch (e: Exception) {
        ////Hilog.error(0, "", err + e.message)
    } finally {
        FileFs.close(fd)
    }
    return buf
}

public func loadMedia(resId: Int32, context: Option<AbilityContext>): Array<UInt8> {
    if (let Some(v) <- context) {
        let stageContext = getStageContext(v)
        let rm: ResourceManager = ResourceManager.getResourceManager(stageContext)
        //        try {
        return rm.getMediaContent(resId, 0)
        //        } catch (e: Exception) {
        //            //Hilog.error(0, "", "[loadMedia]: getMediaContent failed, err msg=" + e.message)
        //            return Array<UInt8>()
        //        }
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

    private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
    private var animateItem: Option<AnimationItem> = None //AnimationItem(animationManager)
    private var animateItem2: Option<AnimationItem> = None //AnimationItem(animationManager)
//    private var animateName: String = "grunt"
//    private var animateItem2: String = "grunt"

    //var filePath: String = "/data/storage/el2/base/files/dengdaitu.gif"
    var sourceId: UInt32 = UInt32(@r(app.media.data).id)

    func build() {
        Column() {
            Canvas(this.canvasRenderingContext).width(100.percent).height(20.percent).backgroundColor(Color.WHITE).
                onReady({
                =>
            //                    this.animateItem?.resize()
            }).onDisAppear({
                =>
            // 组件移除时，可销毁动画资源
            //            lottie.destroy("2016")
            })
            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start)) {
                Row() {
                    Button("播放").onClick {
                        evt => //Hilog.error(0, "", "Hello Cangjie")
                        lottie.play("2016")
                    }.fontSize(40).height(80)
                }.margin(top: 10)

                Button("加载2016-ui").onClick {
                    evt => if (this.animateItem.isNone()) {
                        let buffer: Array<UInt8> = loadMedia(Int32(sourceId), globalAbilityContext)
                        let str: String = String.fromUtf8(buffer)
                        let animationData: AnimationData = AnimationDataParser.parse(str)
                        let ai: AnimationItem = lottie.loadAnimation(
                            AnimationConfig(
                                wrapper_ns: CreateNS("doc"),
                                container: this.canvasRenderingContext,
                                renderer: "canvas", // canvas 渲染模式
                                //                                        loop: TEUE,
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
                    } else {
                        println(123)
                    }
                }.fontSize(40).height(80)
            }.width(100.percent).height(10.percent)
            Canvas(this.mainCanvasRenderingContext).width(100.percent).height(20.percent).backgroundColor(Color.WHITE).
                onReady({
                =>
            //                    this.animateItem?.resize()
            }).onDisAppear({
                =>
            // 组件移除时，可销毁动画资源
            //            lottie.destroy("2016")
            })
            Flex(FlexParams(direction: FlexDirection.Row, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Start)) {
                Row() {
                    Button("播放").onClick {
                        evt => //Hilog.error(0, "", "Hello Cangjie")
                        lottie.play("2016")
                    }.fontSize(40).height(80)
                }.margin(top: 10)

                Button("加载牛").onClick {
                    evt => if (this.animateItem2.isNone()) {
                        let buffer: Array<UInt8> = loadMedia(Int32(@r(app.media.grunt).id), globalAbilityContext)
                        let str: String = String.fromUtf8(buffer)
                        let animationData: AnimationData = AnimationDataParser.parse(str)
                        let ai: AnimationItem = lottie.loadAnimation(
                            AnimationConfig(
                                wrapper_ns: CreateNS("doc"),
                                container: this.mainCanvasRenderingContext,
                                renderer: "canvas", // canvas 渲染模式
                                //                                        loop: TEUE,
                                autoplay: true,
                                name: "grunt",
                                contentMode: "Contain",
                                //path: "common/lottie/data.json", // 路径加载动画只支持entry/src/main/ets 文件夹下的相对路径
                                // path: "common/lottie/data_rawfile.json"
                                // path: "common/lottie/data_base64.json"
                                path: "",
                                animationData: animationData,
                                context: globalAbilityContext
                            )
                        )
                        this.animateItem2 = ai
                    } else {
                        println(123)
                    }
                }.fontSize(40).height(80)
            }.width(100.percent).height(10.percent)

}
    }
}
