// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*

@Test
public class TestLottie4cjArrayFloat64Parser{
    @TestCase
    func test_ArrayFloat64Parser_01():Unit {
        var afp=ArrayFloat64Parser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonObject()])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                afp.parse(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonFloat")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_ArrayFloat64Parser_02():Unit {
        var afp=ArrayFloat64Parser.INSTANCE
        var ja=JsonInt(128)
        var re=afp.parse(ja)
        @Assert(re, Array<Float64>([Float64(128)]))
    }
    @TestCase
    func test_ArrayFloat64Parser_03():Unit {
        var afp=ArrayFloat64Parser.INSTANCE
        var ja=JsonFloat(Float64(22))
        var re=afp.parse(ja)
        @Assert(re,Array<Float64>([Float64(22)]))
    }
    @TestCase
    func test_ArrayFloat64Parser_04():Unit {
        var afp=ArrayFloat64Parser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22))]))
        var re=afp.parse(ja)
        @Assert(re,Array<Float64>([Float64(128),Float64(22)]))
    }
    @TestCase
    func test_ArrayFloat64Parser_05():Unit {
        var afp=ArrayFloat64Parser.INSTANCE
        var flag=1
        var illeagal=JsonArray(Array<JsonValue>([JsonNull(),JsonInt(128),JsonFloat(Float64(22))]))
        try{
            afp.parse(illeagal)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}