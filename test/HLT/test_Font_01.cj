// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjFont{
    var fFamily=""
    var fName=""
    var fStyle=""
    var ascent=Float64(1.0)

    var fOrigin = "fOrigin"
    var origin = 5
    var fPath = "fPath"
    var fClass = "fClass"
    var fWeight = "fWeight"

    @TestCase
    func test_Font_toString_01():Unit {
        fFamily="fFamily"
        fName="fName"
        fStyle="fStyle"
        ascent=Float64(1.0)
        var ft=Font(fFamily,fName,fStyle,ascent, fOrigin, origin, fPath, fClass, fWeight)
        @Assert(ft.toString(), "Font {\n" +
                               "fName   = ${fName}\n" +
                               "fFamily = ${fFamily}\n" +
                               "fStyle  = ${fStyle}\n" +
                                "ascent  = ${ascent}\n" +
                                "fOrigin = ${fOrigin}\n" +
                                "origin  = ${origin}\n" +
                                "fPath   = ${fPath}\n" +
                                "fClass  = ${fClass}\n" +
                                "fWeight = ${fWeight}\n}")
        @Assert(ft.getName(), fName)
    }
    @TestCase
    func test_Font_toString_02():Unit {
        fFamily=""
        fName=""
        fStyle=""
        ascent=Float64(-1.0)
        var ft=Font(fFamily,fName,fStyle,ascent, fOrigin, origin, fPath, fClass, fWeight)
        @Assert(ft.toString(), "Font {\n" +
                               "fName   = ${fName}\n" +
                               "fFamily = ${fFamily}\n" +
                               "fStyle  = ${fStyle}\n" +
                                "ascent  = ${ascent}\n" +
                                "fOrigin = ${fOrigin}\n" +
                                "origin  = ${origin}\n" +
                                "fPath   = ${fPath}\n" +
                                "fClass  = ${fClass}\n" +
                                "fWeight = ${fWeight}\n}")
        @Assert(ft.getName(), fName)
    }
}