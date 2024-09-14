// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
@Test
public class TestLottie4cjShapeFill{
    @TestCase
    func test_ShapeFill_toString_01():Unit {
        var nm="ShapeFill_String"
        var kfaf=Array<Float64>(100, repeat:3.14)

        var k=Option<Array<Float64>>.Some(kfaf)
        var t=Float64(1.1)
        var s=Option<Array<Float64>>.Some(kfaf)
        var e=Option<Array<Float64>>.Some(kfaf)
        var o_kef=PointF(x:Float64(104),y:Float64(105))
        var i=PointF(x:Float64(106),y:Float64(107))
        var h=Int64(108)
        var to: Array<Float64> = [109.0,110.0]
        var ti: Array<Float64> = [111.0,112.0]
        var kf=Keyframe(k:k,t:t,s:s,e:e,o:o_kef,i:i,h:h,to:to,ti:ti)

        var c=Array<Keyframe<Array<Float64>>>(100, repeat:kf)
        var akf=Keyframe<Int64>()
        var o_ShapeFill=Array<Keyframe<Int64>>(100, repeat:akf)
        var fillEnabled=true
        var r=Int64.Max
        var hd=true
        var sf=ShapeFill(nm:nm,c:c,o:o_ShapeFill,fillEnabled:fillEnabled,r:r,hd:hd)
        @Assert(sf.toString(),"ShapeFill[fl]: {\n" +
                                       "ty = fl\n" +
                                       "nm = ${nm}\n" +
                                       "c = ${c}\n" +
                                       "o = ${o_ShapeFill}\n" +
                                       "fillEnabled = ${fillEnabled}\n" +
                                       "r = ${r}\n" +
                                       "hd = ${hd}\n}")
        @Assert(sf.types,Int8(3))
        @Assert(sf.c.toString(),c.toString())
        @Assert(sf.o.toString(),o_ShapeFill.toString())
    }
    @TestCase
    func test_ShapeFill_toString_02():Unit {
        var nm=""
        var c=Array<Keyframe<Array<Float64>>>()
        var o=Array<Keyframe<Int64>>()
        var fillEnabled=false
        var r=Int64.Min
        var hd=false
        var stp=ShapeFill(nm:nm,c:c,o:o,fillEnabled:fillEnabled,r:r,hd:hd)
        @Assert(stp.toString(),"ShapeFill[fl]: {\n" +
                                       "ty = fl\n" +
                                       "nm = ${nm}\n" +
                                       "c = ${c}\n" +
                                       "o = ${o}\n" +
                                       "fillEnabled = ${fillEnabled}\n" +
                                       "r = ${r}\n" +
                                       "hd = ${hd}\n}")
        @Assert(stp.types,Int8(3))
        @Assert(stp.c.toString(),c.toString())
        @Assert(stp.o.toString(),o.toString())
    }
    @TestCase
    func test_ShapeFill_toString_03():Unit {
        var nm=""
        var c=Array<Keyframe<Array<Float64>>>()
        var o=Array<Keyframe<Int64>>()
        var fillEnabled=false
        var r=0
        var hd=false
        var stp=ShapeFill()
        @Assert(stp.toString(),"ShapeFill[fl]: {\n" +
                                       "ty = fl\n" +
                                       "nm = ${nm}\n" +
                                       "c = ${c}\n" +
                                       "o = ${o}\n" +
                                       "fillEnabled = ${fillEnabled}\n" +
                                       "r = ${r}\n" +
                                       "hd = ${hd}\n}")
        @Assert(stp.types,Int8(3))
        @Assert(stp.c.toString(),c.toString())
        @Assert(stp.o.toString(),o.toString())
    }
}