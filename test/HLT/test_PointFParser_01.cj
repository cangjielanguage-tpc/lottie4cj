// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import std.collection.*
public import encoding.json.*

@Test
public class TestLottie4cjPointFParser{
    @TestCase
    func test_PointFParser_01():Unit {
        var pp=PointFParser.INSTANCE
        var flag=1
        var illeagal=[JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22))]
        for (iv in 0..illeagal.size){
            flag=1
            try{
                pp.parse(illeagal[iv])
            }catch(e:IllegalArgumentException){
                if(e.toString().contains("Cannot convert json to point. Next token is not array and object.")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_PointFParser_02():Unit {
        var pp=PointFParser.INSTANCE
        var ja=JsonArray([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))])
        var re=pp.parse(ja)
        @Assert(re.toString(),PointF(x:Float64(128),y:Float64(22)).toString())
    }
    @TestCase
    func test_PointFParser_03():Unit {
        var pp=PointFParser.INSTANCE
        var ja=JsonArray([JsonNull(),JsonBool(true),JsonFloat(Float64(24)),JsonFloat(Float64(25))])
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
    func test_PointFParser_04():Unit {
        var pp=PointFParser.INSTANCE
        var jo=JsonObject()
        var re=pp.parse(jo)
        @Assert(re.toString(),PointF(x:Float64(0),y:Float64(0)).toString())
    }
    @TestCase
    func test_PointFParser_05():Unit {
        var pp=PointFParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("x",JsonNull()),("y",JsonBool(true))])
        var jo=JsonObject(maps)
        var flag=1
        try{
            pp.parse(jo)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("JsonValue is not a number or array type")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_PointFParser_06():Unit {
        var pp=PointFParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("x",JsonInt(128)),("y",JsonFloat(128))])
        var jo=JsonObject(maps)
        var re=pp.parse(jo)
        @Assert(re.toString(),PointF(x:Float64(128),y:Float64(128)).toString())
    }
}