// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjCharsData{
    @TestCase
    func test_CharsData_toString_01():Unit {
        var cm=ContentModel()
        var shapes=Array<ContentModel>(102, repeat:cm)
        var cd=CharsData(shapes:shapes)
        @Assert(cd.toString(),"CharsData: {\n shapes.size = ${shapes.size},\n shapes = ${shapes.toString()}\n }")
        @Assert(cd.shapes.toString(),shapes.toString())
    }
    @TestCase
    func test_CharsData_toString_02():Unit {
        var shapes=Array<ContentModel>()
        var cd=CharsData(shapes:shapes)
        @Assert(cd.toString(),"CharsData: {\n shapes.size = ${shapes.size},\n shapes = ${shapes.toString()}\n }")
        @Assert(cd.shapes.toString(),shapes.toString())
    }
    @TestCase
    func test_CharsData_toString_03():Unit {
        var cd=CharsData()
        @Assert(cd.toString(),"CharsData: {\n shapes.size = 0,\n shapes = []\n }")
        @Assert(cd.shapes.toString(),"[]")
    }
}