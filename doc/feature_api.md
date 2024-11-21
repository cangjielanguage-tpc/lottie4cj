# lottie4cj 特性文档

## 介绍

lottie是一个动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，并在移动设备上进行本地渲染。

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
     * 销毁动画
     *
     * @param name 动画名称
     * 
     */
    public func destroy(name: String): Unit 
}
```

### class AnimationConfig

```cangjie
public class AnimationConfig {
    /**
     * 动画配置
     *
     * @param wrapper_ns  CreateNS对象
     * @param container  Canvas组件渲染对象
     * @param renderer  渲染模式,默认为“canvas”
     * @param loop  是否循环播放，默认 -1
     * @param autoplay  是否自动播放，默认true
     * @param name  动画名称,默认为“”
     * @param contentMode  填充的模式,默认为“”
     * @param path  动画路径，路径加载动画只支持raw文件夹下的相对路径,默认为“”
     * @param animationData  json动画解析的对象，默认AnimationData()
     * @param context  Ability所对应的context，默认Option<AbilityContext>.None
     */
    public init(
        wrapper_ns!: CreateNS,
        container!: CanvasRenderingContext2D,
        renderer!: String = "canvas",
        loop!: Int64 = -1,
        autoplay!: Bool = true,
        name!: String = "",
        contentMode!: String = "",
        path!: String = "",
        animationData!: AnimationData = AnimationData(),
        context!: Option<AbilityContext> = None
    ){
        this.wrapper_ns = wrapper_ns
        this.wrapper = LottieCanvasRenderingContext2D(container)

        this.container = LottieCanvasRenderingContext2D(container)
        this.renderer = renderer
        this.loop = loop
        this.autoplay = autoplay
        this.name = name
        this.contentMode = contentMode
        this.path = path

        this.animationData = animationData
        this.context = context
    }
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