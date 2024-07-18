// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjLayer{
    @TestCase
    func test_Layer_01():Unit {
        var nm = "Layer_nm"
        var ind = Int64.Max
        var refId = "Layer_refId"
        var ty= Int64.Max
        var parent= Int64.Max
        var sw= Int64.Max
        var sh= Int64.Max
        var sc= "Layer_sc"

        var a=Array<Keyframe<PointF>>(232,item:Keyframe<PointF>())
        var p=AnimatableSplitDimensionPathValue()
        var s=Array<Keyframe<Array<Float64>>>(232,item:Keyframe<Array<Float64>>())
        var r= ArrayKeyframeFloat64()
        var o= Array<Keyframe<Int64>>(232,item:Keyframe<Int64>())
        var so=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var eo=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var sk=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var sa=Array<Keyframe<Float64>>(232,item:Keyframe<Float64>())
        var ty_AnimatableTransform="AnimatableTransform_ty"

        var ks= AnimatableTransform(a:a,p:p,s:s,r:r,o:o,so: so,eo: eo,sk: sk,sa: sa,ty: ty_AnimatableTransform)

        var tt = Int64.Max
        var mask=Mask()
        var masksProperties = Array<Mask>(108,item:mask)

        var shapes = Array<ContentModel>(104,item:ContentModel())

        var kfd=Keyframe<DocumentData>()
        var akfd=Array<Keyframe<DocumentData>>(345,item:kfd)
        var ltd=LayerTD(k:akfd)

        var kaf=Keyframe<Array<Float64>>()
        var akaf=Array<Keyframe<Array<Float64>>>(100,item:kaf)
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc_atp=Array<Keyframe<Array<Float64>>>(101,item:kaf)
        var sw_atp=Array<Keyframe<Float64>>(102,item:Keyframe<Float64>())
        var t_atp=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc_atp,sw:sw_atp,t:t_atp)
        var atpa=AnimatableTextPropertiesA(a:atp)
        var aatpa=Array<AnimatableTextPropertiesA>(105,item:atpa)

        var t=LayerT(d:ltd,a:aatpa)

        let ty_layerEF=Int64.Max
        var nm_layerEF="nm_layerEF"
        var aef= Array<Effect>()
        var lef=LayerEF(ty_layerEF,nm_layerEF,aef)

        var ef= Array<LayerEF>(23,item:lef)
        var sr = Float64(101)
        var st = Float64(102)
        var w = Float64(103)
        var h = Float64(104)
        var ip = Float64(105)
        var op = Float64(106)

        let kf=Keyframe<Float64>()
        var k=Array<Keyframe<Float64>>(100,item:kf)
        var tm = ContentModelDK(k:k)
        var cl: String = "Layer_cl"
        var hd: Bool = true
        var ao: Int64 = Int64.Max
        var bm: Int64 = Int64.Max
        var ly=Layer(nm:nm,ind:ind,refId:refId,ty:ty,parent:parent,sw:sw,sh:sh,sc:sc,ks:ks,tt:tt,masksProperties:masksProperties,
                     shapes:shapes,t:t,ef:ef,sr:sr,st:st,w:w,h:h,ip:ip,op:op,tm:tm,cl:cl,hd:hd,ao:ao,bm:bm)
        @Assert(ly.masksProperties.toString(),masksProperties.toString())
        @Assert(ly.shapes.toString(),shapes.toString())
        @Assert(ly.ef.toString(),ef.toString())
        @Assert(ly.toString(),"Layer {\n" +
                              "nm     = ${nm}\n" +
                              "ind    = ${ind}\n" +
                              "refId  = ${refId}\n" +
                              "ty     = ${ty}\n" +
                              "parent = ${parent}\n" +
                              "sw     = ${sw}\n" +
                              "sh     = ${sh}\n" +
                              "sc     = ${sc}\n" +
                              "ks     = ${ks}\n" +
                              "tt     = ${tt}\n" +
                              "masksProperties.size = ${masksProperties.size}\n" +
                              "shapes.size = ${shapes.size}\n" +
                              "t = ${t}\n" +
                              "ef.size = ${ef.size}\n" +
                              "sr = ${sr}\n" +
                              "st = ${st}\n" +
                              "w  = ${w}\n"  +
                              "h  = ${h}\n"  +
                              "ip = ${ip}\n" +
                              "op = ${op}\n" +
                              "tm = ${tm}\n" +
                              "cl = ${cl}\n" +
                              "hd = ${hd}\n" +
                              "ao = ${ao}\n" +
                              "bm = ${bm}\n}"  )
    }
    @TestCase
    func test_Layer_02():Unit {
        var nm = ""
        var ind = Int64.Min
        var refId = ""
        var ty= Int64.Min
        var parent= Int64.Min
        var sw= Int64.Min
        var sh= Int64.Min
        var sc= ""

        var ks= AnimatableTransform()
        var tt = Int64.Min
        var masksProperties = Array<Mask>()
        var shapes = Array<ContentModel>()
        var akfd=Array<Keyframe<DocumentData>>()
        var ltd=LayerTD(k:akfd)
        var akaf=Array<Keyframe<Array<Float64>>>()
        var fc=ArrayKeyframeArrayFloat64(k:akaf)
        var sc_atp=Array<Keyframe<Array<Float64>>>()
        var sw_atp=Array<Keyframe<Float64>>()
        var t_atp=ArrayKeyframeFloat64()
        var atp=AnimatableTextProperties(fc:fc,sc:sc_atp,sw:sw_atp,t:t_atp)
        var atpa=AnimatableTextPropertiesA(a:atp)
        var aatpa=Array<AnimatableTextPropertiesA>(105,item:atpa)

        var t=LayerT(d:ltd,a:aatpa)
        var ef= Array<LayerEF>()
        var sr =Float64(-101)
        var st =Float64(-102)
        var w =Float64(-103)
        var h =Float64(-104)
        var ip =Float64(-105)
        var op =Float64(-106)

        var k=Array<Keyframe<Float64>>()
        var tm = ContentModelDK(k:k)
        var cl: String = ""
        var hd: Bool = false
        var ao: Int64 = Int64.Min
        var bm: Int64 = Int64.Min
        var ly=Layer(nm:nm,ind:ind,refId:refId,ty:ty,parent:parent,sw:sw,sh:sh,sc:sc,ks:ks,tt:tt,masksProperties:masksProperties,
                     shapes:shapes,t:t,ef:ef,sr:sr,st:st,w:w,h:h,ip:ip,op:op,tm:tm,cl:cl,hd:hd,ao:ao,bm:bm)
        @Assert(ly.masksProperties.toString(),masksProperties.toString())
        @Assert(ly.shapes.toString(),shapes.toString())
        @Assert(ly.ef.toString(),ef.toString())
        @Assert(ly.toString(),"Layer {\n" +
                              "nm     = ${nm}\n" +
                              "ind    = ${ind}\n" +
                              "refId  = ${refId}\n" +
                              "ty     = ${ty}\n" +
                              "parent = ${parent}\n" +
                              "sw     = ${sw}\n" +
                              "sh     = ${sh}\n" +
                              "sc     = ${sc}\n" +
                              "ks     = ${ks}\n" +
                              "tt     = ${tt}\n" +
                              "masksProperties.size = ${masksProperties.size}\n" +
                              "shapes.size = ${shapes.size}\n" +
                              "t = ${t}\n" +
                              "ef.size = ${ef.size}\n" +
                              "sr = ${sr}\n" +
                              "st = ${st}\n" +
                              "w  = ${w}\n"  +
                              "h  = ${h}\n"  +
                              "ip = ${ip}\n" +
                              "op = ${op}\n" +
                              "tm = ${tm}\n" +
                              "cl = ${cl}\n" +
                              "hd = ${hd}\n" +
                              "ao = ${ao}\n" +
                              "bm = ${bm}\n}"  )
    }
    @TestCase
    func test_Layer_03():Unit {
        var nm = ""
        var ind = 0
        var refId = ""
        var ty= 0
        var parent= -1
        var sw= 0
        var sh= 0
        var sc= ""
        var ks= AnimatableTransform()
        var tt = 0
        var masksProperties = Array<Mask>()
        var shapes = Array<ContentModel>()
        var t=LayerT()
        var ef= Array<LayerEF>()
        var sr: Float64 = 0.0
        var st: Float64 = 0.0
        var w: Float64 = 0.0
        var h: Float64 = 0.0
        var ip: Float64 = 0.0
        var op: Float64 = 0.0
        var tm = ContentModelDK()
        var cl: String = ""
        var hd: Bool = false
        var ao: Int64 = 0
        var bm: Int64 = 0
        var ly=Layer()
        @Assert(ly.masksProperties.toString(),masksProperties.toString())
        @Assert(ly.shapes.toString(),shapes.toString())
        @Assert(ly.ef.toString(),ef.toString())
        @Assert(ly.toString(),"Layer {\n" +
                              "nm     = ${nm}\n" +
                              "ind    = ${ind}\n" +
                              "refId  = ${refId}\n" +
                              "ty     = ${ty}\n" +
                              "parent = ${parent}\n" +
                              "sw     = ${sw}\n" +
                              "sh     = ${sh}\n" +
                              "sc     = ${sc}\n" +
                              "ks     = ${ks}\n" +
                              "tt     = ${tt}\n" +
                              "masksProperties.size = ${masksProperties.size}\n" +
                              "shapes.size = ${shapes.size}\n" +
                              "t = ${t}\n" +
                              "ef.size = ${ef.size}\n" +
                              "sr = ${sr}\n" +
                              "st = ${st}\n" +
                              "w  = ${w}\n"  +
                              "h  = ${h}\n"  +
                              "ip = ${ip}\n" +
                              "op = ${op}\n" +
                              "tm = ${tm}\n" +
                              "cl = ${cl}\n" +
                              "hd = ${hd}\n" +
                              "ao = ${ao}\n" +
                              "bm = ${bm}\n}"  )
    }
}