/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements

internal import lottie4cj.model.*

internal import std.collection.ArrayList

/*
 * @file
 * Handles AE's layer parenting property.
 * 处理AE的层父子属性。
 */
/*
 * 初始化后需要传入1个函数：
 * 1. comp.buildElementParenting    => 传入 comp 中的这个函数；
 * cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
 */
public open class HierarchyElement <: FrameElement {

    //TODO: finalTransform 从 TransformElement 移到 HierarchyElement 中。
    //TODO: 和 global_data\global_data.cj 中 FinalTransform 冲突了。
    public var finalTransform: FinalTransform2

    //元素的父列表
    //TODO: hierarchy 中装的是某种元素类型，暂定为父类 HierarchyElement？？？ 还是TransformElement(TransformElement中编译用到)？？？
    public var hierarchy: ArrayList<HierarchyElement> = ArrayList<HierarchyElement>()
    public var data: Layer

    public var buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit = {m,n,o => ()}
    //TODO：编译用 BaseRenderer.getElementByPath 中用到。
    //TODO：BaseRenderer.elements 数据类型是 BaseElement/BaseRenderer ？？？
    //TODO：需要后续再确认 BaseRenderer.elements 中的数据类型。
    public var getElementByPathInt64: (Array<Int64>) -> Option<BaseElement> = { m => None }
    public var getElementByPathString: (Array<String>) -> Option<BaseElement> = { m => None }

    public init(data: Layer, globalData: GlobalData) {
        this.globalData = globalData
        this.data = data

        let tp: TransformProperty = TransformProperty(this.data.ks, globalData, data)
        this.finalTransform = FinalTransform2(mProp: tp)
    }

    public func initHierarchy() {
        //元素的父列表
        this.hierarchy = ArrayList<HierarchyElement>()
        //如果元素是另一层的父元素_isPparent将为true
        this._isParent = false
        this.checkParenting()
    }

    /**
     * @function
     * Sets layer's hierarchy.  设置层的层次结构。
     * @param {array} hierarch
     * layer's parent list  层的父列表
     */
    public func setHierarchy(hierarchy: ArrayList<HierarchyElement>): Unit {
        this.hierarchy = hierarchy
    }

    /**
     * @function
     * Sets layer as parent.
     * 将层设置为父层。
     */
    public func setAsParent(): Unit {
        this._isParent = true
    }

    /**
     * @function
     * Searches layer's parenting chain
     * 搜索层的父链
     */
    public func checkParenting(): Unit {
        if (this.data.parent != -1) {
            let be: BaseElement = this.changeToBaseElement()
            this.buildElementParentingInComp(be, this.data.parent, ArrayList<BaseElement>())
        }
    }
    
    // 把当前对象转为 BaseElement。
    func changeToBaseElement(): BaseElement {
        let be: BaseElement = BaseElement(this.data, this.globalData)
        be._isFirstFrame = this._isFirstFrame
        be.dynamicProperties = this.dynamicProperties
        be._mdf = this._mdf
        be._isParent = this._isParent
        be.globalData = this.globalData
        be.data = this.data
        be.finalTransform = this.finalTransform
        be.hierarchy = this.hierarchy
        be.buildElementParentingInComp = this.buildElementParentingInComp
        be.getElementByPathInt64 = this.getElementByPathInt64
        be.getElementByPathString = this.getElementByPathString
        return be
    }
    
}
