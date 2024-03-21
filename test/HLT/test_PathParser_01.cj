// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
from encoding import json.*
from std import collection.*
@Test
public class TestLottie4cjPathParser{
    @TestCase
    func test_PathParser_01():Unit {
        var pp=PathParser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22))])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                pp.parse(illeagal[iv])
            }catch(e:IllegalArgumentException){
                if(e.toString().contains("JsonValue is not a array or object type")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_PathParser_02():Unit {
        var pp=PathParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var re=pp.parse(ja)
        @Assert(re.toString(),PointF(x:Float64(128),y:Float64(22)).toString())
    }
    @TestCase
    func test_PathParser_03():Unit {
        var pp=PathParser.INSTANCE
        var ja=JsonArray(Array<JsonValue>([JsonNull(),JsonBool(true),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var flag=1
        try{
            pp.parse(ja)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonFloat")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_PathParser_04():Unit {
        var pp=PathParser.INSTANCE
        var jo=JsonObject()
        var re=pp.parse(jo)
        @Assert(re.toString(),PointF(x:Float64(0),y:Float64(0)).toString())
    }
    @TestCase
    func test_PathParser_05():Unit {
        var pp=PathParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("x",JsonNull()),("y",JsonBool(true))])
        var jo=JsonObject(maps)
        var flag=1
        try{
            pp.parse(jo)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains(" JsonValue is not a number or array type")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_PathParser_06():Unit {
        var pp=PathParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("x",JsonInt(128)),("y",JsonFloat(128))])
        var jo=JsonObject(maps)
        var re=pp.parse(jo)
        @Assert(re.toString(),PointF(x:Float64(128),y:Float64(128)).toString())
    }
}