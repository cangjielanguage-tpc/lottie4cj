/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils.expressions

//TODO：position 是已经执行了，相当于 ExpressionPropertyInterface(x)()
//TODO：其余都是未执行了，相当于 ExpressionPropertyInterface(x)
class TransformExpressionInterface {

    var transform: TransformProperty

    //TODO： _px/_py/_pz 是 ExpressionPropertyInterface？？？ ExpressionPropertyInterface 调用的返回值是函数 () -> ExpressionValue<T, E>
    //TODO： 和后面 _px/_py/_pz 是 函数 冲突了！--[不冲突]
    var _px: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>
    var _py: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>
    var _pz: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>
    //hasZ 代表 TransformProperty.z 是否为空。hasP = false && hasZ = true 时，z不为空。
    var hasZ: Bool = false
    var _transformFactory: ExpressionPropertyInterface<AnimatableSplitDimensionPathValue, PointF>
    //hasP 代表 TransformProperty.p 是否为空。p 为空的时候，x/y 不为空，z 可能不为空。
    var hasP: Bool = false

    public init(transform: TransformProperty) {
        this.transform = transform
        if (!transform.p.isNull) {
            this.hasP = true
        } else if (!transform.pz.isNull) {
            this.hasZ = true
        }
        this._transformFactory = ExpressionPropertyInterface<AnimatableSplitDimensionPathValue, PointF>(transform.p)
        this._px = ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.px)
        this._py = ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.py)
        this._pz = ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.pz)
    }

    public func selfCalling(value: Int64, name: String, isString!: Bool = false): ExpressionInterface {
    //func selfCalling(name: String) {
        if (name == "scale" || name == "ADBE Scale" || name == "ADBE Scale" || value == 6) {
            return this.scale
        } else if (name == "rotation" || name == "Rotation" || name == "ADBE Rotation" || name == "ADBE Rotate Z" || value == 10) {
            return this.rotation
        //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
        //} else if (name == "ADBE Rotate X") {
        //    return this.xRotation
        //} else if (name == "ADBE Rotate Y") {
        //    return this.yRotation
        } else if (name == "position" || name == "Position" || name == "ADBE Position" || value == 2) {
            return this.position
        } else if (name == "ADBE Position_0") {
            return this.xPosition
        } else if (name == "ADBE Position_1") {
            return this.yPosition
        } else if (name == "ADBE Position_2") {
            return this.zPosition
        } else if (name == "anchorPoint" || name == "AnchorPoint" || name == "Anchor Point" || name == "ADBE AnchorPoint" || value == 1) {
            return this.anchorPoint
        } else if (name == "opacity" || name == "Opacity" || value == 11) {
            return this.opacity
        }
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        let emptyPF = PropertyFactory<Float64, Float64>(0.0, 0.0, dp, this.transform.elemGlobalData, this.transform.elemData, dynamicProperties: ArrayList<DynamicPropertyContainer>())
        return ExpressionPropertyInterface<Float64, Float64>(emptyPF)
    }

    func selfCalling(value: Int64) {
        if (value == 6) {
            return this.scale
        } else if (value == 10) {
            return this.rotation
        } else if (value == 2) {
            return this.position
        } else if (value == 1) {
            return this.anchorPoint
        } else if (value == 11) {
            return this.opacity
        }
        let dp: DynamicPropertyContainer = DynamicPropertyContainer()
        let emptyPF = PropertyFactory<Float64, Float64>(0.0, 0.0, dp, this.transform.elemGlobalData, this.transform.elemData, dynamicProperties: ArrayList<DynamicPropertyContainer>())
        emptyPF.isNull = true
        return ExpressionPropertyInterface<Float64, Float64>(emptyPF)
    }

    public prop rotation: ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64> {
        //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
        get() { ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64>(transform.r) }
    }

    //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
    //public prop zRotation: ExpressionPropertyInterface<T, E> {
    //    get() { ExpressionPropertyInterface(transform.rz || transform.r) }
    //}

    //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
    //public prop xRotation: ExpressionPropertyInterface {
    //    get() { ExpressionPropertyInterface(transform.rx) }
    //}

    //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
    //public prop yRotation: ExpressionPropertyInterface {
    //    get() { ExpressionPropertyInterface(transform.ry) }
    //}

    public prop scale: ExpressionPropertyInterface<ArrayKeyframeArrayFloat64, Array<Float64>> {
        get() { ExpressionPropertyInterface<ArrayKeyframeArrayFloat64, Array<Float64>>(transform.s) }
    }

    //TODO：已经执行了，相当于 ExpressionPropertyInterface(x)()
    public prop position: ExpressionValue<AnimatableSplitDimensionPathValue, PointF>  {
        get() {
            return _transformFactory.selfCalling()()
            //if (!transform.p.isNull) {
            //    return _transformFactory()
            //}
            //TODO: 未在 AnimatableTransform 中找到 data.p.s  =>  has_data_p_s = false，暂无 this.px/this.py/this.px。设置成空的。
            //return [
            //  //TODO： _px/_py/_pz 是 ExpressionPropertyInterface。 ExpressionPropertyInterface 调用的返回值是函数 () -> ExpressionValue<T, E>
            //  _px(),
            //  _py(),
            //  _pz ? _pz() : 0]
        }
    }

    //TODO: [TransformProperty]： p 和 px/py/pz 两者存其一, has_data_p_s = false 表示 p 存在，px/py/pz 为空。
    public prop xPosition: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64> {
        get() { ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.px) }
    }

    public prop yPosition: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64> {
        get() { ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.py) }
    }

    public prop zPosition: ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64> {
        get() { ExpressionPropertyInterface<Array<Keyframe<Float64>>, Float64>(transform.pz) }
    }

    public prop anchorPoint: ExpressionPropertyInterface<ArrayKeyframePointF, PointF> {
        get() { ExpressionPropertyInterface<ArrayKeyframePointF, PointF>(transform.a) }
    }

    public prop opacity: ExpressionPropertyInterface<ArrayKeyframeInt64, Int64> {
        get() { ExpressionPropertyInterface<ArrayKeyframeInt64, Int64>(transform.o) }
    }

    public prop skew: ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64> {
        get() { ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64>(transform.sk) }
    }

    public prop skewAxis: ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64> {
        get() { ExpressionPropertyInterface<ArrayKeyframeFloat64, Float64>(transform.sa) }
    }

    //TODO: TransformProperty 中 this.rx/this.ry/this.rz/this.or 为空。
    //public prop orientation: ExpressionPropertyInterface {
    //    get() { ExpressionPropertyInterface(transform.or) }
    //}

}
