// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjContentModel{
    @TestCase
    func test_ContentModel_toString_01():Unit {
        var cm=ContentModel()
        @Assert(cm.toString(),"The ContentModel is None.")
        @Assert(cm.types,Int8(-1))
    }
}