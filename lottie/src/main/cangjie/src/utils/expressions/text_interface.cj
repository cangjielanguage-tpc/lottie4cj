/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is TextExpressionInterface.
 */
package lottie.utils.expressions


public class TextExpressionInterface {

    var _prevValue: String = ""
    var _sourceText: SourceText = SourceText()

    //数据来源分析：elem: BaseElement  =>  this.data.ty == 5  =>  elem = CVTextElement/HTextElement/SVGTextLottieElement
    var elem: ITextElement

    public init(elem: ITextElement){
        this.elem = elem
    }

    public func selfCalling(name: String): SourceText {
        if (name == "ADBE Text Document") {
            return this.sourceText
        }
        return SourceText()
    }

    public prop sourceText: SourceText {
        get() {
            //数据来源分析：elem.textProperty => ITextElement.textProperty = new TextProperty(this, data.t, this.dynamicProperties)
            this.elem.textProperty.getValue()
            let stringValue: String = elem.textProperty.currentData.t
            if (stringValue != this._prevValue) {
                this._prevValue = stringValue
                //如果stringValue是一个空字符串，eval将返回undefined，因此它必须作为string基元返回
                this._sourceText.value = stringValue
                this._sourceText.style = SourceTextStyle(fillColor: elem.textProperty.currentData.fc)
                this._sourceText.isNull = false
            }
            return this._sourceText
        }
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
    var isNull: Bool = true
    init(){}
    init(value: String){
        this.value = value
    }
}
