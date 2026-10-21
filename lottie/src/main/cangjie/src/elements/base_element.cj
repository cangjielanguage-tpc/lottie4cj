/**
 * @file This file is BaseElement.
 */
package lottie.elements

internal import kit.UIKit.*

internal import kit.PerformanceAnalysisKit.Hilog
internal import kit.ImageKit.PixelMap

internal import lottie.elements.helpers.*

internal import lottie.inner.*
internal import lottie.utils.*
internal import lottie.utils.helpers.*


internal import std.collection.*
internal import lottie.global_data.*
internal import lottie.property.*


internal import lottie.model.*
internal import std.collection.ArrayList


internal import lottie.bezier.*


public func emptyCreateItem(layer: Layer): BaseElement {
    return BaseElement(empty_layer, GlobalData(), isNull: true)
}


public var operationsMap: HashMap<Int64, String> = HashMap<Int64, String>([
    (1, "source-in"),
    (2, "source-out"),
    (3, "source-in"),
    (4, "source-out")

])

public class FinalTransform {

    public var mProp: TransformProperty
    public var _matMdf: Bool
    public var _opMdf: Bool
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

func getElementByIdEmpty(ind: Int64): Option<BaseElement> {
    return Option<BaseElement>.None
}

public open class BaseElement <: Equatable<BaseElement> {

    /* comp数据类型：1-Element；2-Renderer；3-其他 */
    public var compType: Int8 = unsafe {zeroValue<Int8>()}
    /* comp数据类型是 Element，对应的 Element.data.ind */
    public var compDataInd: Int64 = unsafe {zeroValue<Int64>()}
    /*
     * comp 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Element；另一类是 Renderer，用到那个单独处理。
     * 处理方案分为 3 类，参考成员变量 compType。
     * comp数据类型：1-Element；2-Renderer；3-其他。
     */
    public var comp: Array<BaseElement> = unsafe {zeroValue<Array<BaseElement>>()}

    public var renderedFrame: Float64 = unsafe {zeroValue<Float64>()}
    
    public var getElementByIdInRender: (Int64) -> Option<BaseElement> = getElementByIdEmpty

    /* FrameElement-1----------------------------------------------------------------------------- */
    /* 渲染inpoint时设置为true */
    public var _isFirstFrame: Bool = unsafe {zeroValue<Bool>()}

    /* 动画特性列表 */
    public var dynamicProperties: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()

    /* 如果层在当前刻度中已修改，则为真 */
    public var _mdf: Bool = unsafe {zeroValue<Bool>()}
    public var _isParent: Bool = unsafe {zeroValue<Bool>()}
    public var globalData: GlobalData
    public var isNull: Bool
    /* FrameElement-2----------------------------------------------------------------------------- */

    /* HierarchyElement-1----------------------------------------------------------------------------- */
    public var finalTransform: FinalTransform = unsafe {zeroValue<FinalTransform>()}

    /* 元素的父列表 */
    public var hierarchy: ArrayList<BaseElement> = ArrayList<BaseElement>(4)
    public var data: Layer
    public var buildElementParentingInComp: (BaseElement, Int64, ArrayList<BaseElement>) -> Unit = {m,n,o => ()}

    public var getElementByPathInt64: (Array<Int64>) -> Option<BaseElement> = { m => None }
    public var getElementByPathString: (Array<String>) -> Option<BaseElement> = { m => None }

    /* HierarchyElement-2----------------------------------------------------------------------------- */

    /* RenderableElement-1----------------------------------------------------------------------------- */
    public var canvasContext: LottieCanvasRenderingContext2D
    public var transformCanvas: TransformCanvas = unsafe {zeroValue<TransformCanvas>()}
    public var renderableEffectsManager: CvEffects = unsafe {zeroValue<CvEffects>()}
    public var effectsManager: EffectsManager = unsafe {zeroValue<EffectsManager>()}

    /* BaseElement 里面的函数迁移到 RenderableElement */
    public var layerId: String = unsafe {zeroValue<String>()}

    /* 层的可见性与内点和外点有关。将isVisible重命名为isInRange */
    public var isInRange: Bool = unsafe {zeroValue<Bool>()}
    /* 层的显示状态 */
    public var hidden: Bool = unsafe {zeroValue<Bool>()}
    /* 如果层的透明度等于0，则可以将其隐藏 */
    public var isTransparent: Bool = unsafe {zeroValue<Bool>()}
    public var maskManager: Array<CvMaskElement> = unsafe {zeroValue<Array<CvMaskElement>>()}

    /* 动画组件列表 */
    public var renderableComponents1: ArrayList<CvEffects> = ArrayList<CvEffects>(4)
    public var renderableComponents: ArrayList<BaseElement> = ArrayList<BaseElement>(4)

    /* RenderableElement-2----------------------------------------------------------------------------- */

    /* RenderableDOMElement-1----------------------------------------------------------------------------- */
    public var layerElement: CreateNS = CreateNS("")
    var innerElem: CreateNS = unsafe {zeroValue<CreateNS>()}

    /* RenderableDOMElement-2----------------------------------------------------------------------------- */


    /* [ICompElement]--中移过来的。------------------------------------------------------ */
    public var layers: Array<Layer> = empty_Array_layer
    public var elements: Array<BaseElement> = unsafe {zeroValue<Array<BaseElement>>()}
    var completeLayers: Bool = false
    /* [ICompElement]--中移过来的。------------------------------------------------------ */


    public var maskedElement: CreateNS = CreateNS("")

    var types: String = unsafe {zeroValue<String>()}

    var style: HashMap<String, String> = HashMap<String, String>()

    var shapesData: ArrayList<ContentModel> = unsafe {zeroValue<ArrayList<ContentModel>>()}

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

    func getCompDataInd(): Int64 {
        var cdInd: Int64 = -1
        if (this.compType == 1 && this.compDataInd != -1) {
            cdInd = this.compDataInd
        } else if (this.compType == 1) {
            cdInd = this.data.ind
        }
        return cdInd
    }

    public func getRenderedFrameInElemComp(_compDataInd: Int64): Float64 {
        if (this.compType == 2 && this.data.ind == _compDataInd) {
            return this.renderedFrame
        }
        if (this.compType == 1 && this.data.ind == _compDataInd) {
            return this.renderedFrame
        }
        if (this.compType == 1 && this.comp.size >= 1){
            return this.comp[0].getRenderedFrameInElemComp(_compDataInd)
        } else if (this.compType == 2) {
            return this.globalData.renderedFrameInRendered()
        }
        return this.renderedFrame
    }

    public func createItemChildren(layer: Layer, randerType: String): BaseElement {
        if (randerType != "canvas") {
            throw Exception("Non canvas cannot call this function。")
        }
        /* compType-comp数据类型：1-Element；2-Renderer；3-其他 */
        if (layer.ty == 2) {
            return CvImageElement(layer, globalData, this.buildElementParenting, compType: 1, comp: [this], getElementByIdInRender: this.getElementByIdInRender, compDataInd: this.data.ind)
        } else if (layer.ty == 0) {
            return CvCompElement(layer, this.globalData, this.createItem, this.buildElementParenting, compType: 1, comp: [this], getElementByIdInRender: this.getElementByIdInRender, compDataInd: this.data.ind)
        } else if (layer.ty == 1) {
            return CvSolidElement(layer, globalData, this.buildElementParenting, compType: 1, comp: [this], getElementByIdInRender: this.getElementByIdInRender, compDataInd: this.data.ind)
        } else if (layer.ty == 3) {
            return NullElement(layer, this.globalData)
        } else if (layer.ty == 4) {
            return CvShapeElement(layer, this.globalData, this.buildElementParenting, layers: this.layers, elements: this.elements, compType: 1, comp: [this], getElementByIdInRender: this.getElementByIdInRender, compDataInd: this.data.ind)
        } else if (layer.ty == 5) {
            return CvTextElement(layer, this.globalData, this.buildElementParenting, compType: 1, comp: [this], getElementByIdInRender: this.getElementByIdInRender, compDataInd: this.data.ind)
        } else if (layer.ty == 6) {
            /* 暂不实现  //return this.createAudio(layer) */
            return NullElement(layer, this.globalData)
        } else if (layer.ty == 13) {
            /* 暂不实现  //return this.createCamera(layer) */
            throw Exception("You\'re using a 3d camera. Try the html renderer.")
        } else if (layer.ty == 15) {
            /* 暂不实现  //return this.createFootage(layer) */
            return NullElement(layer, this.globalData)
        } else {
            return NullElement(layer, this.globalData)
        }
    }
    /* BaseRenderer.prototype.createItem---------------------------------------------------------------- */

    /* HierarchyElement.prototype.checkParenting---------------------------------------------------------------- */
    public func checkParenting(): Unit {
        let parent = this.data.parent

        if (this.data.parent != -1) {
            if (this.compType == 1 && this.comp.size == 1) {
                this.comp[0].buildElementParenting(this, this.data.parent, ArrayList<BaseElement>())
            } else {
                this.buildElementParentingInComp(this, this.data.parent, ArrayList<BaseElement>())
            }
        }
    }
    /* HierarchyElement.prototype.checkParenting---------------------------------------------------------------- */

    /* BaseRenderer.prototype.buildElementParenting---------------------------------------------------------------- */
    public func addPendingElement(element: BaseElement): Unit {
        this.pendingElements.add(element)
    }
    public func buildElementParenting(element: BaseElement, parentName: Int64, hierarchy: ArrayList<BaseElement>): Unit {
        let elements: Array<BaseElement> = this.elements
        let layers: Array<Layer> = this.layers
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ind == parentName) {                   /* eslint-disable-line eqeqeq */
                if (elements.size > i && elements[i].isNull) {
                    this.buildItem(i)
                    this.addPendingElement(element)
                } else {
                    hierarchy.add(elements[i])
                    elements[i].setAsParent()
                    if (layers[i].parent != -1) {
                        this.buildElementParenting(element, layers[i].parent, hierarchy)
                    } else {
                        let bes: ArrayList<BaseElement> = ArrayList<BaseElement>(hierarchy.size)
                        for(i in 0..hierarchy.size) {
                            bes.add(hierarchy[i])
                        }
                        element.setHierarchy(bes)
                    }
                }
            }
        }
    }
    /* BaseRenderer.prototype.buildElementParenting---------------------------------------------------------------- */


    public var createItem: (Layer) -> BaseElement = emptyCreateItem
    public var pendingElements: ArrayList<BaseElement> = ArrayList<BaseElement>()

    public func buildAllItems(): Unit {
        let len: Int64 = this.layers.size
        for (i in 0..len) {
            this.buildItem(i)
        }
        this.checkPendingElements()
    }

    public open func buildItem(pos: Int64): Unit {
        let elements: Array<BaseElement> = this.elements
        if ((elements.size > pos && !elements[pos].isNull) || this.layers[pos].ty == 99) {
            return
        }

        let element: BaseElement = createItemChildren(this.layers[pos], "canvas")
        elements[pos] = element

        element.initExpressions()
    }

    public open func checkPendingElements(): Unit {
        while (this.pendingElements.size != 0) {
            let element: BaseElement = this.pendingElements.remove(at: this.pendingElements.size - 1)
            element.checkParenting()
        }
    }

    public open func checkLayers(num: Float64): Unit {
        var len: Int64 = this.layers.size
        var data: Layer = empty_layer
        this.completeLayers = true

        for(i in ((len - 1)..=0 : -1)) {
            /* 如果当层无 element，代表该层 layer 未处理。 */
            if (this.elements[i].isNull) {
                data = this.layers[i]
                if ((data.ip - data.st) <= (num - this.layers[i].st) && (data.op - data.st) > (num - this.layers[i].st)) {
                    this.buildItem(i)
                }
            }

            if (this.elements[i].isNull) {
                this.completeLayers = false
            }
        }
        this.checkPendingElements()
    }

    public operator func ==(that: BaseElement): Bool { return true }
    public operator func !=(that: BaseElement): Bool { return !(this == that) }
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
            let dataMasks = this.data.masksProperties[i]
            if (dataMasks.mode != "n" && dataMasks.cl) {
                return true
            }
        }
        return false
    }

    public func initExpressions(): Unit { }

    public func getType(): String {
        return this.types
    }

    /* FrameElement-1----------------------------------------------------------------------------- */

    /**
     * 初始化与帧相关的属性。
     */
    public func initFrame(): Unit {
        /* 渲染inpoint时设置为true */
        this._isFirstFrame = false
        /* 动画特性列表 */
        this.dynamicProperties = ArrayList<DynamicPropertyContainer>(24)
        /* 如果层在当前刻度中已修改，则为真 */
        this._mdf = false
    }
    /**
     * 计算所有动态值
     *
     * @param num - 层时间中的当前帧数
     * @param isVisible - 如果层当前在范围内
     */
    public func prepareProperties(num: Float64, isVisible: Bool): Unit {
        let len: Int64 = this.dynamicProperties.size

        for (i in 0..len) {
            let dynamicTmps = this.dynamicProperties[i]
            if (isVisible || (this._isParent && dynamicTmps.propType == "transform")) {
                dynamicTmps.getValue()
                if (dynamicTmps._mdf) {
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
        this.dynamicProperties.add(props)
    }

    /* FrameElement-2----------------------------------------------------------------------------- */


    /* HierarchyElement-1----------------------------------------------------------------------------- */

    public func initHierarchy() {
        /* 元素的父列表 */
        this.hierarchy = ArrayList<HierarchyElement>()
        /* 如果元素是另一层的父元素_isPparent将为true */
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

    /* HierarchyElement-2----------------------------------------------------------------------------- */

    /* TransformElement-1----------------------------------------------------------------------------- */

    public func initTransform(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData

        var cdInd: Int64 = -1
        if (this.compType == 1 && this.compDataInd != -1) {
            cdInd = this.compDataInd
        } else if (this.compType == 1) {
            cdInd = this.data.ind
        }
        if (!this.data.ks.isNull()) {
            let mProp: TransformProperty
            if (this.compType == 1 && this.comp.size >= 1){
                mProp = TransformPropertyFactory.getTransformProperty(this.data.ks, globalData, data, dynamicProperties: this.dynamicProperties, compType: this.compType, renderedFrame: [comp[0].getRenderedFrameInElemComp], compDataInd: cdInd)
            } else {
                mProp = TransformPropertyFactory.getTransformProperty(this.data.ks, globalData, data, dynamicProperties: this.dynamicProperties, compType: this.compType, renderedFrame: [this.getRenderedFrameInElemComp], compDataInd: cdInd)
            }

            this.finalTransform = FinalTransform(mProp: mProp)
        } else {
            let arrdpc: ArrayList<DynamicPropertyContainer> = ArrayList<DynamicPropertyContainer>()
            this.finalTransform = FinalTransform(isNull: false, dynamicProperties: arrdpc)
            let o = PropertyFactory<ArrayKeyframeInt64, Int64>(ArrayKeyframeInt64(), 0.0, this.finalTransform.mProp, this.globalData, this.data, dynamicProperties: arrdpc, compDataInd: cdInd)
            o.v = [0.0]
            this.finalTransform.mProp.o = o
        }

        if (this.data.ao != 0) {
            this.finalTransform.mProp.autoOriented = true
        }

        if (this.data.ty != 11) {
            /* 为什么要注掉？？？ -- this.createElements() */
        }
    }

    public func renderTransform() {
        if (let Some(o) <- this.finalTransform.mProp.o) {
            this.finalTransform._opMdf = o._mdf || this._isFirstFrame
        }
        this.finalTransform._matMdf = this.finalTransform.mProp._mdf || this._isFirstFrame

        let finalMat: Matrix = this.finalTransform.mat
        let len: Int64 = this.hierarchy.size
        /* 检查层次结构链中的任何变换矩阵是否已更改。 */
        if (!this.finalTransform._matMdf) {
            for (i in 0..len) {
                if (this.hierarchy[i].finalTransform.mProp._mdf) {
                    this.finalTransform._matMdf = true
                    break
                }
            }
        }

        if (this.finalTransform._matMdf) {
            var mat: Array<Float64> = this.finalTransform.mProp.v.props
            finalMat.cloneFromProps(mat)
            for (i in 0..len) {
                mat = this.hierarchy[i].finalTransform.mProp.v.props
                finalMat.transform(mat[0], mat[1], mat[2], mat[3], mat[4], mat[5], mat[6], mat[7], mat[8], mat[9], mat[10], mat[11], mat[12], mat[13], mat[14], mat[15])
            }
        }
    }

    public func globalToLocal(pt2: Array<Float64>): Array<Float64> {
        var pt: Array<Float64> = pt2
        var transforms: ArrayList<FinalTransform> =  ArrayList<FinalTransform>()
        transforms.add(this.finalTransform)

        let len: Int64 = transforms.size
        var ptNew: Array<Float64> = [0.0, 0.0, 0.0]
        for (i in 0..len) {
            ptNew = transforms[i].mat.applyToPointArray(0.0, 0.0, 0.0)
            pt = [pt[0] - ptNew[0], pt[1] - ptNew[1], 0.0]
        }
        return pt
    }


    /* TransformElement-2----------------------------------------------------------------------------- */



    /* RenderableElement-1----------------------------------------------------------------------------- */

    public open func renderFrame(): Unit {
        this.renderFrame(false)
    }

    public func initRenderable(): Unit {
        this.isInRange = false
        this.hidden = false
        this.isTransparent = false
        this.renderableComponents.clear()
        this.renderableComponents1.clear()
    }

    public func addRenderableComponent(component: BaseElement): Unit {
        for (rc in this.renderableComponents) {
            if (refEq(rc, component)) {
                return
            }
        }
        this.renderableComponents.add(component)
    }

    public func removeRenderableComponent(component: BaseElement) {
        for (i in 0..this.renderableComponents.size) {
            let rc = this.renderableComponents[i]
            if (refEq(rc, component)) {
                this.renderableComponents.remove(at: i)
            }
        }
    }
    public func addRenderableComponent(component: CvEffects): Unit {
        for (rc in this.renderableComponents1) {
            if (refEq(rc, component)) {
                return
            }
        }
        this.renderableComponents1.add(component)
    }

    public func removeRenderableComponent(component: CvEffects) {
        for (i in (this.renderableComponents1.size-1)..=0:-1) {
            let rc = this.renderableComponents1[i]
            if (refEq(rc, component)) {
                this.renderableComponents1.remove(at: i)
            }
        }
    }

    public func prepareRenderableFrame(num: Float64): Unit {
        this.checkLayerLimits(num)
    }

    public func checkTransparency(): Unit {
        var vnum: Float64 = 0.0
        if (let Some(o) <- this.finalTransform.mProp.o) {
            vnum = o.v[0]
        }
        if (vnum <= 0.0) {
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
            this.renderableComponents[i].renderFrame()
        }
        let len1: Int64 = this.renderableComponents1.size
        for (i in 0..len1) {
            this.renderableComponents1[i].renderFrame(this._isFirstFrame)
        }
    }

    public open func sourceRectAtTime(): SourceRect {
        return SourceRect(top: 0, left: 0, width: 100, height: 100)
    }

    public func getLayerSize(): SizeLottie {
        if (this.data.ty == 5) {
            return SizeLottie(width: this.data.textData.width, height: this.data.textData.height)
        }
        return SizeLottie(width: this.data.width, height: this.data.height)
    }

    public open func createRenderableComponents() {
        this.maskManager = [CvMaskElement(this.data, this)]
    }

    public func initBaseData(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData
        this.layerId = CreateElementID.createID()

        /* 缺少此属性的旧动画的拉伸因子。 */
        if (this.data.sr == 0.0) {
            this.data.sr = 1.0
        }
        this.effectsManager = EffectsManager(this.data, this.globalData, dynamicProperties: dynamicProperties)
    }

    public func getElementById(ind: Int64): Option<BaseElement> {
        let len: Int64 = this.elements.size
        for (i in 0..len) {
            if (this.elements[i].data.ind == ind) {
                return this.elements[i]
            }
        }
        return None
    }

    public open func exitLayer () {
        if (this.data.tt >= 1) {
            /* 恢复图层 */
            this.canvasContext.restoreLayer()
            /* 将递归图层和mask动效图层进行指定混合 */
            match (operationsMap[this.data.tt]) {
               case "destination-in" => this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationIn)
               case "destination-out" => this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationOut)
               case _ =>  this.canvasContext.globalCompositeOperation(CompositeOperation.DestinationIn)
            }
            /* 保存mask动效层 */
            this.canvasContext.saveLayer()
            
            /* 对之前的混合模式还原成默认模式 */
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)

            var tp: Int64 = this.data.tp
            if (tp == -1){
                tp = this.data.ind - 1
            }
            var mask: Option<BaseElement>
            if (this.compType == 1 && this.comp.size == 1) {
                mask = this.comp[0].getElementById(tp)
            } else {
                mask = this.getElementByIdInRender(tp)
            }
            if(let Some(v) <- mask) {
                v.renderFrame(true)
            }
            /* 恢复图层 */
            this.canvasContext.restoreLayer()
            this.canvasContext.restoreLayer()

            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
        }
    }

    public open func setBlendMode() {
        var globalData = this.globalData
        if (this.data.bm != globalData.blendMode) {
            globalData.blendMode.setValue(this.data.bm)
            var blendModeValue = getBlendMode(this.data.bm.getValue<Int64>(-1))
            match (blendModeValue) {
                case "source-over" => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
                case _ => canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)
            }
        }
    }

    public open func prepareLayer() {
         if (this.data.tt >= 1) {
            this.canvasContext.globalCompositeOperation(CompositeOperation.SourceOver)

            this.canvasContext.saveLayer()
            /* 保存递归图层 */
            this.canvasContext.saveLayer()
            /* 对之前的混合模式还原成默认模式 */
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
        /* 开始处理mask数据：包含两层layer数据，需要创建两个离屏绘制上下文 */
        this.prepareLayer()

        this.globalData.save(forceRealStack)
        this.globalData.ctxTransform(this.finalTransform.mat.props)

        if (let Some(ov) <- this.finalTransform.mProp.o) {
            this.globalData.ctxOpacity(ov.v[0])
        }

        this.renderInnerContent()
        this.globalData.restore(forceRealStack)
        /* 将两个layer数据分别绘制到两个离屏画布上，通过将离屏绘制数据结合混合模式绘制到当前显示画布上，实现mask效果 */
        this.exitLayer()

        /* 恢复高斯模糊的默认值，防止非高斯模糊图层也高斯模糊 shadowBlur(blur: Int64): Unit */
        this.canvasContext.shadowBlur(0)

        if (this.maskManager.size > 0 && this.maskManager[0].hasMasks) {
            this.globalData.restore(true)
        }
        if (this._isFirstFrame) {
            this._isFirstFrame = false
        }
    }

    public open func hide(): Unit {
        if (!this.hidden && (!this.isInRange || this.isTransparent)) {
            this.hidden = true
        }
    }

    public open func show(): Unit {
        if (this.isInRange && !this.isTransparent) {
            this.hidden = false
            this._isFirstFrame = true
            if (this.maskManager.size > 0) {
                this.maskManager[0]._isFirstFrame = true
            }
        }
    }

    public open func createContainerElements() {
        this.canvasContext = this.globalData.canvasContext
        this.transformCanvas = this.globalData.transformCanvas
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
         )
    }

    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>, index: Int64) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, index)
    }

    public open func changeColor(color: Array<Int64>, endColor: Array<Int64>) {
        this._isFirstFrame = true
        this.renderShapeColor(color, endColor, 0)
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
        this.data = empty_layer
        this.globalData = unsafe {zeroValue<GlobalData>()}
        this.maskManager = Array<CvMaskElement>()
    }

    public func mHelper() {
        return Matrix()
    }

    /* RenderableElement-2----------------------------------------------------------------------------- */



    /* RenderableDOMElement-1----------------------------------------------------------------------------- */

    public open func renderElement(): Unit {}
    public open func destroyBaseElement(): Unit {}

    public open func initElement(data: Layer, globalData: GlobalData) {
        this.initFrame()
        this.initBaseData(data, globalData)
        this.initTransform(data, globalData)
        this.initHierarchy()
        this.initRenderable()
        this.initRendererElement()
        this.createContainerElements()
        this.createRenderableComponents()
        this.createContent()
        this.hide()
    }

    public open func prepareFrame(num: Float64): Unit {
        this._mdf = false
        this.prepareRenderableFrame(num)
        this.prepareProperties(num, this.isInRange)
        this.checkTransparency()
    }

    /* RenderableDOMElement-2----------------------------------------------------------------------------- */

}
