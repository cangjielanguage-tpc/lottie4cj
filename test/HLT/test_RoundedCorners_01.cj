// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjRoundedCorners{
    @TestCase
    func test_RoundedCorners_toString_01():Unit {
        var nm="RoundedCorners_nm"
        var kf=Keyframe<Float64>()
        var k=Array<Keyframe<Float64>>(34, repeat:kf)
        let r = ArrayKeyframeFloat64(k: k)
        var hd=true

        var rc=RoundedCorners(nm:nm,r: r,hd:hd)
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                         "r = ${r.k}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }
    @TestCase
    func test_RoundedCorners_toString_02():Unit {
        var nm=""
        var k=Array<Keyframe<Float64>>()
        let r = ArrayKeyframeFloat64(k: k)
        var hd=false

        var rc=RoundedCorners(nm:nm, r: r,hd:hd)
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                          "r = ${r.k}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }

    @TestCase
    func test_RoundedCorners_toString_03():Unit {
        var nm=""
        var k=Array<Keyframe<Float64>>()
        let r = ArrayKeyframeFloat64(k: k)
        var hd=false

        var rc=RoundedCorners()
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                         "r = ${r.k}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }
}