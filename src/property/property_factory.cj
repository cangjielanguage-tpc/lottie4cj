/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is PropertyFactory.
 */
package lottie4cj.property

internal import std.math.*
internal import std.collection.*

internal import lottie4cj.bezier.*
internal import lottie4cj.inner.*
internal import lottie4cj.model.*
internal import lottie4cj.elements.*

let initialDefaultFrame: Int64 = -999999

func defalut_fnc(num: Float64): Float64 {
    return 0.0
}

public class Caching {
    var lastFrame: Int64 = 0
    var lastIndex: Int64 = 0
    //TODO: value 既可以是数组，也可以是数值。
    var value: Array<Float64> = Array<Float64>()
    var _lastKeyframeIndex: Int64 = 0

    var _lastAddedLength: Int64 = 0
    var _lastPoint: Int64 = 0
    
    public init(lastFrame!: Int64 = 0, lastIndex!: Int64 = 0, value!: Array<Float64> = Array<Float64>(), _lastKeyframeIndex!: Int64 = 0){
        this.lastFrame = lastFrame
        this.lastIndex = lastIndex
        this.value = value
        this._lastKeyframeIndex = _lastKeyframeIndex
    }
}

public class PropertyFactory<T, E> where T <: ToString , E <: ToString {

    static var initFrameFloat64: Float64 = -999999.0
    static var initFrame: Int64 = initialDefaultFrame

    //TODO: dataK 是否保存成 E 泛型结构？还是修改保存为 data_k_xxxProperty ???
    var dataK_Number: Array<Float64> = Array<Float64>()
    var dataK_Keyframed: Array<Keyframe<E>> = Array<Keyframe<E>>()
    
    var data: T
    var elem: BaseElement
    //TODO: 暂时没有引入 BaseElement.comp   //var comp: BaseRenderer
    var container: DynamicPropertyContainer
    
    var propType: String = ""
    var mult: Float64 = 1.0
    var v: Array<Float64> = Array<Float64>()
    var pv: Array<Float64> = Array<Float64>()
    
    var _mdf: Bool = false
    var k: Bool = false
    var kf: Bool = false
    
    var vel: Array<Float64> = Array<Float64>()
    var _isFirstFrame: Bool = true
    
    var frameId: Int64 = -1

    var effectsSequence: ArrayList<() -> Array<Float64>> = ArrayList<() -> Array<Float64>>()

    var lock: Bool = false
    var offsetTime: Float64 = 0.0

    var keyframes: Array<Keyframe<E>> = Array<Keyframe<E>>()
    var keyframesMetadata: Array<KeyframeMetadata> = Array<KeyframeMetadata>()
    var _caching: Caching = Caching()
    
    public var isNull: Bool = true
    
    //TODO: 未确认 this.sh 数据类型，为了编译暂定为Bool。
    var sh: Bool = false
    
    //TODO: container 数据类型不固定，是否提取出来一个接口？？？
    // 已知 container 的数据类型：ShapeModifier的子类/ShapePropertyFactory  --都继承于 DynamicPropertyContainer。
    public init(elem: BaseElement, data: T, mult: Float64, container: DynamicPropertyContainer, types!: Int64 = -1) {
        this.elem = elem
        this.data = data
        this.mult = mult
        this.container = container
        //TODO: 暂时没有引入 BaseElement.comp  //this.comp = elem.comp
        
        if (types == 0 || types == 1) {
            this.effectsSequence.append(getValueAtCurrentTime)
        }
    }

    public func interpolateValue(frameNum: Float64, caching: Caching) {
        var offsetTime: Float64 = this.offsetTime
        var newValue: Array<Float64> = Array<Float64>()
        if (this.propType == "multidimensional") {
            newValue = Array<Float64>(this.pv.size, item: 0.0)
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
        }

        var kLen: Int64 = 0
        var perc: Float64 = 0.0
        var jLen: Int64 = 0
        var j: Int64 = 0
        var fnc: (Float64) -> Float64 = defalut_fnc
        var nextKeyTime: Float64 = nextKeyData.t - offsetTime
        var keyTime: Float64 = keyData.t - offsetTime
        var endValue: Array<Float64> = Array<Float64>()

        let keyData_s: Array<Float64> = (keyData.s as Array<Float64>).getOrThrow()
        let keyData_e: Array<Float64> = (keyData.e as Array<Float64>).getOrThrow()
        let nextKeyData_s: Array<Float64> = (nextKeyData.s as Array<Float64>).getOrThrow()

        if (keyData.to.size != 0) { // to: PointF 改为 Array<Float64>
            if (keyframeMetadata.bezierData.isNull()) {
                var arr: Array<Float64> = nextKeyData_s
                if (nextKeyData_s.size == 0) {
                    arr = keyData_e
                }
                keyframeMetadata.bezierData = Bez.buildBezierData()(keyData_s, arr, keyData.to, keyData.ti)
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
                if (let Some(v) <- keyframeMetadata.__fnct) {
                    fnc = v
                } else {
                    fnc = BezierFactory.getBezierEasing(keyData.o.x, keyData.o.y, keyData.i.x, keyData.i.y, keyData.n).getOfBezierEasing
                    keyframeMetadata.__fnct = fnc
                }
                perc = fnc((frameNum - keyTime) / (nextKeyTime - keyTime))
                var distanceInLine: Float64 = Float64(bezierData.segmentLength) * perc

                var segmentPerc: Float64 = 0.0
                var addedLength: Int64 = 0
                if (Float64(caching.lastFrame) < frameNum && caching._lastKeyframeIndex == i) {
                    addedLength = caching._lastAddedLength
                }
                j = 0
                if (Float64(caching.lastFrame) < frameNum && caching._lastKeyframeIndex == i) {
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
                    } else if (distanceInLine >= Float64(addedLength) && distanceInLine < Float64(addedLength + bezierData.points[j + 1].partialLength)) {
                        segmentPerc = (distanceInLine - Float64(addedLength) / Float64(bezierData.points[j + 1].partialLength))
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

            endValue = nextKeyData_s
            if (nextKeyData_s.size == 0) {
                endValue = keyData_e
            }

            //TODO: 未确认 this.sh 数据类型，为了编译暂定为Bool。 
            if (this.sh && keyData.h != 1) {
                if (frameNum >= nextKeyTime) {
                    newValue[0] = endValue[0]
                    newValue[1] = endValue[1]
                    newValue[2] = endValue[2]
                } else if (frameNum <= keyTime) {
                    newValue[0] = keyData_s[0]
                    newValue[1] = keyData_s[1]
                    newValue[2] = keyData_s[2]
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
                            // ??? -- "o":{"x":[0.167],"y":[0.167]}     // Keyframe<T>.o/i = PointF
                            //TODO： 此处的 [0.167] 需要做单独处理吗？？？ if (keyData.o.x.constructor === Array) {......}
                            if (let Some(v) <- keyframeMetadata.__fnct) {
                                fnc = v
                            } else {
                                outX = keyData.o.x
                                outY = keyData.o.y
                                inX = keyData.i.x
                                inY = keyData.i.y
                                //因为关键字， BezierFactory.getBezierEasing(outX, outY, inX, inY).get 中 get 重新命名为 getOfBezierEasing
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

                    keyValue = keyData_s[i] + (endValue[i] - keyData_s[i]) * perc
                    if (keyData.h == 1) {
                        keyValue =  keyData_s[i]
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
        let out: Array<Float64> = Array<Float64>(4, item: 0.0)
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

    //只在 getProp【分支2】相关中使用；data.k是复杂架构，不能是数组或者空。  // data == ContentModel.s/e/h/a等
    func getValueAtCurrentTime(): Array<Float64> {
        //TODO: 暂时没有引入 this.comp   //let frameNum: Float64 = this.comp.renderedFrame - this.offsetTime
        let frameNum: Float64 = 0.0 - this.offsetTime
        let initTime: Float64 = this.keyframes[0].t - this.offsetTime
        let endTime: Float64 = this.keyframes[this.keyframes.size - 1].t - this.offsetTime
        if (!(frameNum == Float64(this._caching.lastFrame) || (this._caching.lastFrame != initFrame &&
            ((Float64(this._caching.lastFrame) >= endTime && frameNum >= endTime) || (Float64(this._caching.lastFrame) < initTime && frameNum < initTime))))
        ) {
            if (Float64(this._caching.lastFrame) >= frameNum) {
                this._caching._lastKeyframeIndex = -1
                this._caching.lastIndex = 0
            }

            var renderResult = this.interpolateValue(frameNum, this._caching)
            this.pv = renderResult
        }
        this._caching.lastFrame = Int64(frameNum)
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
        if (this.elem.globalData.frameId == this.frameId || this.effectsSequence.size == 0 ) {
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
        if (!this.kf) { //当 this.kf = false 时，this.data.k 是【分支1/2】对应的，数据类型是 number/Array<number>。
            finalValue = this.dataK_Number
        }
        for (i in 0..len) {
            //TODO： 确认此处用法。finalValue = this.effectsSequence[i](finalValue)
            finalValue = this.effectsSequence[i]()
        }
        this.setVValue(finalValue)
        this._isFirstFrame = false
        this.lock = false
        this.frameId = this.elem.globalData.frameId
    }

    public func addEffect(effectFunction: () -> Array<Float64>): Unit {
        this.effectsSequence.append(effectFunction)
        // TODO: 暂时不调用 CvShapeData 中 addDynamicProperty 函数   //this.container.addDynamicProperty(this)
    }
    
    /**
     * TODO: 解析后的数据结构和 json 不太一样。实际调用哪个分支，不能按照 arkts 原来的路径直接用。需要在调用 PropertyFactory.getProp 【之前】做一下特殊处理。
     * 这块的数据解析的结构和json有些不一样，要注意对应。（或者修改之前解析封装的结构）
     */
    //【分支1】: dataK 不是数组，是数值/对象，进入此分支。
    public static func getProp<T>(elem: BaseElement, data: T, dataK: Float64, mult: Float64, container: DynamicPropertyContainer): PropertyFactory<T, Float64> where T <: ToString {
        let p: PropertyFactory<T, Float64> = valueProperty(elem, data, dataK, mult, container)
        if (p.effectsSequence.size != 0) {
            //TODO: 暂未确认 addDynamicProperty 调用的是那一级的？？？  //container.addDynamicProperty(p)
        }
        return p
    }
    
    //【分支2-变种】: dataK 是PointF，但是json中是数组 [number, number]，进入此分支。
    public static func getProp<T>(elem: BaseElement, data: T, dataK: PointF, mult: Float64, container: DynamicPropertyContainer): PropertyFactory<T, PointF> where T <: ToString {
        //针对json中是[Float64, Float64]，解析后是 PointF的部分。
        var p: PropertyFactory<T, PointF> = multiDimensionalProperty(elem, data, [dataK.x, dataK.y], mult, container, dataK)
        if (p.effectsSequence.size != 0) {
            //TODO: 暂未确认 addDynamicProperty 调用的是那一级的？？？  //container.addDynamicProperty(p)
        }
        return p
    }
    //【分支2】: dataK 是数组Array<number>，进入此分支。
    public static func getProp<T>(elem: BaseElement, data: T, dataK: Array<Float64>, mult: Float64, container: DynamicPropertyContainer): PropertyFactory<T, Array<Float64>> where T <: ToString {
        var p: PropertyFactory<T, Array<Float64>> = multiDimensionalProperty(elem, data, dataK, mult, container, dataK)
        if (p.effectsSequence.size != 0) {
            //TODO: 暂未确认 addDynamicProperty 调用的是那一级的？？？  //container.addDynamicProperty(p)
        }
        return p
    }
    
    //dataK 是否保存成 E 泛型结构？还是修改保存为 data_k_xxxProperty ??? -- 保存为 data_k_xxxProperty
    //【分支3】://TODO：此处传入的 data.k 是一个 Keyframe<E> 对象？？？
    //【分支4】://此处的 data.k 是一个数组Array<Keyframe<T>>
    public static func getProp<T, E>(elem: BaseElement, data: T, dataK: Array<Keyframe<E>>, types: Int64, mult: Option<Float64>, container: DynamicPropertyContainer): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        var p: PropertyFactory<T, E>
        if (types == 0) {
            p = keyframedValueProperty<T, E>(elem, data, dataK, mult, container, types)
        } else if (types == 1) {
            p = keyframedMultidimensionalProperty<T, E>(elem, data, dataK, mult, container, types)
        } else {
            throw Exception("调用分支错误。")
        }
        
        if (p.effectsSequence.size != 0) {
            //TODO: 暂未确认 addDynamicProperty 调用的是那一级的？？？  //container.addDynamicProperty(p)
        }
        return p
    }
    
    static func valueProperty<T>(elem: BaseElement, data: T, dataK: Float64, mult: Option<Float64>, container: DynamicPropertyContainer): PropertyFactory<T, Float64> where T <: ToString {
        let p: PropertyFactory<T, Float64> = PropertyFactory<T, Float64>(elem, data, 0.0, container)
        p.dataK_Number = [dataK]
        p.isNull = false
        
        p.propType = "unidimensional"
        //在mults处理中，统一处理了
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
            p.v = [dataK * mult_v]
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
    
    static func multiDimensionalProperty<T, E>(elem: BaseElement, data: T, dataK: Array<Float64>, mult: Option<Float64>, container: DynamicPropertyContainer, dataE: E): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(elem, data, 0.0, container)
        p.dataK_Number = dataK
        p.isNull = false
        
        p.propType = "multidimensional"
        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }

        p._mdf = false

        p.k = false
        p.kf = false
        p.frameId = -1

        let len: Int64 = dataK.size
        p.v = Array<Float64>(len, item: 0.0)
        p.pv = Array<Float64>(len, item: 0.0)
        p.vel = Array<Float64>(len, item: 0.0)
        var num: Float64 = 0.0
        for (i in 0..len) {
            //此处的 dataK 是一个数组Array<number>
            num = dataK[i]
            p.v[i] = num * p.mult
            p.pv[i] = num
        }

        p._isFirstFrame = true
        
        return p
    }

    static func keyframedValueProperty<T, E>(elem: BaseElement, data: T, dataK: Array<Keyframe<E>>, mult: Option<Float64>, container: DynamicPropertyContainer, types: Int64): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(elem, data, 0.0, container, types: types)
        p.dataK_Keyframed = dataK
        p.isNull = false
        
        p.propType = "unidimensional"
        //TODO: 此处的 dataK: E 也是 Keyframe<E>类型？？？
        p.keyframes = dataK
        p.offsetTime = elem.data.st
        p.frameId = -1
        p._caching = Caching(lastFrame: initFrame, lastIndex: 0, value: [0.0], _lastKeyframeIndex: -1)
        p.k = true
        p.kf = true

        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }

        p.v = [initFrameFloat64]
        p.pv = [initFrameFloat64]
        p._isFirstFrame = true

        return p
    }

    static func keyframedMultidimensionalProperty<T, E>(elem: BaseElement, data: T, dataK: Array<Keyframe<E>>, mult: Option<Float64>, container: DynamicPropertyContainer, types: Int64): PropertyFactory<T, E> where T <: ToString , E <: ToString {
        let p: PropertyFactory<T, E> = PropertyFactory<T, E>(elem, data, 0.0, container, types: types)
        p.dataK_Keyframed = dataK
        p.isNull = false
        
        p.propType = "multidimensional"

        p.keyframes = dataK
        p.offsetTime = elem.data.st
        p.k = true
        p.kf = true
        p._isFirstFrame = true

        p.mult = 1.0
        if (let Some(mult_v) <- mult) {
            p.mult = mult_v
        }

        p.frameId = -1

        var arrLen = 0
        if (let Some(v) <- dataK[0].s) {
            arrLen = 1
        }
        p.v = Array<Float64>(arrLen, item: initFrameFloat64)
        p.pv = Array<Float64>(arrLen, item: initFrameFloat64)

        p._caching = Caching(lastFrame: initFrame, lastIndex: 0, value: Array<Float64>(arrLen, item: 0.0))
        
        return p
    }

}
