// DEPENDENCE: ./files/AndroidWave.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*
public import std.unittest.*
import std.unittest.testmacro.*

public import lottie4cj.elements.*

main (){
    let testsCvContextData = TestsCvContextData()
    testsCvContextData.testsCvContextData01()
    testsCvContextData.testsCvContextData02()
    testsCvContextData.testsCvContextData03()
    testsCvContextData.testsCvContextData04()
    testsCvContextData.testsCvContextData05()
   
    return 0
}

@Test
public class TestsCvContextData {

    @TestCase
    public func testsCvContextData01(): Unit {
        var src1 = CvContextData()
        src1.push()
        var src = src1.popOpacity()
        @Assert(src, 0)
    }

    @TestCase
    public func testsCvContextData02(): Unit {
        var src1 = CvContextData()
        src1.getTransform()
        var src = src1.getOpacity()
        @Assert(src, 1)
    }


    @TestCase
    public func testsCvContextData03(): Unit {
        var src1 = CvContextData()
        src1.setOpacity(0)
        var src = src1.getOpacity()
        @Assert(src, 0)
    }

    @TestCase
    public func testsCvContextData04(): Unit {
        var src1 = CvContextData()
        src1.setOpacity(-1000)
        var src = src1.getOpacity()
        @Assert(src, -1000)
    }

    @TestCase
    public func testsCvContextData05(): Unit {
        var src1 = CvContextData()
        src1.setOpacity(696)
        var src = src1.getOpacity()
        @Assert(src, 696)
    }
}


