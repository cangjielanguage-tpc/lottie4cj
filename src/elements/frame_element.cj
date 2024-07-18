/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import std.collection.*
public class FrameElement {

    protected var _isFirstFrame: Bool = false
    protected var dynamicProperties: ArrayList<Object> = ArrayList<Object>()
    protected var _mdf: Bool= false
    
    public func initFrame() {
        // set to true when inpoint is rendered
        this._isFirstFrame = false
        // list of animated properties
        this.dynamicProperties = ArrayList<Object>()
        // If layer has been modified in current tick this will be true
        this._mdf = false
    }

    public func prepareProperties(num: Int64, isVisible: Bool) {
        var len = this.dynamicProperties.size
        for (i in 0..len) {
            //TODO
        }
    }

    public func addDynamicProperty(props: Object) {
        var hasPro: Bool = false
        for(pro in this.dynamicProperties) {
            if(refEq(pro, props)) {
                hasPro = true
                break
            }
        }
        if (!hasPro) {
            this.dynamicProperties.append(props)
        }
    }
}
