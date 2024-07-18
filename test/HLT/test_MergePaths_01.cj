// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjMergePaths{
    var nm=""
    var mm=15
    var hd=true
    @TestCase
    func test_MergePaths_toString_01():Unit {
        nm="MergePaths_nm"
        mm=65
        hd=false
        var mp=MergePaths(nm:nm,mm:mm,hd:hd)
        @Assert(mp.toString(), "MergePaths[mm]: {\n" +
                                     "ty = mm\n" +
                                     "nm = ${nm}\n" +
                                     "mm = ${mm}\n" +
                                     "hd = ${hd}\n}")
        @Assert(mp.types, Int8(11))
    }
    @TestCase
    func test_MergePaths_toString_02():Unit {
        nm=""
        mm=-15
        hd=true
        var mp=MergePaths(nm:nm,mm:mm,hd:hd)
        @Assert(mp.toString(), "MergePaths[mm]: {\n" +
                                      "ty = mm\n" +
                                      "nm = ${nm}\n" +
                                      "mm = ${mm}\n" +
                                      "hd = ${hd}\n}")
        @Assert(mp.types, Int8(11))
    }
    @TestCase
    func test_MergePaths_toString_03():Unit {
        var mp=MergePaths()
        @Assert(mp.toString(), "MergePaths[mm]: {\n" +
                                      "ty = mm\n" +
                                      "nm = \n" +
                                      "mm = 0\n" +
                                      "hd = false\n}")
        @Assert(mp.types, Int8(11))
    }
}