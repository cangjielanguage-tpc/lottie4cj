/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is ProjectInterface.
 */
package lottie.utils.expressions


public class ProjectInterface {

    /* compositions 是从上一级传下来的。*/
    public var compositions: ArrayList<BaseElement> = ArrayList<BaseElement>(24)
    public var currentFrame: Float64 = 0.0
    
    public init(){ }

    /* comp数据类型：Expressions 中 animation.renderer/CompElement/各个元素类型的Element. */
    public func registerComposition(comp: BaseElement): Unit {
        this.compositions.append(comp)
    }

    public func thisProjectFunction(name: String): Option<CompExpressionInterface> {
        if (name == "") {
            return None
        }
        let len: Int64 = this.compositions.size
        for (i in 0..len) {
            if (this.compositions[i].data.nm == name) {
                if (this.compositions[i].data.xt) {
                    this.compositions[i].prepareFrame(this.currentFrame)
                }
            }
        }
        return None
    }

}
