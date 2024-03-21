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
        var jv_AnimatableTextPropertiesParser_str=###"{
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
        var jv=JsonValue.fromStr(jv_AnimatableTextPropertiesParser_str)
        var jo=jv.asObject()
        var re=AnimatableTextPropertiesParser.parse(jo)
        var exp_re=###"AnimatableTextProperties: {
fc = ArrayKeyframeArrayFloat64: { k = [] },
sc = [],
sw = [],
t = ArrayKeyframeFloat64: { k = [] }
}"###
        @Assert(re.toString(),exp_re)
    }
    @TestCase
    func test_AnimatableTextPropertiesParser_02():Unit {
        var jv_AnimatableTextPropertiesParser_str=###"{
  "s": 72,
  "g": "Helvetica"
}"###
        var jv=JsonValue.fromStr(jv_AnimatableTextPropertiesParser_str)
        var jo=jv.asObject()
        var re=AnimatableTextPropertiesParser.parse(jo)
        var exp_re=AnimatableTextProperties()
        @Assert(re.toString(),exp_re.toString())
    }
}