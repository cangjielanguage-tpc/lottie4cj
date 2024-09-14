// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjAnimationData{
    @TestCase
    func test_AnimationData_01():Unit {
        var w=Int64.Max
        var h=Int64.Max
        var ip=Float64(5.666)
        var op=Float64(7.666)
        var fr=Float64(9.666)
        var v="v_AnimationData"
        var layers=Array<Layer>(109, repeat:Layer())

        var id="Asset_id"
        var lr=Layer()
        var lrs=Array<Layer>(102, repeat:lr)
        var w_Asset=567
        var h_Asset=765
        var p="Asset_P"
        var u="Asset_U"
        var at=Asset(id,lrs,w_Asset,h_Asset,p,u, 0)

        var assets=Array<Asset>(110, repeat:at)
        var fonts=Fonts()

        var data=CharsData()
        var ch=""
        var size=Float64(-5.0)
        var w_FontCharacter=Float64(-1.0)
        var style=""
        var fFamily=""
        var fc=FontCharacter(data,ch,size,w_FontCharacter,style,fFamily)
        var chars=Array<FontCharacter>(108, repeat:fc)
        var marker=Marker("cm",Float64(9),Float64(19))
        var markers=Array<Marker>(109, repeat:marker)
        var nm="nm_AnimationData"
        var ddd=Int64.Max

        var animationData=AnimationData(w:w, h: h, ip: ip, op: op, fr: fr, v:v,layers: layers, assets: assets, fonts: fonts, chars: chars,markers: markers, nm: nm, ddd: ddd)
        @Assert(animationData.layers.toString(),layers.toString())
        @Assert(animationData.assets.toString(),assets.toString())
        @Assert(animationData.chars.toString(),chars.toString())
        @Assert(animationData.markers.toString(),markers.toString())
        @Assert(animationData.toString(),"AnimationData {\n" +
                                             "w  = ${w}\n" +                       // 0 = width
                                             "h  = ${h}\n" +                       // 1 = height
                                             "ip = ${ip}\n" +                      // 2 = startFrame
                                             "op = ${op}\n" +                      // 3 = endFrame
                                             "fr = ${fr}\n" +                      // 4 = frameRate
                                             "v  = ${v}\n" +                       // 5 = version
                                             "nm  = ${nm}\n" +                     // 11 = nm
                                             "ddd = ${ddd}\n" +                    // 12 = ddd
                                             "layers.size = ${layers.size}\n" +    // 6 = layers
                                             "assets.size = ${assets.size}\n" +    // 7 = assets
                                             "fonts = ${fonts}\n" +                // 8 = fonts
                                             "chars.size = ${chars.size}\n" +      // 9 = chars
                                             "markers.size = ${markers.size}\n}"   // 10 = markers
                                             )
    }
    @TestCase
    func test_AnimationData_02():Unit {
        var w=Int64.Min
        var h=Int64.Min
        var ip=Float64(-5.666)
        var op=Float64(-7.666)
        var fr=Float64(-9.666)
        var v=""
        var layers=Array<Layer>()
        var assets=Array<Asset>()
        var fonts=Fonts()
        var chars=Array<FontCharacter>()
        var markers=Array<Marker>()
        var nm=""
        var ddd=Int64.Min

        var animationData=AnimationData(w:w, h: h, ip: ip, op: op, fr: fr, v:v,layers: layers, assets: assets, fonts: fonts, chars: chars,markers: markers, nm: nm, ddd: ddd)
        @Assert(animationData.layers.toString(),layers.toString())
        @Assert(animationData.assets.toString(),assets.toString())
        @Assert(animationData.chars.toString(),chars.toString())
        @Assert(animationData.markers.toString(),markers.toString())
        @Assert(animationData.toString(),"AnimationData {\n" +
                                             "w  = ${w}\n" +                       // 0 = width
                                             "h  = ${h}\n" +                       // 1 = height
                                             "ip = ${ip}\n" +                      // 2 = startFrame
                                             "op = ${op}\n" +                      // 3 = endFrame
                                             "fr = ${fr}\n" +                      // 4 = frameRate
                                             "v  = ${v}\n" +                       // 5 = version
                                             "nm  = ${nm}\n" +                     // 11 = nm
                                             "ddd = ${ddd}\n" +                    // 12 = ddd
                                             "layers.size = ${layers.size}\n" +    // 6 = layers
                                             "assets.size = ${assets.size}\n" +    // 7 = assets
                                             "fonts = ${fonts}\n" +                // 8 = fonts
                                             "chars.size = ${chars.size}\n" +      // 9 = chars
                                             "markers.size = ${markers.size}\n}"   // 10 = markers
                                             )
    }
    @TestCase
    func test_AnimationData_03():Unit {
        var w=0
        var h=0
        var ip=Float64(0)
        var op=Float64(0)
        var fr=Float64(0)
        var v=""
        var layers=Array<Layer>()
        var assets=Array<Asset>()
        var fonts=Fonts()
        var chars=Array<FontCharacter>()
        var markers=Array<Marker>()
        var nm=""
        var ddd=0

        var animationData=AnimationData()
        @Assert(animationData.layers.toString(),layers.toString())
        @Assert(animationData.assets.toString(),assets.toString())
        @Assert(animationData.chars.toString(),chars.toString())
        @Assert(animationData.markers.toString(),markers.toString())
        @Assert(animationData.toString(),"AnimationData {\n" +
                                             "w  = ${w}\n" +                       // 0 = width
                                             "h  = ${h}\n" +                       // 1 = height
                                             "ip = ${ip}\n" +                      // 2 = startFrame
                                             "op = ${op}\n" +                      // 3 = endFrame
                                             "fr = ${fr}\n" +                      // 4 = frameRate
                                             "v  = ${v}\n" +                       // 5 = version
                                             "nm  = ${nm}\n" +                     // 11 = nm
                                             "ddd = ${ddd}\n" +                    // 12 = ddd
                                             "layers.size = ${layers.size}\n" +    // 6 = layers
                                             "assets.size = ${assets.size}\n" +    // 7 = assets
                                             "fonts = ${fonts}\n" +                // 8 = fonts
                                             "chars.size = ${chars.size}\n" +      // 9 = chars
                                             "markers.size = ${markers.size}\n}"   // 10 = markers
                                             )
    }
}