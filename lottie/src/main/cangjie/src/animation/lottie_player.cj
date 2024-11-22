/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is LottiePlayer.
 */
package lottie.animation

/**
 * LottiePlayer组件提供动画加载与控制播放能力
 */
public open class LottiePlayer {

    //var animationManager: AnimationManager = AnimationManager()

    /**
     * 通过动画名称控制, 播放动画
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时播放所有动画
     */
    func play(name: String): Unit {}

    /**
     * 通过动画名称控制，暂停动画
     * @param name 被指定的动画名, 同loadAnimation接口入参name, 缺省时暂停所有动画
     */
    func pause(name: String): Unit {}

    /**
     * 通过动画名称控制，停止动画
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时停止所有动画
     */
    func stop(name: String): Unit {}

    /**
     * 通过动画名称控制，设置播放速度
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时设置所有动画速度
     * @param speed 值为浮点类型, speed>0正向播放, speed<0反向播放, speed=0暂停播放, speed=1.0/-1.0正常速度播放
     */
    func setSpeed(speed: Float64, name: String): Unit {}

    /**
     * 通过动画名称控制，设置播放方向
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时设置所有动画方向
     * @param direction 1为正向, -1为反向 当设置为反向时, 从当前播放进度开始回播直到首帧, loop值为true时可无限倒放, speed<0叠加时也是倒放
     */
    // 未实现 //func setDirection(direction: AnimationDirection, name: String): Unit {}

    /**
     * 通过动画名称控制，暂停或播放动画
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时停止所有动画
     */
    func togglePause(name: String): Unit {}

    /**
     * 加载动画, 须在组件完成布局后调用, 如可在点击事件回调中及Canvas组件的onReady()生命周期回调内调用
     * 页面退出时, 须与destory()配对使用
     * 目前支持canvas渲染方式, 支持传入json动画资源路径或json格式动画数据
     * 声明式范式下可配合组件生命周期onPageShow()使用, web范式下可配合生命周期onShow()使用
     * @param params 详见AnimationConfigWithPath或AnimationConfigWithData的声明
     * @return AnimationItem 动画对象, 可控制动画播放。
     */

    /**
     * 通过动画名称控制, 销毁动画 声明式范式下可配合组件生命周期onDisappear()与onPageHide()使用, web范式下可配合配合生命周期onHide()使用
     * @param name 被指定的动画名, 同loadAnimation接口参数name, 缺省时销毁所有动画
     */
    func destroy(name: String): Unit {}
}


