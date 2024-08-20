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
    let testsMatrix = TestsMatrix()
    testsMatrix.testsMatrix01()
    testsMatrix.testsMatrix02()
    testsMatrix.testsMatrix03()
    testsMatrix.testsMatrix04()
    testsMatrix.testsMatrix05()

    return 0
}

@Test
public class TestsMatrix {

    @TestCase
    public func testsMatrix01(): Unit {
        var src1 = Matrix()
        var src = src1.isIdentity()
        @Assert(src, true)
    }

    @TestCase
    public func testsMatrix02(): Unit {
        var src1 = Matrix()
        src1.rotate(1.36)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(0.209239,-0.209239,0.209239,0.209239,0.000000,0.000000)")
    }

    @TestCase
    public func testsMatrix03(): Unit {
        var src1 = Matrix()
        src1.rotate(-1.3)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(0.267499,-0.267499,0.267499,0.267499,0.000000,0.000000)")
    }

    @TestCase
    public func testsMatrix04(): Unit {
        var src1 = Matrix()
        src1.rotate(3.7)
        var src = src1.isIdentity()
        @Assert(src, false)
    }

    @TestCase
    public func testsMatrix05(): Unit {
        var src1 = Matrix()
        src1.rotateY(13.7)
        var src = src1.isIdentity()
        @Assert(src, false)
    }
}


