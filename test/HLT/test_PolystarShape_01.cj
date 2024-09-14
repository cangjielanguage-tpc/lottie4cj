// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjPolystarShape{
    @TestCase
    func test_PolystarShape_01():Unit {
        var nm="nm_PolystarShape"
        var sy=Int64.Max
        var pt= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var p=AnimatableSplitDimensionPathValue()
        var r= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var or= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var os= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var ir= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var is2= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(104, repeat:Keyframe<Float64>()))
        var hd=true
        var d=Int64.Max
        var polystarShape=PolystarShape(nm: nm, sy: sy, pt: pt, p: p, r: r, or: or, os: os, ir:ir, is2:is2, hd:hd, d:d)

        @Assert(polystarShape.types,Int8(10))
        @Assert(polystarShape.pt.toString(),pt.toString())
        @Assert(polystarShape.r.toString(),r.toString())
        @Assert(polystarShape.or.toString(),or.toString())
        @Assert(polystarShape.os.toString(),os.toString())
        @Assert(polystarShape.ir.toString(),ir.toString())
        @Assert(polystarShape.is2.toString(),is2.toString())
        var re_exp="PolystarShape[sr]: {\n" +
                           "ty = sr\n" +
                           "nm = ${nm}\n" +
                           "sy = ${sy}\n" +
                           "pt = ${pt.k}\n" +
                           "p = ${p}\n" +
                           "r = ${r.k}\n" +
                           "or = ${or.k}\n" +
                           "os = ${os.k}\n" +
                           "ir = ${ir.k}\n" +
                           "is2 = ${is2.k}\n" +
                           "hd = ${hd}\n" +
                           "d = ${d}\n}"
        @Assert(polystarShape.toString(),re_exp)
    }

    @TestCase
    func test_PolystarShape_02():Unit {
        var nm=""
        var sy=Int64.Min
        var pt= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var p=AnimatableSplitDimensionPathValue()
        var r= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var or= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var os= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var ir= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var is2= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var hd=true
        var d=Int64.Min
        var polystarShape=PolystarShape(nm: nm, sy: sy, pt: pt, p: p, r: r, or: or, os: os, ir:ir, is2:is2, hd:hd, d:d)
        @Assert(polystarShape.types,Int8(10))
        @Assert(polystarShape.pt.toString(),pt.toString())
        @Assert(polystarShape.r.toString(),r.toString())
        @Assert(polystarShape.or.toString(),or.toString())
        @Assert(polystarShape.os.toString(),os.toString())
        @Assert(polystarShape.ir.toString(),ir.toString())
        @Assert(polystarShape.is2.toString(),is2.toString())
        var re_exp="PolystarShape[sr]: {\n" +
                           "ty = sr\n" +
                           "nm = ${nm}\n" +
                           "sy = ${sy}\n" +
                           "pt = ${pt.k}\n" +
                           "p = ${p}\n" +
                           "r = ${r.k}\n" +
                           "or = ${or.k}\n" +
                           "os = ${os.k}\n" +
                           "ir = ${ir.k}\n" +
                           "is2 = ${is2.k}\n" +
                           "hd = ${hd}\n" +
                           "d = ${d}\n}"
        @Assert(polystarShape.toString(),re_exp)
    }

    @TestCase
    func test_PolystarShape_03():Unit {
        var nm=""
        var sy=0
        var pt= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var p=AnimatableSplitDimensionPathValue()
        var r= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var or= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var os= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var ir= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var is2= ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var hd=false
        var d=0

        var polystarShape=PolystarShape()
        @Assert(polystarShape.types,Int8(10))
        @Assert(polystarShape.pt.toString(),pt.toString())
        @Assert(polystarShape.r.toString(),r.toString())
        @Assert(polystarShape.or.toString(),or.toString())
        @Assert(polystarShape.os.toString(),os.toString())
        @Assert(polystarShape.ir.toString(),ir.toString())
        @Assert(polystarShape.is2.toString(),is2.toString())
        @Assert(polystarShape.toString(),"PolystarShape[sr]: {\n" +
                                                                     "ty = sr\n" +
                                                                     "nm = ${nm}\n" +
                                                                     "sy = ${sy}\n" +
                                                                     "pt = ${pt.k}\n" +
                                                                     "p = ${p}\n" +
                                                                     "r = ${r.k}\n" +
                                                                     "or = ${or.k}\n" +
                                                                     "os = ${os.k}\n" +
                                                                     "ir = ${ir.k}\n" +
                                                                     "is2 = ${is2.k}\n" +
                                                                     "hd = ${hd}\n" +
                                                                     "d = ${d}\n}")
    }
}