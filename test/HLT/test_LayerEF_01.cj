// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjLayerEF{
    @TestCase
    func test_LayerEF_toString_01():Unit {
        let ty_layerEF=Int64.Max
        var nm_layerEF="LayerEF_nm"

        let ty_effect=Int64.Max
        var nm_effect="Effect_nm"
        let kaf=Keyframe<Array<Float64>>()
        let k= Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        let cmpk_effect=ContentModelPK(k:k)
        let isNull_effect=true
        let effect=Effect(ty:ty_effect, nm:nm_effect, v:cmpk_effect, isNull:isNull_effect)
        var ef= Array<Effect>(108, repeat:effect)

        var lef=LayerEF(ty_layerEF,nm_layerEF,ef)
        @Assert(lef.toString(),"LayerEF: {\n" +
                                 "ty = ${ty_layerEF},\n" +
                                 "nm = ${nm_layerEF},\n" +
                                 "ef = ${ef}\n}")
        @Assert(lef.ef.toString(),ef.toString())
    }
    @TestCase
    func test_LayerEF_toString_02():Unit {
        let ty_layerEF=Int64.Min
        var nm_layerEF=""
        var ef= Array<Effect>()
        var lef=LayerEF(ty_layerEF,nm_layerEF,ef)
        @Assert(lef.toString(),"LayerEF: {\n" +
                                 "ty = ${ty_layerEF},\n" +
                                 "nm = ${nm_layerEF},\n" +
                                 "ef = ${ef}\n}")
        @Assert(lef.ef.toString(),ef.toString())
    }
}