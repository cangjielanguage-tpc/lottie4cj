// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjAnimatableTextPropertiesA{

    @TestCase
    func test_AnimatableTextPropertiesA_toString_01():Unit {
        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100, repeat:kaf)
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc=Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        var sw=Array<Keyframe<Float64>>(102, repeat:Keyframe<Float64>())
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc,sw:sw,t:t)
        
        var s: AnimatableTextPropertiesS = AnimatableTextPropertiesS()
        var atpa=AnimatableTextPropertiesA(a:atp)
        @Assert(atpa.toString(),"AnimatableTextPropertiesA: {a = ${atp}, s = ${s}}")
    }

    @TestCase
    func test_AnimatableTextPropertiesA_toString_02():Unit {
        var atp=AnimatableTextProperties()
        var s: AnimatableTextPropertiesS = AnimatableTextPropertiesS()
        var atpa=AnimatableTextPropertiesA()
        @Assert(atpa.toString(),"AnimatableTextPropertiesA: {a = ${atp}, s = ${s}}")
    }
}