/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is CompExpressionInterface.
 */
package utils.expressions


public class CompExpressionInterface {

    /**
     * lottieArkTS原理：
     * 1. LayerExpressionInterface初始化自动，返回，函数 [inside-1]。     (inside-1 的函数类型为 (elem) -> (name) -> Option<>)
     * 2. 执行函数 inside-1，自动返回，函数 [inside-2]。                  (inside-2 的函数类型为 (name) -> Option<>)
     *
     * cangjie原理：
     * 1. CompExpressionInterface初始化，再返回该实例的selfCalling函数（即函数 inside-1）
     * 2. 执行 CompExpressionInterface.selfCalling 函数（即函数 inside-1），返回 ThisLayerFunctionComp 类（即函数 inside-2 的类结构，具体执行时调用其selfCalling函数）
     */
    public func selfCalling(comp: ICompElement): (String) -> Option<LayerExpressionInterface> {  //此行函数名称 inside-1，函数类型为 (comp) -> (name) -> Option<>
        let _thisLayerFunction = ThisLayerFunctionComp(comp, this)
        /**
         * 1.返回的_thisLayerFunction是函数，但同时具备对象功能。
         * 2.此处返回对象，需要执行函数时，调用ThisLayerFunctionComp.selfCalling(name)
         *
         * _thisLayerFunction.selfCalling 函数，就是对应的 inside-2 函数，其函数类型为 (name) -> Option<>
         */
        return _thisLayerFunction.selfCalling
    }

}

public class ThisLayerFunctionComp {

    var pixelAspect: Int64 = 1
    var height: Float64 = 0.0
    var width: Float64 = 0.0
    var frameDuration: Float64 = 0.0
    var displayStartTime: Int64 = 0
    var numLayers: Int64

    var comp: ICompElement
    var compExpressionInterface: CompExpressionInterface

    init(comp: ICompElement, compExpressionInterface: CompExpressionInterface) {
        this.comp = comp
        this.compExpressionInterface = compExpressionInterface

        this.height = comp.globalData.compSize.h
        if (comp.data.h != 0.0) {
            this.height = comp.data.h
        }

        this.width = comp.globalData.compSize.w
        if (comp.data.w != 0.0) {
            this.width = comp.data.w
        }

        this.frameDuration = 1.0 / comp.globalData.frameRate
        this.numLayers = comp.layers.size
    }

    public prop _name: String {
        get() { return comp.data.nm }  //BaseElement.data = Layer
    }

    public func selfCalling(name: String): Option<LayerExpressionInterface> {
        let len: Int64 = comp.layers.size
        for (i in 0..len) {
            if (comp.layers[i].nm == name || comp.layers[i].ind.toString() == name) {
                //TODO: 未实现 BaseElement.layerInterfac(LayerExpressionInterface) //return comp.elements[i].layerInterface
                return None
            }
        }
        return None
    }

}
