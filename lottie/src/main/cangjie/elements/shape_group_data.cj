/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
package lottie.elements

internal import lottie.utils.helpers.*
public class ShapeGroupData {

    protected var  it: ArrayList<Object>
    protected var  prevViewData: ArrayList<Object>
    protected var  gr: CreateNS
    public init() {
        this.it = ArrayList<Object>()
        this.prevViewData = ArrayList<Object>()
        this.gr = CreateNS("g")
    }
}