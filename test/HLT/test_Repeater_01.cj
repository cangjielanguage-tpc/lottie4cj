// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjRepeater{
    @TestCase
    func test_Repeater_01():Unit {
        var nm="nm_Repeater"
        var ck=Array<Keyframe<Float64>>(111, repeat:Keyframe<Float64>())
        var c = ArrayKeyframeFloat64(k: ck)
        var ok=Array<Keyframe<Float64>>(101, repeat:Keyframe<Float64>())
        var o = ArrayKeyframeFloat64(k: ok)
        var tr=AnimatableTransform()
        var hd=true
        var Repeater=Repeater(nm:nm,c:c,o:o,tr:tr,hd:hd)
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c.k}\n" +
                                           "o = ${o.k}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
    @TestCase
    func test_Repeater_02():Unit {
        var nm=""
        var ck=Array<Keyframe<Float64>>()
        var c = ArrayKeyframeFloat64(k: ck)
        var ok=Array<Keyframe<Float64>>()
        var o = ArrayKeyframeFloat64(k: ok)
        var tr=AnimatableTransform()
        var hd=false
        var Repeater=Repeater(nm:nm,c:c,o:o,tr:tr,hd:hd)
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c.k}\n" +
                                           "o = ${o.k}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
    @TestCase
    func test_Repeater_03():Unit {
        var nm=""
        var ck=Array<Keyframe<Float64>>()
        var c = ArrayKeyframeFloat64(k: ck)
        var ok=Array<Keyframe<Float64>>()
        var o = ArrayKeyframeFloat64(k: ok)
        var tr=AnimatableTransform()
        var hd=false
        var Repeater=Repeater()
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c.k}\n" +
                                           "o = ${o.k}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
}