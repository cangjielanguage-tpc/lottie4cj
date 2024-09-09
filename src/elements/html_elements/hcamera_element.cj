/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is HCameraElement.
 */
package lottie4cj.elements.html_elements

internal import lottie4cj.property.*
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
    public var _isFirstFrame: Bool = true
    public var finalTransform: FinalTransform = FinalTransform()

    public init(data: Layer, globalData: GlobalData) {
        //this.initFrame()
        super(data,globalData)
        this.pe = PropertyFactory<Layer, Float64>.getProp<Layer>(this, data, 0.0, 0.0, DynamicPropertyContainer(this))
        if (data.ks.p.a!=0) {
            this.px = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(this, data.ks.p.x, 1.0, 0.0, DynamicPropertyContainer(this))
            this.py = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(this, data.ks.p.y, 1.0, 0.0, DynamicPropertyContainer(this))
            this.pz = PropertyFactory<Array<Keyframe<Float64>>, Float64>.getProp(this, data.ks.p.z, 1.0, 0.0, DynamicPropertyContainer(this))
        } else {
            this.p = PropertyFactory<AnimatableSplitDimensionPathValue, Float64>.getProp(this, data.ks.p, 1.0, 0.0, DynamicPropertyContainer(this))
        }
        if (!data.ks.a.isNull()) {
            this.a = PropertyFactory<ArrayKeyframePointF, Float64>.getProp(this, data.ks.a, 1.0, 0.0, DynamicPropertyContainer(this))
        }

    }

    public func setup() {
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
        //TODO
    }    

    public func prepareFrame(num: Float64) {
        //TODO
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
}