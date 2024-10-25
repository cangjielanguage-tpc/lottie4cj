/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.elements

internal import ohos.base.*
internal import ohos.component.*
internal import ohos.state_manage.*
import ohos.state_macro_manage.*

internal import ohos.hilog.*

internal import lottie.elements.helpers.*

internal import lottie.inner.*
internal import lottie.utils.*
internal import lottie.utils.helpers.*


internal import std.collection.*
internal import lottie.global_data.*
internal import lottie.property.*


internal import ohos.hilog.*
internal import lottie.model.*
internal import std.collection.ArrayList


internal import lottie.bezier.*


internal import lottie.utils.helpers.*

public func emptyCreateItem(layer: Layer): BaseElement {
    return BaseElement(Layer(), GlobalData(), isNull: true)
}


public var operationsMap: HashMap<Int64, String> = HashMap<Int64, String>([
    (1, "source-in"),
    (2, "source-out"),
    (3, "source-in"),
    (4, "source-out")

])

public class FinalTransform {

    public var mProp: TransformProperty
    var _matMdf: Bool
    var _opMdf: Bool
    public var mat: Matrix
    public var isNull: Bool = false

    public init(isNull!: Bool, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        this.mProp = TransformProperty(isNull: true, dynamicProperties: dynamicProperties)
        this._matMdf = false
        this._opMdf = false
        this.mat = Matrix()
        this.isNull = isNull
    }

    public init(mProp!: TransformProperty,
        _matMdf!: Bool = false,
        _opMdf!: Bool = false,
        mat!: Matrix = Matrix(),
        isNull!: Bool = false
    ) {
        this.mProp = mProp
        this._matMdf = false
        this._opMdf = false
        this.mat = Matrix()
        this.isNull = isNull
    }
}

public type RenderableElement = BaseElement
public type HierarchyElement = BaseElement

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
//TODO: 暂时先将 CvBaseElement 和 BaseElement 合并。避免后面 CVXXXElement 多继承 XXXElement和 CVBaseElement
public open class BaseElement <: Equatable<BaseElement> {

//FrameElement-1-----------------------------------------------------------------------------
    /* 渲染inpoint时设置为true */
    public var _isFirstFrame: Bool = false

    //TODO: 此处的 dynamicProperties 中数据类型是哪种？  TextProperty  /  PropertyFactory，暂定是 PropertyFactory。
    /* 动画特性列表 */
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>(24)

    /* 如果层在当前刻度中已修改，则为真 */
    public var _mdf: Bool = false
    public var _isParent: Bool = false
    public var globalData: GlobalData = GlobalData()
    public var isNull: Bool = false
//FrameElement-2-----------------------------------------------------------------------------

//HierarchyElement-1-----------------------------------------------------------------------------
    //TODO: finalTransform 从 TransformElement 移到 HierarchyElement 中。
    public var finalTransform: FinalTransform = FinalTransform(isNull: true, dynamicProperties: ArrayList<DynamicPropertyContainer>())

    //元素的父列表
    //TODO: hierarchy 中装的是某种元素类型，暂定为父类 HierarchyElement？？？ 还是TransformElement(TransformElement中编译用到)？？？
    public var hierarchy: ArrayList<BaseElement> = ArrayList<BaseElement>()
    public var data: Layer
    public var buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit = {m,n,o => ()}
    //TODO：编译用 BaseRenderer.getElementByPath 中用到。
    //TODO：BaseRenderer.elements 数据类型是 BaseElement/BaseRenderer ？？？
    //TODO：需要后续再确认 BaseRenderer.elements 中的数据类型。
    public var getElementByPathInt64: (Array<Int64>) -> Option<BaseElement> = { m => None }
    public var getElementByPathString: (Array<String>) -> Option<BaseElement> = { m => None }

//HierarchyElement-2-----------------------------------------------------------------------------

//TransformElement-1-----------------------------------------------------------------------------
//TransformElement-2-----------------------------------------------------------------------------


//RenderableElement-1-----------------------------------------------------------------------------
    public var canvasContext: LottieCanvasRenderingContext2D
    //public var canvasContext: CanvasContext = unsafe {zeroValue<CanvasContext>()}
    public var transformCanvas: TransformCanvas = TransformCanvas()
    public var renderableEffectsManager: CvEffects = unsafe {zeroValue<CvEffects>()}
    public var effectsManager: EffectsManager = unsafe {zeroValue<EffectsManager>()}

    // BaseElement 里面的函数迁移到 RenderableElement
    public var layerId: String = ""

    //层的可见性与内点和外点有关。将isVisible重命名为isInRange
    public var isInRange: Bool = false
    //层的显示状态
    public var hidden: Bool = false
    //如果层的透明度等于0，则可以将其隐藏
    public var isTransparent: Bool = false
    public var maskManager: CvMaskElement = unsafe {zeroValue<CvMaskElement>()}
    //动画组件列表
    //TODO: component: CVEffects/SVGEffects/MaskElement/CVMaskElement，数据类型暂未确认，暂定为 RenderableElement。
    //public var renderableComponents: ArrayList<RenderableElement> = ArrayList<RenderableElement>()
    public var renderableComponents1: ArrayList<CvEffects> = ArrayList<CvEffects>()
    public var renderableComponents: ArrayList<BaseElement> = ArrayList<BaseElement>()

//RenderableElement-2-----------------------------------------------------------------------------



//RenderableDOMElement-1-----------------------------------------------------------------------------
    //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
    public var baseElement: CreateNS = CreateNS("")
    public var layerElement: CreateNS = CreateNS("")
    //TODO：未确认来源和数据类型，暂定是 CreateNS。
    var innerElem: CreateNS = CreateNS("")

//RenderableDOMElement-2-----------------------------------------------------------------------------



    //[ICompElement]--中移过来的。------------------------------------------------------
    public var layers: Array<Layer> = Array<Layer>()
    //TODO: 未确认数据类型，暂定为 BaseElement。
    public var elements: Array<BaseElement> = Array<BaseElement>()
    var completeLayers: Bool = false
    //[ICompElement]--中移过来的。------------------------------------------------------


    //TODO: maskedElement 在 MaskElement 中编译用。
    public var maskedElement: CreateNS = CreateNS("")

    //TODO: 未找到数据类型，暂定为 String 类型。
    var types: String = ""

    //TODO: style 是一个对象??? 还是一个 HashMap<String, String> ???                                ???---lp---20240516--
    var style: HashMap<String, String> = HashMap<String, String>()

    //TODO: 未完全确认 this.maskManager                                                            ???---lp---20240516--
    //var maskManager: MaskManagerInterface
    //TODO: 未完全实现 EffectsManager                                                              ???---lp---20240516--
    //var effectsManager: EffectsManager

    //var layers:     //CompExpressionInterface中用到                        //???---lp---20240429--
    //var elements:   //CompExpressionInterface中用到                        //???---lp---20240429--

    //TODO: 暂未联合编译引入。
    //public var layerInterface: LayerExpressionInterface
    //var compInterface: CompExpressionInterface

    var shapesData: Array<ContentModel> = Array<ContentModel>()
    //TODO: 未确认。itemsData 是 shapesData 初加工后的数据？？？
//    var itemsData: Array<ContentModel> = Array<ContentModel>()
//
//    var layerId: String = ""

    //TODO：父[1]类 FrameElement 中有 globalData/dynamicProperties/_isFirstFrame/_mdf
    //TODO：父[2]类 HierarchyElement 中有 data
    //TODO：父[4]类 RenderableElement 中有 isInRange/hidden/isTransparent
    //TODO：父[5]类 RenderableDOMElement 中有 baseElement/layerElement

    /**
     * //TODO：comp可能是 RendererBase，也可能是 BaseElement =>
     * extendPrototype([CanvasRendererBase, ICompElement, CVBaseElement], CVCompElement);
     * //TODO：CVCompElement 可以继承 CanvasRendererBase ？？？
     */


    /**
     * //TODO: 需要解构 BaseRenderer 和 BaseElement 互调用。
     * //TODO: 将 BaseRenderer 中的 elements 和 pendingElements，放到 BaseElement 中
     *
     * //TODO: elements 数据类型是 BaseElement/BaseRenderer，暂定是 BaseElement
     * public var elements: Array<BaseElement> = Array<BaseElement>()
     * //TODO: 数据类型未确认，暂定是 BaseElement
     * public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()
     */
     //TODO： 能放到一个包里，然后交叉引用么？？？

   // private var buffers: ArrayList<String> = ArrayList<String>()
    //public var canvasContext: ?CanvasContext = CanvasContext()
//    public var canvasContext: CanvasRenderingContext2D
//
//    private var transformCanvas: TransformCanvas = TransformCanvas()
//    public var renderableEffectsManager: ?CvEffects = None
//    private var maskManager: ?CvMaskElement = None


    /**
     * Create a BaseElement instance based on parameters.
     *
     * @param data - Type of Layer, an instance of the "layers" data that encapsulates the animation.
     * @param globalData - Type of GlobalData, encapsulate instances of GlobalData data.
     */
    public init(data: Layer, globalData: GlobalData, isNull!: Bool = false) {
        this.isNull = isNull
        this.data = data
        this.globalData = globalData
        this.canvasContext = this.globalData.canvasContext
    }

    //BaseRenderer.prototype.createItem----------------------------------------------------------------
    public func createItemChildren(layer: Layer, randerType: String): BaseElement {
        if (randerType != "canvas") {
            throw Exception("Non canvas cannot call this function。")
        }
        if (layer.ty == 2) {
            return CvImageElement(layer, globalData)
        } else if (layer.ty == 0) {
            return CvCompElement(layer, this.globalData, this.createItem, this.buildElementParenting)
        } else if (layer.ty == 1) {
            return CvSolidElement(layer, globalData)
        } else if (layer.ty == 3) {
            return NullElement(layer, this.globalData)
        } else if (layer.ty == 4) {
            return CvShapeElement(layer, this.globalData, this.buildElementParenting, layers: this.layers, elements: this.elements)
        } else if (layer.ty == 5) {
            return CvTextElement(layer, globalData)
        } else if (layer.ty == 6) {
            //TODO: 暂不实现  //return this.createAudio(layer)
            return NullElement(layer, this.globalData)
        } else if (layer.ty == 13) {
            //return this.createCamera(layer)
            throw Exception("You\'re using a 3d camera. Try the html renderer.")
        } else if (layer.ty == 15) {
            //TODO: 暂不实现  //return this.createFootage(layer)
            return NullElement(layer, this.globalData)
        } else {
            return NullElement(layer, this.globalData)
        }
    }
    //BaseRenderer.prototype.createItem----------------------------------------------------------------

    //HierarchyElement.prototype.checkParenting----------------------------------------------------------------
    public func checkParenting(): Unit {
        let parent = this.data.parent

        if (this.data.parent != -1) {
            //let be: BaseElement = this.changeToBaseElement()
            // BaseRenderer.buildElementParenting
            //this.buildElementParentingInComp(be, this.data.parent, ArrayList<BaseElement>())
            this.buildElementParenting(this, this.data.parent, ArrayList<BaseElement>())
        }
    }
    //HierarchyElement.prototype.checkParenting----------------------------------------------------------------

    //BaseRenderer.prototype.buildElementParenting----------------------------------------------------------------
    public func addPendingElement(element: BaseElement): Unit {
        this.pendingElements.append(element)
    }
    public func buildElementParenting(element: BaseElement, parentName: Int64, hierarchy: ArrayList<BaseElement>): Unit {
        let elements: Array<BaseElement> = this.elements
        let layers: Array<Layer> = this.layers
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ind == parentName) {                   // eslint-disable-line eqeqeq
                //if (!elements[i] || elements[i] == true)
                if (elements.size > i && elements[i].isNull) {
                    //在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                    this.addPendingElement(element)
                } else {
                    hierarchy.append(elements[i])
                    //TODO[lp]: - HierarchyElement.setAsParent => elements 中保存的是 HierarchyElement ？？？
                    elements[i].setAsParent()
                    if (layers[i].parent != -1) {
                        this.buildElementParenting(element, layers[i].parent, hierarchy)
                    } else {
                        //TODO[lp]: - HierarchyElement.setHierarchy => element 是 HierarchyElement ？？？
                        let bes: ArrayList<BaseElement> = ArrayList<BaseElement>(hierarchy.size)
                        for(i in 0..hierarchy.size) {
                            //bes[i] = hierarchy[i]
                            bes.append(hierarchy[i])
                        }
                        element.setHierarchy(bes)
                    }
                }
            }
        }
    }
    //BaseRenderer.prototype.buildElementParenting----------------------------------------------------------------


    //-------------------------------------------------------------------------------------
    public var createItem: (Layer) -> BaseElement = emptyCreateItem
    //TODO: 数据类型未确认，暂定是 BaseElement
    public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()



    public func buildAllItems(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            //在子类 CanvasRendererBase 中具体实现
            this.buildItem(i)
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }

    public open func buildItem(pos: Int64): Unit {
        let elements: Array<BaseElement> = this.elements
        if ((elements.size > pos && !elements[pos].isNull) || this.layers[pos].ty == 99) {
        //if (this.elements.size > pos || this.layers[pos].ty == 99) {
            return
        }
        //TODO: 函数参数不一致，有 2 个参数暂时未传递。
        //let element: BaseElement = this.createItem(this.layers[pos])
        let element: BaseElement = createItemChildren(this.layers[pos], "canvas")
        //TODO: 【暂未处理】ArrayList 直接指定下标赋值报错。暂时改为append。 //this.elements.append(element)
        elements[pos] = element

        element.initExpressions()
    }

    public open func checkPendingElements(): Unit {
        while (this.pendingElements.size != 0) {
            let element: BaseElement = this.pendingElements.remove(this.pendingElements.size - 1)

            //TODO[lp]: - HierarchyElement.checkParenting => element 是 HierarchyElement ？？？
            element.checkParenting()
        }
    }

    public open func checkLayers(num: Float64): Unit {
        var len: Int64 = this.layers.size
        var data: Layer = Layer()
        this.completeLayers = true

        for(i in ((len - 1)..=0 : -1)) {
            //如果当层无 element，代表该层 layer 未处理。
            //if (this.elements.size < i - 1) {
            if (this.elements[i].isNull) {
                data = this.layers[i]
                if ((data.ip - data.st) <= (num - this.layers[i].st) && (data.op - data.st) > (num - this.layers[i].st)) {
                    //在子类 CanvasRendererBase 中具体实现
                    this.buildItem(i)
                }
            }
            //this.completeLayers = this.elements[i] ? this.completeLayers : false
            if (this.elements[i].isNull) {
                this.completeLayers = false
            }
        }
        //在子类 CanvasRendererBase 中具体实现
        this.checkPendingElements()
    }


    //TODO: 未实现，编译用
    public operator func ==(that: BaseElement): Bool { return true }
    public operator func !=(that: BaseElement): Bool { return !(this == that) }
//    public open func changeColor(color: Array<Int64>): Unit {}
//    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>): Unit {}
    public open func updateDocumentData(newData: Option<DocumentData>, index: Option<Int64>): Unit {}

    /**
     * Check mask data.
     *
     * @return Type of Bool, return the result of check mask data.
     */
    public func checkMasks(): Bool {
        if (!this.data.hasMask) {
            return false
        }
        let len: Int64 = this.data.masksProperties.size
        for (i in 0..len) {
            if ((this.data.masksProperties[i].mode != "n" && this.data.masksProperties[i].cl)) {
                return true
            }
        }
        return false
    }

    //TODO: 未实现 initExpressions
    public func initExpressions(): Unit { }

    public func getType(): String {
        //TODO: 未找到数据类型，暂定为 String 类型。
        return this.types
    }

    //public open func sourceRectAtTime(): SourceRect {
    //    return SourceRect()
    //}

    //TODO: MaskElement 中编译用。暂未实现 addRenderableComponent。
    //public func addRenderableComponent(elem: BaseElement): Unit{}

//FrameElement-1-----------------------------------------------------------------------------

    /**
     * 初始化与帧相关的属性。
     */
    public func initFrame(): Unit {
        //渲染inpoint时设置为true
        this._isFirstFrame = false
        //动画特性列表
        this.dynamicProperties = ArrayList<DynamicPropertyContainer>(24)
        //如果层在当前刻度中已修改，则为真
        this._mdf = false
    }
    /**
     * 计算所有动态值
     *
     * @param num - 层时间中的当前帧数
     * @param isVisible - 如果层当前在范围内
     */
    public func prepareProperties(num: Int64, isVisible: Bool): Unit {
        let len: Int64 = this.dynamicProperties.size

        for (i in 0..len) {
            if (isVisible || (this._isParent && this.dynamicProperties[i].propType == "transform")) {
                this.dynamicProperties[i].getValue()
                if (this.dynamicProperties[i]._mdf) {
                    this.globalData._mdf = true
                    this._mdf = true
                }
            }
        }
    }

    /**
     * Add dynamic attributes.
     *
     * @param props - Type of DynamicPropertyContainer.
     * @return Type of Font, result value.
     */
    public func addDynamicProperty(props: DynamicPropertyContainer): Unit {
        for (i in 0..this.dynamicProperties.size) {
            if (refEq(props, this.dynamicProperties[i])) {
                return
            }
        }
        this.dynamicProperties.append(props)
    }

//FrameElement-2-----------------------------------------------------------------------------


//HierarchyElement-1-----------------------------------------------------------------------------

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
    //public open func checkParenting(): Unit {
    //    if (this.data.parent != -1) {
    //        //let be: BaseElement = this.changeToBaseElement()
    //        // BaseRenderer.buildElementParenting
    //        //this.buildElementParentingInComp(be, this.data.parent, ArrayList<BaseElement>())
    //        this.buildElementParenting(this, this.data.parent, ArrayList<BaseElement>())
    //    }
    //}

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

//HierarchyElement-2-----------------------------------------------------------------------------



//TransformElement-1-----------------------------------------------------------------------------

    public func initTransform(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData

        this.finalTransform.isNull = false
        if (!this.data.ks.isNull()) {
            this.finalTransform.mProp = TransformPropertyFactory.getTransformProperty(this.data.ks, globalData, data, dynamicProperties: this.dynamicProperties)
            //this.finalTransform.mProp.addDynamicPropertyInElem = this.addDynamicProperty
        } else {
            this.finalTransform.mProp.o.v = [0.0]
        }

        if (this.data.ao != 0) {
            this.finalTransform.mProp.autoOriented = true
        }

        // TODO: check TYPE 11: Guided elements
        if (this.data.ty != 11) {
            //TODO: 为什么要注掉？？？ // this.createElements()
        }
    }

    public func renderTransform() {
        this.finalTransform._opMdf = this.finalTransform.mProp.o._mdf || this._isFirstFrame
        this.finalTransform._matMdf = this.finalTransform.mProp._mdf || this._isFirstFrame

        //TODO：[44] TransformElement.renderTransform 中 this.hierarchy 为空数组时，进入if (this.hierarchy) 分支，执行代码逻辑。
        //if (this.hierarchy.size > 0) {
        let finalMat: Matrix = this.finalTransform.mat
        let len: Int64 = this.hierarchy.size
        //检查层次结构链中的任何变换矩阵是否已更改。
        if (!this.finalTransform._matMdf) {
            for (i in 0..len) {
                if (this.hierarchy[i].finalTransform.mProp._mdf) {
                    this.finalTransform._matMdf = true
                    break
                }
            }
        }

        if (this.finalTransform._matMdf) {
            //TODO: [45] TransformElement.renderTransform 中 this.finalTransform.mProp.v.props 的值不正确。
            //TODO: [45] 暂未处理，测试先赋正确的值。
            this.finalTransform.mProp.v.props[12] = 1311.31103515625
            this.finalTransform.mProp.v.props[13] = 513.7009887695313
            var mat: Array<Float64> = this.finalTransform.mProp.v.props
            finalMat.cloneFromProps(mat)
            for (i in 0..len) {
                mat = this.hierarchy[i].finalTransform.mProp.v.props
                finalMat.transform(mat[0], mat[1], mat[2], mat[3], mat[4], mat[5], mat[6], mat[7], mat[8], mat[9], mat[10], mat[11], mat[12], mat[13], mat[14], mat[15])
            }
        }
        //}
    }

    public func globalToLocal(pt2: Array<Float64>): Array<Float64> {
        var pt: Array<Float64> = pt2
        var transforms: ArrayList<FinalTransform> =  ArrayList<FinalTransform>()
        transforms.append(this.finalTransform)

        //TODO：没有看明白逻辑作用。
        //var flag: Bool = true
        //var comp = RepeaterModifier.prototype.initModifierProperties
        //var comp = this.comp
        //while (flag) {
        //    if (comp.finalTransform) {
        //        if (comp.data.hasMask) {
        //            transforms.splice(0, 0, comp.finalTransform)
        //        }
        //        comp = comp.comp
        //    } else {
        //        flag = false
        //    }
        //}

        let len: Int64 = transforms.size
        var ptNew: Array<Float64> = [0.0, 0.0, 0.0]
        for (i in 0..len) {
            ptNew = transforms[i].mat.applyToPointArray(0.0, 0.0, 0.0)
            pt = [pt[0] - ptNew[0], pt[1] - ptNew[1], 0.0]
        }
        return pt
    }

//    public open func mHelper(): Matrix {
//        return Matrix()
//    }

//TransformElement-2-----------------------------------------------------------------------------



//RenderableElement-1-----------------------------------------------------------------------------

    //TODO: 编译用。实际实现在后续子类中。
    public open func renderFrame(): Unit {
        this.renderFrame(false)
    }
//    public open func renderFrame(_isFirstFrame: Bool): Unit {}
//    public open func hide(): Unit {}
//    public open func show(): Unit {}

    public func initRenderable(): Unit {
        this.isInRange = false
        this.hidden = false
        this.isTransparent = false
        this.renderableComponents.clear()
        this.renderableComponents1.clear()
    }

    //TODO: component: CVEffects/SVGEffects/MaskElement/CVMaskElement，数据类型暂未确认，暂定为 RenderableElement。
    public func addRenderableComponent(component: BaseElement): Unit {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (rc in this.renderableComponents) {
            if (refEq(rc, component)) {
                return
            }
        }
        this.renderableComponents.append(component)
    }

    public func removeRenderableComponent(component: BaseElement) {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (i in 0..this.renderableComponents.size) {
            let rc = this.renderableComponents[i]
            if (refEq(rc, component)) {
                this.renderableComponents.remove(i)
            }
        }
    }
    public func addRenderableComponent(component: CvEffects): Unit {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (rc in this.renderableComponents1) {
            if (refEq(rc, component)) {
                return
            }
        }
        this.renderableComponents1.append(component)
    }

    public func removeRenderableComponent(component: CvEffects) {
        //TODO: 元素怎么判断相同？ -> 暂时用 refEq
        for (i in (this.renderableComponents1.size-1)..=0:-1) {
            let rc = this.renderableComponents1[i]
            if (refEq(rc, component)) {
                this.renderableComponents1.remove(i)
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
        //TODO：调试用，后续删除
        let a = this.data.ip - this.data.st <= num
        let b = this.data.op - this.data.st > num
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
            //this.renderableComponents[i].renderFrame(this._isFirstFrame)
            //TODO: 少传一个参数？？？
            this.renderableComponents[i].renderFrame()
        }
        let len1: Int64 = this.renderableComponents1.size
        for (i in 0..len1) {
            //调用具体子类的 renderFrame 函数
            this.renderableComponents1[i].renderFrame(this._isFirstFrame)
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

    public open func createRenderableComponents() {
        this.maskManager = CvMaskElement(this.data, this)
    }

    public func initBaseData(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData
        this.layerId = CreateElementID.createID()

        //缺少此属性的旧动画的拉伸因子。
        if (this.data.sr == 0.0) {
            this.data.sr = 1.0
        }
        this.effectsManager = EffectsManager(this.data, this.globalData, dynamicProperties: dynamicProperties)
    }

    public open func exitLayer () {
        if (this.data.tt >= 1) {
            //恢复图层
            //this.canvasContext.restoreLayer()
            this.canvasContext.restore();
            //将递归图层和mask动效图层进行指定混合
            match (operationsMap[this.data.tt]) {
               case "destination-in" => this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationIn)
               case "destination-out" => this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationOut)
               case _ =>  this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationIn)
            }
            //保存mask动效层
            //this.canvasContext.saveLayer()
            this.canvasContext.save();
            //对之前的混合模式还原成默认模式
            // this.canvasContext.globalCompositeOperation = "source-over"
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)// We draw the mask
//            const mask = this.comp.getElementById('tp' in this.data ? this.data.tp : this.data.ind - 1);*
//            mask.renderFrame(true);
            //恢复图层
            //this.canvasContext.restoreLayer()
            //this.canvasContext.restoreLayer()
            this.canvasContext.restore()
            this.canvasContext.restore()
            //this.canvasContext.globalCompositeOperation = 'source-over';
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
        }
    }

    public open func setBlendMode() {
        var globalData = this.globalData
        if (globalData.blendMode != this.data.bm.toString()) {
            globalData.blendMode = this.data.bm.toString()
            var blendModeValue = getBlendMode(this.data.bm)
            match (blendModeValue) {
                case "source-over" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
                case _ => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "multiply" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "screen" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "overlay" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "darken" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "lighten" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "color-dodge" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "color-burn" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "hard-light" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "soft-light" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "difference" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "exclusion" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "hue" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "saturation" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "color" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
//                case "luminosity" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
            }

        }

    }

    public open func prepareLayer() {
         if (this.data.tt >= 1) {
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
            //this.canvasContext.saveLayer()
            this.canvasContext.save()
            //保存递归图层
            //this.canvasContext.saveLayer()
            this.canvasContext.save()
            //对之前的混合模式还原成默认模式
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
         }
    }
    public open func renderInnerContent() {}

    public open func renderFrame(forceRender: Bool): Unit {
        if (this.hidden || this.data.hd) {
            return
        }
        if (this.data.td == 1 && !forceRender) {
            return
        }
        this.renderTransform()
        this.renderRenderable()
        this.setBlendMode()
        let forceRealStack = (this.data.ty == 0)
        //开始处理mask数据：包含两层layer数据，需要创建两个离屏绘制上下文
        this.prepareLayer()
        //TODO: [已解构--直接调用函数，省去renderer. ]解构 renderer 和 globalData。
        this.globalData.save(forceRealStack)  //CanvasRendererBase
//        this.globalData.ctxTransform(this.finalTransform.mat.props) //CanvasRendererBase
        this.globalData.ctxOpacity(Int64(this.finalTransform.mProp.o.v[0]))   //CanvasRendererBase
        this.renderInnerContent() //CVShapeElement
//        this.globalData.restore(forceRealStack)
//        //将两个layer数据分别绘制到两个离屏画布上，通过将离屏绘制数据结合混合模式绘制到当前显示画布上，实现mask效果
//        this.exitLayer() // CVBaseElement
//
//        //恢复高斯模糊的默认值，防止非高斯模糊图层也高斯模糊 shadowBlur(blur: Int64): Unit
//        this.canvasContext.shadowBlur(0)
//
//        if (this.maskManager.hasMasks) {
//            this.globalData.restore(true)
//        }
//        if (this._isFirstFrame) {
//            this._isFirstFrame = false
//        }
    }

    public open func hide(): Unit {
        if (!this.hidden && (!this.isInRange || this.isTransparent)) {
            this.hidden = true
        }
    }

    public open func show(): Unit {
        if (this.isInRange && !this.isTransparent) {
            this.hidden = false;
            this._isFirstFrame = true;
            this.maskManager._isFirstFrame = true;
        }
    }

    public open func createContainerElements() {
        this.canvasContext = this.globalData.canvasContext;
        this.transformCanvas = this.globalData.transformCanvas;
        this.renderableEffectsManager = CvEffects(this)
    }

    public open func initRendererElement() {}

    public open func createContent(): Unit {}

    public open func createElements(): Unit {}

    public open func clearCanvas(canvasContext: LottieCanvasRenderingContext2D): Unit {
         canvasContext.clearRect(
             this.transformCanvas.tx,
             this.transformCanvas.ty,
             this.transformCanvas.w * this.transformCanvas.sx,
             this.transformCanvas.h * this.transformCanvas.sy
         );
    }

    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, index)
    }

    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, 0) //CvCompElement
    }

    public open func changeColor(color: Array<Int64>, endColor: Int64) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor)
    }

    public open func changeColor(color: Array<Int64>, endColor: Int64, index: Int64) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, index)
    }

    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {}
    public open func renderShapeColor(color: Array<Int64>, endColor: Int64) {}
    public open func renderShapeColor(color: Array<Int64>, endColor: Int64, index: Int64) {}

    public open func destroy() {
        this.canvasContext = unsafe {zeroValue<LottieCanvasRenderingContext2D>()}
        this.data = Layer()
        this.globalData = unsafe {zeroValue<GlobalData>()}
        this.maskManager.destroy()
    }

    public func mHelper() {
        return Matrix()
    }

//RenderableElement-2-----------------------------------------------------------------------------



//RenderableDOMElement-1-----------------------------------------------------------------------------

    //TODO：编译用。后续子类实现。
    public open func renderElement(): Unit {}
    public open func destroyBaseElement(): Unit {}
//    public open func initBaseData(data: Layer, globalData: GlobalData): Unit {}
//    public open func initRendererElement(): Unit {}
//    public open func createContainerElements(): Unit {}
//    public open func createRenderableComponents(): Unit {}
//    public open func createContent(): Unit {}

    public open func initElement(data: Layer, globalData: GlobalData) {
        //调用 FrameElement.initFrame
        this.initFrame()
        //调用 BaseElement.initBaseData
        this.initBaseData(data, globalData)
        //调用 TransformElement.initTransform
        this.initTransform(data, globalData)
        //调用 HierarchyElement.initHierarchy
        this.initHierarchy()
        //调用 RenderableElement.initRenderable
        this.initRenderable()
        //调用 CVBaseElement.initRendererElement
        this.initRendererElement()
        //调用 CVBaseElement.createContainerElements
        this.createContainerElements()
        //调用 CVBaseElement.createRenderableComponents
        this.createRenderableComponents()
        //调用 CVBaseElement.createContent
        this.createContent()
        this.hide()
    }

    //public open func hide(): Unit {
    //    if (!this.hidden && (!this.isInRange || this.isTransparent)) {
    //        //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
    //        var elem: CreateNS = this.layerElement
    //        if (this.baseElement.isNull) {
    //            elem = this.baseElement
    //        }
    //        //TODO:还需要再确认一下elem数据类型，及elem.styles数据类型。 //elem.style.display = 'none'
    //        elem.styles.put("display", "none")
    //        this.hidden = true
    //    }
    //}

    //public open func show(): Unit {
    //    if (this.isInRange && !this.isTransparent) {
    //        if (!this.data.hd) {
    //            //TODO: baseElement/layerElement 数据类型不确认, CreateNS/createTag/BaseElement 或者其他。暂定是 CreateNS
    //            var elem: CreateNS = this.layerElement
    //            if (this.baseElement.isNull) {
    //                elem = this.baseElement
    //            }
    //            //TODO:还需要再确认一下elem数据类型，及elem.styles数据类型。 //elem.style.display = 'block'
    //            elem.styles.put("display", "block")
    //        }
    //        this.hidden = false
    //        this._isFirstFrame = true
    //    }
    //}

//    public open func renderFrame(): Unit {
//        //如果导出为隐藏（data.hd===true），则无需渲染
//        //如果不可见，则无需渲染
//        if (this.data.hd || this.hidden) {
//            return
//        }
//        //调用 TransformElement.renderTransform
//        this.renderTransform()
//
//        //调用 RenderableElement.renderRenderable
//        this.renderRenderable()
//
//        //TODO: 未实现 HBaseElement.renderElement/SVGBaseElement.renderElement
//        this.renderElement()
//
//        this.renderInnerContent()
//        if (this._isFirstFrame) {
//            this._isFirstFrame = false
//        }
//    }


        // 暂时注释，使用的是 RenderableElement func changeColor
//    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {
//        this._isFirstFrame = true
//        this.renderShapeColor(color, endColor, index)
//        this.isInRange = false
//    }

//    public open func renderInnerContent() {
//    }
//
//    public open func renderShapeColor(): Unit {}
//    public open func renderShapeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64): Unit {}

    public open func prepareFrame(num: Float64): Unit {
        this._mdf = false
        //调用 RenderableElement.prepareRenderableFrame
        this.prepareRenderableFrame(num)
        //调用 FrameElement.prepareProperties
        this.prepareProperties(Int64(num), this.isInRange)
        //调用 RenderableElement.checkTransparency
        this.checkTransparency()
    }

    //public open func destroy(): Unit {
    //    //TODO：未确认来源和数据类型，暂定是 CreateNS。
    //    this.innerElem = CreateNS("")
    //    //TODO： 未确认调用哪块？ SVGBaseElement/HBaseElement
    //    this.destroyBaseElement()
    //}

//RenderableDOMElement-2-----------------------------------------------------------------------------


}