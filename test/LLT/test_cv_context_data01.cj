// DEPENDENCE: ./files/AndroidWave.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*
public import std.unittest.*
import std.unittest.testmacro.*

public import lottie4cj.elements.*
public import lottie4cj.bezier.*

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
        var src = src1.popOpacity()
        @Assert(src, 0)
    }

    @TestCase
    public func testsCvContextData02(): Unit {
        var src1 = CvContextData()
        src1.duplicate()
        var src = src1.popOpacity()
        @Assert(src, 0)
    }


    @TestCase
    public func testsCvContextData03(): Unit {
        var src1 = CvContextData()
        src1.reset()
        var src = src1.popOpacity()
        @Assert(src, 0)
    }

    @TestCase
    public func testsCvContextData04(): Unit {
        var src1 = CvContextData()
        var src = src1.popTransform()
        @Assert(src.size, 16)
    }

    @TestCase
    public func testsCvContextData05(): Unit {
        var src1 = CvContextData()
        ShapeGroupData()
        src1.push()
        var src = src1.pop()
        @Assert(src[1], 1)
    }
}


