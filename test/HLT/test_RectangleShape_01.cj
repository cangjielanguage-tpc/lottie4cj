// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjRectangleShape{
    @TestCase
    func test_RectangleShape_toString_01():Unit {
        var nm="RectangleShape_nm"

        var kfp=Keyframe<PointF>()
        var kff=Keyframe<Float64>()
        var akff=Array<Keyframe<Float64>>(34, repeat:kff)
        var akfp=Array<Keyframe<PointF>>(334, repeat:kfp)
        var p=AnimatableSplitDimensionPathValue(k:akfp,x:akff,y:akff)

        var sk=Array<Keyframe<PointF>>(301, repeat:kfp)
        var s = ArrayKeyframePointF(k: sk)
        var rk=Array<Keyframe<Float64>>(301, repeat:kff)
        var r =ArrayKeyframeFloat64(k: rk)
        var hd=true
        var rts=RectangleShape(nm:nm,p:p,s:s,r:r,hd:hd)
        @Assert(rts.toString(),"RectangleShape[rc]: {\n" +
                                             "ty = rc\n" +
                                             "nm = ${nm}\n" +
                                             "p = ${p}\n" +
                                             "s = ${s.k}\n" +
                                             "r = ${r.k}\n" +
                                             "hd = ${hd}\n}")
        @Assert(rts.s.toString(),s.toString())
        @Assert(rts.r.toString(),r.toString())
        @Assert(rts.types,Int8(8))
    }
    @TestCase
    func test_RectangleShape_toString_02():Unit {
        var nm=""
        var p=AnimatableSplitDimensionPathValue()
        var sk=Array<Keyframe<PointF>>()
        var s = ArrayKeyframePointF(k: sk)
        var rk=Array<Keyframe<Float64>>()
        var r =ArrayKeyframeFloat64(k: rk)
        var hd=false
        var rts=RectangleShape(nm:nm,p:p,s:s,r:r,hd:hd)
        @Assert(rts.toString(),"RectangleShape[rc]: {\n" +
                                             "ty = rc\n" +
                                             "nm = ${nm}\n" +
                                             "p = ${p}\n" +
                                             "s = ${s.k}\n" +
                                             "r = ${r.k}\n" +
                                             "hd = ${hd}\n}")
        @Assert(rts.s.toString(),s.toString())
        @Assert(rts.r.toString(),r.toString())
        @Assert(rts.types,Int8(8))
    }
    @TestCase
    func test_RectangleShape_toString_03():Unit {
        var nm=""
        var p=AnimatableSplitDimensionPathValue()
        var sk=Array<Keyframe<PointF>>()
        var s = ArrayKeyframePointF(k: sk)
        var rk=Array<Keyframe<Float64>>()
        var r =ArrayKeyframeFloat64(k: rk)
        var hd=false
        var rts=RectangleShape()
        @Assert(rts.toString(),"RectangleShape[rc]: {\n" +
                                             "ty = rc\n" +
                                             "nm = ${nm}\n" +
                                             "p = ${p}\n" +
                                             "s = ${s.k}\n" +
                                             "r = ${r.k}\n" +
                                             "hd = ${hd}\n}")
        @Assert(rts.s.toString(),s.toString())
        @Assert(rts.r.toString(),r.toString())
        @Assert(rts.types,Int8(8))
    }
}