// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjGradientFill{
    @TestCase
    func test_GradientFill_toString_01():Unit {
        let nm="GradientFill_nm"
        let g=ContentModelP()
        let o=Array<Keyframe<Int64>>(100,item:Keyframe<Int64>())
        let t=Int64.Max
        let s=Array<Keyframe<Array<Float64>>>(100,item:Keyframe<Array<Float64>>())
        let e=Array<Keyframe<Array<Float64>>>(100,item:Keyframe<Array<Float64>>())
        let r=Int64.Max
        let hd=true
        var gf=GradientFill(nm:nm, g: g, o: o, t: t,s:s,e:e,r:r,hd:hd)
        @Assert(gf.toString(),"GradientFill[gf]: {\n" +
                                     "ty = gf\n" +
                                     "nm = ${nm}\n" +
                                     "g = ${g}\n" +
                                     "o = ${o}\n" +
                                     "t = ${t}\n" +
                                     "s = ${s}\n" +
                                     "e = ${e}\n" +
                                     "r = ${r}\n" +
                                     "hd = ${hd}\n}")
        @Assert(gf.types,Int8(4))
        @Assert(gf.o.toString(),o.toString())
        @Assert(gf.s.toString(),s.toString())
        @Assert(gf.e.toString(),e.toString())
    }
    @TestCase
    func test_GradientFill_toString_02():Unit {
        let nm=""
        let g=ContentModelP()
        let o=Array<Keyframe<Int64>>()
        let t=Int64.Min
        let s=Array<Keyframe<Array<Float64>>>()
        let e=Array<Keyframe<Array<Float64>>>()
        let r=Int64.Min
        let hd=false
        var gf=GradientFill(nm:nm, g: g, o: o, t: t,s:s,e:e,r:r,hd:hd)
        @Assert(gf.toString(),"GradientFill[gf]: {\n" +
                                     "ty = gf\n" +
                                     "nm = ${nm}\n" +
                                     "g = ${g}\n" +
                                     "o = ${o}\n" +
                                     "t = ${t}\n" +
                                     "s = ${s}\n" +
                                     "e = ${e}\n" +
                                     "r = ${r}\n" +
                                     "hd = ${hd}\n}")
        @Assert(gf.types,Int8(4))
        @Assert(gf.o.toString(),o.toString())
        @Assert(gf.s.toString(),s.toString())
        @Assert(gf.e.toString(),e.toString())
    }
    @TestCase
    func test_GradientFill_toString_03():Unit {
        let g=ContentModelP()
        var gf=GradientFill()
        @Assert(gf.toString(),"GradientFill[gf]: {\n" +
                                     "ty = gf\n" +
                                     "nm = \n" +
                                     "g = ${g}\n" +
                                     "o = []\n" +
                                     "t = 0\n" +
                                     "s = []\n" +
                                     "e = []\n" +
                                     "r = 0\n" +
                                     "hd = false\n}")
        @Assert(gf.types,Int8(4))
    }
}