/**
 * @file This file is PropertyFactory.
 */
package lottie.property

internal import std.math.*
internal import std.collection.*

internal import lottie.bezier.*
internal import lottie.inner.*
internal import lottie.pool.*

import kit.PerformanceAnalysisKit.Hilog

public type Caching = CachingAtTime

let initialDefaultFrame: Int64 = -999999
let initialDefaultFrameFloat64: Float64 = -999999.0

func defalut_fnc(num: Float64): Float64 {
    return 0.0
}

public class CachingAtTime {

    public var shapeValue: ShapeData
    public var lastIndex: Int64
    public var lastTime: Float64

    public var value: Array<Float64>

    public var lastFrame: Float64
    public var _lastKeyframeIndex: Int64

    public var _lastAddedLength: Float64 = 0.0
    public var _lastPoint: Int64 = 0

    public init(shapeValue!: ShapeData = empty_shapeValue, lastIndex!: Int64 = 0, lastTime!: Float64 = initialDefaultFrameFloat64,
        lastFrame!: Float64 = 0.0, value!: Array<Float64> = empty_Array_Float64, _lastKeyframeIndex!: Int64 = 0
    ){
        this.shapeValue = shapeValue
        this.lastIndex = lastIndex
        this.lastTime = lastTime

        this.lastFrame = lastFrame
        this.value = value
        this._lastKeyframeIndex = _lastKeyframeIndex
    }
}


/*
 * 初始化后需要传入2个函数：
 * 2. renderedFrameInElemComp() => 间接获取 this.elem.comp.renderedFrame 可变的当时的值。
 */
public class PropertyFactory<T, E> <: DynamicPropertyContainer where T <: ToString , E <: ToString {

    static var initFrameFloat64: Float64 = -999999.0
    static var initFrame: Float64 = -999999.0

    public var _placeholder: Bool = false

    var hasGetValueAtTime: Bool = false

    var propertyGroup: PropertyInterface = PropertyInterface()
    public var numKeys: Int64 = 0
    public var _cachingAtTime: CachingAtTime = CachingAtTime()

    /* dataK 是否保存成 E 泛型结构？还是修改保存为 data_k_xxxProperty ??? */
    var dataK_Number: Array<Float64> = empty_Array_Float64
    var dataK_Keyframed: Array<Keyframe<E>> = Array<Keyframe<E>>()
    
    public var data: T
    /*
     * container 在arkts中是多种数据类型，cangjie没有办法完全兼容。
     * 【暂时】保存为两类，一类代表各种 Factory，存在成员变量 container[0]中；一个代表各种 Element，通过操作成员变量 dynamicPropertiesInElem达到效果。
     * 处理方案分为 3 类，参考成员变量 containerType。
     * containerType：1-FrameElement; 2-TransformPropertyFactory; 3-其他Property/DynamicPropertyContainer
     * 间接用 addDynamicPropertyContainer 函数进行分别处理。
     */

    public var mult: Float64 = 1.0
    public var v: Array<Float64> = empty_Array_Float64
    public var pv: Array<Float64> = empty_Array_Float64

    public var k: Bool = false
    var kf: Bool = false
    
    var vel: Array<Float64> = empty_Array_Float64
    var _isFirstFrame: Bool = true
    
    var frameId: Int64 = -1

    var effectsSequence: ArrayList<() -> Array<Float64>> = ArrayList<() -> Array<Float64>>()

    var lock: Bool = false
    var offsetTime: Float64 = 0.0

    public var keyframes: Array<Keyframe<E>> = Array<Keyframe<E>>()
    var keyframesMetadata: Array<KeyframeMetadata> = Array<KeyframeMetadata>()
    var _caching: Caching = Caching()
    
    var sh: Bool = false

    public init(data: T, mult: Float64, container: DynamicPropertyContainer, elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = -1, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ) {
        super(elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        this.compType = compType
        this.compDataInd = compDataInd
        this.getRenderedFrame = renderedFrame
        this.isNull = true
        this.data = data
        this.mult = mult
        this.container = [container]
    }

    public func interpolateValue(frameNum: Float64, caching: Caching) {
        var offsetTime: Float64 = this.offsetTime
        var newValue: Array<Float64> = Array<Float64>()
        /* 移到后面处理？ */
        if (this.propType == "multidimensional") {
            newValue = Array<Float64>(this.pv.size, repeat: 0.0)
        }
        var iterationIndex: Int64 = caching.lastIndex
        var i: Int64 = iterationIndex
        var len: Int64 = this.keyframes.size - 1
        var flag: Bool = true
        var keyData: Keyframe<E> = Keyframe<E>()
        var nextKeyData: Keyframe<E> = Keyframe<E>()
        var keyframeMetadata: KeyframeMetadata = KeyframeMetadata()

        while (flag) {
            keyData = this.keyframes[i]
            nextKeyData = this.keyframes[i + 1]
            if (i == len - 1 && frameNum >= (nextKeyData.t - offsetTime)) {
                if (keyData.h != 0) {
                    keyData = nextKeyData
                }
                iterationIndex = 0
                break
            }
            if ((nextKeyData.t - offsetTime) > frameNum) {
                iterationIndex = i
                break
            }
            if (i < len - 1) {
                i += 1
            } else {
                iterationIndex = 0
                flag = false
            }
        }
        if (this.keyframesMetadata.size > i) {
            keyframeMetadata = this.keyframesMetadata[i]
        } else {
            keyframeMetadata = KeyframeMetadata()
        }

        var kLen: Int64 = 0
        var perc: Float64 = 0.0
        var jLen: Int64 = 0
        var j: Int64 = 0
        var fnc: (Float64) -> Float64 = {n => return n}
        var nextKeyTime: Float64 = nextKeyData.t - offsetTime
        var keyTime: Float64 = keyData.t - offsetTime
        var endValue: Array<Float64> = Array<Float64>()

        let keyData_s: Array<Float64> = if (let Some(v)<- keyData.s) {
            match (v) {
                case w: Float64 => [w]
                case w: Array<Float64> => w
                case w: PointF => [w.x, w.y, 0.0]
                case w: Int64 => [Float64(w)]
                case w: Array<Int64> =>
                    let temp = Array<Float64>(w.size, repeat: 0.0)
                    for(tempIndex in 0..temp.size) {
                        temp[tempIndex] = Float64(w[tempIndex])
                    }
                    temp
                case _ => throw IllegalArgumentException()
            }
        } else {
            Array<Float64>()
        }

        /* 加一层数组越界拦截处理 */
        if (this.pv.size < keyData_s.size && this.propType == "multidimensional") {
            newValue = Array<Float64>(keyData_s.size, repeat: 0.0)
        }


        let keyData_e: Array<Float64> =
        if (let Some(vl) <- keyData.e) {
            match (vl) {
                case w: Float64 => [w]
                case w: Array<Float64> => w
                case w: PointF => [w.x, w.y, 0.0]
                case w: Int64 => [Float64(w)]
                case w: Array<Int64> =>
                    let temp = Array<Float64>(w.size, repeat: 0.0)
                    for(tempIndex in 0..temp.size) {
                        temp[tempIndex] = Float64(w[tempIndex])
                    }
                    temp
                case _ => throw IllegalArgumentException()
            }
        } else {
            Array<Float64>()
        }
        let nextKeyData_s: Array<Float64> =
        if (let Some(vl) <- nextKeyData.s) {
            match (vl) {
                case w: Float64 => [w]
                case w: Array<Float64> => w
                case w: PointF => [w.x, w.y, 0.0]
                case w: Int64 => [Float64(w)]
                case w: Array<Int64> =>
                    let temp = Array<Float64>(w.size, repeat: 0.0)
                    for(tempIndex in 0..temp.size) {
                        temp[tempIndex] = Float64(w[tempIndex])
                    }
                    temp
                case _ => throw IllegalArgumentException()
            }
        } else {
            Array<Float64>()
        }

        if (keyData.to.size != 0) {
            if (keyframeMetadata.bezierData.isNull()) {
                var arr: Array<Float64> = nextKeyData_s
                if (nextKeyData_s.size == 0) {
                    arr = keyData_e
                }
                keyframeMetadata.bezierData = Bez.buildBezierData(keyData_s, arr, keyData.to, keyData.ti)
            }
            var bezierData: BezierData = keyframeMetadata.bezierData
            if (frameNum >= nextKeyTime || frameNum < keyTime) {
                var ind: Int64 = 0
                if (frameNum >= nextKeyTime) { ind = bezierData.points.size - 1 }
                kLen = bezierData.points[ind].point.size
                for (k in 0..kLen) {
                    newValue[k] = bezierData.points[ind].point[k]
                }
            } else {
                if (let Some(val) <- keyframeMetadata.__fnct) {
                    fnc = val
                } else {
                    fnc = BezierFactory.getBezierEasing(keyData.o.x, keyData.o.y, keyData.i.x, keyData.i.y, keyData.n).getOfBezierEasing
                    keyframeMetadata.__fnct = fnc
                }
                perc = fnc((frameNum - keyTime) / (nextKeyTime - keyTime))
                var distanceInLine: Float64 = bezierData.segmentLength * perc

                var segmentPerc: Float64 = 0.0
                var addedLength: Float64 = 0.0
                j = 0
                if (Float64(caching.lastFrame) < frameNum && caching._lastKeyframeIndex == i) {
                    addedLength = caching._lastAddedLength
                    j = caching._lastPoint
                }

                flag = true
                jLen = bezierData.points.size
                while (flag) {
                    addedLength += bezierData.points[j].partialLength
                    if (distanceInLine == 0.0 || perc == 0.0 || j == bezierData.points.size - 1) {
                        kLen = bezierData.points[j].point.size
                        for (k in 0..kLen) {
                            newValue[k] = bezierData.points[j].point[k]
                        }
                        break
                    } else if (distanceInLine >= addedLength && distanceInLine < (addedLength + bezierData.points[j + 1].partialLength)) {
                        segmentPerc = (distanceInLine - addedLength) / bezierData.points[j + 1].partialLength
                        kLen = bezierData.points[j].point.size
                        for (k in 0..kLen) {
                            newValue[k] = bezierData.points[j].point[k] + (bezierData.points[j + 1].point[k] - bezierData.points[j].point[k]) * segmentPerc
                        }
                        break
                    }
                    if (j < jLen - 1) {
                        j += 1
                    } else {
                        flag = false
                    }
                }
                caching._lastPoint = j
                caching._lastAddedLength = addedLength - bezierData.points[j].partialLength
                caching._lastKeyframeIndex = i
            }
        } else {
            var outX: Float64 = 0.0
            var outY: Float64 = 0.0
            var inX: Float64 = 0.0
            var inY: Float64 = 0.0
            var keyValue: Float64 = 0.0
            len = keyData_s.size

            if (nextKeyData_s.size == 0) {
                endValue = keyData_e
            } else {
                endValue = nextKeyData_s
            }

            if (this.sh && keyData.h != 1) {
                if (frameNum >= nextKeyTime) {
                    if (endValue.size > 2) {
                        newValue[0] = endValue[0]
                        newValue[1] = endValue[1]
                        newValue[2] = endValue[2]
                    } else if (endValue.size > 1) {
                        newValue[0] = endValue[0]
                        newValue[1] = endValue[1]
                    } else if (endValue.size == 1) {
                        newValue[0] = endValue[0]
                    }
                } else if (frameNum <= keyTime) {
                    if (keyData_s.size > 2) {
                        newValue[0] = keyData_s[0]
                        newValue[1] = keyData_s[1]
                        newValue[2] = keyData_s[2]
                    } else if (keyData_s.size > 1) {
                        newValue[0] = keyData_s[0]
                        newValue[1] = keyData_s[1]
                    } else if (keyData_s.size == 1) {
                        newValue[0] = keyData_s[0]
                    }
                } else {
                    let quatStart: Array<Float64> = createQuaternion(keyData_s)
                    let quatEnd: Array<Float64> = createQuaternion(endValue)
                    let time: Float64 = (frameNum - keyTime) / (nextKeyTime - keyTime)
                    quaternionToEuler(newValue, slerp(quatStart, quatEnd, time))
                }
            } else {
                for (i in 0..len) {
                    if (keyData.h != 1) {
                        if (frameNum >= nextKeyTime) {
                            perc = 1.0
                        } else if (frameNum < keyTime) {
                            perc = 0.0
                        } else {

                            if (let Some(val) <- keyframeMetadata.__fnct) {
                                fnc = val
                            } else {
                                outX = keyData.o.x
                                outY = keyData.o.y
                                inX = keyData.i.x
                                inY = keyData.i.y
                                /* 因为关键字，BezierFactory.getBezierEasing(outX, outY, inX, inY).get 中 get 重新命名为 getOfBezierEasing */
                                fnc = BezierFactory.getBezierEasing(outX, outY, inX, inY, "").getOfBezierEasing
                                keyData.keyframeMetadata = fnc
                            }
                            perc = fnc((frameNum - keyTime) / (nextKeyTime - keyTime))
                        }
                    }

                    endValue = nextKeyData_s
                    if (nextKeyData_s.size == 0) {
                        endValue = keyData_e
                    }

                    if (keyData.h == 1) {
                        keyValue =  keyData_s[i]
                    } else {
                        keyValue = keyData_s[i] + (endValue[i] - keyData_s[i]) * perc
                    }

                    if (this.propType == "multidimensional") {
                        newValue[i] = keyValue
                    } else {
                        newValue = [keyValue]
                    }
                }
            }
        }
        caching.lastIndex = iterationIndex
        return newValue
    }

    func slerp(a: Array<Float64>, b: Array<Float64>, t: Float64): Array<Float64> {
        let out: Array<Float64> = Array<Float64>(4, repeat: 0.0)
        let ax: Float64 = a[0]
        let ay: Float64 = a[1]
        let az: Float64 = a[2]
        let aw: Float64 = a[3]
        var bx: Float64 = b[0]
        var by: Float64 = b[1]
        var bz: Float64 = b[2]
        var bw: Float64 = b[3]

        var omega: Float64 = 0.0
        var sinom: Float64 = 0.0
        var scale0: Float64 = 0.0
        var scale1: Float64 = 0.0

        var cosom: Float64 = ax * bx + ay * by + az * bz + aw * bw
        if (cosom < 0.0) {
            cosom = -cosom
            bx = -bx
            by = -by
            bz = -bz
            bw = -bw
        }
        if ((1.0 - cosom) > 0.000001) {
            omega = acos(cosom)
            sinom = sin(omega)
            scale0 = sin((1.0 - t) * omega) / sinom
            scale1 = sin(t * omega) / sinom
        } else {
            scale0 = 1.0 - t
            scale1 = t
        }
        out[0] = scale0 * ax + scale1 * bx
        out[1] = scale0 * ay + scale1 * by
        out[2] = scale0 * az + scale1 * bz
        out[3] = scale0 * aw + scale1 * bw

        return out
    }


    func quaternionToEuler(out: Array<Float64>, quat: Array<Float64>): Unit {
        let qx: Float64 = quat[0]
        let qy: Float64 = quat[1]
        let qz: Float64 = quat[2]
        let qw: Float64 = quat[3]
        /**
         * atan2（y，x）求的是y/x的反正切，其返回值为[-pi,+pi]之间的一个数。
         * atan（x）表示求的是x的反正切，其返回值为[-pi/2,+pi/2]之间的一个数。
         */
        let heading: Float64 = atan((2.0 * qy * qw - 2.0 * qx * qz) / (1.0 - 2.0 * qy * qy - 2.0 * qz * qz))
        let attitude: Float64 = asin(2.0 * qx * qy + 2.0 * qz * qw)
        let bank: Float64 = atan((2.0 * qx * qw - 2.0 * qy * qz) / (1.0 - 2.0 * qx * qx - 2.0 * qz * qz))
        out[0] = heading / degToRads
        out[1] = attitude / degToRads
        out[2] = bank / degToRads
    }

    func createQuaternion(values: Array<Float64>): Array<Float64> {
        let heading: Float64 = values[0] * degToRads
        let attitude: Float64 = values[1] * degToRads
        let bank: Float64 = values[2] * degToRads
        let c1: Float64 = cos(heading / 2.0)
        let c2: Float64 = cos(attitude / 2.0)
        let c3: Float64 = cos(bank / 2.0)
        let s1: Float64 = sin(heading / 2.0)
        let s2: Float64 = sin(attitude / 2.0)
        let s3: Float64 = sin(bank / 2.0)
        let w: Float64 = c1 * c2 * c3 - s1 * s2 * s3
        let x: Float64 = s1 * s2 * c3 + c1 * c2 * s3
        let y: Float64 = s1 * c2 * c3 + c1 * s2 * s3
        let z: Float64 = c1 * s2 * c3 - s1 * c2 * s3

        return [x, y, z, w]
    }

    /* 只在 getProp【分支2】相关中使用；data.k是复杂架构，不能是数组或者空。  -- data == ContentModel.s/e/h/a等 */
    func getValueAtCurrentTime(): Array<Float64> {
        let renderedFrameNum: Float64 = this.getRenderedFrameInElemComp(this.compDataInd)
        let frameNum: Float64 = renderedFrameNum - this.offsetTime

        let initTime: Float64 = this.keyframes[0].t - this.offsetTime
        let endTime: Float64 = this.keyframes[this.keyframes.size - 1].t - this.offsetTime
        if (!(frameNum == Float64(this._caching.lastFrame) || (this._caching.lastFrame != Float64(initFrame) &&
            ((Float64(this._caching.lastFrame) >= endTime && frameNum >= endTime) || (this._caching.lastFrame < initTime && frameNum < initTime))))
        ) {
            if (Float64(this._caching.lastFrame) >= frameNum) {
                this._caching._lastKeyframeIndex = -1
                this._caching.lastIndex = 0
            }

            var renderResult = this.interpolateValue(frameNum, this._caching)
            this.pv = renderResult
        }
        this._caching.lastFrame = frameNum
        return this.pv
    }

    func setVValue(val: Array<Float64>): Unit {
        var multipliedValue: Float64 = 0.0
        if (this.propType == "unidimensional") {
            multipliedValue = val[0] * this.mult
            if (abs(this.v[0] - multipliedValue) > 0.00001) {
                this.v[0] = multipliedValue
                this._mdf = true 
            }
        } else {
            let len: Int64 = this.v.size
            for (i in 0..len) {
                multipliedValue = val[i] * this.mult
                if (abs(this.v[i] - multipliedValue) > 0.00001) {
                    this.v[i] = multipliedValue
                    this._mdf = true
                }
            }
        }
    }

    public func getValue(): Unit {
        this.processEffectsSequence()
    }

    func processEffectsSequence(): Unit {
        if (this.elemGlobalData.frameId == this.frameId || this.effectsSequence.size == 0 ) {
            return
        }
        if (this.lock) {
            this.setVValue(this.pv)
            return
        }
        this.lock = true
        this._mdf = this._isFirstFrame
        let len: Int64 = this.effectsSequence.size

        var finalValue: Array<Float64> = this.pv
        if (!this.kf) { /* 当 this.kf = false 时，this.data.k 是【分支1/2】对应的，数据类型是 number/Array<number>。 */
            finalValue = this.dataK_Number
        }
        for (i in 0..len) {
            finalValue = this.effectsSequence[i]()
        }
        this.setVValue(finalValue)
        this._isFirstFrame = false
        this.lock = false
        this.frameId = this.elemGlobalData.frameId
    }

    public func addEffect(effectFunction: () -> Array<Float64>): Unit {
        this.effectsSequence.add(effectFunction)
        this.container[0].addDynamicProperty(this)
    }

    /**
     * 如果函数调用前使用了 new 关键字, 则是调用了构造函数。
     * 这看起来就像创建了新的函数，但实际上 JavaScript 函数是重新创建的对象：
     * 将 ValueProperty/MultiDimensionalProperty/KeyframedValueProperty/KeyframedMultidimensionalProperty数据类型进行合并
     *  =>  此处实现直接返回当前类
     */

    /**
     * 解析后的数据结构和 json 不太一样。实际调用哪个分支，不能按照 arkts 原来的路径直接用。需要在调用 PropertyFactory.getProp 【之前】做一下特殊处理。
     * 这块的数据解析的结构和json有些不一样，要注意对应。（或者修改之前解析封装的结构）
     * 【分支1-变种】: dataK 不是数组，是数值 Int64，进入此分支。
     */
    public static func getProp<T>(data: T, dataK: Int64, mult: Float64, container: DynamicPropertyContainer,
        elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>, containerType!: Int8 = 3,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ): PropertyFactory<T, Int64> where T <: ToString {
        let p: PropertyFactory<T, Int64> = valueProperty(data, Float64(dataK), mult, container, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.containerType = containerType
        if (p.effectsSequence.size != 0) {
            addDynamicPropertyContainer(p)
        }
        getPropInExpressionPropertyDecorator<T, Int64>(p, 1, dataA: dataA, types: types, vLen: vLen)
        return p
    }
    /*【分支1】: dataK 不是数组，是数值/对象，进入此分支。 */
    public static func getProp<T>(data: T, dataK: Float64, mult: Float64, container: DynamicPropertyContainer,
        elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>, containerType!: Int8 = 3,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ): PropertyFactory<T, Float64> where T <: ToString {
        let p: PropertyFactory<T, Float64> = valueProperty(data, dataK, mult, container, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.containerType = containerType
        if (p.effectsSequence.size != 0) {
            addDynamicPropertyContainer(p)
        }
        getPropInExpressionPropertyDecorator<T, Float64>(p, 1, dataA: dataA, types: types, vLen: vLen)
        return p
    }
    
    /* 【分支2-变种】: dataK 是PointF，但是json中是数组 [number, number]，进入此分支。 */
    public static func getProp<T>(data: T, dataK: PointF, mult: Float64, container: DynamicPropertyContainer,
        elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>, containerType!: Int8 = 3,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ): PropertyFactory<T, PointF> where T <: ToString {
        /* 针对json中是[Float64, Float64]，解析后是 PointF的部分。 */
        var p: PropertyFactory<T, PointF> = multiDimensionalProperty(data, [dataK.x, dataK.y, 0.0], mult, container, dataK, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.containerType = containerType
        if (p.effectsSequence.size != 0) {
            addDynamicPropertyContainer(p)
        }
        getPropInExpressionPropertyDecorator<T, PointF>(p, 2, dataA: dataA, types: types, vLen: vLen)
        return p
    }
    /* 【分支2】: dataK 是数组Array<number>，进入此分支。 */
    public static func getProp<T>(data: T, dataK: Array<Float64>, mult: Float64, container: DynamicPropertyContainer,
        elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1,
        dynamicProperties!: ArrayList<DynamicPropertyContainer>, containerType!: Int8 = 3,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(),
        compDataInd!: Int64 = -1
    ): PropertyFactory<T, Array<Float64>> where T <: ToString {
        var p: PropertyFactory<T, Array<Float64>>
        if (dataK.size == 0) {
            p = valueProperty<T, Array<Float64>>(data, 0.0, mult, container, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties)
        } else {
            p = multiDimensionalProperty(data, dataK, mult, container, dataK, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        }
        p.containerType = containerType
        if (p.effectsSequence.size != 0) {
            addDynamicPropertyContainer(p)
        }
        getPropInExpressionPropertyDecorator<T, Array<Float64>>(p, dataK.size, dataA: dataA, types: types, vLen: vLen)
        return p
    }
    
    /*
     *【分支3】:此处传入的 data.k 是一个 Keyframe<E> 对象？？？
     *【分支4】:此处的 data.k 是一个数组Array<Keyframe<T>>
     */
    public static func getProp<T, E>(data: T, dataK: Array<Keyframe<E>>, types: Int64, mult: Option<Float64>,
        container: DynamicPropertyContainer, elemGlobalData: GlobalData, elemData: Layer,
        dataA!: Int64 = 0, vLen!: Int64 = 1, dynamicProperties!: ArrayList<DynamicPropertyContainer>, containerType!: Int8 = 3,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        var vLen2: Int64 = vLen
        var p: PropertyFactory<T, E>
        // let p: PropertyFactory<T, Float64> = valueProperty(data, dataK, mult, container, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        if (dataK[0].k.isSome() && (dataK[0].k.getOrThrow() is Float64)) {
            p = valueProperty<T, E>(data, (dataK[0].k.getOrThrow() as Float64).getOrThrow(), mult, container, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties)
        } else if (dataK[0].k.isSome() && (dataK[0].k.getOrThrow() is Array<Float64>)) {
            p = multiDimensionalProperty<T, E>(data, (dataK[0].k.getOrThrow() as Array<Float64>).getOrThrow(), mult, container,Option<E>.None, elemGlobalData, elemData, types: types, dataA: dataA, vLen: vLen, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        }else {
            if (types == 0) {
                p = keyframedValueProperty<T, E>(data, dataK, mult, container, types, elemGlobalData, elemData, dataA: dataA, vLen: vLen2, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
            } else if (types == 1) {
                p = keyframedMultidimensionalProperty<T, E>(data, dataK, mult, container, types, elemGlobalData, elemData, dataA: dataA, vLen: vLen2, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
                vLen2 = p.v.size
            } else {
                throw Exception("调用分支错误。")
            }
        }
        p.containerType = containerType
        
        if (p.effectsSequence.size != 0) {
            addDynamicPropertyContainer(p)
        }
        getPropInExpressionPropertyDecorator<T, E>(p, dataK.size, dataA: dataA, types: types, vLen: vLen2)
        return p
    }
    
    static func valueProperty<T, E>(data: T, dataK: Float64, mult: Option<Float64>, container: DynamicPropertyContainer,
        elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(data, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.dataK_Number = [dataK]
        p.isNull = false
        
        p.propType = "unidimensional"
        /* 在mults处理中，统一处理了 */
        if (let Some(mult_v) <- mult) {
            if (mult_v == 0.0) {
                p.mult = 1.0
                p.v = [dataK]
            } else {
                p.mult = mult_v
                p.v = [dataK * mult_v]
            }
        } else {
            p.mult = 1.0
            p.v = [dataK]
        }

        p.pv = [dataK]
        p._mdf = false

        p.k = false
        p.kf = false
        p.vel = [0.0]
        p._isFirstFrame = true

        return p
    }
    
    static func multiDimensionalProperty<T, E>(data: T, dataK: Array<Float64>, mult: Option<Float64>, container: DynamicPropertyContainer,
        dataE: Option<E>, elemGlobalData: GlobalData, elemData: Layer,
        types!: Int64 = 0, dataA!: Int64 = 0, vLen!: Int64 = 1, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(data, 0.0, container, elemGlobalData, elemData, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.dataK_Number = dataK
        p.isNull = false
        
        p.propType = "multidimensional"
        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }
        if (p.mult == 0.0) {
            p.mult = 1.0
        }

        p._mdf = false

        p.k = false
        p.kf = false
        p.frameId = -1

        let len: Int64 = dataK.size
        p.v = Array<Float64>(len, repeat: 0.0)
        p.pv = Array<Float64>(len, repeat: 0.0)
        p.vel = Array<Float64>(len, repeat: 0.0)
        var num: Float64 = 0.0
        for (i in 0..len) {
            /* 此处的 dataK 是一个数组Array<number> */
            num = dataK[i]
            p.v[i] = num * p.mult
            p.pv[i] = num
        }

        p._isFirstFrame = true

        return p
    }

    static func keyframedValueProperty<T, E>(data: T, dataK: Array<Keyframe<E>>, mult: Option<Float64>,
        container: DynamicPropertyContainer, types: Int64, elemGlobalData: GlobalData, elemData: Layer,
        dataA!: Int64 = 0, vLen!: Int64 = 1, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(data, 0.0, container, elemGlobalData, elemData, types: types, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.dataK_Keyframed = dataK
        p.isNull = false

        p.propType = "unidimensional"
        /*  此处的 dataK: E 也是 Keyframe<E>类型？？？ */
        p.keyframes = dataK
        p.offsetTime = elemData.st
        p.frameId = -1
        p._caching = Caching(lastFrame: initFrame, lastIndex: 0, value: [0.0], _lastKeyframeIndex: -1)
        p.k = true
        p.kf = true

        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }
        if (p.mult == 0.0) {
            p.mult = 1.0
        }

        p.v = [initFrameFloat64]
        p.pv = [initFrameFloat64]
        p._isFirstFrame = true
        if (types == 0 || types == 1) {
            p.effectsSequence.add(p.getValueAtCurrentTime)
        }
        return p
    }

    static func keyframedMultidimensionalProperty<T, E>(data: T, dataK: Array<Keyframe<E>>, mult: Option<Float64>,
        container: DynamicPropertyContainer, types: Int64, elemGlobalData: GlobalData, elemData: Layer,
        vLen!: Int64 = 1, dataA!: Int64 = 0, dynamicProperties!: ArrayList<DynamicPropertyContainer>,
        compType!: Int8 = 0, renderedFrame!: Array<(Int64) -> Float64> = Array<(Int64) -> Float64>(), compDataInd!: Int64 = -1
    ): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(data, 0.0, container, elemGlobalData, elemData, types: types, dynamicProperties: dynamicProperties, compType: compType, renderedFrame: renderedFrame, compDataInd: compDataInd)
        p.dataK_Keyframed = dataK
        p.isNull = false
        
        p.propType = "multidimensional"

        p.keyframes = dataK
        p.offsetTime = elemData.st
        p.k = true
        p.kf = true
        p._isFirstFrame = true

        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }
        if (p.mult == 0.0) {
            p.mult = 1.0
        }

        p.frameId = -1

        var arrLen = 0
        if (let Some(v) <- dataK[0].s) {
            arrLen = 1
        }
        if (arrLen < vLen) {
            arrLen = vLen
        }
        if (let Some(v) <- dataK[0].s) {
            if(v is Array<Float64>) {
                arrLen = (v as Array<Float64>).getOrThrow().size
            }
        }
        p.v = Array<Float64>(arrLen, repeat: initFrameFloat64)
        p.pv = Array<Float64>(arrLen, repeat: initFrameFloat64)

        p._caching = Caching(lastFrame: initFrame, lastIndex: 0, value: Array<Float64>(arrLen, repeat: 0.0))
        if (types == 0 || types == 1) {
            p.effectsSequence.add(p.getValueAtCurrentTime)
        }
        return p
    }

    /* [扩展中赋值]【ExpressionPropertyDecorator】PropertyFactory.getProp ------------------------------------------- */

    static func getPropInExpressionPropertyDecorator<T, E>(p: PropertyFactory<T, E>, dataKSize: Int64, dataA!: Int64 = 0, types!: Int64 = 0, vLen!: Int64 = 1): Unit where T <: ToString , E <: ToString {
        /* 此时的dataA 是空值，后续排查的时候，需要校验传入data.a的值。 */
        p.numKeys = 0
        if (dataA == 1) {
            p.numKeys = dataKSize
        }
        var len: Int64 = 0
        var value: Array<Float64> = [0.0]
        if (types != 0) {
            len = dataKSize
            if (dataA == 1) {
                len = vLen
            }
            value = Array<Float64>(len, repeat: 0.0)
        }
        p._cachingAtTime.value = value
        if (p.k) {
            addDynamicPropertyContainer(p)
        }

    }

    public static func addDynamicPropertyContainer<T, E>(dp: PropertyFactory<T, E>): Unit where T <: ToString , E <: ToString {
        /*  1-FrameElement; 2-TransformPropertyFactory; 3-其他Property  */
        if (dp.containerType == 2 && dp.container.size == 1) {
            dp.container[0].addDynamicProperty(dp)
        } else if (dp.containerType == 1) {
            dp.addDynamicPropertyInElem(dp)
        } else if (dp.containerType == 3 && dp.container.size == 1){
            dp.container[0].addDynamicProperty(dp)
        }
    }

    public func getValueAtTime(frameNumber: Float64, num: Float64): Array<Float64> {
        this.getValueAtTime(frameNumber)
    }
    public func getValueAtTime(frameNumber: Float64): Array<Float64> {
        if (this.kf) {
            this.getValueAtTimeInExpressionHelpers(frameNumber)
        } else {
            this.getStaticValueAtTime()
        }
    }

    public func setGroupProperty(propertyGroup: PropertyInterface): Unit {
        this.propertyGroup = propertyGroup
    }

    public func getVelocityAtTime(frameNum: Float64): Array<Float64> {
        if (this.vel.size > 1) {
            return this.vel
        }
        var delta: Float64 = -0.001

        var v1: Array<Float64> = this.getValueAtTime(frameNum)
        var v2: Array<Float64> = this.getValueAtTime(frameNum + delta)
        var velocity: Array<Float64> = Array<Float64>(v1.size, repeat: 0.0)
        if (v1.size == 1) {
            velocity = [(v2[0] - v1[0]) / delta]
        } else if (v1.size != 0) {
            for (i in 0..v1.size) {
                /* 删除帧率。如果需要，不要在这里添加 */
                velocity[i] = (v2[i] - v1[i]) / delta
            }
        }
        return velocity
    }

    public func getSpeedAtTime(frameNum: Float64): Float64 {
        let delta: Float64 = -0.01
        /* v1/v2 既可以是数组，也可以是数值。 => 数值按照一个值的数组处理 */
        let v1: Array<Float64> = this.getValueAtTime(frameNum)
        let v2: Array<Float64> = this.getValueAtTime(frameNum + delta)
        var speed: Float64 = 0.0
        if (v1.size == 1) {
            speed = 0.0
        } else if (v1.size != 0) {
            for (i in 0..v1.size) {
                speed += pow(v2[i] - v1[i], 2)
            }
            speed = sqrt(speed) * 100.0
        }
        return speed
    }

    /* getValueAtTime-1-------------------------------------------------------------------------------------------- */

    func getStaticValueAtTime(): Array<Float64> {
        return this.pv
    }
    /* 返回值 既可以是数组，也可以是数值。 => 数值按照一个值的数组处理 */
    public func getValueAtTimeInExpressionHelpers(frameNumber: Float64): Array<Float64> {
        var frameNum: Float64 = frameNumber
        frameNum *= this.elemGlobalData.frameRate
        frameNum -= this.offsetTime
        if (frameNum != Float64(this._cachingAtTime.lastFrame)) {
            this._cachingAtTime.lastIndex = 0
            if (Float64(this._cachingAtTime.lastFrame) < frameNum) {
                return [Float64(this._cachingAtTime.lastIndex)]
            }
            this._cachingAtTime.value = this.interpolateValue(frameNum, this._cachingAtTime)
            this._cachingAtTime.lastFrame = frameNum
        }
        return this._cachingAtTime.value
    }

    /* getValueAtTime-2---------------------------------------------------------------------------------------------- */

    /* PropertyFactory 扩展，增加函数 loopOut/loopIn/smooth。 */
    func loopOut(types2: String, duration2: Int64, durationFlag: Bool): Array<Float64> {
        if (!this.k || this.keyframes.size == 0) {
            return this.pv
        }
        let types: String = types2.toAsciiLower()
        var duration: Int64 = duration2

        var currentFrame: Float64 = this.getRenderedFrameInElemComp(this.compDataInd)

        var keyframes: Array<Keyframe<E>> = this.keyframes
        var lastKeyFrame: Float64 = keyframes[keyframes.size - 1].t
        if (currentFrame <= lastKeyFrame) {
            return this.pv
        }
        var cycleDuration: Float64 = 0.0
        var firstKeyFrame: Float64 = 0.0
        if (!durationFlag) {
            if (duration == 0 || duration > keyframes.size - 1) {
                duration = keyframes.size - 1
            }
            firstKeyFrame = keyframes[keyframes.size - 1 - duration].t
            cycleDuration = lastKeyFrame - firstKeyFrame
        } else {
            if (duration == 0) {
                cycleDuration = max(0.0, lastKeyFrame - this.elemData.ip)
            } else {
                cycleDuration = abs(lastKeyFrame - this.elemGlobalData.frameRate * Float64(duration))
            }
            firstKeyFrame = lastKeyFrame - cycleDuration
        }

        var len: Int64 = 0
        var ret: Array<Float64> = Array<Float64>()
        if (types == "pingpong") {
            var iterations: Int64 = Int64(floor((currentFrame - firstKeyFrame) / cycleDuration))
            if (iterations % 2 != 0) {
                return this.getValueAtTime(((cycleDuration - Float64(Int64(currentFrame - firstKeyFrame) % Int64(cycleDuration)) + firstKeyFrame)) / this.elemGlobalData.frameRate) /*  eslint-disable-line  */
            }
        } else if (types == "offset") {
            let initV: Array<Float64> = this.getValueAtTime(firstKeyFrame / this.elemGlobalData.frameRate)
            let endV: Array<Float64> = this.getValueAtTime(lastKeyFrame / this.elemGlobalData.frameRate)
            let current: Array<Float64> = this.getValueAtTime((Float64(Int64(currentFrame - firstKeyFrame) % Int64(cycleDuration)) + firstKeyFrame) / this.elemGlobalData.frameRate) /*  eslint-disable-line  */
            let repeats: Float64 = floor((currentFrame - firstKeyFrame) / cycleDuration)
            if (this.pv.size != 0) {
                ret = Array<Float64>(initV.size, repeat: 0.0)
                len = ret.size
                for (i in 0..len) {
                    ret[i] = (endV[i] - initV[i]) * repeats + current[i]
                }
                return ret
            }
            return [(endV[0] - initV[0]) * repeats + current[0]]
        } else if (types == "continue") {
            let lastValue: Array<Float64> = this.getValueAtTime(lastKeyFrame / this.elemGlobalData.frameRate)
            let nextLastValue: Array<Float64> = this.getValueAtTime((lastKeyFrame - 0.001) / this.elemGlobalData.frameRate)
            if (this.pv.size != 0) {
                ret = Array<Float64>(lastValue.size, repeat: 0.0)
                len = ret.size
                for (i in 0..len) {
                    ret[i] = lastValue[i] + (lastValue[i] - nextLastValue[i]) * ((currentFrame - lastKeyFrame) / this.elemGlobalData.frameRate) / 0.0005 /*  eslint-disable-line  */
                }
                return ret
            }
            return [lastValue[0] + (lastValue[0] - nextLastValue[0]) * (((currentFrame - lastKeyFrame)) / 0.001)]
        }
        return this.getValueAtTime(((Float64(Int64(currentFrame - firstKeyFrame) % Int64(cycleDuration)) + firstKeyFrame)) / this.elemGlobalData.frameRate) /*  eslint-disable-line  */

    }

    func loopIn(types2: String, duration2: Int64, durationFlag: Bool): Array<Float64> {
        if (!this.k) {
            return this.pv
        }
        let types: String = types2.toAsciiLower()
        var duration: Int64 = duration2

        var currentFrame: Float64 = this.getRenderedFrameInElemComp(this.compDataInd)

        var keyframes: Array<Keyframe<E>> = this.keyframes
        var firstKeyFrame: Float64 = keyframes[0].t
        if (currentFrame >= firstKeyFrame) {
            return this.pv
        }
        var cycleDuration: Float64 = 0.0
        var lastKeyFrame: Float64 = 0.0
        if (!durationFlag) {
            if (duration == 0 || duration > keyframes.size - 1) {
                duration = keyframes.size - 1
            }
            lastKeyFrame = keyframes[duration].t
            cycleDuration = lastKeyFrame - firstKeyFrame
        } else {
            if (duration == 0) {
                cycleDuration = max(0.0, this.elemData.op - firstKeyFrame)
            } else {
                cycleDuration = abs(this.elemGlobalData.frameRate * Float64(duration))
            }
            lastKeyFrame = firstKeyFrame + cycleDuration
        }

        var len: Int64 = 0
        var ret: Array<Float64> = Array<Float64>()
        if (types == "pingpong") {
            var iterations: Int64 = Int64(floor((firstKeyFrame - currentFrame) / cycleDuration))
            if (iterations % 2 == 0) {
                return this.getValueAtTime(((Float64(Int64(firstKeyFrame - currentFrame) % Int64(cycleDuration)) + firstKeyFrame)) / this.elemGlobalData.frameRate) /*  eslint-disable-line  */
            }
        } else if (types == "offset") {
            let initV: Array<Float64> = this.getValueAtTime(firstKeyFrame / this.elemGlobalData.frameRate)
            let endV: Array<Float64> = this.getValueAtTime(lastKeyFrame / this.elemGlobalData.frameRate)
            let current: Array<Float64> = this.getValueAtTime((cycleDuration - Float64(Int64(firstKeyFrame - currentFrame) % Int64(cycleDuration)) + firstKeyFrame) / this.elemGlobalData.frameRate)
            let repeats = floor((firstKeyFrame - currentFrame) / cycleDuration) + 1.0
            if (this.pv.size > 0) {
                ret = Array<Float64>(initV.size, repeat: 0.0)
                len = ret.size
                for (i in 0..len) {
                    ret[i] = current[i] - (endV[i] - initV[i]) * repeats
                }
                return ret
            }
            return [current[0] - (endV[0] - initV[0]) * repeats]
        } else if (types == "continue") {
            let firstValue: Array<Float64> = this.getValueAtTime(firstKeyFrame / this.elemGlobalData.frameRate)
            let nextFirstValue: Array<Float64> = this.getValueAtTime((firstKeyFrame + 0.001) / this.elemGlobalData.frameRate)
            if (this.pv.size > 0) {
                ret = Array<Float64>(firstValue.size, repeat: 0.0)
                len = ret.size
                for (i in 0..len) {
                    ret[i] = firstValue[i] + ((firstValue[i] - nextFirstValue[i]) * (firstKeyFrame - currentFrame)) / 0.001
                }
                return ret
            }
            return [firstValue[0] + ((firstValue[0] - nextFirstValue[0]) * (firstKeyFrame - currentFrame)) / 0.001]
        }
        return this.getValueAtTime(((cycleDuration - (Float64(Int64(firstKeyFrame - currentFrame) % Int64(cycleDuration)) + firstKeyFrame))) / this.elemGlobalData.frameRate) /*  eslint-disable-line  */

    }

    func smooth(width2: Float64, samples2: Float64): Array<Float64> {
        if (!this.k) {
            return this.pv
        }

        var width: Float64 = width2
        if (width2 != 0.0) {
            width2 * 0.5
        } else {
            0.4 * 0.5
        }

        var samples: Float64 = samples2
        if (samples != 0.0) {
            samples = floor(samples)
        } else {
            samples = 5.0
        }

        if (samples <= 1.0) {
            return this.pv
        }

        let currentTime: Float64 = this.getRenderedFrameInElemComp(this.compDataInd) / this.elemGlobalData.frameRate
        let initFrame: Float64 = currentTime - width
        let endFrame: Float64 = currentTime + width

        var sampleFrequency: Float64 = 1.0
        if (samples > 1.0) {
            sampleFrequency = (endFrame - initFrame) / (samples - 1.0)
        }
        var i: Int64 = 0

        var value: Array<Float64> = [0.0]
        if (this.pv.size > 0) {
            value = Array<Float64>(this.pv.size, repeat: 0.0)
        }
        var sampleValue: Array<Float64> = Array<Float64>()
        let len: Int64 = Int64(samples)
        while (i < len) {
            sampleValue = this.getValueAtTime(initFrame + Float64(i) * sampleFrequency)
            if (this.pv.size > 0) {
                for (j in 0..this.pv.size) {
                    value[j] = value[j] + sampleValue[j]
                }
            } else {
                value[0] = value[0] + sampleValue[0]
            }
            i += 1
        }
        if (this.pv.size != 0) {
            for (j in 0..this.pv.size) {
                value[j] = value[j] / samples
            }
        } else {
            value[0] = value[0] / samples
        }
        return value
    }




}
