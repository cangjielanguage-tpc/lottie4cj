// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjPointF{
    var x=Float64(105)
    var y=Float64(105)
    @TestCase
    func test_PointF_toString_01():Unit {
        var pf=PointF(x:x,y:y)
        @Assert(pf.toString(),"PointF: {x='${x}', y='${y}'}")
    }
    @TestCase
    func test_PointF_toString_02():Unit {
        var pf=PointF()
        @Assert(pf.toString(),"PointF: {x='${Float64(0.0)}', y='${Float64(0.0)}'}")
    }
    @TestCase
    func test_PointF_toString_03():Unit {
        var pf=PointF(x:-x,y:-y)
        @Assert(pf.toString(),"PointF: {x='${-x}', y='${-y}'}")
    }
}