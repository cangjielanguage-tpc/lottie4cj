// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
@Test
public class TestLottie4cjShapeTrimPath{
    @TestCase
    func test_ShapeTrimPath_toString_01():Unit {
        var kf=Keyframe<Float64>()
        var s=Array<Keyframe<Float64>>(15,item:kf)
        var e=Array<Keyframe<Float64>>(16,item:kf)
        var o=Array<Keyframe<Float64>>(17,item:kf)
        var nm="ShapeTrimPath_nm"
        var m=Int64.Max
        var hd=true
        var stp=ShapeTrimPath(s:s,e:e,o:o,nm:nm,m:m,hd:hd)
        @Assert(stp.toString(),"ShapeTrimPath[tm]: {\n" +
                                          "ty = tm\n" +
                                          "s = ${s}\n" +
                                          "e = ${e}\n" +
                                          "o = ${o}\n" +
                                          "nm = ${nm}\n" +
                                          "m = ${m}\n" +
                                          "hd = ${hd}\n}")
        @Assert(stp.types,Int8(9))
        @Assert(stp.s.toString(),s.toString())
        @Assert(stp.e.toString(),e.toString())
        @Assert(stp.o.toString(),o.toString())
    }
    @TestCase
    func test_ShapeTrimPath_toString_02():Unit {
        var s=Array<Keyframe<Float64>>()
        var e=Array<Keyframe<Float64>>()
        var o=Array<Keyframe<Float64>>()
        var nm=""
        var m=Int64.Min
        var hd=false
        var stp=ShapeTrimPath(s:s,e:e,o:o,nm:nm,m:m,hd:hd)
        @Assert(stp.toString(),"ShapeTrimPath[tm]: {\n" +
                                          "ty = tm\n" +
                                          "s = ${s}\n" +
                                          "e = ${e}\n" +
                                          "o = ${o}\n" +
                                          "nm = ${nm}\n" +
                                          "m = ${m}\n" +
                                          "hd = ${hd}\n}")
        @Assert(stp.types,Int8(9))
        @Assert(stp.s.toString(),s.toString())
        @Assert(stp.e.toString(),e.toString())
        @Assert(stp.o.toString(),o.toString())
    }
    @TestCase
    func test_ShapeTrimPath_toString_03():Unit {
        var s=Array<Keyframe<Float64>>()
        var e=Array<Keyframe<Float64>>()
        var o=Array<Keyframe<Float64>>()
        var nm=""
        var m=0
        var hd=false
        var kf=ShapeTrimPath()
        @Assert(kf.toString(),"ShapeTrimPath[tm]: {\n" +
                                            "ty = tm\n" +
                                            "s = ${s}\n" +
                                            "e = ${e}\n" +
                                            "o = ${o}\n" +
                                            "nm = ${nm}\n" +
                                            "m = ${m}\n" +
                                            "hd = ${hd}\n}")
    }
}