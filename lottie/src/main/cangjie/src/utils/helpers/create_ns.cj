/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is CreateNS.
 */
package lottie.utils.helpers

internal import std.collection.*

let svgNS: String = "http://www.w3.org/2000/svg"

func addEventListener(types: String, callback: () -> Unit, flag: Bool): Unit { }

public class TagStyle {
    var fontFamily: String = ""
    var fontSize: Int64 = 0      //'300px'
    var fontVariant: String = "" //'normal'
    var fontStyle: String = ""   //'normal'
    var fontWeight: String = ""  //'normal'

    var position: String = ""    //'absolute'
    var left: Int64 = 0          //'-10000px'
    var top: Int64 = 0           //'-10000px'
    var letterSpacing = "absolute"  //字间距
    public var transform = ""  
    public var webkitTransform = "" 
    public var opacity = 0

    public var width: String = ""
    public var height: String = ""
}

public class CreateNS <: ToString & Equatable<CreateNS> {

    //------CreateTag---------------------------------------------------------------------
    public var types: String = ""
    public var style: TagStyle = TagStyle()
    public var innerText: String = ""
    //------CreateTag---------------------------------------------------------------------

    public var crossOrigin: String = ""
    public var src: String = ""
    public var textContent: String = ""
    public var addEventListener: (String, () -> Unit, Bool) -> Unit = addEventListener

    var label: String = ""
    var ks: HashMap<String, String> = HashMap<String, String>()
    var childs: ArrayList<CreateNS> = ArrayList<CreateNS>()

    //TODO: 暂时无成员变量 style 的数据类型
    //TODO: style 是一个对象??? 还是一个 HashMap<String, String> ???
    public var styles: HashMap<String, String> = HashMap<String, String>()
    
    public let isNull: Bool

    /**
     * Create a CreateNS instance based on the parameter.
     *
     * @param types - Type of String.
     */
    public init(types: String){
        this(types, svgNS)
    }

    /**
     * Create a CreateNS instance based on parameters.
     *
     * @param types - Type of String.
     * @param svg - Type of String.
     */
    public init(types: String, svg: String) {
        this.types = types
        this.label = types
        
        if (types == "") {
            this.isNull = true
        } else {
            this.isNull = false
        }
        
        if (types == "svg" && svg != "") {
            this.setAttribute("xmlns", svg)
        }
    }

    /**
     * Set properties in the Create NS instance.
     *
     * @param n - Type of String.
     * @param k - Type of String.
     * @param v - Type of String.
     */
    public func setAttributeNS(n: String, k: String, v: String): Unit {
        this.setAttribute("xmlns", n)
        this.ks.put(k, v)
    }

    /**
     * Set attribute to the CreateNS instance.
     *
     * @param k - Type of String.
     * @param v - Type of String.
     */
    public func setAttribute(k: String, v: String): Unit {
        this.ks.put(k, v)
    }

    /**
     * append child to the CreateNS instance.
     *
     * @param element - Type of Option<CreateNS>.
     */
    public func appendChild(element: Option<CreateNS>): Unit {
        if (let Some(v) <- element) {
            this.childs.append(v)
        }
    }

    /**
     * Insert newNode in the children array of the current Create NS instance, before referenceNode.
     *
     * @param element - Type of CreateNS, create NS instance to be inserted into the children array..
     * @param referenceNode - Type of CreateNS, insert newNode before referenceNode.
     */
    public func insertBefore(newNode: CreateNS, referenceNode: CreateNS): Unit {
        let addindex: Int64 = this.indexOf(referenceNode, this.childs)
        this.childs.insert(addindex, newNode)
    }

    func indexOf(referenceNode: CreateNS, arr: ArrayList<CreateNS>): Int64 {
        var index: Int64 = 0
        for (createNS in arr) {
            if (createNS == referenceNode) {
                return index
            }
            index++
        }
        return -1
    }

    /**
     * Check if the current CreatNS is equal to the target that.
     *
     * @param that - Type of CreateNS.
     * @return Type of Bool.
     */
    public operator func ==(that: CreateNS): Bool {
        if (refEq(this, that)) {
            return true
        } else if (this.label != that.label) {
            return false
        } else if (this.ks.size != that.ks.size) {
            return false
        } else if (this.ks.size == that.ks.size) {
            for((k, v) in this.ks) {
                if (v != that.ks[k]) {
                    return false
                }
            }
        } else if (this.childs.size != that.childs.size) {
            return false
        } else if (this.childs.size == that.childs.size) {
            let len: Int64 = this.childs.size
            for (i in 0..len) {
                if (refEq(this.childs[i], that.childs[i]) || this.childs[i] == that.childs[i]) {
                    continue
                } else {
                    return false
                }
            }
        }
        //TODO: 暂时无成员变量 style 的数据类型，顾暂时不做相同比较
        return true
    }

    /**
     * Check if the current CreatNS is not equal to the target that.
     *
     * @param that - Type of CreateNS.
     * @return Type of Bool.
     */
    public operator func !=(that: CreateNS): Bool {
        return !(this == that)
    }
    
    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "CreateNS: {\n" +
               "label = ${label}\n" +
               "ks.size = ${ks.size}\n" +
               "childs.size = ${childs.size}\n" +
               "styles.size = ${styles.size}\n}"
    }

}
