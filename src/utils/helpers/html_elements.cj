/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

package lottie4cj.utils.helpers

/**
 * 合计18个
 * 'span'   - 4
 * 'div'    - 7
 * 'canvas' - 2
 * 'link'   - 2
 * 'style'  - 1
 */
public open class CreateTag {
    public var types: String = ""
    public var innerText: String = ""

    //TODO: style 和 styles 在 arkts 中是同一个成员变量。但是因为数据类型同时具备 Object 和 HashMap<String, String>情况，拆成两个？？？
    //TODO：style 和 styles 需要进行合并处理吗？？？后续赋值/使用等会受影响？？？
    public var styles: HashMap<String, String> = HashMap<String, String>()
    public var style: TagStyle = TagStyle()

    /**
     * Create a CreateTag instance based on the parameter.
     *
     * @param types - Type of String.
     */
    public init(types: String) {
        this.types = types
    }

    //TODO: 未实现
    public func appendChild(n: CreateTag) { }
    public func appendChild(n: CreateNS) { }
    public open func setAttribute(k: String, v: String) { }
    func getContext(s: String) { }
}

public class TagStyle {
    public var fontFamily: String = ""
    public var fontSize: String = ""  //'300px'
    var fontVariant: String = "" //'normal'
    public var fontStyle: String = ""   //'normal'
    public var fontWeight: String = ""  //'normal'

    public var position: String = ""    //'absolute'
    public var left: Int64 = 0          //'-10000px'
    public var top: Int64 = 0           //'-10000px'
    var letterSpacing = "absolute"  //字间距
    public var transform = ""  
    public var webkitTransform = "" 
    public var opacity = 0  
    public var fill = ""
    public var color = ""
    public var stroke = ""
    public var strokeWidth = ""
    public var lineHeight = ""
    public var display = ""
    public var width = ""
    public var height = ""
    public var backgroundColor = ""
    public var transformOrigin = ""
    public var webkitTransformOrigin = ""
    public var backfaceVisibility = ""
    public var webkitBackfaceVisibility = ""
    public var transformStyle = ""
    public var webkitTransformStyle = ""
    public var mozTransformStyle = ""

}

class FontManagerNode {
    var node: CreateTag
    var w: Int64
    var parent: CreateTag
    init(node!: CreateTag, w!: Int64, parent!: CreateTag){
        this.node = node
        this.w = w
        this.parent = parent
    }
}

