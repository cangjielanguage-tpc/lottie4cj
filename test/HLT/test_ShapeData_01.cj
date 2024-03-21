// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjShapeData{
    @TestCase
    func test_ShapeData_toString_01():Unit {
        var c=true
        var v=Array<PointF>()
        var i=Array<PointF>()
        var o=Array<PointF>()
        var sd=ShapeData(c:c,v:v,i:i,o:o)
        @Assert(sd.toString(), "ShapeData: {\n" +
                                  "c = ${c}\n" +
                                  "v = ${v}\n" +
                                  "i = ${i}\n" +
                                  "o = ${o}\n}")
        @Assert(sd.i.toString(), i.toString())
        @Assert(sd.v.toString(), v.toString())
        @Assert(sd.o.toString(), o.toString())
    }
    @TestCase
    func test_ShapeData_toString_02():Unit {
        var c=true
        var pf=PointF(x:Float64(1080),y:Float64(1080))
        var v=Array<PointF>(101,item:pf)
        var i=Array<PointF>(10,item:pf)
        var o=Array<PointF>(1,item:pf)
        var sd=ShapeData(c:c,v:v,i:i,o:o)
        @Assert(sd.toString(), "ShapeData: {\n" +
                                  "c = ${c}\n" +
                                  "v = ${v}\n" +
                                  "i = ${i}\n" +
                                  "o = ${o}\n}")
        @Assert(sd.i.toString(), i.toString())
        @Assert(sd.v.toString(), v.toString())
        @Assert(sd.o.toString(), o.toString())
    }
    @TestCase
    func test_ShapeData_toString_03():Unit {
        var re=Array<PointF>()
        var sd=ShapeData()
        @Assert(sd.toString(), "ShapeData: {\n" +
                                  "c = false\n" +
                                  "v = ${re}\n" +
                                  "i = ${re}\n" +
                                  "o = ${re}\n}")
        @Assert(sd.i.toString(), re.toString())
        @Assert(sd.v.toString(), re.toString())
        @Assert(sd.o.toString(), re.toString())
    }
}