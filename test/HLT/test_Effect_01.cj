// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjEffect{
    @TestCase
    func test_Effect_toString_01():Unit {
        let ty=567
        var nm="Effect_nm"
        let kaf=Keyframe<Array<Float64>>()
        let k= Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        let cmpk=ContentModelPK(k:k)
        let isNull=true
        let effect=Effect(ty:ty, nm:nm, v:cmpk, isNull:isNull)
        @Assert(effect.toString(),"Effect: {\n" +
                                 "ty = ${ty},\n" +
                                 "nm = ${nm},\n" +
                                 "v = ${cmpk}\n}")
    }
    @TestCase
    func test_Effect_toString_02():Unit {
        let ty=-567
        var nm=""
        let cmpk=ContentModelPK()
        let isNull=true
        let effect=Effect(ty:ty, nm:nm, v:cmpk, isNull:isNull)
        @Assert(effect.toString(),"Effect: {\n" +
                                 "ty = ${ty},\n" +
                                 "nm = ${nm},\n" +
                                 "v = ${cmpk}\n}")
    }
    @TestCase
    func test_Effect_toString_03():Unit {
        let ty=-0
        var nm=""
        let cmpk=ContentModelPK()
        let effect=Effect()
        @Assert(effect.toString(),"Effect: {\n" +
                                 "ty = ${ty},\n" +
                                 "nm = ${nm},\n" +
                                 "v = ${cmpk}\n}")
    }
}