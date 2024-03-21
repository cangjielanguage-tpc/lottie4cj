// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjAnimatableTransform{
    @TestCase
    func test_AnimatableTransform_toString_01():Unit {
        var a=Array<Keyframe<PointF>>(232,item:Keyframe<PointF>())
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<Array<Float64>>>(232,item:Keyframe<Array<Float64>>())
        var r= ArrayKeyframeFloat64()
        var o= Array<Keyframe<Int64>>(232,item:Keyframe<Int64>())
        var so=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var eo=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var sk=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var sa=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var ty="AnimatableTransform_ty"

        var at=AnimatableTransform(a:a,p:p,s:s,r:r,o:o,so: so,eo: eo,sk: sk,sa: sa,ty: ty)
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o},\n" +
                                             "so = ${so},\n" +
                                             "eo = ${eo},\n" +
                                             "sk = ${sk},\n" +
                                             "sa = ${sa}\n}")
    }
    @TestCase
    func test_AnimatableTransform_toString_02():Unit {
        var a=Array<Keyframe<PointF>>()
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<Array<Float64>>>()
        var r= ArrayKeyframeFloat64()
        var o= Array<Keyframe<Int64>>()
        var so=Array<Keyframe<Float64>>()
        var eo=Array<Keyframe<Float64>>()
        var sk=Array<Keyframe<Float64>>()
        var sa=Array<Keyframe<Float64>>()
        var ty=""

        var at=AnimatableTransform(a:a,p:p,s:s,r:r,o:o,so: so,eo: eo,sk: sk,sa: sa,ty: ty)
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o},\n" +
                                             "so = ${so},\n" +
                                             "eo = ${eo},\n" +
                                             "sk = ${sk},\n" +
                                             "sa = ${sa}\n}")
    }
    @TestCase
    func test_AnimatableTransform_toString_03():Unit {
        var a=Array<Keyframe<PointF>>()
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<Array<Float64>>>()
        var r= ArrayKeyframeFloat64()
        var o= Array<Keyframe<Int64>>()
        var so=Array<Keyframe<Float64>>()
        var eo=Array<Keyframe<Float64>>()
        var sk=Array<Keyframe<Float64>>()
        var sa=Array<Keyframe<Float64>>()
        var ty=""

        var at=AnimatableTransform()
        @Assert(at.toString(),"AnimatableTransform[tr]: {\n" +
                                             "ty = ${ty},\n" +
                                             "a = ${a},\n" +
                                             "p = ${p},\n" +
                                             "s = ${s},\n" +
                                             "r = ${r},\n" +
                                             "o = ${o},\n" +
                                             "so = ${so},\n" +
                                             "eo = ${eo},\n" +
                                             "sk = ${sk},\n" +
                                             "sa = ${sa}\n}")
    }
}