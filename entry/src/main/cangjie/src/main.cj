/**
 * Created on 2025/1/3
 */
package ohos_app_cangjie_entry

import ohos.router.Router
import ohos.component.Row
import ohos.component.Button
import ohos.component.Text
import ohos.component.Flex
import ohos.component.CustomView
import ohos.component.FlexParams
import ohos.component.FlexDirection
import ohos.component.ItemAlign
import ohos.component.FlexAlign
import ohos.component.FontWeight
import ohos.component.TextOverflow
import ohos.component.BorderStyle
import ohos.component.loadNativeView
import ohos.component.CJEntry
import ohos.base.LengthProp
import ohos.base.Color
import ohos.state_macro_manage.Entry
import ohos.state_macro_manage.Component
import ohos.state_macro_manage.State
import ohos.state_macro_manage.r
import ohos.state_manage.ObservedProperty
import ohos.state_manage.SubscriberManager
import ohos.component.Alignment
internal import ohos.state_manage.LocalStorage
@Entry
@Component
class Mains {
    func build() {
        Flex( FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start )) {
          Button("LottieSample")
            .size( width: 300, height: 36)
            .margin( top: 20, right: 6, bottom: 0, left: 6 )
            .fontColor(Color.WHITE)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(0x00a6ff)
            .borderWidth(1)
            .borderColor(0x28c989)
            .borderRadius(2)
            .borderStyle(BorderStyle.Solid)
            .onClick({ =>
              Router.push(url: "LottieSample")
            })
        Button("MyView")
            .size( width: 300, height: 36)
            .margin( top: 20, right: 6, bottom: 0, left: 6 )
            .fontColor(Color.WHITE)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(0x00a6ff)
            .borderWidth(1)
            .borderColor(0x28c989)
            .borderRadius(2)
            .borderStyle(BorderStyle.Solid)
            .onClick({ =>
              Router.push(url: "MyView")
            })

        Button("MyView1")
            .size( width: 300, height: 36)
            .margin( top: 20, right: 6, bottom: 0, left: 6 )
            .fontColor(Color.WHITE)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(0x00a6ff)
            .borderWidth(1)
            .borderColor(0x28c989)
            .borderRadius(2)
            .borderStyle(BorderStyle.Solid)
            .onClick({ =>
              Router.push(url: "MyView1")
            })
        Button("LottieSample2")
            .size( width: 300, height: 36)
            .margin( top: 20, right: 6, bottom: 0, left: 6 )
            .fontColor(Color.WHITE)
            .fontSize(14)
            .fontWeight(FontWeight.Bold)
            .backgroundColor(0x00a6ff)
            .borderWidth(1)
            .borderColor(0x28c989)
            .borderRadius(2)
            .borderStyle(BorderStyle.Solid)
            .onClick({ =>
              Router.push(url: "LottieSample2")
            })
        }
        .width(100.percent)
        .height(100.percent)
    }

}