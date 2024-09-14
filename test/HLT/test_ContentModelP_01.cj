// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjContentModelP{
    @TestCase
    func test_ContentModelP_toString_01():Unit {
        var p=Int64.Max
        let kaf=Keyframe<Array<Float64>>()
        var k= Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        var cmp=ContentModelP(p:p, k:k)
        @Assert(cmp.toString(),"ContentModelP: {\n" +
                                     "p = ${p},\n" +
                                     "k = ${k}\n}")
        @Assert(cmp.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelP_toString_02():Unit {
        var p=Int64.Min
        var k= Array<Keyframe<Array<Float64>>>()
        var cmp=ContentModelP(p:p, k:k)
        @Assert(cmp.toString(),"ContentModelP: {\n" +
                                     "p = ${p},\n" +
                                     "k = ${k}\n}")
        @Assert(cmp.k.toString(),k.toString())
    }
    @TestCase
    func test_ContentModelP_toString_03():Unit {
        var k= Array<Keyframe<Array<Float64>>>()
        var cmp=ContentModelP()
        @Assert(cmp.toString(),"ContentModelP: {\n" +
                                   "p = 0,\n" +
                                   "k = ${k}\n}")
        @Assert(cmp.k.toString(),k.toString())
    }
}