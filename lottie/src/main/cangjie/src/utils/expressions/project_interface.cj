/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is ProjectInterface.
 */
package lottie.utils.expressions
//package lottie.elements

internal import std.collection.ArrayList

public class ProjectInterface {

    //TODO: ProjectInterface 和 BaseElement 互相引用。
    //TODO: compositions 是从上一级传下来的。
    public var compositions: ArrayList<BaseElement> = ArrayList<BaseElement>(24)
    public var currentFrame: Float64 = 0.0
    
    public init(){ }

    //comp数据类型：Expressions 中 animation.renderer/CompElement/各个元素类型的Element
    public func registerComposition(comp: BaseElement): Unit {
        this.compositions.append(comp)
    }

    public func thisProjectFunction(name: String): Option<CompExpressionInterface> {
        if (name == "") {
            return None
        }
        let len: Int64 = this.compositions.size
        for (i in 0..len) {
            //TODO:增加 this.compositions[i].data = Layer 为空的判断。
            //if (this.compositions[i].data && this.compositions[i].data.nm == name) 
            if (this.compositions[i].data.nm == name) {
                //TODO:增加 this.compositions[i].prepareFrame 函数为空的判断。
                if (this.compositions[i].data.xt) {
                    this.compositions[i].prepareFrame(this.currentFrame)
                }
                //TODO: BaseElement 中暂未实现成员变量 compInterface。
                //return this.compositions[i].compInterface
            }
        }
        return None
    }

}
