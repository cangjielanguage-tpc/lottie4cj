/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
//package lottie.utils.shapes
package lottie.property

/*
 * createStyleElement(data) 中 data  == ContentModel  => data.g = GradientFill/GradientStroke.g(ContentModelP)
 * data.ty === 'gf' || data.ty === 'gs'
 * GradientProperty(elem, data, container) 中 data  == ContentModelP
 * "g":{"p":2,"k":{"a":0,"k":[0,1,1,1,1,0,0,0],"ix":9}}
 */
public class GradientProperty <: DynamicPropertyContainer {

    //TODO：拆分多继承问题 -- extendPrototype([DynamicPropertyContainer], GradientProperty);

    var data: ContentModelP
    //TODO: 和 ElementData.c 名称冲突了，改为 c。 c: PropertyFactory<Array<Keyframe<Array<Float64>>>, Array<Float64>>
    public var c: Array<Float64>
    public var o: Array<Float64>
    var _cmdf: Bool = false
    var _omdf: Bool = false
    public var _collapsable: Bool = false
    public var _hasOpacity: Int64 = 0
    var props: PropertyFactory<ContentModelP, Array<Float64>>
    var k: Bool = false

    //public var isNull: Bool = false
    
    //在父类 DynamicPropertyContainer 中 var _mdf: Bool = false
    public init(isNull!: Bool, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super()
        this.isNull = isNull
        this.data = ContentModelP()
        this.c = Array<Float64>()
        this.o = Array<Float64>()
        //为了后续编译，提前初始化一个空的成员变量 this.props
        this.props = PropertyFactory<ContentModelP, Array<Float64>>(ContentModelP(), 0.0, DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: dynamicProperties), elemGlobalData, elemData, dynamicProperties: dynamicProperties)
    }


    public init(data: ContentModelP, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.data = data
        this.c = Array<Float64>(data.p * 4, item: 0.0)
        var cLength: Int64 = 0
        if (data.k.size > 1) {
            if (let Some(v) <- data.k[0].s) {
                cLength = v.size - data.p * 4
            }
        } else if (data.k.size == 1) {
            if (let Some(v) <- data.k[0].k) {
                cLength = v.size - data.p * 4
            }
        }
        this.o = Array<Float64>(cLength, item: 0.0)

        //为了后续编译，提前初始化一个空的成员变量 this.props
        this.props = PropertyFactory<ContentModelP, Array<Float64>>(ContentModelP(), 0.0, DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: dynamicProperties), elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this._collapsable = this.checkCollapsable()
        this._hasOpacity = cLength
        //TODO: 直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        this.initDynamicPropertyContainer(elemGlobalData, elemData)

        var vLen: Int64 = 0
        if (data.k.size > 0) { vLen = (data.k[0].s ?? Array<Float64>()).size }
        //"g":{"p":2,"k":{"a":0,"k":[0,1,1,1,1,0,0,0],"ix":9}}  //data.k = ContentModelP.k = Array<Keyframe<Array<Float64>>>
        this.props = PropertyFactory<ContentModelP, Array<Float64>>.getProp(data, data.k, 1, 0.0, this, elemGlobalData, elemData, vLen: vLen, dynamicProperties: dynamicProperties)
        this.props.containerType = 3  //1-FrameElement; 2-TransformPropertyFactory; 3-其他Property
        this.props.container = [this]

        this.k = this.props.k
        this.getValue(true)
    }
    
    public func comparePoints(values: Array<Float64>, points: Int64): Bool {
        let len: Int64 = this.o.size / 2
        var diff: Float64 = 0.0
        for (i in 0..len) {
            diff = abs(values[i * 4] - values[points * 4 + i * 2])
            if (diff > 0.01) {
                return false
            }
        }
        return true
    }
    
    public func checkCollapsable(): Bool {
        if (this.o.size / 2 != this.c.size / 4) {
            return false
        }
        
        if (this.data.k.size > 1) {
            let len: Int64 = this.data.k.size
            for (i in 0..len) {
                if (let Some(v) <- this.data.k[i].s) {
                    if (!this.comparePoints(v, this.data.p)) {
                        return false
                    }
                }
            }
        } else if (this.data.k.size == 1) {
            if (let Some(v) <- this.data.k[0].k) {
                if (!this.comparePoints(v, this.data.p)) {
                    return false
                }
            }
        }
        return true
    }

    public func getValue(): Unit {
        this.getValue(false)
    }

    public func getValue(forceRender: Bool) {
        this.props.getValue()
        this._mdf = false
        this._cmdf = false
        this._omdf = false
        if (this.props._mdf || forceRender) {
            var len: Int64 = this.data.p * 4
            var mult: Float64 = 0.0
            var val: Float64 = 0.0
            for (i in 0..len) {
                mult = 255.0
                if (i % 4 == 0) {
                    mult = 100.0
                }
                val = round(this.props.v[i] * mult)
                if (this.c[i] != val) {
                    this.c[i] = val
                    this._cmdf = !forceRender
                }
            }
            if (this.o.size > 0) {
                len = this.props.v.size
                for (i in (this.data.p * 4) ..len) {
                    mult = 1.0
                    if (i % 2 == 0) {
                        mult = 100.0
                    }
                    val = this.props.v[i]
                    if (i % 2 == 0) {
                        val = round(this.props.v[i] * 100.0)
                    }
                    
                    if (this.o[i - this.data.p * 4] != val) {
                        this.o[i - this.data.p * 4] = val
                        this._omdf = !forceRender
                    }
                }
            }
            this._mdf = !forceRender
        }
    }

}
