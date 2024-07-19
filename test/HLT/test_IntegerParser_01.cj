// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*

@Test
public class TestLottie4cjIntegerParser{
    @TestCase
    func test_IntegerParser_01():Unit {
        var intP=IntegerParser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonObject(),JsonArray(Array<JsonValue>([JsonNull(),JsonInt(128),JsonFloat(Float64(22))]))])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                intP.parse(illeagal[iv])
            }catch(e:IllegalArgumentException){
                if(e.toString().contains("JsonValue is not a number or array type")){
                    flag=0
                }
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonFloat")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }

    @TestCase
    func test_IntegerParser_02():Unit {
        var intP=IntegerParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22))]))
        var re=intP.parse(ja)
        @Assert(re,128)
    }

    @TestCase
    func test_IntegerParser_03():Unit {
        var intP=IntegerParser.INSTANCE
        var ja=JsonInt(128)
        var re=intP.parse(ja)
        @Assert(re,128)
    }

    @TestCase
    func test_IntegerParser_04():Unit {
        var intP=IntegerParser.INSTANCE
        var ja=JsonFloat(Float64(22))
        var re=intP.parse(ja)
        @Assert(re,22)
    }
}