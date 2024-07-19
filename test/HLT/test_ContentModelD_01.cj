// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*

@Test
public class TestLottie4cjContentModelD{
    @TestCase
    func test_ContentModelD_toString_01():Unit {
        let n="n_String"
        let v= ContentModelDK()
        var cmd=ContentModelD(n:n,v:v)
        @Assert(cmd.toString(),"ContentModelD: {\n" +"n = ${n},\n" +"v = ${v}\n}")
    }
    @TestCase
    func test_ContentModelD_toString_02():Unit {
        let n=""
        let v= ContentModelDK()
        var cmd=ContentModelD(n:n,v:v)
        @Assert(cmd.toString(),"ContentModelD: {\n" +"n = ${n},\n" +"v = ${v}\n}")
    }
    @TestCase
    func test_ContentModelD_toString_03():Unit {
        let v= ContentModelDK()
        var cmd=ContentModelD()
        @Assert(cmd.toString(),"ContentModelD: {\n" +"n = ,\n" +"v = ${v}\n}")
    }
}