// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjArrayKeyframeFloat64{
    @TestCase
    func test_ArrayKeyframeFloat64_toString_01():Unit {
        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100,item:kaf)
        var akfaf=ArrayKeyframeArrayFloat64(k:akaf)
        @Assert(akfaf.k.toString(),akaf.toString())
        @Assert(akfaf.toString(),"ArrayKeyframeArrayFloat64: { k = ${akaf} }")
    }
    @TestCase
    func test_ArrayKeyframeFloat64_toString_02():Unit {
        var akaf=Array<Keyframe<Array<Float64>>>()
        var akfaf=ArrayKeyframeArrayFloat64(k:akaf)
        @Assert(akfaf.k.toString(),akaf.toString())
        @Assert(akfaf.toString(),"ArrayKeyframeArrayFloat64: { k = ${akaf} }")
    }
    @TestCase
    func test_ArrayKeyframeFloat64_toString_03():Unit {
        var akaf=Array<Keyframe<Array<Float64>>>()
        var akfaf=ArrayKeyframeArrayFloat64()
        @Assert(akfaf.k.toString(),akaf.toString())
        @Assert(akfaf.toString(),"ArrayKeyframeArrayFloat64: { k = ${akaf} }")
    }
}