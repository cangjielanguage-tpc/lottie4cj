// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjGradientStroke{
    @TestCase
    func test_GradientStroke_01():Unit {
        var nm="nm_GradientStroke"
        var g=ContentModelP()
        var o=Array<Keyframe<Int64>>(104,item:Keyframe<Int64>())
        var t=Int64.Max
        var s=Array<Keyframe<PointF>>(104,item:Keyframe<PointF>())
        var e=Array<Keyframe<PointF>>(104,item:Keyframe<PointF>())
        var w=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())

        var lc=Int64.Max
        var lj=Int64.Max
        var ml=Float64(9)
        var hd=true
        var d=Array<ContentModelD>(105,item:ContentModelD())

        var gradientStroke=GradientStroke(nm: nm, g: g, o: o, t: t, s: s, e: e, w: w, lc:lc, lj:lj, ml:ml,hd:hd, d:d)

        @Assert(gradientStroke.types,Int8(2))
        @Assert(gradientStroke.o.toString(),o.toString())
        @Assert(gradientStroke.s.toString(),s.toString())
        @Assert(gradientStroke.e.toString(),e.toString())
        @Assert(gradientStroke.w.toString(),w.toString())
        @Assert(gradientStroke.d.toString(),d.toString())
        var re_exp="GradientStroke[gs]: {\n" +
                            "ty = gs\n" +
                            "nm = ${nm}\n" +
                            "g = ${g}\n" +
                            "o = ${o}\n" +
                            "t = ${t}\n" +
                            "s = ${s}\n" +
                            "e = ${e}\n" +
                            "w = ${w}\n" +
                            "lc = ${lc}\n" +
                            "lj = ${lj}\n" +
                            "ml = ${ml}\n" +
                            "hd = ${hd}\n" +
                            "d = ${d}\n}"
        @Assert(gradientStroke.toString(),re_exp)
    }

    @TestCase
    func test_GradientStroke_02():Unit {
        var nm=""
        var g=ContentModelP()
        var o=Array<Keyframe<Int64>>()
        var t=Int64.Min
        var s=Array<Keyframe<PointF>>()
        var e=Array<Keyframe<PointF>>()
        var w=Array<Keyframe<Float64>>()
        var lc=Int64.Min
        var lj=Int64.Min
        var ml=Float64(-9)
        var hd=false
        var d=Array<ContentModelD>()
        var gradientStroke=GradientStroke(nm: nm, g: g, o: o, t: t, s: s, e: e, w: w, lc:lc, lj:lj, ml:ml,hd:hd, d:d)

        @Assert(gradientStroke.types,Int8(2))
        @Assert(gradientStroke.o.toString(),o.toString())
        @Assert(gradientStroke.s.toString(),s.toString())
        @Assert(gradientStroke.e.toString(),e.toString())
        @Assert(gradientStroke.w.toString(),w.toString())
        @Assert(gradientStroke.d.toString(),d.toString())
        var re_exp="GradientStroke[gs]: {\n" +
                            "ty = gs\n" +
                            "nm = ${nm}\n" +
                            "g = ${g}\n" +
                            "o = ${o}\n" +
                            "t = ${t}\n" +
                            "s = ${s}\n" +
                            "e = ${e}\n" +
                            "w = ${w}\n" +
                            "lc = ${lc}\n" +
                            "lj = ${lj}\n" +
                            "ml = ${ml}\n" +
                            "hd = ${hd}\n" +
                            "d = ${d}\n}"
        @Assert(gradientStroke.toString(),re_exp)
    }
    /*
    @TestCase
    func test_GradientStroke_03():Unit {
        var nm="nm_GradientStroke"
        var sy=Int64.Max
        var pt=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var p=AnimatableSplitDimensionPathValue()
        var r=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var or=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var os=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var ir=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var is2=Array<Keyframe<Float64>>(104,item:Keyframe<Float64>())
        var hd=true
        var d=Int64.Max

        var gradientStroke=GradientStroke()
        @Assert(gradientStroke.types,Int8(10))
        @Assert(gradientStroke.pt.toString(),pt.toString())
        @Assert(gradientStroke.r.toString(),r.toString())
        @Assert(gradientStroke.or.toString(),or.toString())
        @Assert(gradientStroke.os.toString(),os.toString())
        @Assert(gradientStroke.ir.toString(),ir.toString())
        @Assert(gradientStroke.is2.toString(),is2.toString())
        @Assert(gradientStroke.toString(),"GradientStroke[sr]: {\n" +
                                                "ty = sr\n" +
                                                "nm = ${nm}\n" +
                                                "sy = ${sy}\n" +
                                                "pt = ${pt}\n" +
                                                "p = ${p}\n" +
                                                "r = ${r}\n" +
                                                "or = ${or}\n" +
                                                "os = ${os}\n" +
                                                "ir = ${ir}\n" +
                                                "is2 = ${is2}\n" +
                                                "hd = ${hd}\n" +
                                                "d = ${d}\n}")
    }*/
}