// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjLayerTD{
    @TestCase
    func test_LayerTD_toString_01():Unit {
        var kfd=Keyframe<DocumentData>()
        var akfd=Array<Keyframe<DocumentData>>(345,item:kfd)
        var ltd=LayerTD(k:akfd)
        @Assert(ltd.toString(),"LayerTD: {\n k = ${akfd}\n}")
        @Assert(ltd.k.toString(),akfd.toString())
    }
    @TestCase
    func test_LayerTD_toString_02():Unit {
        var akfd=Array<Keyframe<DocumentData>>()
        var ltd=LayerTD()
        @Assert(ltd.toString(),"LayerTD: {\n k = ${akfd}\n}")
        @Assert(ltd.k.toString(),akfd.toString())
    }
}