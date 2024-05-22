// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
from encoding import json.*
from std import collection.*
@Test
public class TestLottie4cjAnimatablePathValueParser{
    @TestCase
    func test_AnimatablePathValueParser_01():Unit {
        var flag=1
        var illeagal=Array<JsonValue>([JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22))])
        for (iv in 0..illeagal.size){
            flag=1
            try{
                AnimatablePathValueParser.parse(illeagal[iv])
            }catch(e:IllegalArgumentException){
                if(e.toString().contains("JsonValue is not a array or object type")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_AnimatablePathValueParser_02():Unit {
        var ja=JsonArray()
        var re=AnimatablePathValueParser.parse(ja)
        @Assert(re.toString(),"[]")
    }

    @TestCase
    func test_AnimatablePathValueParser_03():Unit {
        var ja=JsonArray(Array<JsonValue>([JsonInt(128),JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var re=AnimatablePathValueParser.parse(ja)
        var exp_re=###"[Keyframe{
k = PointF: {x='128.000000', y='22.000000'}
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}]"###
        @Assert(re.toString(),exp_re)
    }

    @TestCase
    func test_AnimatablePathValueParser_04():Unit {
        var ja=JsonArray(Array<JsonValue>([JsonFloat(Float64(22)),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var re=AnimatablePathValueParser.parse(ja)
        var exp_re=###"[Keyframe{
k = PointF: {x='22.000000', y='24.000000'}
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}]"###
        @Assert(re.toString(),exp_re)
    }
    @TestCase
    func test_AnimatablePathValueParser_05():Unit {
        var ja=JsonArray(Array<JsonValue>([JsonObject(),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var flag=1
        try{
            AnimatablePathValueParser.parse(ja)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("JsonValue is not a array or object type")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
    @TestCase
    func test_AnimatablePathValueParser_06():Unit {
        var ja=JsonArray(Array<JsonValue>([JsonNull(),JsonFloat(Float64(24)),JsonFloat(Float64(25))]))
        var re=AnimatablePathValueParser.parse(ja)
        @Assert(re.toString(),"[]")
    }
    @TestCase
    func test_AnimatablePathValueParser_07():Unit {
        var ja=JsonNull()
        var flag=1
        try{
            AnimatablePathValueParser.parse(ja)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("JsonValue is not a array or object type")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}