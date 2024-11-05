/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

import ohos.hilog.*

@Entry
@Component
class LottieSample2D {

    var settings18: RenderingContextSettings = RenderingContextSettings(antialias: true)
    var context: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings18)

    func build() {
        Scroll() {
            Flex(
                FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center)) {
                Column() {
                    Row(10) {
                        Canvas(this.context).width(100.percent).height(100.percent).backgroundColor(Color.GRAY).onReady(
                            {
                                =>
                                this.context.beginPath()
                                this.context.lineWidth(6)
                                this.context.strokeStyle(Color.GREEN)
                                this.context.moveTo(15, 80)
                                this.context.lineTo(280, 160)
                                this.context.stroke()

                                //this.context.setTransform(0.264, -0.007559, 0.0079, 0.2244, 59.4932, 78.7684)//1.85
                                this.context.setTransform(0.264, 0.0079, -0.007559, 0.2244, 59.4932, 78.7684)//1.85
                                this.context.beginPath()
                                this.context.lineWidth(6)
                                this.context.strokeStyle(Color.GREEN)
                                this.context.moveTo(15, 80)
                                this.context.lineTo(280, 160)
                                this.context.stroke()

                                //this.context.setTransform(0.2652, -0.04401, 0.05034, 0.2064, 50.8984, 85.765869)//5.45
                                this.context.setTransform(0.2652, 0.05034, -0.04401, 0.2064, 50.8984, 85.765869)//5.45
                                this.context.beginPath()
                                this.context.lineWidth(6)
                                this.context.strokeStyle(Color.GREEN)
                                this.context.moveTo(15, 80)
                                this.context.lineTo(280, 160)
                                this.context.stroke()

                                //this.context.setTransform(0.26351, -0.0664, 0.08484, 0.1836566, 44.98, 92.16397)//11.45
                                this.context.setTransform(0.26351, 0.08484, -0.0664, 0.1836566, 44.98, 92.16397)//11.45
                                this.context.beginPath()
                                this.context.lineWidth(6)
                                this.context.strokeStyle(Color.GREEN)
                                this.context.moveTo(15, 80)
                                this.context.lineTo(280, 160)
                                this.context.stroke()

                                //this.context.setTransform(0.2406775802373886, -0.0003507829096633941, 0.0003204679524060339, 0.2344648540019989, 62.2708854675293, 76.20721435546875)//20.52
                                this.context.setTransform(0.2406775802373886, 0.0003204679524060339, -0.0003507829096633941, 0.2344648540019989, 62.2708854675293, 76.20721435546875)//20.52
                                this.context.beginPath()
                                this.context.lineWidth(6)
                                this.context.strokeStyle(Color.GREEN)
                                this.context.moveTo(15, 80)
                                this.context.lineTo(280, 160)
                                this.context.stroke()

                            }
                        )
                    }.backgroundColor(0xF0F0F0).justifyContent(FlexAlign.Center).width(100.percent)
                }.height(30.percent).width(100.percent)
            }
        }.scrollBar(BarState.Off).width(100.percent)
    }
}
