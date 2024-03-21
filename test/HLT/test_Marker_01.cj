// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
@Test
public class TestLottie4cjMarker{
    var cm="cm"
    var tm=Float64(6.66)
    var dr=Float64(8.88)
    @TestCase
    func test_Marker_toString_01():Unit {
        cm="cm"
        tm=Float64(6.66)
        dr=Float64(8.88)
        var clr=Marker(cm,tm,dr)
        @Assert(clr.toString(), "Marker: {\n" +
                                "cm = ${cm}\n" +
                                "tm = ${tm}\n" +
                                "dr = ${dr}\n}")
    }
    @TestCase
    func test_Marker_toString_02():Unit {
        cm=""
        tm=Float64(-6.66)
        dr=Float64(-8.88)
        var clr=Marker(cm,tm,dr)
        @Assert(clr.toString(), "Marker: {\n" +
                                "cm = ${cm}\n" +
                                "tm = ${tm}\n" +
                                "dr = ${dr}\n}")
    }
}