/**
 * Created on 2025/7/1
 */
package ohos_app_cangjie_entry

import ohos.state_manage.*
import ohos.state_macro_manage.*
import ohos.hybrid_base.HybridComponentBase
import ohos.component.*
import ohos.base.*
import lottie.utils.helpers.*
import lottie.model.*
import lottie.parser.*
import lottie.animation.*
import lottie.utils.globContext
import ohos.ark_interop_macro.Interop
import std.collection.HashMap
import ohos.ark_interop.*
import ohos.hilog.*
import ohos.ark_interop_helper.*
import ohos.ark_interop.*
import ohos.hybrid_base.CJPageEntry

var globCJLottieItem: ?CJLottieItem = None

@HybridComponentEntry
@Component
class CJLottieComp {
    var lottieItem: ?CJLottieItem = None

    public func aboutToAppear() {
        lottieItem = globCJLottieItem
    }

    private func getCanvasRenderingCtx(): CanvasRenderingContext2D {
        lottieItem.getOrThrow().canvasRenderingContext
    }

    public func build() {
        Column {
            Canvas(getCanvasRenderingCtx()).width(45.percent).height(200).backgroundColor(Color.GRAY).onReady(
                    {
                    =>
                }).onDisAppear({
                    =>
                })
        }.width(100.percent).height(30.percent)
    }
}

@Interop[ArkTS]
public class CJLottieItem {
    private let settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
    let canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(settings)
    private let manager: AnimationManager = AnimationManager(canvasRenderingContext)
    private var animationItem: ?AnimationItem = None

    public init() {
        globCJLottieItem = this
    }

    // 传递要加载的json文件名称和路径 pathType 区分工程目录=1/手机本地路径=2/网络下载=3 设置循环次数和是否自动播放
    public func setAnimationConfig(name: String, path: String, pathType: Int64, loop: Int64, autoPlay: Bool): Unit {
        animationItemDestory()
        if (pathType == 3) {
        	animationItem = manager.loadAnimation(
                AnimationConfig(
                    uri: path,
                    isNetwork: true,
                    wrapper_ns: CreateNS("doc"),
                    container: canvasRenderingContext,
                    name: name, // 加载 rawfile 下面的数据
                    contentMode: "Contain",
                    loop:loop,
                    autoplay:autoPlay,
                    animationData: AnimationData(isNull: true),
                    context: globContext
                )
            )
        } else {
            animationItem = manager.loadAnimation(
                AnimationConfig(
                    wrapper_ns: CreateNS("doc"),
                    container: canvasRenderingContext,
                    name: name, // 加载 rawfile 下面的数据
                    contentMode: "Contain",
                    path: path,
                    animationData: AnimationData(isNull: true),
                    context: globContext
                )
            )
        }

    }

    // 操作-开始播放
    public func playAnimation(lottieName: String): Unit {
        manager.play()
    }

    // 操作-暂停播放
    public func pauseAnimation(lottieName: String): Unit {
        manager.pause()
    }

    // 操作-停止播放
    public func stopAnimation(lottieName: String): Unit {
        manager.stop()
    }

    // 操作-销毁
    public func destroyAnimation(lottieName: String): Unit {
        animationItemDestory()
    }

    // 操作-跳转指定位置并停止
    public func goAndStopAnimation(value: Float64, isFrame: Bool, lottieName: String): Unit {
        if (let Some(item) <- this.animationItem) {
            item.goToAndStop(value, isFrame: isFrame, name: lottieName)
        }
    }
    
    func animationItemDestory() {
    	if (!animationItem.isNone()){
            animationItem.getOrThrow().destroy()
            animationItem = None
    	}
    }
}