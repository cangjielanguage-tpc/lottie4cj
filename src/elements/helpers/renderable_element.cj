/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.elements.helpers

import lottie4cj.global_data.*
import lottie4cj.model.*
import std.collection.*

//TODO
public class RenderableElement{

    public var isInRange: Bool
    public var hidden: Bool
    public var isTransparent: Bool
    public var _mdf: Bool = false
    public var renderableComponents: ArrayList<Object>
    
    public var data: Layer
    public var globalData: GlobalData
    public var finalTransform: FinalTransform

    public init(data: Layer, globalData: GlobalData, finalTransform: FinalTransform) {
        // layer's visibility related to inpoint and outpoint. Rename isVisible to isInRange
        this.isInRange = false
        // layer's display state
        this.hidden = false
        // If layer's transparency equals 0, it can be hidden
        this.isTransparent = false
        // list of animated components
        this.renderableComponents = ArrayList<Object>()
        this.data = data
        this.globalData = globalData
        this.finalTransform = finalTransform
    }

    public func addRenderableComponent(component: Object) {
        if (indexOf(component,this.renderableComponents) == -1) {
            this.renderableComponents.append(component)
        }
    }

    public func removeRenderableComponent(component: Object) {
        if (indexOf(component,this.renderableComponents) != -1) {
            this.renderableComponents.remove(indexOf(component,this.renderableComponents))
        }
    }

    public func prepareRenderableFrame(num: Float64) {
        this.checkLayerLimits(num)
    }

    public func checkTransparency() {
        if (this.finalTransform.mProp.o.v <= 0) {
            if (!this.isTransparent && this.globalData.renderConfig.hideOnTransparent) {
                this.isTransparent = true
                //this.hide()
            }
        } else if (this.isTransparent) {
            this.isTransparent = false
            //this.show()
        }
    }

    public func checkLayerLimits(num: Float64) {
        if (this.data.ip - this.data.st <= num && this.data.op - this.data.st > num) {
            if (this.isInRange != true) {
                this.globalData._mdf = true
                this._mdf = true
                this.isInRange = true
                //this.show()
            }
        } else if (this.isInRange != false) {
            this.globalData._mdf = true
            this.isInRange = false
            //this.hide()
        }
    }  

    public func renderRenderable() {
        var len = this.renderableComponents.size
        for (i in 0..len) {
            //this.renderableComponents[i].renderFrame(this._isFirstFrame)
        }
    }

    public func sourceRectAtTime() {
        return SourceRect(top: 0, left: 0,  width: 100,  height: 100)
    }

    public func getLayerSize() {
        // if (this.data.ty == 5) {
        //     return CompSize( w: this.data.textData.width, h: this.data.textData.height )
        // }
        // return CompSize( w: this.data.width, h: this.data.height )
    }

}
