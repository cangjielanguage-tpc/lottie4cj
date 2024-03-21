// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjRoundedCorners{
    @TestCase
    func test_RoundedCorners_toString_01():Unit {
        var nm="RoundedCorners_nm"
        var kf=Keyframe<Float64>()
        var r=Array<Keyframe<Float64>>(34,item:kf)
        var hd=true

        var rc=RoundedCorners(nm:nm,r:r,hd:hd)
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                         "r = ${r}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }
    @TestCase
    func test_RoundedCorners_toString_02():Unit {
        var nm=""
        var r=Array<Keyframe<Float64>>()
        var hd=false

        var rc=RoundedCorners(nm:nm,r:r,hd:hd)
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                         "r = ${r}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }

    @TestCase
    func test_RoundedCorners_toString_03():Unit {
        var nm=""
        var r=Array<Keyframe<Float64>>()
        var hd=false

        var rc=RoundedCorners()
        @Assert(rc.toString(), "RoundedCorners[rd]: {\n" +
                                         "ty = rd\n" +
                                         "nm = ${nm}\n" +
                                         "r = ${r}\n" +
                                         "hd = ${hd}\n}")
        @Assert(rc.types,Int8(13))
        @Assert(rc.r.toString(),r.toString())
    }
}