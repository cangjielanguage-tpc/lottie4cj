/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

//package lottie.utils.shapes
package lottie.property

//TODO: 需确认是否和 ContentModel 的子类 Repeater 有关联？？？
//TODO：需确认，其他 ShapeModifier 子类是否和 ContentModel 的其他子类有关联？？？
public class RepeaterModifier <: ShapeModifier { 
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], RepeaterModifier)

    var pMatrix: Matrix = Matrix()
    var rMatrix: Matrix = Matrix()
    var sMatrix: Matrix = Matrix()
    var tMatrix: Matrix = Matrix()
    var matrix: Matrix = Matrix()
    
    var data: Repeater

    public var c: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    public var o: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    public var so: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>
    public var eo: Option<PropertyFactory<ArrayKeyframeFloat64, Float64>>

    var tr: TransformProperty

    
    //TODO: 注意 怎么实现无参的初始化？？？   //TODO：考虑 Option
    //在父类中已经定义成员变量elem  //var elem: IShapeElement
    //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。[后续注意单独测试一下。]---------------------------------------2024.09.14
    //TODO: 调用 CvShapeElement/SVGShapeElement.reloadShapes()
    public var reloadShapesInShapeElement: () -> Unit = { => ()}

    var arr: Array<ContentModel> = Array<ContentModel>()
    var pos: Int64 = 0
    
    // 在 CvShapeElement 中 elemsData 可以存储：elementData是多种情况自定义结构/CVShapeData/ShapeModifier及子类
    // 储存的是处理后的 Layer.shapes
    //TODO：是否将 CVShapeData 和 ShapeModifier 进行关联？？？或者创建提取继承关系？？？-------------------------------------------2024.08.22
    //TODO: 提取的父类 ElementData：elementData是多种情况自定义结构/CVShapeData/ShapeModifier及子类
    //TODO: ShapeModifier <: DynamicPropertyContainer，让 DynamicPropertyContainer <: ElementData ???----------------------2024.08.22
    var elemsData: Array<ContentModelElement> = Array<ContentModelElement>()
    //TODO：elemsData 储存的是处理后的是，处理后的数据。
    //TODO：elemsData.it 储存的是处理后的 layers.shapes.{"ty": "gr"}.it = ShapeGroup.it
    
    var _currentCopies: Int64 = 0
    var _elements: ArrayList<ContentModel> = ArrayList<ContentModel>()
    var _groups: Array<ShapeGroup> = Array<ShapeGroup>()
    //在父类中已经定义成员变量elem  //var frameId: Int64 = -1

    public init(data: Repeater, elemGlobalData: GlobalData, elemData: Layer,
        reloadShapes: () -> Unit, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<() -> Float64> = Array<() -> Float64>()
    ){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.data = data

        this.reloadShapesInShapeElement = reloadShapes

        this.compType = compType
        this.getRenderedFrame = renderedFrame

//        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
//        this.c = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
//        this.o = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
//        this.so = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
//        this.eo = PropertyFactory<ArrayKeyframeFloat64, Float64>(ArrayKeyframeFloat64(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.c = None
        this.o = None
        this.so = None
        this.eo = None

        //(data: AnimatableTransform, elemGlobalData: GlobalData, elemData: Layer)
        this.tr = TransformPropertyFactory.getTransformProperty(data.tr, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties, compType: compType, renderedFrame: renderedFrame)
    }

    //TODO: 注意 怎么实现无参的初始化？？？
    public init(arr: Array<ContentModel>, pos: Int64, elemsData: Array<ContentModelElement>,
        elemGlobalData: GlobalData, elemData: Layer,
        reloadShapes: () -> Unit, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<() -> Float64> = Array<() -> Float64>()
    ) {
        this((arr[pos] as Repeater).getOrThrow(), elemGlobalData, elemData, reloadShapes, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame)
        this.arr = arr
        this.pos = pos
        this.elemsData = elemsData

        this.initDynamicPropertyContainer(elemGlobalData, elemData)
        let rp: Repeater = (arr[pos] as Repeater).getOrThrow()
        this.initModifierProperties(rp, elemGlobalData, elemData)
        if (pos > 0) {
            for (i in pos..0:-1) {
                //unshift() 方法可向数组的开头添加一个或更多元素，并返回新的长度。 // this._elements.unshift(arr.splice(i,1)[0])
                this._elements.prepend(arr[i])
            }
        }
        if (this.dynamicProperties.size > 0) {
            this.k = true
        } else {
            this.getValue(true)
        }
    }

    public func getValue(): Unit {
        this.processKeys()
    }

    public func initModifierProperties(rp: Repeater, elemGlobalData: GlobalData, elemData: Layer): Unit {
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys
        
        //"c": {"a": 0, "k": 2, "ix": 1}  //_c: Array<Keyframe<Float64>>
        if (rp.c.k.size == 1) {//走【分支1】
            this.c = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.c, rp.c.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        } else if (rp.c.k.size > 1) {//走【分支3】
            this.c = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.c, rp.c.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        }
        if (let Some(value) <- c) {
            value.containerType = 3
            value.container = [this]
        }
//        this.c.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
//        this.c.container = [this]
        
        //"o": {"a": 0, "k": 0, "ix": 2}  //_c: Array<Keyframe<Float64>>
        if (rp.o.k.size == 1) {//走【分支1】
            this.o = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.o, rp.o.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        } else if (rp.o.k.size > 1) {//走【分支3】
            this.o = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.o, rp.o.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        }
        //if (let Some(value) <- o) {
        //    value.containerType = 3
        //    value.container = [this]
        //}
//        this.o.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
//        this.o.container = [this]
        
        this.tr = TransformPropertyFactory.getTransformProperty(rp.tr, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties, compType: this.compType, renderedFrame: this.getRenderedFrame)
        this.tr.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.tr.container = [this]
        
        //"so": {"a": 0, "k": 100, "ix": 5}  //_so: Array<Keyframe<Float64>>
        if (rp.tr.so.k.size == 1) {//走【分支1】
            this.so = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.tr.so, rp.tr.so.k[0].k ?? 0.0, 0.01, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        } else if (rp.tr.so.k.size > 1) {//走【分支3】
            this.so = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.tr.so, rp.tr.so.k, 0, 0.01, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        }
        //if (let Some(value) <- so) {
        //    value.containerType = 3
        //    value.container = [this]
        //}
//        this.so.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
//        this.so.container = [this]
        
        //"eo": {"a": 0, "k": 100, "ix": 6}  //_eo: Array<Keyframe<Float64>>
        if (rp.tr.eo.k.size == 1) {//走【分支1】
            this.eo = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.tr.eo, rp.tr.eo.k[0].k ?? 0.0, 0.01, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        } else if (rp.tr.eo.k.size > 1) {//走【分支3】
            this.eo = PropertyFactory<ArrayKeyframeFloat64, Float64>.getProp(rp.tr.eo, rp.tr.eo.k, 0, 0.01, this, elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        }
        //if (let Some(value) <- eo) {
        //    value.containerType = 3
        //    value.container = [this]
        //}
//        this.eo.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
//        this.eo.container = [this]

        this.data = rp
        if (this.dynamicProperties.size == 0) {
            this.getValue(true)
        }

        this._isAnimated = this.dynamicProperties.size != 0
    }

    public func applyTransforms(pMatrix: Matrix, rMatrix: Matrix, sMatrix: Matrix, transform: TransformProperty, perc: Float64, inv: Bool) {
        var dir: Float64 = 1.0
        if (inv) {
            dir = -1.0
        }
        var scaleX: Float64 = 0.0
        var scaleY: Float64 = 0.0
        if (let Some(sv) <- transform.s) {
            scaleX = sv.v[0] + (1.0 - sv.v[0]) * (1.0 - perc)
            scaleY = sv.v[1] + (1.0 - sv.v[1]) * (1.0 - perc)
        }

        if (let Some(p_v) <- transform.p) {
            pMatrix.translate(p_v.v[0] * dir * perc, p_v.v[1] * dir * perc, tz: p_v.v[2])
        }
        if (let Some(a_v) <- transform.a) {
            rMatrix.translate(-a_v.v[0], -a_v.v[1], tz: a_v.v[2])
            if (let Some(r_v) <- transform.r) {
                rMatrix.rotate(-r_v.v[0] * dir * perc)
            }
            rMatrix.translate(a_v.v[0], a_v.v[1], tz: a_v.v[2])
            sMatrix.translate(-a_v.v[0], -a_v.v[1], tz: a_v.v[2])
        } else if (let Some(r_v) <- transform.r) {
             rMatrix.rotate(-r_v.v[0] * dir * perc)
        }
        //rMatrix.translate(-transform.a.v[0], -transform.a.v[1], tz: transform.a.v[2])
        //rMatrix.rotate(-transform.r.v[0] * dir * perc)
        //rMatrix.translate(transform.a.v[0], transform.a.v[1], tz: transform.a.v[2])
        //sMatrix.translate(-transform.a.v[0], -transform.a.v[1], tz: transform.a.v[2])

        if (inv) {
            sMatrix.scale(1.0 / scaleX, 1.0 / scaleY)
        } else {
            sMatrix.scale(scaleX, scaleY)
        }

        if (let Some(a_v) <- transform.a) {
            sMatrix.translate(a_v.v[0], a_v.v[1], tz: a_v.v[2])
        }
    }
    
    public func resetElements(elements: Array<ContentModel>): Unit {
        let len: Int64 = elements.size
        for (i in 0..len) {
            elements[i]._processed = false
            if (elements[i].ty == "gr") {
                this.resetElements((elements[i] as ShapeGroup).getOrThrow().it)
            }
        }
    }
    
    //TODO: 在开发此函数--20240807
    //TODO: 类似与逐级复制：JSON.parse(JSON.stringify(Array<Object>) 操作之后，原Array<Object>中成员变量数据变化，不影响新的数组中对象。
    //TODO: 测试对象数组在 clone() 生成新数组后，修改新数组中对象，旧数组中对象数据发生改变。
    //TODO: 需要实现逐级 Clone 函数，暂未实现。------------------------------------------------------------------2024.08.08
    public func cloneElements(elements: Array<ContentModel>): Array<ContentModel> {
        var newElements: Array<ContentModel> = elements.clone()
        this.resetElements(newElements)
        return newElements
    }
    
    public func changeGroupRender(elements: Array<ContentModel>, renderFlag: Bool): Unit {
        let len: Int64 = elements.size
        for (i in 0..len) {
            elements[i]._render = renderFlag
            if (elements[i].ty == "gr") {
                this.changeGroupRender((elements[i] as ShapeGroup).getOrThrow().it, renderFlag)
            }
        }
    }

    public func processShapes(_isFirstFrame: Bool): Bool {
        var items: Array<ContentModelElement> = Array<ContentModelElement>()
        var itemsTransform: Array<Float64> = Array<Float64>()
        var i: Int64 = 0
        var dir: Int64 = 0
        var cont: Int64 = 0
        var hasReloaded: Bool = false
        if (this._mdf || _isFirstFrame) {
            //数据来源分析：this.c.v = PropertyFactory.v = Array<Float64>
//            var copies: Int64 = Int64(ceil(this.c.v[0]))
            var copies: Int64 = Int64(ceil(if (let Some(value) <- c) {
                    value.v[0]
                }else {
                    0.0
                }))

            if (this._groups.size < copies) {
                var diffNum: Int64 = copies - this._groups.size
                let empty_ShapeGroup: ShapeGroup = ShapeGroup("", Array<ContentModel>(), false)
                let diffArr: Array<ShapeGroup> = Array<ShapeGroup>(diffNum, item: empty_ShapeGroup)

                while (this._groups.size < copies) {
                    let it: Array<ContentModel> = Array<ContentModel>(this._elements.size + 1, item: ContentModel())
                    //TODO: 将 this._elements 循环逐级 clone 的新对象，存储到 it 中
                    for(j in 0..this._elements.size) {
                        //TODO：【暂未实现】 shape 逐级实现 clone() 函数。
                        it[j] = this._elements[j].clone()
                    }
                    
                    let tr: AnimatableTransform = AnimatableTransform(
                        a: ArrayKeyframePointF(a: 0, ix: 1, k: [ Keyframe<PointF>(k: PointF(x: 0.0, y: 0.0)) ]),
                        p: AnimatableSplitDimensionPathValue( a: 0, ix: 2, k: [Keyframe<PointF>(k: PointF(x: 0.0, y: 0.0))] ),
                        s: ArrayKeyframeArrayFloat64(a: 0, ix: 3, k: [ Keyframe<Array<Float64>>(k: [100.0, 100.0]) ]),
                        r: ArrayKeyframeFloat64( a: 1, ix: 6, k: [Keyframe<Float64>( s: 0.0, e: 0.0, t: 0.0 ), Keyframe<Float64>( s: 0.0, e: 0.0, t: 1.0 )] ),
                        o: ArrayKeyframeInt64(a: 0, ix: 7, k: [ Keyframe<Int64>(k: 100) ]),
                        sk: ArrayKeyframeFloat64(a: 0, ix: 4, k: [ Keyframe<Float64>(k: 0.0) ]),
                        sa: ArrayKeyframeFloat64(a: 0, ix: 5, k: [ Keyframe<Float64>(k: 0.0) ]),
                        ty: "tr",
                        nm: "Transform"
                    )

                    it[it.size - 1] = tr
                    
                    let group: ShapeGroup = ShapeGroup(
                        nm: "",
                        it: it    //ty: "gr"
                    )
                    //splice: 从数组中添加或删除元素。--此处都是添加--在下标0处，删除0个长度，添加group
                    //TODO：单次扩展数组，改为最后一次性扩展
                    //this.arr.splice(0, 0, group)
                    //this._groups.splice(0, 0, group)
                    diffNum--
                    diffArr[diffNum] = group
                    this._currentCopies += 1
                }

                //TODO：单次扩展数组，改为最后一次性扩展
                let diffArrSize: Int64 = diffArr.size
                let len: Int64 = this.arr.size + diffArrSize
                let arr_new: Array<ContentModel> = Array<ContentModel>(len, item: ContentModel())
                for (i in 0..diffArrSize) {
                    arr_new[i] = diffArr[i]
                }
                for (i in 0..this.arr.size) {
                    arr_new[i + diffArrSize] = this.arr[i]
                }
                this.arr = arr_new
                
                this._groups = diffArr.concat(this._groups)
                
                //TODO: 调用 CvShapeElement/SVGShapeElement.reloadShapes()
                //TODO: elem 中用到的成员变量，在初始化后需要单独赋值过来。---------------------------------------2024.09.14
                //this.elem.reloadShapes()
                this.reloadShapesInShapeElement()
                hasReloaded = true
            }
            cont = 0
            var renderFlag: Bool = false
            for (i in 0..this._groups.size) {
                renderFlag = cont < copies
                this._groups[i]._render = renderFlag
                this.changeGroupRender((this._groups[i] as ShapeGroup).getOrThrow().it, renderFlag)
                if (!renderFlag) {
                    let elems: Array<ContentModelElement> = (this.elemsData[i] as ShapeGroupElement).getOrThrow().it
                    let transformData: AnimatableTransformElement = (elems[elems.size - 1] as AnimatableTransformElement).getOrThrow()
                    //TODO: 为避免循环/递归构造函数调用，方便初始化，transform.op 从 PropertyFactory 类型改为 Array<PropertyFactory> 类型。
                    if (transformData.transform.op.v[0] != 0.0) {
                        transformData.transform.op._mdf = true
                        transformData.transform.op.v[0] = 0.0
                    } else {
                        transformData.transform.op._mdf = false
                    }
                }
                cont += 1
            }
            i = this._groups.size
    
            this._currentCopies = copies
    
//            var offset: Float64 = this.o.v[0]
            var offset: Float64 = if (let Some(value) <- o) {
                    value.v[0]
                }else {
                    0.0
                }
            var offsetModulo: Int64 = Int64(offset) % 1

            var roundOffset: Float64 = 0.0
            if (offset > 0.0) {
                roundOffset = floor(offset)
            } else {
                roundOffset = ceil(offset)
            }
            var pProps: Array<Float64> = this.pMatrix.props
            var rProps: Array<Float64> = this.rMatrix.props
            var sProps: Array<Float64> = this.sMatrix.props
            this.pMatrix.reset()
            this.rMatrix.reset()
            this.sMatrix.reset()
            this.tMatrix.reset()
            this.matrix.reset()
            var iteration: Int64 = 0
    
            if (offset > 0.0) {
                while (Float64(iteration) < roundOffset) {
                    this.applyTransforms(this.pMatrix, this.rMatrix, this.sMatrix, this.tr, 1.0, false)
                    iteration += 1
                }
                if (offsetModulo != 0) {
                    this.applyTransforms(this.pMatrix, this.rMatrix, this.sMatrix, this.tr, Float64(offsetModulo), false)
                    iteration += offsetModulo
                }
            } else if (offset < 0.0) {
                while (Float64(iteration) > roundOffset) {
                    this.applyTransforms(this.pMatrix, this.rMatrix, this.sMatrix, this.tr, 1.0, true)
                    iteration -= 1
                }
                if (offsetModulo != 0) {
                    this.applyTransforms(this.pMatrix, this.rMatrix, this.sMatrix, this.tr, Float64(-offsetModulo), true)
                    iteration -= offsetModulo
                }
            }
            //i = this.data.m == 1 ? 0 : this._currentCopies - 1
            i = this._currentCopies - 1
            //TODO: Repeater 中需要新增成员变量 m。
            if (this.data.m == 1) {
                i = 0
            }
            //dir = this.data.m == 1 ? 1 : -1
            dir = -1
            if (this.data.m == 1) {
                dir = 1
            }
            cont = this._currentCopies
            var jLen: Int64 = 0
            while (cont != 0) {
                items = (this.elemsData[i] as ShapeGroupElement).getOrThrow().it
                let transformData: AnimatableTransformElement = (items[items.size - 1] as AnimatableTransformElement).getOrThrow()
                itemsTransform = transformData.transform.mProps.v.props
                jLen = itemsTransform.size
                transformData.transform.mProps._mdf = true
                
                //TODO: 为避免循环/递归构造函数调用，方便初始化，transform.op 从 PropertyFactory 类型改为 Array<PropertyFactory> 类型。
                transformData.transform.op._mdf = true
                if (this._currentCopies == 1) {
//                    transformData.transform.op.v = this.so.v
                    transformData.transform.op.v = if (let Some(value) <- so) {
                        value.v
                    } else {
                    	Array<Float64>()
                    }
                } else {
//                    let v0: Float64 = this.so.v[0] + (this.eo.v[0] - this.so.v[0]) * Float64(i / (this._currentCopies - 1))
                    var sov = if (let Some(value) <- so) {
                        value.v[0]
                    }else {
                        0.0
                    }
                    var eov = if (let Some(value) <- eo) {
                        value.v[0]
                    }else {
                        0.0
                    }
                    let v0: Float64 = sov + (eov - sov) * Float64(i / (this._currentCopies - 1))
                    transformData.transform.op.v = [v0]
                }
    
                if (iteration != 0) {
                    if ((i != 0 && dir == 1) || (i != this._currentCopies - 1 && dir == -1)) {
                        this.applyTransforms(this.pMatrix, this.rMatrix, this.sMatrix, this.tr, 1.0, false)
                    }
                    this.matrix.transform(rProps[0], rProps[1], rProps[2], rProps[3], rProps[4], rProps[5], rProps[6], rProps[7], rProps[8], rProps[9], rProps[10], rProps[11], rProps[12], rProps[13], rProps[14], rProps[15])
                    this.matrix.transform(sProps[0], sProps[1], sProps[2], sProps[3], sProps[4], sProps[5], sProps[6], sProps[7], sProps[8], sProps[9], sProps[10], sProps[11], sProps[12], sProps[13], sProps[14], sProps[15])
                    this.matrix.transform(pProps[0], pProps[1], pProps[2], pProps[3], pProps[4], pProps[5], pProps[6], pProps[7], pProps[8], pProps[9], pProps[10], pProps[11], pProps[12], pProps[13], pProps[14], pProps[15])
    
                    for (j in 0..jLen) {
                        itemsTransform[j] = this.matrix.props[j]
                    }
                    this.matrix.reset()
                } else {
                    this.matrix.reset()
                    for (j in 0..jLen) {
                        itemsTransform[j] = this.matrix.props[j]
                    }
                }
                iteration += 1
                cont -= 1
                i += dir
            }
        } else {
            cont = this._currentCopies
            i = 0
            dir = 1
            while (cont != 0) {
                items = (this.elemsData[i] as ShapeGroupElement).getOrThrow().it
                let transformData: AnimatableTransformElement = (items[items.size - 1] as AnimatableTransformElement).getOrThrow()
                itemsTransform = transformData.transform.mProps.v.props
                transformData.transform.mProps._mdf = false
                //TODO: 为避免循环/递归构造函数调用，方便初始化，transform.op 从 PropertyFactory 类型改为 Array<PropertyFactory> 类型。
                transformData.transform.op._mdf = false
                cont -= 1
                i += dir
            }
        }
        return hasReloaded
    }
    
    public func addShape() {}

}
