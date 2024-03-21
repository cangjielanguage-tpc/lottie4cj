// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
from encoding import json.*
from std import collection.*
@Test
public class TestLottie4cjShapeDataParser{
    @TestCase
    func test_ShapeDataParser_01():Unit {
        var sdp=ShapeDataParser.INSTANCE
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),
                                       JsonInt(128),JsonFloat(Float64(22)),
                                       JsonArray(Array<JsonValue>([JsonNull(),JsonBool(true)]))])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                sdp.parse(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonObject")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_ShapeDataParser_02():Unit {
        var sdp=ShapeDataParser.INSTANCE
        var jo=JsonObject()
        var flag=1
        try{
            sdp.parse(jo)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("Shape data was missing information.")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_ShapeDataParser_03():Unit {
        var sdp=ShapeDataParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("c",JsonBool(true)),
                                            ("v",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)])),JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)]))]))),
                                            ("i",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)])),JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)]))]))),
                                            ("o",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)])),JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)]))])))])
        var jo=JsonObject(maps)
        var re=sdp.parse(jo)
        var exp_re=ShapeData(
                               c: true,
                               v: Array<PointF>([PointF(x:Float64(128),y:Float64(228)),PointF(x:Float64(128),y:Float64(228))]),
                               i: Array<PointF>([PointF(x:Float64(38),y:Float64(18)),PointF(x:Float64(38),y:Float64(18))]),
                               o: Array<PointF>([PointF(x:Float64(18),y:Float64(28)),PointF(x:Float64(18),y:Float64(28))])
                           )
        @Assert(re.toString(),exp_re.toString())
    }
    @TestCase
    func test_ShapeDataParser_04():Unit {
        var sdp=ShapeDataParser.INSTANCE
        var maps=HashMap<String,JsonValue>([
                                            ("v",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)])),JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)]))]))),
                                            ("i",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)])),JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)]))]))),
                                            ("o",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)])),JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)]))])))])
        var jo=JsonObject(maps)
        var re=sdp.parse(jo)
        var exp_re=ShapeData(
                               c: false,
                               v: Array<PointF>([PointF(x:Float64(128),y:Float64(228)),PointF(x:Float64(128),y:Float64(228))]),
                               i: Array<PointF>([PointF(x:Float64(38),y:Float64(18)),PointF(x:Float64(38),y:Float64(18))]),
                               o: Array<PointF>([PointF(x:Float64(18),y:Float64(28)),PointF(x:Float64(18),y:Float64(28))])
                           )
        @Assert(re.toString(),exp_re.toString())
    }
    @TestCase
    func test_ShapeDataParser_05():Unit {
        var sdp=ShapeDataParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("c",JsonInt(123)),
                                            ("v",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)])),JsonArray(Array<JsonValue>([JsonInt(128),JsonInt(228)]))]))),
                                            ("i",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)])),JsonArray(Array<JsonValue>([JsonFloat(38),JsonFloat(18)]))]))),
                                            ("o",JsonArray(Array<JsonValue>([JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)])),JsonArray(Array<JsonValue>([JsonFloat(18),JsonInt(28)]))])))])
        var jo=JsonObject(maps)
        var flag=1
        try{
            sdp.parse(jo)
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonBool")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}