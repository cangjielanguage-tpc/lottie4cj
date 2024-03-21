// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjKeyframe{
    @TestCase
    func test_Keyframe_toString_01():Unit {
        var k=Option<Int64>.Some(101)
        var t=Float64(1.1)
        var s=Option<Int64>.Some(102)
        var e=Option<Int64>.Some(103)
        var o=PointF(x:Float64(104),y:Float64(105))
        var i=PointF(x:Float64(106),y:Float64(107))
        var h=Int64(108)
        var to=PointF(x:Float64(109),y:Float64(110))
        var ti=PointF(x:Float64(111),y:Float64(112))
        var kf=Keyframe(k:k,t:t,s:s,e:e,o:o,i:i,h:h,to:to,ti:ti)
        @Assert(kf.toString(),"Keyframe{\n" +
                             "k = ${k.getOrThrow()}\n" +
                             "t = ${t}\n" +
                             "s = ${s.getOrThrow()}\n" +
                             "e = ${e.getOrThrow()}\n" +
                             "o = ${o}\n" +
                             "i = ${i}\n" +
                             "h = ${h}\n" +
                             "to = ${to}\n" +
                             "ti = ${ti}\n}")
    }
    @TestCase
    func test_Keyframe_toString_02():Unit {
        var k=Option<Int64>.Some(-101)
        var t=Float64(-1.1)
        var s=Option<Int64>.Some(-102)
        var e=Option<Int64>.Some(-103)
        var o=PointF(x:Float64(-104),y:Float64(-105))
        var i=PointF(x:Float64(-106),y:Float64(-107))
        var h=Int64(-108)
        var to=PointF(x:Float64(-109),y:Float64(-110))
        var ti=PointF(x:Float64(-111),y:Float64(-112))
        var kf=Keyframe(k:k,t:t,s:s,e:e,o:o,i:i,h:h,to:to,ti:ti)
        @Assert(kf.toString(),"Keyframe{\n" +
                             "k = ${k.getOrThrow()}\n" +
                             "t = ${t}\n" +
                             "s = ${s.getOrThrow()}\n" +
                             "e = ${e.getOrThrow()}\n" +
                             "o = ${o}\n" +
                             "i = ${i}\n" +
                             "h = ${h}\n" +
                             "to = ${to}\n" +
                             "ti = ${ti}\n}")
    }
    @TestCase
    func test_Keyframe_toString_03():Unit {
        var k=Option<Int64>.None
        var t=Float64(0)
        var s=Option<Int64>.None
        var e=Option<Int64>.None
        var o=PointF(x:Float64(-0),y:Float64(-0))
        var i=PointF(x:Float64(-0),y:Float64(-0))
        var h=Int64(-0)
        var to=PointF(x:Float64(-0),y:Float64(-0))
        var ti=PointF(x:Float64(-0),y:Float64(-0))
        var kf=Keyframe(k:k,t:t,s:s,e:e,o:o,i:i,h:h,to:to,ti:ti)
        @Assert(kf.toString(),"Keyframe{\n" +
                             "k = None\n" +
                             "t = ${t}\n" +
                             "s = None\n" +
                             "e = None\n" +
                             "o = ${o}\n" +
                             "i = ${i}\n" +
                             "h = ${h}\n" +
                             "to = ${to}\n" +
                             "ti = ${ti}\n}")
    }
    @TestCase
    func test_Keyframe_toString_04():Unit {
        var t=Float64(0)
        var o=PointF()
        var i=PointF()
        var h=Int64(0)
        var to=PointF()
        var ti=PointF()
        var kf=Keyframe()
        @Assert(kf.toString(),"Keyframe{\n" +
                             "k = None\n" +
                             "t = ${t}\n" +
                             "s = None\n" +
                             "e = None\n" +
                             "o = ${o}\n" +
                             "i = ${i}\n" +
                             "h = ${h}\n" +
                             "to = ${to}\n" +
                             "ti = ${ti}\n}")
    }
}