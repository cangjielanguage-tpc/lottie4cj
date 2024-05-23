// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import collection.*
from encoding import json.*

@Test
public class TestLottie4cjAnimatableTextPropertiesParser{
    @TestCase
    func test_AnimatableTextPropertiesParser_01():Unit {
        var jv_AnimatableTextPropertiesParser_str_0=###"{
  "s": 72,
  "f": "Helvetica",
  "t": "Benchmark",
  "ca": 0,
  "j": 2,
  "tr": 0,
  "lh": 112,
  "ls": 0,
  "fc": [
    0,
    0,
    0
  ],
  "sc": [
    1,
    0,
    0
  ],
  "sw": 1,
  "of": true
}"###

var jv_AnimatableTextPropertiesParser_str=###"{
    "s": {
      "t": 0,
      "xe": {
        "a": 0,
        "k": 0
      },
      "ne": {
        "a": 0,
        "k": 0
      },
      "a": {
        "a": 0,
        "k": 100
      },
      "b": 1,
      "rn": 0,
      "sh": 1,
      "r": 1
    },
    "a": {
      "fc": {
        "a": 1,
        "k": [
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 0,
            "s": [1, 0, 0, 1],
            "e": [0, 1, 0, 1]
          },
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 15,
            "s": [0, 1, 0, 1],
            "e": [0, 0, 1, 1]
          },
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 30,
            "s": [0, 0, 1, 1],
            "e": [0, 1, 0, 1]
          },
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 45,
            "s": [0, 1, 0, 1],
            "e": [1, 0, 0, 1]
          },
          {"t": 60.0000024438501}
        ]
      },
      "t": {
        "a": 1,
        "k": [
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 30,
            "s": [0],
            "e": [20]
          },
          {
            "i": {"x": [0.833],"y": [0.833]},
            "o": {"x": [0.167],"y": [0.167]},
            "n": ["0p833_0p833_0p167_0p167"],
            "t": 45,
            "s": [20],
            "e": [0]
          },
          {"t": 60.0000024438501}
        ]
      }
    }
}"###

        var jv=JsonValue.fromStr(jv_AnimatableTextPropertiesParser_str)
        var jo=jv.asObject()
        var re=AnimatableTextPropertiesParser.parse(jo)
        var exp_re=###"AnimatableTextPropertiesA: {a = AnimatableTextProperties: {
fc = ArrayKeyframeArrayFloat64: { k = [Keyframe{
k = None
t = 0.000000
s = [1.000000, 0.000000, 0.000000, 1.000000]
e = [0.000000, 1.000000, 0.000000, 1.000000]
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 15.000000
s = [0.000000, 1.000000, 0.000000, 1.000000]
e = [0.000000, 0.000000, 1.000000, 1.000000]
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 30.000000
s = [0.000000, 0.000000, 1.000000, 1.000000]
e = [0.000000, 1.000000, 0.000000, 1.000000]
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 45.000000
s = [0.000000, 1.000000, 0.000000, 1.000000]
e = [1.000000, 0.000000, 0.000000, 1.000000]
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 60.000002
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}] },
sc = [],
sw = [],
t = ArrayKeyframeFloat64: { k = [Keyframe{
k = None
t = 30.000000
s = 0.000000
e = 20.000000
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 45.000000
s = 20.000000
e = 0.000000
o = PointF: {x='0.167000', y='0.167000'}
i = PointF: {x='0.833000', y='0.833000'}
h = 0
to = []
ti = []
}, Keyframe{
k = None
t = 60.000002
s = None
e = None
o = PointF: {x='0.000000', y='0.000000'}
i = PointF: {x='0.000000', y='0.000000'}
h = 0
to = []
ti = []
}] }
}, s = AnimatableTextPropertiesS-s: {
t  = 0,
xe = AK: {a = 0, k = 0},
ne = AK: {a = 0, k = 0},
a  = AK: {a = 0, k = 100},
b  = 1,
rn = 0,
sh = 1,
r  = 1
}}"###
        
        
        //println(re.toString())
        @Assert(re.toString(),exp_re)
    }
    @TestCase
    func test_AnimatableTextPropertiesParser_02():Unit {
        var jv_AnimatableTextPropertiesParser_str=###"{
  "m": 72,
  "g": "Helvetica"
}"###
        var jv=JsonValue.fromStr(jv_AnimatableTextPropertiesParser_str)
        var jo=jv.asObject()
        var re=AnimatableTextPropertiesParser.parse(jo)
        var exp_re=AnimatableTextPropertiesA()
        @Assert(re.toString(),exp_re.toString())
    }
}