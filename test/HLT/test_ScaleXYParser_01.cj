// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*
public import std.collection.*
@Test
public class TestLottie4cjScaleXYParser{
    @TestCase
    func test_ScaleXYParser_01():Unit {
        var sp=ScaleXYParser.INSTANCE
        var flag=1
        var illeagal=[JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22)),JsonObject()]
        for (iv in 0..illeagal.size){
            flag=1
            try{
                sp.parse(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonArray")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_ScaleXYParser_02():Unit {
        var sp=ScaleXYParser.INSTANCE
        var ja=JsonArray([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))])
        var re=sp.parse(ja)
        @Assert(re,[128.000000, 22.000000, 24.000000, 25.000000])
    }
    @TestCase
    func test_ScaleXYParser_03():Unit {
        var sp=ScaleXYParser.INSTANCE
        var ja=JsonArray([JsonNull(),JsonBool(true),JsonFloat(Float64(24)),JsonFloat(Float64(25))])
        var flag=1
        try{
            sp.parse(ja)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}