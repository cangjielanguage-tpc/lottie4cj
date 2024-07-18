// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjShapeGroup{
    @TestCase
    func test_ShapeGroup_toString_01():Unit {
        var cm=ContentModel()
        var nm="ShapeGroup"
        var it=Array<ContentModel>(102,item:cm)
        var hd=true
        var sg=ShapeGroup(nm,it,hd)
        @Assert(sg.toString(),"ShapeGroup[gr]: {\n" +
                                      "ty: gr,\n" +
                                      "nm: ${nm},\n" +
                                      "hd: ${hd},\n" +
                                      "it: ${it}\n}")
        @Assert(sg.types,Int8(0))
        @Assert(sg.it.toString(),it.toString())
    }
    @TestCase
    func test_ShapeGroup_toString_02():Unit {
        var nm=""
        var it=Array<ContentModel>()
        var hd=false
        var sg=ShapeGroup(nm,it,hd)
        @Assert(sg.toString(),"ShapeGroup[gr]: {\n" +
                                      "ty: gr,\n" +
                                      "nm: ${nm},\n" +
                                      "hd: ${hd},\n" +
                                      "it: ${it}\n}")
        @Assert(sg.types,Int8(0))
        @Assert(sg.it.toString(),it.toString())
    }
}