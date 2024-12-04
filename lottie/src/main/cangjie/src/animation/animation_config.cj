/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is AnimationConfig.
 */
package lottie.animation

import ohos.base.*
import ohos.component.*
import ohos.state_manage.*
import ohos.state_macro_manage.*

/**
 * 动画事件回调函数声明
 */
public class AnimationEventCallback {
    public var callback: (Option<BMEvent>) -> Unit
    public init(callback: (Option<BMEvent>) -> Unit){
        this.callback = callback
    }
}


public class AnimationConfig {
    /**
     * 与canvas组件绑定的上下文CanvasRenderingContext2D, 提供最基础的绘制渲染能力
     */
    //要挂载动画的DOM对象
    public var container: LottieCanvasRenderingContext2D
    public var wrapper: LottieCanvasRenderingContext2D
    public var wrapper_ns: CreateNS = CreateNS("")

    /**
     * 渲染类型, 目前支持canvas方式
     */
    public var renderer: String = ""
    public var animType: String = ""

    /**
     * 动画播放结束后, 是否循环播放，默认值true, 值为true时无限循环播放 值类型为number, 且>=1时为设置重复播放的次数
     * 定为 Int64 数据类型，-1 表示true，-2 表示false。
     */
    public var loop: Int64 = 0

    /**
     * 自动播放设置
     */
    public var autoplay: Bool = false

    /**
     * 初始化动画资源播放时的整体帧范围
     * 动画片段声明 AnimationSegment = [number, number] => Array<Float64>，其中的数据含义：time,...
     */
    public var initialSegment: Array<Float64> = Array<Float64>()

    /**
     * 动画名称, 动画成功加载后, 可在Lottie相关接口上, 应用该名称进行动画控制
     */
    public var name: String = ""

    /**
     * 应用包名 用于打印日志区分不同模块调用启动aniamtor，packageName可以不传
     */
    public var packageName: String = ""

    /**
     * 动画填充模式 支持填充模式：Fill, Top, Cover, Buttom, Contain  默认模式是：Contain
     */
    public var contentMode: String = ""

    public var rendererSettings: RenderConfig = RenderConfig()
    public var autoloadSegments: Bool = true
    public var assetsPath: String = ""
    public var audioFactory: (String) -> Audio = { m => return Audio() }
    // hasAudioFactory 表示 audioFactory 是否有实际代码逻辑。
    public var hasAudioFactory: Bool = false

    /**
     * json格式的动画数据, 仅限json格式.
     */
    public var animationData: AnimationData = AnimationData(isNull: true)

    /**
     * 读取指定路径下的图片资源
     * @since 8
     * @design
     */
     public var imagePath: String = ""

    /**
     * 应用内的动画数据文件路径, 仅限json格式
     * path 路径仅支持entry/src/main/ets 路径下的相对路径，不支持跨包路径设置
     * @example path: 'common/lottie/data.json'
     */
    public var path: String = ""
    //区别json文件来源：1.来自\resources\rawfile\， 2.来自手机中保存的json。
    public var pathSourceFrom: Int8 = 1

    /**
     * 读取来自网络路径的动画数据，支持json和zip格式
     */
    public var uri: String = ""
    /**
     * true优先读取网络资源,false优先读取本地缓存资源
     */
    public var isNetwork: Bool = false


    var context: Option<AbilityContext> = None

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
    ){
        this.uri = uri
        this.isNetwork = isNetwork
        this.wrapper_ns = wrapper_ns
        this.wrapper = LottieCanvasRenderingContext2D(container)

        this.container = LottieCanvasRenderingContext2D(container)
        this.renderer = renderer
        this.loop = loop
        this.autoplay = autoplay
        this.name = name
        this.contentMode = contentMode
        this.imagePath = imagePath
        this.path = path
        this.pathSourceFrom = pathSourceFrom

        this.animationData = animationData
        this.context = context
    }

}
