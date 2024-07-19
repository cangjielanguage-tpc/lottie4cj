// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*
public import std.collection.*
@Test
public class TestLottie4cjColorParser{
    @TestCase
    func test_ColorParser_01():Unit {
        var cp=ColorParser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22)),JsonObject()])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                cp.parseColor(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonArray")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_ColorParser_02():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var re=cp.parseColor(ja)
        var exp_color=Color(25,128,22,24)
        @Assert(re.toString(),exp_color.toString())
    }
    @TestCase
    func test_ColorParser_03():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonBool(true),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var flag=1
        try{
            cp.parseColor(ja)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_ColorParser_04():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24))]))
        var re=cp.parseColor(ja)
        var exp_color=Color(1,128,22,24)
        @Assert(re.toString(),exp_color.toString())
    }
    @TestCase
    func test_ColorParser_05():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonBool(true),JsonFloat(Float64(22)),JsonFloat(Float64(24))]))
        var flag=1
        try{
            cp.parseColor(ja)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_ColorParser_06():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25)),JsonFloat(Float64(45))]))
        var re=cp.parseColor(ja)
        var exp_color=Color(25,128,22,24)
        @Assert(re.toString(),exp_color.toString())
    }
    @TestCase
    func test_ColorParser_07():Unit {
        var cp=ColorParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonFloat(0.235),JsonFloat(Float64(0.415)),JsonFloat(Float64(0.386)),JsonFloat(Float64(0.48)),JsonFloat(Float64(0.65))]))
        var re=cp.parseColor(ja)
        var exp_color=Color(Int64(0.48*Float64(255)),Int64(0.235*Float64(255)),Int64(0.415*Float64(255)),Int64(0.386*Float64(255)))
        @Assert(re.toString(),exp_color.toString())
    }
}