/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*


@Entry
@Component
class LottieSample2 {
    var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)
    private var manager: AnimationManager = AnimationManager(this.canvasRenderingContext)
    private var caseName: String = "Test_Lottie_04"
    private var animateName: String = "Test_Lottie_04"

    protected func aboutToAppear():Unit{
        Hilog.error(0, "lipei", "aboutToAppear------4------times = ${SystemDateTime.getCurrentTime(isNano: true)}")
        this.manager.loadAnimation(this.cfg)
    }


    func build() {
        Scroll() {
            Flex(FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center)) {
                Column() {
                    Text(caseName).width(80.percent).height(20).textAlign(TextAlign.Start).margin(top:10,bottom:10,left:0)
                    Row(10) {
                        Canvas(this.canvasRenderingContext).width(60.percent).height(200).padding(left:20.0).alignSelf(ItemAlign.Center).backgroundColor(0xF4F2D9)

                    }.backgroundColor(0xF0F0F0).justifyContent(FlexAlign.Center).width(100.percent)

                }.height(30.percent).width(100.percent).margin(top:20)

                Column() {
                    Button("togglePause").onClick {
                        manager.togglePause(this.animateName)
                    }.margin(top:40)
                }
            }
        }.scrollBar(BarState.Off).width(100.percent)
    }
/*
    let cfg:AnimationConfig = AnimationConfig(
                                uri: "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json",//可达的网络链接,json不含图片资源
                                isNetwork: true,
                                wrapper_ns: CreateNS("doc"),
                                container: this.canvasRenderingContext,
                                renderer: "canvas",
                                loop: -1,
                                autoplay: true,
                                name: this.animateName,
                                contentMode: "Contain",
//                                imagePath: "",
//                                path: "",
//                                pathSourceFrom: 1,//1.来自entry/src/main/resources/rawfile/ 文件夹下的相对路径， 2.来自本地中保存的json
//                                animationData: AnimationData(isNull: true),
                                context: globalAbilityContext
                            )*/

    let cfg:AnimationConfig = AnimationConfig(
                                        uri: "https://assets7.lottiefiles.com/packages/lf20_sF7uci.json",
                                        isNetwork: true,
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        //loop: true,
                                        autoplay: true,
                                        name: "lf20_sF7uci.json",
                                        contentMode: "Contain",
                                        path: "", // 路径加载动画只支持raw文件夹下的相对路径
                                        //path: "grunt.json", // 路径加载动画只支持raw文件夹下的相对路径
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    )


}
