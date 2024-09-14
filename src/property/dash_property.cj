/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is DashProperty.
 */

package lottie4cj.property

/*
 * createStyleElement(data) 中 data  ==  ContentModel => data.d = ShapeStroke/GradientStroke.d(Array<ContentModelD>)
 * data.ty === 'st' || data.ty === 'gs'
 * data  ==  Array<ContentModelD>
 * renderer  ==  String
 * "d":[
 * {"n":"d","nm":"dash","v":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":30,"s":[0],"e":[140]},{"t":60.0000024438501}],"ix":1}}
 * {"n":"g","nm":"gap","v":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":30,"s":[11],"e":[62]},{"t":60.0000024438501}],"ix":2}},
 * {"n":"o","nm":"offset","v":{"a":0,"k":0,"ix":7}}
 * ]
 */
public class DashProperty <: DynamicPropertyContainer {
    //TODO：拆分多继承问题 -- extendPrototype([DynamicPropertyContainer], DashProperty)

    var elem: BaseElement
    //TODO:未确认数据类型，自定义为 DataProp。
    var dataProps: Array<DataProp<ContentModelDK, Float64>> = Array<DataProp<ContentModelDK, Float64>>()
    var renderer: String

    var frameId: Int64 = -1
    var k: Bool = false
    var dashStr: String = ""

    var dashArray: Array<Float64> = Array<Float64>()
    //TODO: 长度为 1 的数组，是否换成数值成员变量类型 ？？？
    var dashoffset: Array<Float64> = Array<Float64>(1, repeat: 0.0)

    //createStyleElement(data) 中 data  == ContentModel => data.d = ShapeStroke/GradientStroke.d(Array<ContentModelD>)
    public init(elem: BaseElement, data: Array<ContentModelD>, renderer: String, container: BaseElement) {
        super(container)
        this.elem = elem
        let empty_dp: DataProp<ContentModelDK, Float64> = DataProp<ContentModelDK, Float64>(n: "", p: PropertyFactory<ContentModelDK, Float64>(elem, ContentModelDK(), 0.0, DynamicPropertyContainer(container)))
        this.dataProps = Array<DataProp<ContentModelDK, Float64>>(data.size, repeat: empty_dp)
        this.renderer = renderer

        let len: Int64 = data.size
        if (data.size > 0) {
            this.dashArray = Array<Float64>(len - 1, repeat: 0.0)
        }

        //直接调用的 DynamicPropertyContainer.initDynamicPropertyContainer。
        this.initDynamicPropertyContainer(container)

        for (i in 0..len) {
            var props: PropertyFactory<ContentModelDK, Float64>

            if (data[i].v.k.size == 1) {//走【分支1】 // data[i].v  =>  ContentModelDK(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>())
                //"v":{"a":0,"k":0,"ix":7}
                props = PropertyFactory<ContentModelDK, Float64>.getProp(elem, data[i].v, data[i].v.k[0].k ?? 0.0, 0.0, this)
            } else if (data[i].v.k.size > 1) {//走【分支3】
                //"v":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":30,"s":[0],"e":[140]},{"t":60.0000024438501}],"ix":1}
                props = PropertyFactory<ContentModelDK, Float64>.getProp(elem, data[i].v, data[i].v.k, 0, 0.0, this)
            } else {
                props = PropertyFactory<ContentModelDK, Float64>(elem, data[i].v, 0.0, this)
            }
            this.k = props.k || this.k

            this.dataProps[i] = DataProp<ContentModelDK, Float64>(n: data[i].n, p: props)
        }
        if (!this.k) {
            this.getValue(true)
        }
        this._isAnimated = this.k
    }
    
    public func getValue(forceRender: Bool): Unit {
        if (this.elem.globalData.frameId == this.frameId && !forceRender) {
            return
        }
        this.frameId = this.elem.globalData.frameId
        //调用父类 DynamicPropertyContainer.iterateDynamicProperties
        this.iterateDynamicProperties()
        this._mdf = this._mdf || forceRender
        if (this._mdf) {
            let len: Int64 = this.dataProps.size
            if (this.renderer == "svg") {
                this.dashStr = ""
            }
            for (i in 0..len) {
                if (this.dataProps[i].n != "o") {
                    if (this.renderer == "svg") {
                        this.dashStr += " " + this.dataProps[i].p.v[0].toString()
                    } else {
                        this.dashArray[i] = this.dataProps[i].p.v[0]
                    }
                } else {
                    this.dashoffset[0] = this.dataProps[i].p.v[0]
                }
            }
        }
    }

}
