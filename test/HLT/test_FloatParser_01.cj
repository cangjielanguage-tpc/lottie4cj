// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
from encoding import json.*

@Test
public class TestLottie4cjFloatParser{
    @TestCase
    func test_FloatParser_01():Unit {
        var fp=FloatParser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonObject(),JsonArray(Array<JsonValue>([JsonNull(),JsonInt(128),JsonFloat(Float64(22))]))])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                fp.parse(illeagal[iv])
            }catch(e:IllegalArgumentException){
                if(e.toString().contains("JsonValue is not a number or array type") ){
                    flag=0
                }
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonFloat") ){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }

    @TestCase
    func test_FloatParser_02():Unit {
        var fp=FloatParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22))]))
        var re=fp.parse(ja)
        @Assert(re,Float64(128))
    }

    @TestCase
    func test_FloatParser_03():Unit {
        var fp=FloatParser.INSTANCE
        var ja=JsonInt(128)
        var re=fp.parse(ja)
        @Assert(re,Float64(128))
    }

    @TestCase
    func test_FloatParser_04():Unit {
        var fp=FloatParser.INSTANCE
        var ja=JsonFloat(Float64(22))
        var re=fp.parse(ja)
        @Assert(re,Float64(22))
    }
}