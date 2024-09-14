// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjDocumentData{
    @TestCase
    func test_DocumentData_toString_01():Unit {
        var tValue="DocumentData"
        var fValue="DocumentData"
        var sValue=Float64(1.23333)
        var jValue=108
        var trValue=95
        var lhValue=Float64(1.00000)
        var lsValue=Float64(1.00000)
        var fcValue=Array<Float64>(100, repeat:Float64(1.00000))
        var scValue=Array<Float64>(100, repeat:Float64(1.00000))
        var swValue=Float64(2.00000)
        var ofValue=true
        var psValue: Array<Float64> = [Float64(25),Float64(25)]
        var szValue: Array<Float64> = [Float64(55),Float64(55)]
        var dd=DocumentData(t:tValue, f:fValue,s: sValue, j:jValue, tr:trValue, lh:lhValue, ls:lsValue, fc:fcValue,
                            sc:scValue, sw:swValue, of: ofValue, ps: psValue, sz: szValue)
        @Assert(dd.fc,fcValue)
        @Assert(dd.sc,scValue)
        @Assert(dd.toString(), "DocumentData: {\n" +
                             "t = ${tValue}\n" +
                             "f = ${fValue}\n" +
                             "s = ${sValue}\n" +
                             "j = ${jValue}\n" +
                             "tr = ${trValue}\n" +
                             "lh = ${lhValue}\n" +
                             "ls = ${lsValue}\n" +
                             "fc = ${dd.fc}\n" +
                             "sc = ${dd.sc}\n" +
                             "sw = ${swValue}\n" +
                             "of = ${ofValue}\n" +
                             "ps = ${psValue}\n" +
                             "sz = ${szValue}\n}")
    }
    @TestCase
    func test_DocumentData_toString_02():Unit {
        var tValue=""
        var fValue=""
        var sValue=Float64(-1.23333)
        var jValue=-108
        var trValue=-95
        var lhValue=Float64(-1.00000)
        var lsValue=Float64(-1.00000)
        var fcValue=Array<Float64>()
        var scValue=Array<Float64>()
        var swValue=Float64(-2.00000)
        var ofValue=false
        var psValue: Array<Float64> = [Float64(-25),Float64(-25)]
        var szValue: Array<Float64> = [Float64(-55),Float64(-55)]
        var dd=DocumentData(t:tValue, f:fValue,s: sValue, j:jValue, tr:trValue, lh:lhValue, ls:lsValue, fc:fcValue,
                            sc:scValue, sw:swValue, of: ofValue, ps: psValue, sz: szValue)
        @Assert(dd.fc,fcValue)
        @Assert(dd.sc,scValue)
        @Assert(dd.toString(), "DocumentData: {\n" +
                             "t = ${tValue}\n" +
                             "f = ${fValue}\n" +
                             "s = ${sValue}\n" +
                             "j = ${jValue}\n" +
                             "tr = ${trValue}\n" +
                             "lh = ${lhValue}\n" +
                             "ls = ${lsValue}\n" +
                             "fc = ${dd.fc}\n" +
                             "sc = ${dd.sc}\n" +
                             "sw = ${swValue}\n" +
                             "of = ${ofValue}\n" +
                             "ps = ${psValue}\n" +
                             "sz = ${szValue}\n}")
    }
    @TestCase
    func test_DocumentData_toString_03():Unit {
        var tValue=""
        var fValue=""
        var sValue=Float64(0)
        var jValue=0
        var trValue=0
        var lhValue=Float64(0.00000)
        var lsValue=Float64(0.00000)
        var fcValue=Array<Float64>()
        var scValue=Array<Float64>()
        var swValue=Float64(0.00000)
        var ofValue=false  
        var psValue: Array<Float64> = Array<Float64>()
        var szValue: Array<Float64> = Array<Float64>()
        
        var dd=DocumentData()
        @Assert(dd.fc,fcValue)
        @Assert(dd.sc,scValue)
        @Assert(dd.toString(), "DocumentData: {\n" +
                             "t = ${tValue}\n" +
                             "f = ${fValue}\n" +
                             "s = ${sValue}\n" +
                             "j = ${jValue}\n" +
                             "tr = ${trValue}\n" +
                             "lh = ${lhValue}\n" +
                             "ls = ${lsValue}\n" +
                             "fc = ${dd.fc}\n" +
                             "sc = ${dd.sc}\n" +
                             "sw = ${swValue}\n" +
                             "of = ${ofValue}\n" +
                             "ps = ${psValue}\n" +
                             "sz = ${szValue}\n}")
    }
}