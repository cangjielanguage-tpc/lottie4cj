/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package elements.svg_elements

from std import collection.*
import utils.*
import model.*
import global_data.*
import utils.helpers.*
import elements.*

//TODO: 未完全实现
public open class SVGCompElement  {

    public var data: Layer

    public var globalData: GlobalData

    
    public init(data: Layer, globalData: GlobalData) {
        this.data = data
        this.globalData = globalData
    }
}