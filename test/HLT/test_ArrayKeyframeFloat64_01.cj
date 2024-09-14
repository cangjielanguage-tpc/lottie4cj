// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjArrayKeyframeFloat64{
    @TestCase
    func test_ArrayKeyframeFloat64_toString_01():Unit {
        var kf=Keyframe<Float64>()
        var akf=Array<Keyframe<Float64>>(100, repeat:kf)
        var akff=ArrayKeyframeFloat64(k:akf)
        @Assert(akff.k.toString(),akf.toString())
        @Assert(akff.toString(),"ArrayKeyframeFloat64: { k = ${akf} }")
    }
    @TestCase
    func test_ArrayKeyframeFloat64_toString_02():Unit {
        var akf=Array<Keyframe<Float64>>()
        var akff=ArrayKeyframeFloat64(k:akf)
        @Assert(akff.k.toString(),akf.toString())
        @Assert(akff.toString(),"ArrayKeyframeFloat64: { k = ${akf} }")
    }
    @TestCase
    func test_ArrayKeyframeFloat64_toString_03():Unit {
        var akf=Array<Keyframe<Float64>>()
        var akff=ArrayKeyframeFloat64()
        @Assert(akff.k.toString(),akf.toString())
        @Assert(akff.toString(),"ArrayKeyframeFloat64: { k = ${akf} }")
    }
}