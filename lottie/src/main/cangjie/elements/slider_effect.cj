/**
 * Created on 2024/10/11
 */
package lottie.elements
/*

 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.

 */


public class SliderEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class AngleEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class ColorEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class PointEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class CheckboxEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class LayerIndexEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public class MaskIndexEffect <: NoValueEffect {
    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect, dynamicProperties!: ArrayList<DynamicPropertyContainer>) {
        super(data, elem, datas, container)

        this.p = PropertyFactory<ContentModelPK, Float64>.getProp(data.v, 0.0, 0.0, container, elem, datas, dynamicProperties: dynamicProperties)
    }
}

public open class NoValueEffect {
    public var p: PropertyFactory<ContentModelPK, Float64>

    public init(data: Effect, elem: GlobalData, datas: Layer, container: GroupEffect) {
        this.p = unsafe { zeroValue<PropertyFactory<ContentModelPK, Float64>>() }
    }
}
