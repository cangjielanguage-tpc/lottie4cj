// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjMask{
    @TestCase
    func test_Mask_01():Unit {
        var cl=true
        var inv=true
        var mode="Mask_mode"
        var pt=Array<Keyframe<ShapeData>>(56,item:Keyframe<ShapeData>())
        var o=Array<Keyframe<Int64>>(57,item:Keyframe<Int64>())
        var x=Array<Keyframe<Int64>>(58,item:Keyframe<Int64>())
        var nm="Mask_nm"
        var mask=Mask(cl:cl,inv:inv,mode:mode,pt:pt,o:o,x:x,nm:nm)
        @Assert(mask.pt.toString(),pt.toString())
        @Assert(mask.o.toString(),o.toString())
        @Assert(mask.x.toString(),x.toString())
        @Assert(mask.toString(),"Mask: {\n" +
                            "cl    = ${cl}\n" +
                            "inv   = ${inv}\n" +
                            "mode  = ${mode}\n" +
                            "pt    = ${pt}\n" +
                            "o     = ${o}\n" +
                            "x     = ${x}\n" +
                            "nm    = ${nm}\n}")
    }
    @TestCase
    func test_Mask_02():Unit {
        var cl=false
        var inv=false
        var mode=""
        var pt=Array<Keyframe<ShapeData>>()
        var o=Array<Keyframe<Int64>>()
        var x=Array<Keyframe<Int64>>()
        var nm=""
        var mask=Mask(cl:cl,inv:inv,mode:mode,pt:pt,o:o,x:x,nm:nm)
        @Assert(mask.pt.toString(),pt.toString())
        @Assert(mask.o.toString(),o.toString())
        @Assert(mask.x.toString(),x.toString())
        @Assert(mask.toString(),"Mask: {\n" +
                            "cl    = ${cl}\n" +
                            "inv   = ${inv}\n" +
                            "mode  = ${mode}\n" +
                            "pt    = ${pt}\n" +
                            "o     = ${o}\n" +
                            "x     = ${x}\n" +
                            "nm    = ${nm}\n}")
    }
    @TestCase
    func test_Mask_03():Unit {
        var cl=false
        var inv=false
        var mode=""
        var pt=Array<Keyframe<ShapeData>>()
        var o=Array<Keyframe<Int64>>()
        var x=Array<Keyframe<Int64>>()
        var nm=""
        var mask=Mask()
        @Assert(mask.pt.toString(),pt.toString())
        @Assert(mask.o.toString(),o.toString())
        @Assert(mask.x.toString(),x.toString())
        @Assert(mask.toString(),"Mask: {\n" +
                            "cl    = ${cl}\n" +
                            "inv   = ${inv}\n" +
                            "mode  = ${mode}\n" +
                            "pt    = ${pt}\n" +
                            "o     = ${o}\n" +
                            "x     = ${x}\n" +
                            "nm    = ${nm}\n}")
    }
}