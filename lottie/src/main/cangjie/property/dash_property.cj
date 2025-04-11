/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is DashProperty.
 */
package lottie.property

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

    var dataProps: Option<Array<DataProp<ContentModelDK, Float64>>>
    var renderer: String

    var frameId: Int64 = -1
    public var k: Bool = false
    var dashStr: String = ""

    public var dashArray: Array<Float64>
    public var dashoffset: Array<Float64> = Array<Float64>(1, item: 0.0)

    public init(data: Array<ContentModelD>, renderer: String, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)

        this.dataProps = None
        this.renderer = renderer

        let len: Int64 = data.size
        if (data.size > 0) {
            this.dashArray = Array<Float64>(len - 1, item: 0.0)
            let empty_dp: DataProp<ContentModelDK, Float64> = DataProp<ContentModelDK, Float64>(n: "", p: PropertyFactory<ContentModelDK, Float64>(empty_ContentModelDK, 0.0, DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: dynamicProperties), elemGlobalData, elemData, dynamicProperties: dynamicProperties))
            this.dataProps = Array<DataProp<ContentModelDK, Float64>>(data.size, item: empty_dp)
        } else {
            this.dashArray = Array<Float64>()
        }

        this.initDynamicPropertyContainer(elemGlobalData, elemData)

        for (i in 0..len) {
            var props: PropertyFactory<ContentModelDK, Float64>

            if (data[i].v.k.size == 1) {//走【分支1】 // data[i].v  =>  ContentModelDK(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>())
                /* "v":{"a":0,"k":0,"ix":7} */
                props = PropertyFactory<ContentModelDK, Float64>.getProp(data[i].v, data[i].v.k[0].k ?? 0.0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
            } else if (data[i].v.k.size > 1) {//走【分支3】
                /* "v":{"a":1,"k":[{"i":{"x":[0.833],"y":[0.833]},"o":{"x":[0.167],"y":[0.167]},"n":["0p833_0p833_0p167_0p167"],"t":30,"s":[0],"e":[140]},{"t":60.0000024438501}],"ix":1} */
                props = PropertyFactory<ContentModelDK, Float64>.getProp(data[i].v, data[i].v.k, 0, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
            } else {
                props = PropertyFactory<ContentModelDK, Float64>(data[i].v, 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
            }
            props.containerType = 3  /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
            props.container = [this]
            this.k = props.k || this.k

            if (let Some(value) <- dataProps) {
                value[i] = DataProp<ContentModelDK, Float64>(n: data[i].n, p: props)
            }

        }
        if (!this.k) {
            this.getValue(true)
        }
        this._isAnimated = this.k
    }

    public func getValue(): Unit {
        this.getValue(false)
    }

    public func getValue(forceRender: Bool): Unit {
        if (this.elemGlobalData.frameId == this.frameId && !forceRender) {
            return
        }
        this.frameId = this.elemGlobalData.frameId

        this.iterateDynamicProperties()
        this._mdf = this._mdf || forceRender
        if (this._mdf) {
            let len: Int64 = if (let Some(value) <- dataProps) {
                value.size
            } else {
            	0
            }

            if (this.renderer == "svg") {
                this.dashStr = ""
            }

            if (let Some(value) <- dataProps) {
                for (i in 0..len) {
                    if (value[i].n != "o") {
                        if (this.renderer == "svg") {
                            this.dashStr += " " + value[i].p.v[0].toString()
                        } else {
                            this.dashArray[i] = value[i].p.v[0]
                        }
                    } else {
                        this.dashoffset[0] = value[i].p.v[0]
                    }
                }
            }

        }
    }

}
