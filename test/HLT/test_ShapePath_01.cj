// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjShapePath{
    @TestCase
    func test_ShapePath_toString_01():Unit {
        var nm="ShapePath_nm"
        var ind=Int64.Max
        let kf=Keyframe<ShapeData>()
        var ks= Array<Keyframe<ShapeData>>(101, repeat:kf)
        var hd=true
        var sp=ShapePath(nm:nm,ind:ind,ks:ks,hd:hd)
        @Assert(sp.toString(),"ShapePath[sh]: {\n" +
                                 "ind: ${ind},\n" +
                                 "ty: sh,\n" +
                                 "nm: ${nm},\n" +
                                 "ks: ${ks},\n" +
                                 "hd: ${hd}\n}")
        @Assert(sp.types,Int8(6))
        @Assert(sp.ks.toString(),ks.toString())
    }
    @TestCase
    func test_ShapePath_toString_02():Unit {
        var nm=""
        var ind=Int64.Min
        var ks= Array<Keyframe<ShapeData>>()
        var hd=false
        var sp=ShapePath(nm:nm,ind:ind,ks:ks,hd:hd)
        @Assert(sp.toString(),"ShapePath[sh]: {\n" +
                               "ind: ${ind},\n" +
                               "ty: sh,\n" +
                               "nm: ${nm},\n" +
                               "ks: ${ks},\n" +
                               "hd: ${hd}\n}")
        @Assert(sp.types,Int8(6))
        @Assert(sp.ks.toString(),ks.toString())
    }
    @TestCase
    func test_ShapePath_toString_03():Unit {
        var nm=""
        var ind=0
        var ks= Array<Keyframe<ShapeData>>()
        var hd=false
        var sp=ShapePath()
        @Assert(sp.toString(),"ShapePath[sh]: {\n" +
                               "ind: ${ind},\n" +
                               "ty: sh,\n" +
                               "nm: ${nm},\n" +
                               "ks: ${ks},\n" +
                               "hd: ${hd}\n}")
        @Assert(sp.types,Int8(6))
        @Assert(sp.ks.toString(),ks.toString())
    }
}