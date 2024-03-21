// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*

@Test
public class TestLottie4cjContentModelPK{
    @TestCase
    func test_ContentModelPK_toString_01():Unit {
        let kaf=Keyframe<Array<Float64>>()
        var k= Array<Keyframe<Array<Float64>>>(101,item:kaf)
        var cmp=ContentModelPK(k:k)
        @Assert(cmp.toString(),"ContentModelPK: { k = ${k} }")
        @Assert(cmp.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelPK_toString_02():Unit {
        var k= Array<Keyframe<Array<Float64>>>()
        var cmp=ContentModelPK(k:k)
        @Assert(cmp.toString(),"ContentModelPK: { k = ${k} }")
        @Assert(cmp.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelPK_toString_03():Unit {
        var k= Array<Keyframe<Array<Float64>>>()
        var cmp=ContentModelPK()
        @Assert(cmp.toString(),"ContentModelPK: { k = ${k} }")
        @Assert(cmp.k.toString(),k.toString())
    }
}