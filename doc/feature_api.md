# lottie4cj 特性文档

## 介绍

lottie4cj 是一个动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，并在移动设备上进行本地渲染。

### class AnimationItem

```cangjie
public class AnimationItem <: BaseEvent {

    /**
     * 播放动画
     * 参数 name - 被指定的动画名， 缺省默认为空
     */
    public func play(name!: String = ""): Unit

    /**
     * 停止动画
     * 参数 name - 被指定的动画名， 缺省默认为空
     */
    public func stop(name!: String = ""): Unit

    /**
     * 暂停动画
     * 参数 name - 被指定的动画名， 缺省默认为空
     */
    public func pause(name!: String = ""): Unit

    /**
     * 播放或暂停动画
     * 参数 name - 被指定的动画名， 缺省默认为空
     */
    public func togglePause(name!: String = ""): Unit

    /**
     * 销毁动画
     * 参数 name - 被指定的动画名， 缺省默认为空
     */
    public func destroy(name!: String = ""): Unit

    /**
     * 控制动画画面停止在某一帧或某个时刻，判断按帧还是按毫秒控制，true 按帧控制，false 按时间控制
     * 参数 value - 帧号(值>=0.0)或时刻(ms)
     * 参数 isFrame - true按帧控制， false按时间控制， 缺省默认false
     * 参数 name - 被指定的动画名， 可缺省默认为空
     */
    public func goToAndStop(value: Float64, isFrame!: Bool = false, name!: String = ""): Unit

    /**
     * 控制动画从某一帧或某一时刻开始播放，判断按帧还是按毫秒控制，true 按帧控制，false 按时间控制
     * 参数 value - 帧号(值>=0.0)或时刻(ms)
     * 参数 isFrame - true按帧控制， false按时间控制， 缺省默认false
     * 参数 name - 被指定的动画名， 可缺省默认为空
     */
    public func goToAndPlay(value: Float64, isFrame!: Bool = false, name!: String = ""): Unit

    /**
     * 限定动画资源播放时的整体帧范围。不可连续调用，再次调用时，需要先调用resetSegments。
     * 参数 initNum - 起始帧号
     * 参数 end - 结束帧号
     */
    public func setSegment(initNum: Float64, end: Float64): Unit

    /**
     * 设置仅播放指定范围的帧动画。不可连续调用，再次调用时，需要先调用resetSegments。
     * 参数 arr - 片段或片段数组，片段必须是长度为 2 的数组; 若传入的是数组， 且当前loop!=0， 播放结束后， 仅循环播放最后一个片段。
     * 参数 forceFlag - 值为true立刻生效， 值为false下次播放的时候生效。
     */
    public func playSegments(arr: Array<Array<Float64>>, forceFlag: Bool): Unit

    /**
     * 重置动画播放片段， 使动画重新从第一帧开始播放完整动画
     * 参数 forceFlag - 值为true立刻生效， 值为false下次播放的时候生效
     */
    public func resetSegments(forceFlag: Bool): Unit

    /**
     * 设置播放速度
     * 参数 val - 为Float64类型， val>0.0正向播放， val<0.0反向播放， val=0.0暂停播放， val=1.0/-1.0正常速度播放
     */
    public func setSpeed(val: Float64): Unit

    /**
     * 设置播放方向
     * 参数 val - 大于等于0为正向， 小于0为反向
     */
    public func setDirection(val: Int64): Unit

    /**
     * 获取动画单次完整播放的时间(与播放速度无关)或帧数
     * 参数 isFrame - 值为true时获取帧数， 值为false时获取时间(单位ms)
     * 返回值 Float64 - 动画单次完整播放的时间(与播放速度无关)或帧数
     */
    public func getDuration(isFrame: Bool): Float64

    /**
     * 添加侦听事件， 事件完成后会触发指定回调函数
     * 参数 eventName - 事件名称， 有效取值'enterFrame' | 'loopComplete' | 'complete' | 'segmentStart' | 'destroy' | 'config_ready' | 'data_ready' | 'DOMLoaded' | 'error' | 'data_failed' | 'loaded_images';
     * 参数 callback - 用户自定义回调函数封装的对象
     * 返回值 () -> Unit - 对应侦听事件的回调函数
     */
    public func addEventListener(eventName: String, callback: AnimationEventCallback): () -> Unit

    /**
     * 移除侦听事件
     * 参数 eventName - 事件名称， 有效取值'enterFrame' | 'loopComplete' | 'complete' | 'segmentStart' | 'destroy' | 'config_ready' | 'data_ready' | 'DOMLoaded' | 'error' | 'data_failed' | 'loaded_images';
     * 参数 callback - 用户自定义回调函数； 缺省为空时， 删除此事件的所有回调函数。
     * 参数 hascallback - 是否直接清除此事件名称对应的回调函数。
     */
    public func removeEventListener(eventName: String, callback: AnimationEventCallback, hascallback!: Bool = true): Unit

    /**
     * 修改整个动画的颜色
     * 参数 color - 颜色数组RGB值
     */
    public func changeColor(color: Array<Int64>): Unit
    
    /**
     * 修改该动画第 layer 层的颜色
     * 参数 color - 颜色数组RGB值
     * 参数 layer - 层次的下标值。
     */
    public func changeColor(color: Array<Int64>, layer: Int64): Unit

    /**
     * 修改该动画第 layer 层第 index 个元素的颜色
     * 参数 color - 颜色数组RGB值
     * 参数 layer - 层次的下标值
     * 参数 index - 对应层次里面的elements的下标值
     */
    public func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit

    /**
     * 动画填充模式，默认的填充模式是：Contain
     * 参数 contentMode - 模式：'Fill'，'Top'，'Bottom'，'Cover'，'Contain'
     */
    public func setContentMode(contentMode: String): Unit
    
}
```

### class AnimationManager

```cangjie
public class AnimationManager {
    
    /**
     * AnimationManager 构造器
     *
     * 参数 canvasRenderingContext - Canvas 组件 CanvasRenderingContext2D 对象
     */
    public init(canvasRenderingContext: CanvasRenderingContext2D)
    /**
     * 加载动画
     *
     * 参数 ac - AnimationConfig对象
     * 返回值 AnimationItem - 返回AnimationItem对象
     */
    public func loadAnimation(ac: AnimationConfig): AnimationItem

    /**
     * 播放动画
     * 参数 animationName - 被指定的动画名， 缺省默认为空
     */
    public func play(animationName!: String = ""): Unit

    /**
     * 停止动画
     * 参数 animationName - 被指定的动画名， 缺省默认为空
     */
    public func stop(animationName!: String = ""): Unit

    /**
     * 暂停动画
     * 参数 animationName - 被指定的动画名， 缺省默认为空
     */
    public func pause(animationName!: String = ""): Unit

    /**
     * 播放或暂停动画
     * 参数 animationName - 被指定的动画名， 缺省默认为空
     */
    public func togglePause(animationName!: String = ""): Unit

    /**
     * 设置播放速度
     * 参数 val - 为Float64类型， val>0.0正向播放， val<0.0反向播放， val=0.0暂停播放， val=1.0/-1.0正常速度播放
     */
    public func setSpeed(val: Float64): Unit

    /**
     * 设置播放方向
     * 参数 val - 大于等于0为正向， 小于0为反向
     */
    public func setDirection(val: Int64): Unit

    /**
     * 销毁动画
     * 参数 animationName - 被指定的动画名，缺省默认为空
     */
    public func destroy(animationName!: String = ""): Unit

    /**
     * 清除缓存。
     *
     * 参数 url - 清除指定本地动画中网络资源缓存文件，默认值为空。当 url 为空时，清除所有动画缓存文件。
     * 参数 container - 与 canvas 组件绑定的上下文 CanvasRenderingContext2D。用于获取本地资源路径的 json 文件，默认值为 None。
     */
    public func clearFileCache(url!: String = "", container!: Option<AbilityContext> = None): Unit

}
```

### class AnimationConfig

```cangjie
public class AnimationConfig {
    /**
     * 动画配置
     *
     * 参数 uri - 读取来自网络路径的动画数据，支持json和zip/gzip格式。gzip格式只能是单json文件压缩，且结尾为.tar.gz或者.gz。
     * 参数 isNetwork - true优先读取网络资源，false优先读取本地缓存资源
     * 参数 wrapper_ns - CreateNS对象
     * 参数 container - Canvas组件渲染对象
     * 参数 renderer - 渲染方式，当前仅支持canvas 渲染模式
     * 参数 loop - 是否循环播放，默认 -1。当前逻辑是：先完整播放一次，再按照设置的循环次数loop的值，进行对应次数的循环播放。实际播放的次数是：loop+1。
     * 参数 autoplay - 是否自动播放，默认true
     * 参数 name - 动画名称，控制动画的播放、暂停、销毁等功能，默认为“”
     * 参数 contentMode - 填充的模式，默认为“”，支持模式：'Fill'，'Top'，'Bottom'，'Cover'，'Contain'
     * 参数 imagePath - 读取路径只支持rawfile文件夹下的相对路径下的图片资源，默认为“”
     * 参数 path - 动画路径，路径加载动画只支持rawfile文件夹下的相对路径，默认为“”
     * 参数 pathSourceFrom - 区别json文件来源：1.来自entry/src/main/resources/rawfile/ 文件夹下的相对路径， 2.来自本地中保存的json。
     * 参数 animationData - json动画解析的对象，默认AnimationData(isNull: true)，其它构造方式参考AnimationDataParser
     * 参数 context - Ability所对应的context，默认Option<AbilityContext>.None
     */
    public init(
        uri!: String = "",
        isNetwork!: Bool = false,
        wrapper_ns!: CreateNS,
        container!: CanvasRenderingContext2D,
        renderer!: String = "canvas",
        loop!: Int64 = -1,
        autoplay!: Bool = true,
        name!: String = "",
        contentMode!: String = "",
        imagePath!: String = "",
        path!: String = "",
        pathSourceFrom!: Int8 = 1,
        animationData!: AnimationData = AnimationData(isNull: true),
        context!: Option<AbilityContext> = None
    )
}
```


### class AnimationDataParser

```cangjie
/**
 * 用于lottie json的解析器，它解析为AnimationData对象。
 */
public class AnimationDataParser {
    
    /**
     * 将动画的 json 数据，解析封装到 AnimationData 实例中。
     * 
     * 参数 reader - 动画的 json 数据字符串。
     * 返回值 AnimationData - 封装动画的 json 数据的实例。
     */
    public static func parse (reader: String): AnimationData

    /**
     * 将动画的 json 数据，解析封装到 AnimationData 实例中。
     * 
     * 参数 bas - 读取到的动画的 json 数据存储到 ByteBuffer 流中。
     * 返回值 AnimationData - 封装动画的 json 数据的实例。
     */
    public static func parse(bas: ByteBuffer): AnimationData
}
```

### 1.2 示例 

```cangjie
internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

import ohos.hilog.*

internal import lottie.animation.*
internal import lottie.utils.helpers.*
internal import lottie.model.*
internal import lottie.parser.*

@Entry
@Component
class LottieSample {
@State var isCanvasVisible: Visibility = Visibility.Visible
var settings: RenderingContextSettings = RenderingContextSettings(antialias: true)
var canvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)
private var lottie: AnimationManager = AnimationManager(this.canvasRenderingContext)
private var animateItem: Option<AnimationItem> = None

    protected override func onBackPress(): Bool {
        lottie.destroy(animationName: "2016")
        return false
    }

    func build() {
        Scroll() {
            Flex(
                FlexParams(direction: FlexDirection.Column, alignItems: ItemAlign.Center,
                justifyContent: FlexAlign.Center)) {
                Column() {
                    Row(10) {
                        Canvas(this.canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY)
                    }.backgroundColor(0xF0F0F0).justifyContent(FlexAlign.Center).width(100.percent)
                }.height(30.percent).width(100.percent)

                Scroll() {
                    Column() {
                        Row() {
                             Button("加载2016").onClick {
                                evt =>
                                if (this.animateItem.isNone()) {
                                     this.animateItem = lottie.loadAnimation(AnimationConfig(
                                        wrapper_ns: CreateNS("doc"),
                                        container: this.canvasRenderingContext,
                                        renderer: "canvas", // canvas 渲染模式
                                        autoplay: true,
                                        name: "2016",
                                        contentMode: "Contain",
                                        path: "data.json", 
                                        animationData: AnimationData(isNull: true),
                                        context: globalAbilityContext
                                    ))
                                }
                         }
                        }.margin(top: 5)

                        Row() {
                        }.margin(top: 5)
                        Row() {}.margin(top: 5)
                    }
                }.nestedScroll(NestedScrollOptions(NestedScrollMode.SELF_FIRST, NestedScrollMode.PARENT_FIRST)).
                    scrollBar(BarState.Off).height(75.percent)

            }
        }.scrollBar(BarState.Off).width(100.percent)
    }
}
```