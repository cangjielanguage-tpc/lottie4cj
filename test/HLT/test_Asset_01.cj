// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

from lottie4cj import parser.*
from lottie4cj import model.*

@Test
public class TestLottie4cjAsset{
    @TestCase
    func test_Asset_toString_01():Unit {
        var id="Asset_id"
        var lr=Layer()
        var lrs=Array<Layer>(102,item:lr)
        var w=567
        var h=765
        var p="Asset_P"
        var u="Asset_U"
        var at=Asset(id,lrs,w,h,p,u)
        @Assert(at.toString(),"Asset: {\n" +
                              "id = ${id}\n" +
                              "layers.size = ${lrs.size}\n" +
                              "w = ${w}\n" +
                              "h = ${h}\n" +
                              "p = ${p}\n" +
                              "u = ${u}\n}")
        @Assert(at.layers.toString(),lrs.toString())
    }
    @TestCase
    func test_Asset_toString_02():Unit {
        var id=""
        var lrs=Array<Layer>()
        var w=-567
        var h=-765
        var p=""
        var u=""
        var at=Asset(id,lrs,w,h,p,u)
        @Assert(at.toString(),"Asset: {\n" +
                              "id = ${id}\n" +
                              "layers.size = ${lrs.size}\n" +
                              "w = ${w}\n" +
                              "h = ${h}\n" +
                              "p = ${p}\n" +
                              "u = ${u}\n}")
        @Assert(at.layers.toString(),lrs.toString())
    }
}