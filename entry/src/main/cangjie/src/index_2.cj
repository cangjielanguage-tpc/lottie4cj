/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package ohos_app_cangjie_entry

/*
import ohos.base.*
import ohos.component.*
import ohos.animator.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

@Entry
@Component
class MyView {
    var backAnimator: ?AnimatorResult = None
    var flag = false
    @State var wid = 100.0
    @State var hei = 100.0

    func build() {

        Column {
            Column()
                .width(this.wid)
                .height(this.wid)
                .backgroundColor(Color.RED)

            Button("create")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick {
                    this.backAnimator = AnimatorResult(AnimatorOptions(
                          duration: 5000,
                          easing: "ease",
                          delay: 0,
                          fill: AnimatorFill.Both,
                          direction: AnimatorDirection.AlternateReverse,
                          iterations: -1,
                          begin: -100.0,
                          end: 200.0
                        ))
                    this.backAnimator?.onframe = { value: Float64  =>
                                                        AppLog.info("onframe called ${value}")
                                                        this.wid = value
                                                        this.hei = value }
                    this.backAnimator?.oncancel = { => AppLog.info("oncancel called") }
                    this.backAnimator?.onrepeat = { => AppLog.info("onrepeat called") }
                    this.backAnimator?.onfinish = { => AppLog.info("onfinish called") }
                    var callBackGet = this.backAnimator?.onfinish
                    var fun = callBackGet.getOrThrow()
                    fun()
                    callBackGet = this.backAnimator?.onrepeat
                    fun = callBackGet.getOrThrow()
                    fun()
                    callBackGet = this.backAnimator?.oncancel
                    fun = callBackGet.getOrThrow()
                    fun()
                    let callBackGet2 = this.backAnimator?.onframe
                    let fun2 = callBackGet2.getOrThrow()
                    fun2(333.0)
                }

            Button("play")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick {
                    this.flag = false
                    this.backAnimator?.play()
                }
            Button("pause")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick {
                    this.flag = false
                    this.backAnimator?.pause()
                }
            Button("cancel")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick {
                    this.flag = false
                    this.backAnimator?.cancel()
                }
            Button("reverse")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick {
                    this.flag = false
                    this.backAnimator?.reverse()
                }
            Button("finish")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick{
                    this.flag = true
                    this.backAnimator?.finish()
                }

            Button("reset")
                .fontSize(30)
                .fontColor(Color.BLACK)
                .onClick{
                    if (this.flag) {
                        this.flag = false
                        this.backAnimator?.reset(AnimatorOptions(
                            duration: 6000,
                            easing: "linear-out-slow-in",
                            delay: 0,
                            fill: AnimatorFill.Forwards,
                            direction: AnimatorDirection.Reverse,
                            iterations: 1,
                            begin: 200.0,
                            end: 400.0
                            ))
                     } else {
                        AppLog.info("Animation not ended")
                     }
                }
        }
    }
}
*/
