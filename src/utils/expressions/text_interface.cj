/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is TextExpressionInterface.
 */
package utils.expressions


public class TextExpressionInterface {

    /**
     * lottieArkTS原理：
     * 1. LayerExpressionInterface初始化自动，返回，函数 [inside-1]。     (inside-1 的函数类型为 (elem) -> (name) -> Option<>)
     * 2. 执行函数 inside-1，自动返回，函数 [inside-2]。                  (inside-2 的函数类型为 (name) -> Option<>)
     *
     * cangjie原理：
     * 1. TextExpressionInterface初始化，再返回该实例的selfCalling函数（即函数 inside-1）
     * 2. 执行 TextExpressionInterface.selfCalling 函数（即函数 inside-1），返回 ThisLayerFunctionText 类（即函数 inside-2 的类结构，具体执行时调用其selfCalling函数）
     */
    public func selfCalling(elem: ITextElement): ThisLayerFunctionText {  //此行函数名称 inside-1，函数类型为 (elem) -> (name) -> Option<>
        let _thisLayerFunction = ThisLayerFunctionText(elem, this)
        /**
         * 1.返回的_thisLayerFunction是函数，但同时具备对象功能。
         * 2.此处返回对象，需要执行函数时，调用ThisLayerFunctionText.selfCalling(name)
         *
         * _thisLayerFunction.selfCalling 函数，就是对应的 inside-2 函数，其函数类型为 (name: String) -> Option<SourceText>
         */
        return _thisLayerFunction
    }

}

class SourceTextStyle {
    var fillColor: Array<Float64> = Array<Float64>()
    init(fillColor!: Array<Float64> = Array<Float64>()){
        this.fillColor = fillColor
    }
}

public class SourceText {
    var value: String = ""
    var style: SourceTextStyle = SourceTextStyle()
    init(){}
}

public class ThisLayerFunctionText {

    var _prevValue: String = ""
    var _sourceText: SourceText = SourceText()

    var elem: ITextElement
    var textExpressionInterface: TextExpressionInterface

    init(elem: ITextElement, textExpressionInterface: TextExpressionInterface) {
        this.elem = elem
        this.textExpressionInterface = textExpressionInterface
    }

    public prop sourceText: SourceText {
        get() {
            elem.textProperty.getValue()
            //TODO: 此处的 elem.textProperty == TextProperty 未完全实现
            var stringValue: String = elem.textProperty.currentData.t
            if (stringValue != _prevValue) {
                //TODO: 此处的 elem.textProperty == TextProperty 未完全实现
                _prevValue = elem.textProperty.currentData.t
                _sourceText.value = stringValue
                //TODO: 此处的 elem.textProperty == TextProperty 未完全实现
                _sourceText.style = SourceTextStyle(fillColor: elem.textProperty.currentData.fc)
            }
            return _sourceText
        }
    }

    public func selfCalling(name: String): Option<SourceText> {
        if (name == "ADBE Text Document") {
            return this.sourceText
        }
        return None
    }

}
