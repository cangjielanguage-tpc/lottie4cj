// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjFontCharacter{

    @TestCase
    func test_FontCharacter_toString_01():Unit {
        var data=CharsData()
        var ch="ch_String"
        var size=Float64(0.0)
        var w=Float64(1.0)
        var style="style_String"
        var fFamily="fFamily_String"
        var fc=FontCharacter(data,ch,size,w,style,fFamily)
        @Assert(fc.toString(), "FontCharacter: {\n" +
                               "ch = ${ch}\n" +
                               "size = ${size}\n" +
                               "w = ${w}\n" +
                               "style = ${style}\n" +
                               "fFamily = ${fFamily}\n" +
                               "data = ${data}\n}" )
    }
    @TestCase
    func test_FontCharacter_toString_02():Unit {
        var data=CharsData()
        var ch=""
        var size=Float64(-5.0)
        var w=Float64(-1.0)
        var style=""
        var fFamily=""
        var fc=FontCharacter(data,ch,size,w,style,fFamily)
        @Assert(fc.toString(), "FontCharacter: {\n" +
                               "ch = ${ch}\n" +
                               "size = ${size}\n" +
                               "w = ${w}\n" +
                               "style = ${style}\n" +
                               "fFamily = ${fFamily}\n" +
                               "data = ${data}\n}" )
    }
    @Skip
    @TestCase
    func test_FontCharacter_hashFor_01():Unit {
        var ch="ch_String"
        var style="style_String"
        var fFamily="fFamily_String"
        var fc_hashFor=FontCharacter.hashFor(ch,fFamily,style)
        @Assert(fc_hashFor, 1356227481711 )
    }
    @Skip
    @TestCase
    func test_FontCharacter_hashFor_02():Unit {
        var ch=""
        var style=""
        var fFamily=""
        var fc_hashFor=FontCharacter.hashFor(ch,fFamily,style)
        @Assert(fc_hashFor, 5343333)
    }
   @Skip
   @TestCase
    func test_FontCharacter_hashCode_01():Unit {
        var data=CharsData()
        var ch="ch_String"
        var size=Float64(0.0)
        var w=Float64(1.0)
        var style="style_String"
        var fFamily="fFamily_String"
        var fc=FontCharacter(data,ch,size,w,style,fFamily)
        var fc_hashFor=fc.hashCode()
        @Assert(fc_hashFor, 1356227481711 )
    }
    @Skip
    @TestCase
    func test_FontCharacter_hashCode_02():Unit {
        var data=CharsData()
        var ch=""
        var size=Float64(-5.0)
        var w=Float64(-1.0)
        var style=""
        var fFamily=""
        var fc=FontCharacter(data,ch,size,w,style,fFamily)
        var fc_hashFor=fc.hashCode()
        @Assert(fc_hashFor, 5343333 )
    }
}