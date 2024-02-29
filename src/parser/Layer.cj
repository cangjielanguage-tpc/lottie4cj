/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

package parser

public class Layer <: ToString {

    var nm: String = ""                                                    // 0 = layerName
    var ind: Int64 = 0                                                     // 1 = layerId
    var refId: String = ""                                                 // 2 = refId
    var ty: Int64 = 0                                                      // 3 = layerType
    var parent: Int64 = -1                                                 // 4 = parentId
    var sw: Int64 = 0                                                      // 5 = solidWidth
    var sh: Int64 = 0                                                      // 6 = solidHeight
    var sc: String = ""                                                    // 7 = solidColor
    public var ks: AnimatableTransform = AnimatableTransform()             // 8 = transform
    var tt: Int64 = 0                                                      // 9 = matteType
    public var masksProperties: ArrayList<Mask> = ArrayList<Mask>()        // 10 = masks
    public var shapes: ArrayList<ContentModel> = ArrayList<ContentModel>() // 11 = shapes
    public var t: LayerT = LayerT()                                        // 12 = t
    public var ef: ArrayList<LayerEF> = ArrayList<LayerEF>()               // 13 = ef
    var sr: Float64 = 0.0                                                  // 14 = timeStretch
    var st: Float64 = 0.0                                                  // 15 = startFrame
    var w: Float64 = 0.0                                                   // 16 = preCompWidth
    var h: Float64 = 0.0                                                   // 17 = preCompHeight
    var ip: Float64 = 0.0                                                  // 18 = inFrame
    var op: Float64 = 0.0                                                  // 19 = outFrame

    public var tm: ContentModelDK = ContentModelDK()                       // 20 = timeRemapping

    var cl: String = ""                                                    // 21 = cl
    var hd: Bool = false                                                   // 22 = hidden
    var ao: Int64 = 0                                                      // 23 = autoOrient
    var bm: Int64 = 0                                                      // 24 = blendMode

    init(){}

    public func toString(): String {
        "Layer {\n" +
        "nm     = ${nm}\n" +            // 0 = layerName
        "ind    = ${ind}\n" +           // 1 = layerId
        "refId  = ${refId}\n" +         // 2 = refId
        "ty     = ${ty}\n" +            // 3 = layerType
        "parent = ${parent}\n" +        // 4 = parentId
        "sw     = ${sw}\n" +            // 5 = solidWidth
        "sh     = ${sh}\n" +            // 6 = solidHeight
        "sc     = ${sc}\n" +            // 7 = solidColor

        "tt     = ${tt}\n" +            // 9 = matteType
        "masksProperties.size = ${masksProperties.size}\n" +      // 10 = masks
        "shapes.size = ${shapes.size}\n" +                        // 11 = shapes

        "ef.size = ${ef.size}\n" +                                // 13 = ef
        "sr = ${sr}\n" +                // 14 = timeStretch
        "st = ${st}\n" +                // 15 = startFrame
        "w  = ${w}\n"  +                // 16 = preCompWidth
        "h  = ${h}\n"  +                // 17 = preCompHeight
        "ip = ${ip}\n" +                // 18 = inFrame
        "op = ${op}\n" +                // 19 = outFrame
        "tm = ${tm}\n" +                // 20 = timeRemapping
        "cl = ${cl}\n" +                // 21 = cl
        "hd = ${hd}\n" +                // 22 = hidden
        "ao = ${ao}\n" +                // 23 = autoOrient
        "bm = ${bm}\n" +                // 24 = blendMode
        "}\n"
    }

}

public class LayerTD <: ToString {
    var k: ArrayList<Keyframe<DocumentData>> = ArrayList<Keyframe<DocumentData>>()

    init (){}
    init (k: ArrayList<Keyframe<DocumentData>>){
        this.k = k
    }

    public func toString(): String {
        return "LayerTD: {\n k = ${k}\n}"
    }
}

public class LayerT <: ToString {

    var d: LayerTD = LayerTD()
    var a: ArrayList<AnimatableTextPropertiesA> = ArrayList<AnimatableTextPropertiesA>()
    init (){}

    public func toString(): String {
        return "LayerT: {\n" +
               "d = ${d},\n" +
               "a = ${a} \n}"
    }
}

public class LayerEF <: ToString {
    var ty: Int64 = 0
    var nm: String = ""
    var ef: ArrayList<Effect> = ArrayList<Effect>()
    init (){}

    public func toString(): String {
        return "LayerEF: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "ef = ${ef} \n}"
    }
}
