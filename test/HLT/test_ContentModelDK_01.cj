// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*

@Test
public class TestLottie4cjContentModelDK{
    @TestCase
    func test_ContentModelDK_toString_01():Unit {
        let kf=Keyframe<Float64>()
        var k=Array<Keyframe<Float64>>(100,item:kf)
        let cmdk= ContentModelDK(k:k)
        @Assert(cmdk.toString(),"ContentModelDK: { k = ${k} }")
        @Assert(cmdk.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelDK_toString_02():Unit {
        var k=Array<Keyframe<Float64>>()
        let cmdk= ContentModelDK(k:k)
        @Assert(cmdk.toString(),"ContentModelDK: { k = ${k} }")
        @Assert(cmdk.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelDK_toString_03():Unit {
        var k=Array<Keyframe<Float64>>()
        let cmdk= ContentModelDK()
        @Assert(cmdk.toString(),"ContentModelDK: { k = ${k} }")
        @Assert(cmdk.k.toString(),k.toString())
    }
}