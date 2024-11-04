/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie.elements

internal import lottie.bezier.*

public class CvContextData {

    private var saved: Array<Array<Float64>>
    private var cArrPos: Int64
    private var cTr: Matrix
    private var cO: Float64
    private var _length: Int64
    private var savedOp: Array<Float64>

    public init() {
        this.cArrPos = 0
        this.cTr = Matrix()
        this.cO = 1.0
        var len: Int64 = 15
        this.saved = Array<Array<Float64>>(len, item: [])
        this.savedOp = Array<Float64>(len,item: 0.0)
        for (i in 0..len) {
            this.saved[i] = Array<Float64>(16,item: 0.0)
        }
        this._length = len
    }

    public func duplicate() {
        var newLength = this._length * 2
        var currentSavedOp = this.savedOp.clone()
        this.savedOp = Array<Float64>(newLength,item: 0.0)
        currentSavedOp.copyTo(this.savedOp, 0, 0, currentSavedOp.size)
        var currentSaved = this.saved.clone()
        this.saved = Array<Array<Float64>>(newLength, item: [])
        currentSaved.copyTo(this.saved, 0, 0, currentSaved.size)
        for (i in this._length..newLength) {
            this.saved[i] = Array<Float64>(16,item: 0.0)
        }
        this._length = newLength
    }

    public func reset() {
        this.cArrPos = 0
        this.cTr.reset()
        this.cO = 1.0
    }

    public func popTransform(): Array<Float64> {
        var popped = this.saved[this.cArrPos]
        var arr = this.cTr.props
        for (i in 0..16) {
            arr[i] = popped[i]
        }
        return popped
    }

    public func popOpacity(): Float64 {
        var popped = this.savedOp[this.cArrPos]
        this.cO = popped
        return popped
    }

    public func pop(): (Array<Float64>, Float64) {
        this.cArrPos -= 1
        var transform = this.popTransform()
        var opacity = this.popOpacity()
        return (transform,opacity)
    }

    public func push() {
        //TODO: [45] TransformElement.renderTransform 中 this.finalTransform.mProp.v.props 的值不正确。
        //TODO: [45] 暂未处理，测试先赋正确的值。
        //this.cTr.props[12] = -0.7269230484962463
        //this.cTr.props[13] = 42.93653869628906


        var props = this.cTr.props
        if (this._length <= this.cArrPos) {
            this.duplicate()
        }
        var arr = this.saved[this.cArrPos]
        for (i in 0..16) {
            arr[i] = props[i]
        }
        this.savedOp[this.cArrPos] = this.cO
        this.cArrPos += 1
    }

    public func getTransform(): Matrix {
        return this.cTr
    }

    public func getOpacity(): Float64 {
        return this.cO
    }

    public func setOpacity(value: Float64) {
        this.cO = value
    }

}


