# lottie4cj 特性文档

## 介绍

lottie是一个动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，并在移动设备上进行本地渲染。

### class AnimationItem

```cangjie
public class AnimationItem <: BaseEvent {

    /**
     * 播放动画
     * 参数 name - 被指定的动画名, 缺省默认为空
     */
    public func play(name!: String = ""): Unit

    /**
     * 停止动画
     * 参数 name - 被指定的动画名, 缺省默认为空
     */
    public func stop(name: String): Unit

    /**
     * 暂停动画
     * 参数 name - 被指定的动画名, 缺省默认为空
     */
    public func pause(name!: String = ""): Unit

    /**
     * 播放或暂停动画
     * 参数 name - 被指定的动画名, 缺省默认为空
     */
    public func togglePause(name: String): Unit

    /**
     * 销毁动画
     * 参数 name - 被指定的动画名, 缺省默认为空
     */
    public func destroy(name: String): Unit

    /**
     * 控制动画画面停止在某一帧或某个时刻
     * 参数 value - 帧号(值>=0)或时刻(ms)
     * 参数 isFrame - true按帧控制, false按时间控制, 缺省默认false
     * 参数 name - 被指定的动画名, 可缺省默认为空
     */
    public func goToAndStop(value: Float64, isFrame: Bool, name: String): Unit

    /**
     * 控制动画画面从在某一帧或某个时刻开始播放
     * 参数 value - 帧号(值>=0)或时刻(ms)
     * 参数 isFrame - true按帧控制, false按时间控制, 缺省默认false
     * 参数 name - 被指定的动画名, 可缺省默认为空
     */
    public func goToAndPlay(value: Float64, isFrame: Bool, name: String): Unit

    /**
     * 限定动画资源播放时的整体帧范围
     * 参数 initNum - 起始帧号
     * 参数 iend - 结束帧号
     */
    public func setSegment(initNum: Float64, end: Float64): Unit

    /**
     * 设置仅播放指定范围的帧动画
     * 参数 arr - 片段或片段数组; 若传入的是数组, 且当前loop!=0, 播放结束后, 仅循环播放最后一个片段
     * 参数 forceFlag - 值为true立刻生效, 值为false循环下次播放的时候生效
     */
    public func playSegments(arr: Array<Array<Float64>>, forceFlag: Bool): Unit

    /**
     * 重置动画播放片段, 使动画重新从第一帧开始播放完整动画
     * 参数 forceFlag - 值为true立刻生效, 值为false循环下次播放的时候生效
     */
    public func resetSegments(forceFlag: Bool): Unit

    /**
     * 设置播放速度
     * 参数 val - speed 值为浮点类型, speed>0正向播放, speed<0反向播放, speed=0暂停播放, speed=1.0/-1.0正常速度播放
     */
    public func setSpeed(val: Float64): Unit

    /**
     * 设置播放方向
     * 参数 val - 1为正向, -1为反向
     */
    public func setDirection(val: Int64): Unit

    /**
     * 获取动画单次完整播放的时间(与播放速度无关)或帧数, 与Lottie.loadAnimation接口入参initialSegment有关
     * 参数 isFrame - 值为true时获取帧数, 值为false时获取时间(单位ms)
     * 返回值 Float64 - 动画单次完整播放的时间(与播放速度无关)或帧数
     */
    public func getDuration(isFrame: Bool): Float64

    /**
     * 添加侦听事件, 事件完成后会触发指定回调函数
     * 参数 eventName - 事件名称, 有效范围见AnimationEventName声明
     * 参数 callback - 用户自定义回调函数封装的对象
     * 返回值 () -> Unit - 对应的删除侦听事件
     */
    public func addEventListener(eventName: String, callback: AnimationEventCallback): () -> Unit

    /**
     * 添删除侦听事件
     * 参数 eventName - 事件名称, 有效范围见AnimationEventName声明
     * 参数 callback - 用户自定义回调函数； 缺省为空时, 删除此事件的所有回调函数。
     * 参数 hascallback - 是否直接清除此事件名称对应的回调函数。
     */
    public func removeEventListener(eventName: String, callback: AnimationEventCallback, hascallback!: Bool = true): Unit

    /**
     * 修改整个动画的颜色
     * 参数 color - 颜色数组RGBA
     */
    public func changeColor(color: Array<Int64>): Unit
    
    /**
     * 修改该动画第 layer 层的颜色
     * 参数 color - 颜色数组RGBA
     * 参数 layer - 层次的下标值。当 layer 参数值为 0 时，等同于调用 changeColor(color: Array<Int64>)。
     */
    public func changeColor(color: Array<Int64>, layer: Int64): Unit

    /**
     * 修改该动画第 layer 层第 index 个元素的颜色
     * 参数 color - 颜色数组RGBA
     * 参数 layer - 层次的下标值。当 layer 参数值为 0 时，等同于调用 changeColor(color: Array<Int64>)。
     * 参数 inde - 对应层次里面的elements的下标值
     */
    public func changeColor(color: Array<Int64>, layer: Int64, index: Int64): Unit

    /**
     * 修改整个动画的颜色
     * 参数 startColor - 开始颜色数组RGBA
     * 参数 endColor - 结束颜色数组RGBA
     */
     public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>)

    /**
     * 修改该动画第 layer 层的颜色
     * 参数 startColor - 开始颜色数组RGBA
     * 参数 endColor - 结束颜色数组RGBA
     * 参数 layer - 层次的下标值。当 layer 参数值为 0 时，等同于调用 changeColor(startColor: Array<Int64>, endColor: Array<Int64>)。
     */
     public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>, layer: Int64)

    /**
     * 修改该动画第 layer 层第 index 个元素的颜色
     * 参数 startColor - 开始颜色数组RGBA
     * 参数 endColor - 结束颜色数组RGBA
     * 参数 layer - 层次的下标值。当 layer 参数值为 0 时，等同于调用 changeColor(startColor: Array<Int64>, endColor: Array<Int64>)。
     * 参数 inde - 对应层次里面的elements的下标值
     */
     public func changeColor(startColor: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64)

    /**
     * 动画填充模式，默认的填充模式是：Contain
     * 参数 contentMode - 模式：'Fill','Top','Bottom','Cover','Contain'
     */
    public func setContentMode(contentMode: String): Unit

    /**
     * 设置当前动画的播放帧率不超过该值，范围1~120。
     * 当动画源帧率高于该值时，该动画的播放帧率会被强制降到该值，否则默认以动画源帧率进行播放，除非另有全局设置；
     * 可通过设置0帧率来取消该限制。
     * 参数 playingFrameRate - 播放帧率
     *
     * 备注：暂不支持此功能
     */
    public func setFrameRate(playingFrameRate: Float64): Unit
}
```

### class AnimationManager

```cangjie
public class AnimationManager {
    
    /**
     * AnimationManager 构造器
     *
     * @param canvasRenderingContext Canvas组件CanvasRenderingContext2D对象
     */
    public init(canvasRenderingContext: CanvasRenderingContext2D)
    /**
     * 加载动画
     *
     * @param ac AnimationConfig对象
     * @return AnimationItem 返回AnimationItem对象
     */
    public func loadAnimation(ac: AnimationConfig): AnimationItem

    /**
     * 播放动画
     * 参数 animationName - 被指定的动画名, 缺省默认为空
     */
    public func play(animationName!: String = ""): Unit

    /**
     * 停止动画
     * 参数 animationName - 被指定的动画名, 缺省默认为空
     */
    public func stop(animationName: String): Unit

    /**
     * 暂停动画
     * 参数 animationName - 被指定的动画名, 缺省默认为空
     */
    public func pause(animationName!: String = ""): Unit

    /**
     * 播放或暂停动画
     * 参数 animationName - 被指定的动画名, 缺省默认为空
     */
    public func togglePause(animationName: String): Unit

    /**
     * 设置播放速度
     * 参数 val - speed 值为浮点类型, speed>0正向播放, speed<0反向播放, speed=0暂停播放, speed=1.0/-1.0正常速度播放
     */
    public func setSpeed(val: Float64): Unit

    /**
     * 设置播放方向
     * 参数 val - 1为正向, -1为反向
     */
    public func setDirection(val: Int64): Unit

    /**
     * 销毁动画
     * 参数 animationName - 被指定的动画名, 缺省默认为空
     */
    public func destroy(animationName: String): Unit

    /**
     * 清除缓存
     *
     * @param ac 具体动画被清除缓存的地址
     * @param container 与canvas组件绑定的上下文CanvasRenderingContext2D,用于本地资源路径json文件
     */
    public func clearFileCache(url: String, container: Option<AbilityContext>): Unit

}
```

### class AnimationConfig

```cangjie
public class AnimationConfig {
    /**
     * 动画配置
     *
     * @param uri  读取来自网络路径的动画数据，支持json和zip/gzip格式
     * @param isNetwork  true优先读取网络资源,false优先读取本地缓存资源
     * @param wrapper_ns  CreateNS对象
     * @param container  Canvas组件渲染对象
     * @param renderer  渲染模式,默认为“canvas”
     * @param loop  是否循环播放，默认 -1
     * @param autoplay  是否自动播放，默认true
     * @param name  动画名称,默认为“”
     * @param contentMode  填充的模式,默认为“”
     * @param imagePath  读取指定路径下的图片资源,默认为“”
     * @param path  动画路径，路径加载动画只支持raw文件夹下的相对路径,默认为“”
     * @param pathSourceFrom  区别json文件来源：1.来自entry/src/main/resources/rawfile/ 文件夹下的相对路径， 2.来自本地中保存的json。
     * @param animationData  json动画解析的对象，默认AnimationData()
     * @param context  Ability所对应的context，默认Option<AbilityContext>.None
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
                                        path: "data.json", // 路径加载动画只支持raw文件夹下的相对路径
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