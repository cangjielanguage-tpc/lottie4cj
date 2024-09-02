// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjAnimatableTransform{
    @TestCase
    func test_AnimatableTransform_toString_01():Unit {
        var a=ArrayKeyframePointF(k: Array<Keyframe<PointF>>(232,item:Keyframe<PointF>()))
        var p=AnimatableSplitDimensionPathValue()
        var s=ArrayKeyframeArrayFloat64(k: Array<Keyframe<Array<Float64>>>(232,item:Keyframe<Array<Float64>>()))
        var r= ArrayKeyframeFloat64()
        var o= ArrayKeyframeInt64(k: Array<Keyframe<Int64>>(232,item:Keyframe<Int64>()))
        var so=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(232,item:Keyframe<Float64>()))
        var eo=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(232,item:Keyframe<Float64>()))
        var sk=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(232,item:Keyframe<Float64>()))
        var sa=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>(232,item:Keyframe<Float64>()))
        var ty="AnimatableTransform_ty"

        var at=AnimatableTransform(a:a,p:p,s:s,r:r,o:o,so: so,eo: eo,sk: sk,sa: sa,ty: ty)
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a.k},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s.k},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o.k},\n" +
                                             "so = ${so.k},\n" +
                                             "eo = ${eo.k},\n" +
                                             "sk = ${sk.k},\n" +
                                             "sa = ${sa.k}\n}")
    }
    @TestCase
    func test_AnimatableTransform_toString_02():Unit {
        var a=ArrayKeyframePointF(k: Array<Keyframe<PointF>>())
        var p=AnimatableSplitDimensionPathValue()
        var s=ArrayKeyframeArrayFloat64(k: Array<Keyframe<Array<Float64>>>())
        var r= ArrayKeyframeFloat64()
        var o= ArrayKeyframeInt64(k: Array<Keyframe<Int64>>())
        var so=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var eo=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var sk=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var sa=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var ty=""

        var at=AnimatableTransform(a:a,p:p,s:s,r:r,o:o,so: so,eo: eo,sk: sk,sa: sa,ty: ty)
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a.k},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s.k},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o.k},\n" +
                                             "so = ${so.k},\n" +
                                             "eo = ${eo.k},\n" +
                                             "sk = ${sk.k},\n" +
                                             "sa = ${sa.k}\n}")
    }
    @TestCase
    func test_AnimatableTransform_toString_03():Unit {
        var a=ArrayKeyframePointF(k: Array<Keyframe<PointF>>())
        var p=AnimatableSplitDimensionPathValue()
        var s=ArrayKeyframeArrayFloat64(k: Array<Keyframe<Array<Float64>>>())
        var r= ArrayKeyframeFloat64()
        var o= ArrayKeyframeInt64(k: Array<Keyframe<Int64>>())
        var so=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var eo=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var sk=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var sa=ArrayKeyframeFloat64(k: Array<Keyframe<Float64>>())
        var ty=""

        var at=AnimatableTransform()
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a.k},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s.k},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o.k},\n" +
                                             "so = ${so.k},\n" +
                                             "eo = ${eo.k},\n" +
                                             "sk = ${sk.k},\n" +
                                             "sa = ${sa.k}\n}")
    }
}