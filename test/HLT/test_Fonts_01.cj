// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjFonts{
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
    func test_Fonts_toString_01():Unit {
        fFamily="fFamily"
        fName="fName"
        fStyle="fStyle"
        ascent=Float64(1.0)
        var ft=Font(fFamily,fName,fStyle,ascent, fOrigin, origin, fPath, fClass, fWeight)
        var listCur=Array<Font>(10, repeat:ft)
        var fts=Fonts(list:listCur)
        @Assert(fts.toString(), "Fonts: {\n list = ${listCur}\n }")
        @Assert(fts.list.toString(), listCur.toString())
    }
    @TestCase
    func test_Fonts_toString_02():Unit {
        fFamily=""
        fName=""
        fStyle=""
        ascent=Float64(-1.0)
        var ft=Font(fFamily,fName,fStyle,ascent, fOrigin, origin, fPath, fClass, fWeight)
        var listCur=Array<Font>(10, repeat:ft)
        var fts=Fonts(list:listCur)
        @Assert(fts.toString(), "Fonts: {\n list = ${listCur}\n }")
        @Assert(fts.list.toString(), listCur.toString())
    }
    @TestCase
    func test_Fonts_toString_03():Unit {
        var fts=Fonts()
        var listCur=Array<Font>()
        @Assert(fts.toString(), "Fonts: {\n list = ${listCur}\n }")
        @Assert(fts.list.toString(), listCur.toString())
    }
}