// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*
from std import math.*
@Test
public class TestLottie4cjColor{
    @TestCase
    func test_Color_toString_01():Unit {
        var a=Int64.Min
        var r=Int64.Min
        var g=Int64.Min
        var b=Int64.Min
        var clr=Color(a,r,g,b)
        @Assert(clr.toString(), "Color{a: ${a}, r: ${r}, g: ${g}, b: ${b}}")
    }
    @TestCase
    func test_Color_toString_02():Unit {
        var a=Int64.Max
        var r=Int64.Max
        var g=Int64.Max
        var b=Int64.Max
        var clr=Color(a,r,g,b)
        @Assert(clr.toString(), "Color{a: ${a}, r: ${r}, g: ${g}, b: ${b}}")
    }
    @TestCase
    func test_Color_toString_03():Unit {
        var a=0
        var r=0
        var g=0
        var b=0
        var clr=Color(a,r,g,b)
        @Assert(clr.toString(), "Color{a: ${a}, r: ${r}, g: ${g}, b: ${b}}")
    }
}