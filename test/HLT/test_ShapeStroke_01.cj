// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjShapeStroke{
    @TestCase
    func test_ShapeStroke_01():Unit {
        var nm="nm_ShapeStroke"
        var c= Array<Keyframe<Array<Float64>>>(145,item:Keyframe<Array<Float64>>())
        var w= Array<Keyframe<Float64>>(425,item:Keyframe<Float64>())
        var o= Array<Keyframe<Int64>>(450,item:Keyframe<Int64>())
        var lc=Int64.Max
        var lj=Int64.Max
        var ml=Float64(9)
        var hd=true
        var d=Array<ContentModelD>(105,item:ContentModelD())

        var shapeStroke=ShapeStroke(nm: nm, c: c, w: w, o: o, lc: lc, lj: lj, ml: ml,hd:hd, d:d)

        @Assert(shapeStroke.types,Int8(1))
        @Assert(shapeStroke.c.toString(),c.toString())
        @Assert(shapeStroke.w.toString(),w.toString())
        @Assert(shapeStroke.o.toString(),o.toString())
        @Assert(shapeStroke.d.toString(),d.toString())
        var re_exp= "ShapeStroke[st]: {\n" +
                                  "ty = st\n" +
                                  "nm = ${nm}\n" +
                                  "c = ${c}\n" +
                                  "w = ${w}\n" +
                                  "o = ${o}\n" +
                                  "lc = ${lc}\n" +
                                  "lj = ${lj}\n" +
                                  "ml = ${ml}\n" +
                                  "hd = ${hd}\n" +
                                  "d = ${d}\n}"
        @Assert(shapeStroke.toString(),re_exp)
    }

    @TestCase
    func test_ShapeStroke_02():Unit {
        var nm=""
        var c= Array<Keyframe<Array<Float64>>>()
        var w= Array<Keyframe<Float64>>()
        var o= Array<Keyframe<Int64>>()
        var lc=Int64.Min
        var lj=Int64.Min
        var ml=Float64(-9)
        var hd=false
        var d=Array<ContentModelD>()

        var shapeStroke=ShapeStroke(nm: nm, c: c, w: w, o: o, lc: lc, lj: lj, ml: ml,hd:hd, d:d)

        @Assert(shapeStroke.types,Int8(1))
        @Assert(shapeStroke.c.toString(),c.toString())
        @Assert(shapeStroke.w.toString(),w.toString())
        @Assert(shapeStroke.o.toString(),o.toString())
        @Assert(shapeStroke.d.toString(),d.toString())
        var re_exp= "ShapeStroke[st]: {\n" +
                                  "ty = st\n" +
                                  "nm = ${nm}\n" +
                                  "c = ${c}\n" +
                                  "w = ${w}\n" +
                                  "o = ${o}\n" +
                                  "lc = ${lc}\n" +
                                  "lj = ${lj}\n" +
                                  "ml = ${ml}\n" +
                                  "hd = ${hd}\n" +
                                  "d = ${d}\n}"
        @Assert(shapeStroke.toString(),re_exp)
    }
    /*
    @TestCase
    func test_ShapeStroke_03():Unit {
        var nm=""
        var c= Array<Keyframe<Array<Float64>>>()
        var w= Array<Keyframe<Float64>>()
        var o= Array<Keyframe<Int64>>()
        var lc=Int64.Min
        var lj=Int64.Min
        var ml=Float64(-9)
        var hd=false
        var d=Array<ContentModelD>()

        var shapeStroke=ShapeStroke(nm: nm, c: c, w: w, o: o, lc: lc, lj: lj, ml: ml,hd:hd, d:d)

        @Assert(shapeStroke.types,Int8(1))
        @Assert(shapeStroke.c.toString(),c.toString())
        @Assert(shapeStroke.w.toString(),w.toString())
        @Assert(shapeStroke.o.toString(),o.toString())
        @Assert(shapeStroke.d.toString(),d.toString())
        var re_exp= "ShapeStroke[st]: {\n" +
                                  "ty = st\n" +
                                  "nm = ${nm}\n" +
                                  "c = ${c}\n" +
                                  "w = ${w}\n" +
                                  "o = ${o}\n" +
                                  "lc = ${lc}\n" +
                                  "lj = ${lj}\n" +
                                  "ml = ${ml}\n" +
                                  "hd = ${hd}\n" +
                                  "d = ${d}\n}"
        @Assert(shapeStroke.toString(),re_exp)
    }*/
}