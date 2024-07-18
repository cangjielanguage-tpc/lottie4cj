// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.collection.*
public import encoding.json.*

@Test
public class TestLottie4cjAnimatableValueParser{
    @TestCase
    func test_AnimatableValueParser_01():Unit {
        var jv_AnimatableValueParser_str=###"{
"r": {
 "a": 0,
 "k": 0,
 "ix": 10
}
}"###
        var jv=JsonValue.fromStr(jv_AnimatableValueParser_str)
        var jo=jv.asObject()
        var re=AnimatableValueParser.parseFloat(jo)
        @Assert(re.toString(),"[]")
    }
    @TestCase
    func test_AnimatableValueParser_02():Unit {
        var jv_AnimatableValueParser_str=###"{
  "s": 72,
  "g": "Helvetica"
}"###
        var jv=JsonValue.fromStr(jv_AnimatableValueParser_str)
        var jo=jv.asObject()
        var re=AnimatableValueParser.parseArrayFloat(jo)
        @Assert(re.toString(),"[]")
    }
}