/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is TransformElement.
 */
package lottie4cj.elements

internal import lottie4cj.bezier.*

//TODO: 和 global_data\global_data.cj 中 FinalTransform 冲突了。
public class FinalTransform2 {

    public var mProp: TransformProperty 
    var _matMdf: Bool
    var _opMdf: Bool
    public var mat: Matrix
    
    public init(mProp!: TransformProperty,
        _matMdf!: Bool = false,
        _opMdf!: Bool = false,
        mat!: Matrix = Matrix()
    ) {
        this.mProp = mProp
        this._matMdf = _matMdf
        this._opMdf = _opMdf
        this.mat = mat
    }
}

//cj继承关系：BaseElement <: RenderableDOMElement <: RenderableElement <: TransformElement <: HierarchyElement <: FrameElement
public open class TransformElement <: HierarchyElement {

    //finalTransform 从 TransformElement 移到 HierarchyElement 中。

    public init(data: Layer, globalData: GlobalData) {
        super(data, globalData)
    }

    public func initTransform(data: Layer, globalData: GlobalData): Unit {
        this.data = data
        this.globalData = globalData
        if (!this.data.ks.isNull()) {
            this.finalTransform.mProp = TransformPropertyFactory.getTransformProperty(this.data.ks, globalData, data)
            this.finalTransform.mProp.addDynamicPropertyInElem = this.addDynamicProperty
        }

        if (this.data.ao != 0) {
            this.finalTransform.mProp.autoOriented = true
        }

        // TODO: check TYPE 11: Guided elements
        if (this.data.ty != 11) {
            //TODO: 为什么要注掉？？？ // this.createElements()
        }
    }
    
    public func renderTransform() {
        this.finalTransform._opMdf = this.finalTransform.mProp.o._mdf || this._isFirstFrame
        this.finalTransform._matMdf = this.finalTransform.mProp._mdf || this._isFirstFrame

        if (this.hierarchy.size > 0) {
            let finalMat: Matrix = this.finalTransform.mat
            let len: Int64 = this.hierarchy.size
            //检查层次结构链中的任何变换矩阵是否已更改。
            if (!this.finalTransform._matMdf) {
                for (i in 0..len) {
                    if (this.hierarchy[i].finalTransform.mProp._mdf) {
                        this.finalTransform._matMdf = true
                        break
                    }
                }
            }

            if (this.finalTransform._matMdf) {
                var mat: Array<Float64> = this.finalTransform.mProp.v.props
                finalMat.cloneFromProps(mat)
                for (i in 0..len) {
                    mat = this.hierarchy[i].finalTransform.mProp.v.props
                    finalMat.transform(mat[0], mat[1], mat[2], mat[3], mat[4], mat[5], mat[6], mat[7], mat[8], mat[9], mat[10], mat[11], mat[12], mat[13], mat[14], mat[15])
                }
            }
        }
    }
    
    public func globalToLocal(pt2: Array<Float64>): Array<Float64> {
        var pt: Array<Float64> = pt2
        var transforms: ArrayList<FinalTransform2> =  ArrayList<FinalTransform2>()
        transforms.append(this.finalTransform)

        //TODO：暂未实现。

        let len: Int64 = transforms.size
        var ptNew: Array<Float64> = [0.0, 0.0, 0.0]
        for (i in 0..len) {
            ptNew = transforms[i].mat.applyToPointArray(0.0, 0.0, 0.0)
            pt = [pt[0] - ptNew[0], pt[1] - ptNew[1], 0.0]
        }
        return pt
    }

    //TODO: 和 \src\elements\svg_elements\svg_text_element.cj 成员变量名重复。
    public open func mHelper(): Matrix {
        return Matrix()
    }

}
