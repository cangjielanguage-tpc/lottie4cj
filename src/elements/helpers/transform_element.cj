/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.helpers

import lottie4cj.global_data.*
import lottie4cj.model.*
import lottie4cj.bezier.*
import std.collection.*

//TODO
public class TransformElement{

    public var _isFirstFrame: Bool = false
    public var data: Layer
    public var globalData: GlobalData
    public var finalTransform: FinalTransform
    public var hierarchy: Array<TransformElement> = Array<TransformElement>()
    

    public init(data: Layer, globalData: GlobalData) {
        this.data = data
        this.globalData = globalData
        this.finalTransform = FinalTransform()
        if (this.data.ao != 0) {
            this.finalTransform.mProp.autoOriented = true
        }
        if (this.data.ty != 11) {
            // this.createElements()
        }
    }


    
    public func renderTransform(){
        this.finalTransform._opMdf = this.finalTransform.mProp.o._mdf || this._isFirstFrame
        this.finalTransform._matMdf = this.finalTransform.mProp._mdf || this._isFirstFrame
        if (!this.hierarchy.isEmpty()) {
            var mat: Array<Float64> = Array<Float64>()
            var finalMat = this.finalTransform.mat
            var i = 0
            var len = this.hierarchy.size
            // Checking if any of the transformation matrices in the hierarchy chain has changed.
            if (!this.finalTransform._matMdf) {
                while (i < len) {
                    if (this.hierarchy[i].finalTransform.mProp._mdf) {
                        this.finalTransform._matMdf = true
                        break
                    }
                    i += 1
                }
            }

            if (this.finalTransform._matMdf) {
                mat = this.finalTransform.mProp.v.props
                finalMat.cloneFromProps(mat)
                for (i in 0..len) {
                    mat = this.hierarchy[i].finalTransform.mProp.v.props
                    finalMat.transform(mat[0], mat[1], mat[2], mat[3], mat[4], mat[5], mat[6], mat[7], mat[8], mat[9], mat[10], mat[11], mat[12], mat[13], mat[14], mat[15])
                }
            }
        }
    }

    public func globalToLocal(pts: Array<Float64>) {
        var pt = pts
        var transforms = ArrayList<FinalTransform>()
        transforms.append(this.finalTransform)
        var flag = true
        //TODO comp
        var len = transforms.size
        var ptNew: (Float64,Float64,Float64)
        for (i in 0..len) {
            ptNew = transforms[i].mat.applyToPointArray(0.0, 0.0, 0.0)
            // ptNew = transforms[i].mat.applyToPointArray(pt[0],pt[1],pt[2])
            pt = [pt[0] - ptNew[0], pt[1] - ptNew[1], 0.0]
        }
        return pt
    }
}