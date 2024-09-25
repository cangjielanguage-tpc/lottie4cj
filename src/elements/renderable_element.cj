/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is RenderableElement.
 */
package lottie4cj.elements

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
public open class RenderableElement <: TransformElement {

    //层的可见性与内点和外点有关。将isVisible重命名为isInRange
    public var isInRange: Bool = false
    //层的显示状态
    public var hidden: Bool = false
    //如果层的透明度等于0，则可以将其隐藏
    public var isTransparent: Bool = false
    
    //动画组件列表
    //TODO: component: CVEffects/SVGEffects/MaskElement/CVMaskElement，数据类型暂未确认，暂定为 RenderableElement。
    public var renderableComponents: ArrayList<RenderableElement> = ArrayList<RenderableElement>()

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }
    
    //TODO: 编译用。实际实现在后续子类中。
    public open func renderFrame(): Unit {}
    public open func renderFrame(_isFirstFrame: Bool): Unit {}
    public open func hide(): Unit {}
    public open func show(): Unit {}

    public func initRenderable(): Unit {
        this.isInRange = false
        this.hidden = false
        this.isTransparent = false
        this.renderableComponents.clear()
    }
    
    //TODO: component: CVEffects/SVGEffects/MaskElement/CVMaskElement，数据类型暂未确认，暂定为 RenderableElement。
    public func addRenderableComponent(component: RenderableElement): Unit {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (rc in this.renderableComponents) {
            if (refEq(rc, component)) {
                return
            }
        }
        this.renderableComponents.append(component)
    }
    
    public func removeRenderableComponent(component: RenderableElement) {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (i in (this.renderableComponents.size-1)..=0:-1) {
            let rc = this.renderableComponents[i]
            if (refEq(rc, component)) {
                this.renderableComponents.remove(i)
            }
        }
    }
    
    public func prepareRenderableFrame(num: Float64): Unit {
        this.checkLayerLimits(num)
    }
    
    public func checkTransparency(): Unit {
        if (this.finalTransform.mProp.o.v[0] <= 0.0) {
            if (!this.isTransparent && this.globalData.renderConfig.hideOnTransparent) {
                this.isTransparent = true
                this.hide()
            }
        } else if (this.isTransparent) {
            this.isTransparent = false
            this.show()
        }
    }

    /**
     * @function
     * 初始化与帧相关的属性。
     *
     * @param {number} num
     * current frame number in Layer's time   //层时间中的当前帧数
     */
    public func checkLayerLimits(num: Float64): Unit {
        if (this.data.ip - this.data.st <= num && this.data.op - this.data.st > num) {
            if (!this.isInRange) {
                this.globalData._mdf = true
                this._mdf = true
                this.isInRange = true
                this.show()
            }
        } else if (this.isInRange) {
            this.globalData._mdf = true
            this.isInRange = false
            this.hide()
        }
    }
    
    public func renderRenderable(): Unit {
        let len: Int64 = this.renderableComponents.size
        for (i in 0..len) {
            //调用具体子类的 renderFrame 函数
            this.renderableComponents[i].renderFrame(this._isFirstFrame)
        }
    }
    
    public open func sourceRectAtTime(): SourceRect {
        return SourceRect(top: 0, left: 0, width: 100, height: 100)
    }
    
    public func getLayerSize(): Size {
        if (this.data.ty == 5) {
            return Size(width: this.data.textData.width, height: this.data.textData.height)
        }
        return Size(width: this.data.width, height: this.data.height)
    }

}
