// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.collection.*
public import encoding.json.*

@Test
public class TestLottie4cjAnimatableTransformParser{

    @TestCase
    func test_AnimatableTransformParser_01():Unit {
        var jv_AnimatableTransformParser_str=###"{
 "o": {
   "a": 0,
   "k": 100,
   "ix": 11
 },
 "r": {
   "a": 0,
   "k": 0,
   "ix": 10
 },
 "p": {
   "a": 0,
   "k": [
     200,
     57,
     0
   ],
   "ix": 2,
   "l": 2
 },
 "a": {
   "a": 0,
   "k": [
     0,
     0,
     0
   ],
   "ix": 1,
   "l": 2
 },
 "s": {
   "a": 0,
   "k": [
     100,
     100,
     100
   ],
   "ix": 6,
   "l": 2
 }
}"###
        var jv=JsonValue.fromStr(jv_AnimatableTransformParser_str)
        var jo=jv.asObject()
        var re=AnimatableTransformParser.parse(jo)
        var exp_re=###"AnimatableTransform[tr]: {
ty = ,
a = [Keyframe{
k = PointF: {x='0.000000', y='0.000000'}
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}],
p = AnimatableSplitDimensionPathValue: {
k = [Keyframe{
k = PointF: {x='200.000000', y='57.000000'}
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}]
x = []
y = []
},
s = [Keyframe{
k = [100.000000, 100.000000, 100.000000]
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}],
r = ArrayKeyframeFloat64: { k = [Keyframe{
k = 0.000000
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}] },
o = [Keyframe{
k = 100
t = 0.000000
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}],
so = [],
eo = [],
sk = [],
sa = []
}"###
        
        //println(re.toString())
        @Assert(re.toString(),exp_re)

    }
    @TestCase
    func test_AnimatableTransformParser_02():Unit {
        var jv_AnimatableTransformParser_str=###"{
 "a": {
   "a": 0,
   "k": 100,
   "ix": 11
 },
 "b": {
   "a": 0,
   "k": 0,
   "ix": 10
 },
 "c": {
   "a": 0,
   "k": [
     200,
     57,
     0
   ],
   "ix": 2,
   "l": 2
 },
 "d": {
   "a": 0,
   "k": [
     0,
     0,
     0
   ],
   "ix": 1,
   "l": 2
 }
}"###
        var jv=JsonValue.fromStr(jv_AnimatableTransformParser_str)
        var jo=jv.asObject()
        var flag=1
        try{
            AnimatableTransformParser.parse(jo)
        }catch(e:IllegalArgumentException){
            if(e.toString().contains("JsonValue is not a array or object type")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}