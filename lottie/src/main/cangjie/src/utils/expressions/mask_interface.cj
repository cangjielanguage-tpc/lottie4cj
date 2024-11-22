/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is MaskManagerInterface.
 */
package lottie.utils.expressions

public class MaskInterface {

    public var _mask: ViewData
    public var _data: Mask
    
    public var isNull: Bool = false

    public init(mask: ViewData, data: Mask) {
        this._mask = mask
        this._data = data
    }
    
    public prop maskPath: ShapePropertyFactory {
        get() {
            if (this._mask.props.k) {/* this._mask.prop => ShapePropertyFactory.getShapeProp */
                this._mask.props.getValue()
            }
            return this._mask.props
        }
    }

    public prop maskOpacity: Float64 {
        get() {
            if (this._mask.op.k) {/* this._mask.op => PropertyFactory.getProp */
                this._mask.op.getValue()
            }
            return this._mask.op.v[0] * 100.0
        }
    }
    
}

public class MaskManagerInterface {

    var _masksInterfaces: Array<MaskInterface>

    var viewDataInMaskElement: Array<ViewData>
    var masksPropertiesInMaskElement: Array<Mask>

    let len: Int64
    let emptyMaskInterface: MaskInterface

    public init(viewData: Array<ViewData>, masksProperties: Array<Mask>) {
        this.viewDataInMaskElement = viewData
        this.masksPropertiesInMaskElement = masksProperties
        
        this.len = viewDataInMaskElement.size
        
        /* 需要初始化一个空的 ViewData。 */
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        dp.isNull = true
        let pf: PropertyFactory<Array<Keyframe<Int64>>, Int64> = PropertyFactory<Array<Keyframe<Int64>>, Int64>(Array<Keyframe<Int64>>(), 0.0, dp, dp.elemGlobalData, dp.elemData, dynamicProperties: ArrayList<DynamicPropertyContainer>())
        pf.isNull = true
        let spf: ShapePropertyFactory = ShapePropertyFactory(ContentModel(), 0, dp.elemGlobalData, dp.elemData, dynamicProperties: ArrayList<DynamicPropertyContainer>())
        spf.isNull = true
        let emptyViewData: ViewData = ViewData(op: pf, props: spf)
        
        this.emptyMaskInterface = MaskInterface(emptyViewData, Mask())
        this.emptyMaskInterface.isNull = true
        this._masksInterfaces = Array<MaskInterface>(this.len, item: this.emptyMaskInterface)
        
        for (i in 0..this.len) {
            this._masksInterfaces[i] = MaskInterface(viewDataInMaskElement[i], masksPropertiesInMaskElement[i])
        }
    }

    func maskFunction(name: String): MaskInterface {
        for (i in 0..this.len) {
            if (masksPropertiesInMaskElement[i].nm == name) {
                return this._masksInterfaces[i]
            }
        }
        return this.emptyMaskInterface
    }

}
