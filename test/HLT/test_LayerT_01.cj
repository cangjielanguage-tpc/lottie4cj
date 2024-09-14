// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjLayerT{
    @TestCase
    func test_LayerT_toString_01():Unit {
        var kfd=Keyframe<DocumentData>()
        var akfd=Array<Keyframe<DocumentData>>(345, repeat:kfd)
        var ltd=LayerTD(k:akfd)

        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100, repeat:kaf)
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc=Array<Keyframe<Array<Float64>>>(101, repeat:kaf)
        var sw=Array<Keyframe<Float64>>(102, repeat:Keyframe<Float64>())
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc,sw:sw,t:t)
        var atpa=AnimatableTextPropertiesA(a:atp)
        var aatpa=Array<AnimatableTextPropertiesA>(105, repeat:atpa)

        var m: LayerTM = LayerTM()

        var lt=LayerT(d:ltd,a:aatpa, m: m)
        @Assert(lt.toString(),"LayerT-t: {\n" + "d = ${ltd},\n" + "a = ${aatpa},\n" + "m = ${m}\n}")

        @Assert(lt.a.toString(),aatpa.toString())
    }
    @TestCase
    func test_LayerT_toString_02():Unit {
        var d=LayerTD()
        var a=Array<AnimatableTextPropertiesA>()
        var m: LayerTM = LayerTM()
        var lt=LayerT()
        @Assert(lt.toString(),"LayerT-t: {\n" + "d = ${d},\n" + "a = ${a},\n" + "m = ${m}\n}")
        @Assert(lt.a.toString(),a.toString())
    }
}