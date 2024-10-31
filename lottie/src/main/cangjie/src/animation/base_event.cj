/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseEvent.
 */
package lottie.animation

//取值类型：AnimationEventName = 'enterFrame' | 'loopComplete' | 'complete' | 'segmentStart' | 'destroy' | 'DOMLoaded'
public open class BaseEvent <: BMEvent {

    /*
     * TODO: 未确定 this._cbs 的 value 中的数据类型。
     * TODO: 没法直接比较 2 个函数，需要包装成 2 个 Object，用 refEq 进行比较。 
     * (T) -> Unit 包装成 AnimationEventCallback，调用的时候调用 AnimationEventCallback.callback
     */
    public var _cbs: HashMap<String, ArrayList<AnimationEventCallback>> = HashMap<String, ArrayList<AnimationEventCallback>>(24)

    public init(){
        super("")
    }

    //TODO：未确认参数 args 的数据类型。
    public func triggerEvent(eventName: String, args: BMEvent): Unit {
        if (this._cbs.size > 0) {
            if (this._cbs.contains(eventName)) {
                //TODO: 未确定 this._cbs 的 value 中的数据类型。
                let callbacks: ArrayList<AnimationEventCallback> = this._cbs[eventName]
                for (i in 0..callbacks.size) {
                    callbacks[i].callback(args)
                }
            }
        }
    }
    
    public func addEventListener(eventName: String, callback: AnimationEventCallback): () -> Unit {
        var view = this._cbs.entryView(eventName)
        if (let Some(v) <- view.getValue()) {
            v
        } else {
            let arr = ArrayList<AnimationEventCallback>()
            view.setValue(arr)
            arr
        }.append(callback)

        return { => this.removeEventListener(eventName, callback) }
    }
    
    public func removeEventListener(eventName: String, callback: AnimationEventCallback, hascallback!: Bool = true): Unit {
        if (this._cbs.size <= 0) {
            return
        }
        var callbacks: ArrayList<AnimationEventCallback> = ArrayList<AnimationEventCallback>()
        var hasEventName: Bool = false
        if (this._cbs.contains(eventName)) {
            hasEventName = true
            callbacks = this._cbs[eventName]
        }
        if (!hascallback) {
            callbacks.clear()
        } else if (hasEventName) {
            if (hasEventName) {
                var i: Int64 = 0
                if (hasEventName) {
                    var len: Int64 = callbacks.size
                    while (i < len) {
                        //TODO: 没法直接比较 2 个函数，需要包装成 2 个 Object，用 refEq 进行比较。refEq(Object, Object)：判断两个 Object 实例的内存地址是否相同。
                        if (refEq(callbacks[i], callback)) {
                            //splice: 从数组中添加或删除元素。--此处是删除--删除下标 i 处元素
                            callbacks.remove(i)

                            i -= 1
                            len -= 1
                        }
                        i += 1
                    }
                    if (callbacks.size == 0) {
                        callbacks.clear()
                    }
                }
            }
        }
    }

}
