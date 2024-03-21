// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjLayerT{
    @TestCase
    func test_LayerT_toString_01():Unit {
        var kfd=Keyframe<DocumentData>()
        var akfd=Array<Keyframe<DocumentData>>(345,item:kfd)
        var ltd=LayerTD(k:akfd)

        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100,item:kaf)
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc=Array<Keyframe<Array<Float64>>>(101,item:kaf)
        var sw=Array<Keyframe<Float64>>(102,item:Keyframe<Float64>())
        var t=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc,sw:sw,t:t)
        var atpa=AnimatableTextPropertiesA(a:atp)
        var aatpa=Array<AnimatableTextPropertiesA>(105,item:atpa)
        var lt=LayerT(d:ltd,a:aatpa)
        @Assert(lt.toString(),"LayerT: {\n" +"d = ${ltd},\n" +"a = ${aatpa}\n}")
        @Assert(lt.a.toString(),aatpa.toString())
    }
    @TestCase
    func test_LayerT_toString_02():Unit {
        var d=LayerTD()
        var a=Array<AnimatableTextPropertiesA>()
        var lt=LayerT()
        @Assert(lt.toString(),"LayerT: {\n" +"d = ${d},\n" +"a = ${a}\n}")
        @Assert(lt.a.toString(),a.toString())
    }
}