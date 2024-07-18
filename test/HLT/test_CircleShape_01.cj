// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjCircleShape{
    @TestCase
    func test_CircleShape_toString_01():Unit {
        var nm="CircleShape_nm"
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<PointF>>(208,item:Keyframe<PointF>())
        var hd=true
        var d=Int64.Max
        var cs=CircleShape(nm:nm, p:p, s:s, hd:hd, d:d)
        @Assert(cs.toString(), "CircleShape[el]: {\n" +
                                     "ty = el,\n" +
                                     "nm = ${nm},\n" +
                                     "p = ${p},\n" +
                                     "s = ${s},\n" +
                                     "hd = ${hd},\n" +
                                     "d = ${d}\n}")
        @Assert(cs.types,Int8(7))
        @Assert(cs.s.toString(),s.toString())
    }
    @TestCase
    func test_CircleShape_toString_02():Unit {
        var nm=""
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<PointF>>()
        var hd=false
        var d=Int64.Min
        var cs=CircleShape(nm:nm, p:p, s:s, hd:hd, d:d)
        @Assert(cs.toString(), "CircleShape[el]: {\n" +
                                     "ty = el,\n" +
                                     "nm = ${nm},\n" +
                                     "p = ${p},\n" +
                                     "s = ${s},\n" +
                                     "hd = ${hd},\n" +
                                     "d = ${d}\n}")
        @Assert(cs.types,Int8(7))
        @Assert(cs.s.toString(),s.toString())
    }
    @TestCase
    func test_CircleShape_toString_03():Unit {
        var nm=""
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<PointF>>()
        var hd=false
        var d=0
        var cs=CircleShape()
        @Assert(cs.toString(), "CircleShape[el]: {\n" +
                                     "ty = el,\n" +
                                     "nm = ${nm},\n" +
                                     "p = ${p},\n" +
                                     "s = ${s},\n" +
                                     "hd = ${hd},\n" +
                                     "d = ${d}\n}")
        @Assert(cs.types,Int8(7))
        @Assert(cs.s.toString(),s.toString())
    }
}