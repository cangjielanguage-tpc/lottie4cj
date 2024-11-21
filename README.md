<div align="center">
<h1>lottie4cj</h1>
</div>

<p align="center">
<img alt="" src="https://img.shields.io/badge/release-v0.0.1-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/build-pass-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjc-v0.53.13-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/cjcov-91.9%25-brightgreen" style="display: inline-block;" />
<img alt="" src="https://img.shields.io/badge/project-open-brightgreen" style="display: inline-block;" />
</p>

## 介绍

lottie4cj是一个动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，并在移动设备上进行本地渲染。

### 特性

- 🚀 支持播放动画

## 软件架构

### 架构图

<p align="center">
<img src="./doc/assets/lottie.png" width="100%" >
</p>

### 源码目录

```shell
/lottie4cj                   # 项目根目录
├── doc                      #文档目录
│   ├── assets               #文档资源目录
│   └── feature_api.md       #API接口文档
├── entry                    # 示例代码文件夹
├── lottie                   # lottie库文件夹
│    └─ src/main/cangjie/src # 核心代码，包含json解析，动画绘制，操作动画                  
├── README.md                # 安装使用方法      
```

### 接口说明

主要类和函数接口说明详见 [API](./doc/feature_api.md)


## 使用说明

前提：数据准备

lottie动画文件是由设计人员使用Adobe After Effects软件通过bodymovin插件导出json格式的文件。

AE软件创建动画时需要设置动画的宽(w)、高(h)、bodymovin插件的版本号(v)、帧率(fr)、开始帧(ip)、
结束帧(op)、静态资源信息(assets)、图层信息(layers)等重要信息。

如果仅是用于demo测试，可以使用[工程示例中的json文件](https://gitcode.com/Cangjie-TPC/lottie4cj/tree/develop/entry/src/main/resources/rawfile) 。

1.在相应的类中引入组件：

```
internal import lottie.animation.*
internal import lottie.utils.helpers.*
internal import lottie.model.*
```

2.构建渲染上下文

```
var mainRenderingSettings: RenderingContextSettings = RenderingContextSettings(antialias: true)
var mainCanvasRenderingContext: CanvasRenderingContext2D = CanvasRenderingContext2D(this.settings)
```

3.將动画需要的json文件放到resources/rawfile目录下，然后引用。(json路径为entry/src/main/resources/rawfile/data.json)


注意：json文件路径不能使用 ./ 或者 ../ 等相对路径，相对路径获取不到动画源数据，会导致动画加载不出来,

传递给loadAnimation 方法的路径是相对于resources/rawfile文件夹为基准的。

```
  let path: String = "data.json"
  或
  let jsonData: String = {"v":"4.6.6","fr":24,"ip":0,"op":72,"w":1000,"h":1000,"nm":"Comp 2","ddd":0,"assets":[],...}
  let animationData: AnimationData = AnimationDataParser.parse(jsonData)
```

4.关联画布

```
Canvas(this.canvasRenderingContext).width(45.percent).height(200).backgroundColor(Color.GRAY)
.onReady({ =>
    //抗锯齿的设置
    this.mainCanvasRenderingContext.imageSmoothingEnabled(true)
    this.mainCanvasRenderingContext.imageSmoothingQuality(QualityType.Medium)
})
```
注意：canvas设置的宽高比例建议和动画json资源里面的宽高比例一致，如：json动画资源里的宽高比例是 1:2 ，则canvas设置的宽高也是 1:2
- 想要的抗锯齿效果：mainCanvasRenderingContext.imageSmoothingEnabled(true) 与 mainCanvasRenderingContext.imageSmoothingQuality(QualityType.Medium)

- 动画绘制前会对canvas画布进行清空处理，画布清空后再绘制动画。

5.加载动画

- 加载动画的时机需要注意，点击按钮加载动画可按照正常逻辑放在点击事件内，如果想要实现进入页面自动播放动画，需要结合Canvas组件的onReady()生命回调周期实现，加载动画时机需放置在onReady()生命周期回调内或及之后。
- 同一Canvas组件加载多次/不同动画资源，需要手动销毁动画(lottie.destroy('name'))，之后才可再次加载其他动画资源。
```      
    lottie.destroy("2016") //加载动画前先销毁之前加载的动画
    this.animateItem = lottie.loadAnimation(AnimationConfig(
        container: this.canvasRenderingContext,           // 渲染上下文
        renderer: "canvas",                               // canvas 渲染模式
        loop: -1,                                         // 是否循环播放,默认 -1 循环。
        autoplay: true,                                   // 是否自动播放，默认true
        name: "2016",                                     // 动画名称
        contentMode: "Contain",                           // 填充的模式
        path: "data.json",                                // 路径加载动画只支持raw文件夹下的相对路径
        animationData: AnimationData(isNull: true),       // json动画解析的对象
        context: globalAbilityContext
    ))
    或      
    this.animateItem = lottie.loadAnimation(AnimationConfig(
        container: this.canvasRenderingContext,           // 渲染上下文
        renderer: "canvas",                               // canvas 渲染模式
        loop: 1,                                          // 是否循环播放,默认 -1 循环。
        autoplay: true,                                   // 是否自动播放，默认true
        name: "2016",                                     // 动画名称
        contentMode: "Contain",                           // 填充的模式
        path: "",                                         // 路径加载动画只支持raw文件夹下的相对路径
        animationData: animationData,                     // json动画解析的对象
        context: globalAbilityContext
    ))
```

- 加载动画时，path 参数和 animationData 参数，二者选其一。
- path 参数：只支持加载entry/src/main/resources/rawfile/ 文件夹下的相对路径，不支持跨包查找文件。
- animationData 参数：可结合ResourceManager进行读取资源文件内容进行设置，调用AnimationDataParser.parse 进行解析。
- 加载外部资源图片：应用默认读取rawfile下的对应资源图片

6.控制动画

- 播放动画

  ```
  animationItem.play() //当前指定animationItem动画播放
  ```

### 功能示例
#### 动画json数据解析 功能示例

功能示例描述:      
加载动画json文件，进行动画播放。

示例代码如下：

```cangjie
package ohos_app_cangjie_entry

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

执行结果如下：

```shell
动画正常播放
```

## 约束与限制
在下述版本验证通过：

    DevEco Studio NEXT Developer Beta2(5.0.3.906) 
    Cangjie Support Plugin 5.0.3.906
    Cangjie Compiler: 0.53.13 (cjnative)

## 开源协议
本项目基于 [The MIT License](./LICENSE)，请自由的享受和参与开源。

## 参与贡献

欢迎给我们提交PR，欢迎给我们提交Issue，欢迎参与任何形式的贡献。
