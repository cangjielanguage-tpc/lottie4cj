/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is MaskManagerInterface.
 */
package utils.expressions

//TODO: 未实现，编译用
public class MaskManagerInterface {

    public var mask: ViewData = ViewData()
    public var data: BaseElement

    /**
     * Create a MaskManagerInterface instance based on the parameter.
     *
     * @param data - Type of BaseElement.
     */
    public init(data: BaseElement) {
        this.data = data
    }

    /**
     * Create a MaskManagerInterface instance based on parameters.
     *
     * @param mask - Type of ViewData.
     * @param data - Type of BaseElement.
     */
    public init(mask: ViewData, data: BaseElement) {
        this.mask = mask
        this.data = data
    }
}

