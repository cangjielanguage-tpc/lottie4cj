// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjAnimatableTextProperties{
    @TestCase
    func test_AnimatableTextProperties_toString_01():Unit {
        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100, repeat:kaf)
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc=Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        var sw=Array<Keyframe<Float64>>(102, repeat:Keyframe<Float64>())
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc,sw:sw,t:t)
        @Assert(atp.toString(),"AnimatableTextProperties: {\n" +
                                              "fc = ${fc},\n" +
                                              "sc = ${sc},\n" +
                                              "sw = ${sw},\n" +
                                              "t = ${t}\n}")
        @Assert(atp.sc.toString(),sc.toString())
        @Assert(atp.sw.toString(),sw.toString())
    }
    @TestCase
    func test_AnimatableTextProperties_toString_02():Unit {
        var fc=ArrayKeyframeArrayFloat64()
        var sc=Array<Keyframe<Array<Float64>>>()
        var sw=Array<Keyframe<Float64>>()
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc,sw:sw,t:t)
        @Assert(atp.toString(),"AnimatableTextProperties: {\n" +
                                              "fc = ${fc},\n" +
                                              "sc = ${sc},\n" +
                                              "sw = ${sw},\n" +
                                              "t = ${t}\n}")
        @Assert(atp.sc.toString(),sc.toString())
        @Assert(atp.sw.toString(),sw.toString())
    }
    @TestCase
    func test_AnimatableTextProperties_toString_03():Unit {
        var fc=ArrayKeyframeArrayFloat64()
        var sc=Array<Keyframe<Array<Float64>>>()
        var sw=Array<Keyframe<Float64>>()
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties()
        @Assert(atp.toString(),"AnimatableTextProperties: {\n" +
                                              "fc = ${fc},\n" +
                                              "sc = ${sc},\n" +
                                              "sw = ${sw},\n" +
                                              "t = ${t}\n}")
        @Assert(atp.sc.toString(),sc.toString())
        @Assert(atp.sw.toString(),sw.toString())
    }
}