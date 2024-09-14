// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*

@Test
public class TestLottie4cjGradientColorParser{
    @TestCase
    func test_GradientColorParser_01():Unit {
        var colorPoints=Int64.Max
        var gradientColorParser=GradientColorParser(colorPoints)
        var flag=1
        var illeagal=[JsonNull(),JsonBool(true),JsonInt(128),JsonFloat(Float64(22)),JsonString("JsonString"),JsonObject()]
        for (iv in 0..illeagal.size){
            flag=1
            try{
                gradientColorParser.parse(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonArray")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }

    }
    @TestCase
    func test_GradientColorParser_02():Unit {
        var colorPoints=Int64.Min
        var gradientColorParser=GradientColorParser(colorPoints)
        var flag=1
        var ja=JsonArray([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonObject()])
        try{
            gradientColorParser.parse(ja)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_GradientColorParser_03():Unit {
        var colorPoints=Int64.Min
        var gradientColorParser=GradientColorParser(colorPoints)
        var ja=JsonArray([JsonInt(128),JsonFloat(Float64(22))])
        var re=gradientColorParser.parse(ja)
        println(re)
        @Assert(re,[128.000000, 22.000000])
    }
}