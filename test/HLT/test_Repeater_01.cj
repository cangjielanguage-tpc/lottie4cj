// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*

@Test
public class TestLottie4cjRepeater{
    @TestCase
    func test_Repeater_01():Unit {
        var nm="nm_Repeater"
        var c=Array<Keyframe<Float64>>(111,item:Keyframe<Float64>())
        var o=Array<Keyframe<Float64>>(101,item:Keyframe<Float64>())
        var tr=AnimatableTransform()
        var hd=true
        var Repeater=Repeater(nm:nm,c:c,o:o,tr:tr,hd:hd)
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c}\n" +
                                           "o = ${o}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
    @TestCase
    func test_Repeater_02():Unit {
        var nm=""
        var c=Array<Keyframe<Float64>>()
        var o=Array<Keyframe<Float64>>()
        var tr=AnimatableTransform()
        var hd=false
        var Repeater=Repeater(nm:nm,c:c,o:o,tr:tr,hd:hd)
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c}\n" +
                                           "o = ${o}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
    @TestCase
    func test_Repeater_03():Unit {
        var nm=""
        var c=Array<Keyframe<Float64>>()
        var o=Array<Keyframe<Float64>>()
        var tr=AnimatableTransform()
        var hd=false
        var Repeater=Repeater()
        @Assert(Repeater.c.toString(),c.toString())
        @Assert(Repeater.o.toString(),o.toString())
        @Assert(Repeater.types,Int8(12))
        @Assert(Repeater.toString(),"Repeater[rp]: {\n" +
                                           "ty = rp\n" +
                                           "nm = ${nm}\n" +
                                           "c = ${c}\n" +
                                           "o = ${o}\n" +
                                           "tr = ${tr}\n" +
                                           "hd = ${hd}\n}")
    }
}