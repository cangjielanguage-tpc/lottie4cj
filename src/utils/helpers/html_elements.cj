/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package utils.helpers

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
    var style: TagStyle = TagStyle()
    var innerText: String = ""

    public init(types: String) {
        this.types = types
    }

    //TODO: 未实现
    func appendChild(n: CreateTag) { }
    func setAttribute(k: String, v: String) { }
    func getContext(s: String) { }
}

class TagStyle {
    var fontFamily: String = ""
    var fontSize: Int64 = 0      //'300px'
    var fontVariant: String = "" //'normal'
    var fontStyle: String = ""   //'normal'
    var fontWeight: String = ""  //'normal'

    var position: String = ""    //'absolute'
    var left: Int64 = 0          //'-10000px'
    var top: Int64 = 0           //'-10000px'
    var letterSpacing = "absolute"  //字间距
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

