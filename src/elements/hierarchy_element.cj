/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */
package lottie4cj.elements

internal import std.collection.*
public class HierarchyElement {

    protected var _isParent: Bool = false
    protected var hierarchy: ArrayList<Object> = ArrayList<Object>()

    public func initHierarchy() {
        this.hierarchy = ArrayList<Object>()
        // if element is parent of another layer _isParent will be true
        this._isParent = false
        this.checkParenting()
    }

    public func setHierarchy(hierarchy: ArrayList<Object>) {
        this.hierarchy = hierarchy
    }

    public func setAsParent() {
        this._isParent = true;
    }

    public func checkParenting() {
        //TODO
    }
}