/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is HCameraElement.
 */
package lottie4cj.elements.html_elements

internal import lottie4cj.property.*
internal import lottie4cj.property.PropertyFactory
internal import lottie4cj.property.DynamicPropertyContainer
internal import lottie4cj.elements.*
internal import lottie4cj.inner.*
public class HCameraElement <: BaseElement{

    public var pe: ?PropertyFactory<Layer, Float64> = None
    public var px: ?PropertyFactory<Array<Keyframe<Float64>>, Float64> = None
    public var py: ?PropertyFactory<Array<Keyframe<Float64>>, Float64> = None
    public var pz: ?PropertyFactory<Array<Keyframe<Float64>>, Float64> = None
    public var p: ?PropertyFactory<AnimatableSplitDimensionPathValue, Float64> = None
    public var a: ?PropertyFactory<ArrayKeyframePointF, Float64> = None
    public var mat: Matrix = Matrix()
    public var _prevMat: Matrix = Matrix()

    //TODO: 和 \src\elements\helpers\transform_element.cj 中 FinalTransform 冲突了。
    public var or: ?PropertyFactory<Float64, Float64> = None
    public var rx: ?PropertyFactory<Float64, Float64> = None
    public var ry: ?PropertyFactory<Float64, Float64> = None
    public var rz: ?PropertyFactory<Float64, Float64> = None

    //单继承 先使用 HierarchyElement类型的 this.hierarchyElement.hierarchy 来替代调用 this.hierarchy
    protected var hierarchyElement: HierarchyElement

    public init(data: Layer, globalData: GlobalData) {
        //this.initFrame()
        super(data,globalData)
        this.hierarchyElement = HierarchyElement(this.data,this.globalData)
        this._isFirstFrame = true
        this.pe = PropertyFactory<Layer, Float64>.getProp<Layer>(data, 0.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
        if (data.ks.p.a!=0) {
            this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.ks.p.x, 1.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
            this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.ks.p.y, 1.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
            this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(data.ks.p.z, 1.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
        } else {
            this.p = PropertyFactory<AnimatableSplitDimensionPathValue, Float64>.getProp(data.ks.p, 1.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
        }
        if (!data.ks.a.isNull()) {
            this.a = PropertyFactory<ArrayKeyframePointF, Float64>.getProp(data.ks.a, 1.0, 0.0, DynamicPropertyContainer(globalData, data), globalData, data)
        }
        // 未实现 data.ks.or ，data.ks.rx，data.ks.ry，data.ks.rz
        this.or = PropertyFactory<Float64, Float64>.getProp(data.sr, 1.0, degToRads, DynamicPropertyContainer(globalData, data), globalData, data)
        this.or.getOrThrow().sh = true;
        this.rx = PropertyFactory<Float64, Float64>.getProp(data.sr, 0.0, degToRads, DynamicPropertyContainer(globalData, data), globalData, data)
        this.ry = PropertyFactory<Float64, Float64>.getProp(data.sr, 0.0, degToRads, DynamicPropertyContainer(globalData, data), globalData, data)
        this.rz = PropertyFactory<Float64, Float64>.getProp(data.sr, 0.0, degToRads, DynamicPropertyContainer(globalData, data), globalData, data)

    }

    public func setup() {
        // 未使用 this.comp.
        var len = this.mat.props.size
        var perspectiveStyle: PerspectiveStyle = PerspectiveStyle()
        var containerStyle: ContainerStyle = ContainerStyle()
        for (i in 0..len) {
            if (this.pe.isSome()) {
                var perspective = "${this.pe.getOrThrow().v.toString()}" + "px"
                var origin = "0px 0px 0px"
                var matrix = "matrix3d(1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1)"
                perspectiveStyle.perspective = perspective
                perspectiveStyle.webkitPerspective = perspective
                containerStyle.transformOrigin = origin
                containerStyle.mozTransformOrigin = origin
                containerStyle.webkitTransformOrigin = origin
                perspectiveStyle.transform = matrix
                perspectiveStyle.webkitTransform = matrix
            }
        }
    }  

    public func createElements(){}    

    public func hide(){}    

    public func renderFrame(){
        var _mdf = this._isFirstFrame
        var len: Int64 = 0
        if (this.hierarchyElement.hierarchy.size > 0) {
            len = this.hierarchyElement.hierarchy.size
            for (i in 0..len) {
                _mdf = this.hierarchyElement.hierarchy[i].finalTransform.mProp._mdf || _mdf
            }
        }
        if (_mdf || this.pe.getOrThrow()._mdf || (this.p.isSome() && this.p.getOrThrow()._mdf) || (this.px.isSome() && (this.px.getOrThrow()._mdf || this.py.getOrThrow()._mdf || this.pz.getOrThrow()._mdf)) || this.rx.getOrThrow()._mdf || this.ry.getOrThrow()._mdf || this.rz.getOrThrow()._mdf || this.or.getOrThrow()._mdf || (this.a.isSome() && this.a.getOrThrow()._mdf)) {
            this.mat.reset()

            if (this.hierarchyElement.hierarchy.size>0) {
                len = this.hierarchyElement.hierarchy.size - 1
                var i = len
                while (i >= 0) {
                    var mTransf = this.hierarchyElement.hierarchy[i].finalTransform.mProp;
                    this.mat.translate(-mTransf.p.v[0], -mTransf.p.v[1],tz:mTransf.p.v[2]);
                    this.mat.rotateX(-mTransf.or.v[0]).rotateY(-mTransf.or.v[1]).rotateZ(mTransf.or.v[2]);
                    this.mat.rotateX(-mTransf.rx.v[0]).rotateY(-mTransf.rx.v[0]).rotateZ(mTransf.rx.v[0]);
                    this.mat.scale(1.0 / mTransf.s.v[0], 1.0 / mTransf.s.v[1], sz:1.0 / mTransf.s.v[2]);
                    this.mat.translate(mTransf.a.v[0], mTransf.a.v[1], tz:mTransf.a.v[2]);
                    i -= 1
                }
            }
            if (this.p.isSome()) {
                this.mat.translate(-this.p.getOrThrow().v[0], -this.p.getOrThrow().v[1], tz:this.p.getOrThrow().v[2]);
            } else {
                this.mat.translate(-this.px.getOrThrow().v[0], -this.py.getOrThrow().v[0], tz:this.pz.getOrThrow().v[0]);
            }
            if (this.a.isSome()) {
                var diffVector: Array<Float64>
                if (this.p.isSome()) {
                    diffVector = [this.p.getOrThrow().v[0] - this.a.getOrThrow().v[0], this.p.getOrThrow().v[1] - this.a.getOrThrow().v[1], this.p.getOrThrow().v[2] - this.a.getOrThrow().v[2]];
                } else {
                    diffVector = [this.px.getOrThrow().v[0] - this.a.getOrThrow().v[0], this.py.getOrThrow().v[1] - this.a.getOrThrow().v[1], this.pz.getOrThrow().v[2] - this.a.getOrThrow().v[2]];
                }
                var mag = sqrt(pow(diffVector[0], 2) + pow(diffVector[1], 2) + pow(diffVector[2], 2));
                var lookDir = [diffVector[0] / mag, diffVector[1] / mag, diffVector[2] / mag];
                var lookLengthOnXZ = sqrt(lookDir[2] * lookDir[2] + lookDir[0] * lookDir[0]);
                var mRotationX = atan(lookDir[1]/lookLengthOnXZ)
                var mRotationY = atan(lookDir[0]/-lookDir[2])
                this.mat.rotateY(mRotationY).rotateX(-mRotationX);
            }
            this.mat.rotateX(-this.rx.getOrThrow().v[0]).rotateY(-this.ry.getOrThrow().v[0]).rotateZ(this.rz.getOrThrow().v[0]);
            this.mat.rotateX(-this.or.getOrThrow().v[0]).rotateY(-this.or.getOrThrow().v[1]).rotateZ(this.or.getOrThrow().v[2]);
            this.mat.translate(this.globalData.compSize.w / 2.0, this.globalData.compSize.h / 2.0, tz:0.0);
            this.mat.translate(0.0, 0.0, tz:this.pe.getOrThrow().v[0]);

            var hasMatrixChanged = !this._prevMat.equals(this.mat);
            // 暂时未实现 this.comp.threeDElements
            if (hasMatrixChanged || this.pe.getOrThrow()._mdf) {
                // 未使用 this.comp
                var len = this.mat.props.size
                var perspectiveStyle: PerspectiveStyle = PerspectiveStyle()
                var containerStyle: ContainerStyle = ContainerStyle()
                for (i in 0..len) {
                    if (this.pe.isSome()) {
                        if (hasMatrixChanged) {
                            var matValue = this.mat.toCSS()
                            containerStyle.transform = matValue;
                            containerStyle.webkitTransform = matValue;
                        }
                        if (this.pe.getOrThrow()._mdf) {
                            perspectiveStyle.perspective = "${this.pe.getOrThrow().v}" + "px"
                            perspectiveStyle.webkitPerspective = "${this.pe.getOrThrow().v}" + "px"
                        }
                    }
                }
                this.mat.clone(this._prevMat);
            }
        }
        this._isFirstFrame = false;
    }    

    public func prepareFrame(num: Int64) {
        this.prepareProperties(num, true)
    }

    public func destroy(){}

    public func getBaseElement(): Option<BaseElement> {
        return None
    }

}

public class PerspectiveStyle {
    var perspective: String = ""    
    var webkitPerspective: String = ""    
    var transform: String = ""    
    var webkitTransform: String = ""    
}

public class ContainerStyle {
    var transformOrigin: String = ""    
    var mozTransformOrigin: String = ""    
    var webkitTransformOrigin: String = ""  
    var transform: String = ""  
    var webkitTransform: String = ""  
}