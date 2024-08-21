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
        src1.transform(0.1,7.69,6.77,0.81,7.689,6.7,0.71,7.69,6.7,0.91,7.669,6.7,0.1,7.769,6.77,5.8)
        var src = src1.isIdentity()
        @Assert(src, false)
    }

    @TestCase
    public func testsMatrix02(): Unit {
        var src1 = Matrix()
        var src = src1.translate(-1.6,3.9)
        var sct = src1.equals(src)
        @Assert(sct, true)
    }

    @TestCase
    public func testsMatrix03(): Unit {
        var src1 = Matrix()
        var src = src1.clone(src1)
        var sct = src1.equals(src)
        @Assert(sct, true)
    }

    @TestCase
    public func testsMatrix04(): Unit {
        var src1 = Matrix()
        src1.cloneFromProps(Array<Float64>(16,item: 0.6))
        var src = src1.isIdentity()
        @Assert(src, false)
    }

    @TestCase
    public func testsMatrix05(): Unit {
        var src1 = Matrix()
        var src = src1.applyToPoint(0.1,7.69,6.77)
        @Assert(src[0], 0.100000)
        @Assert(src[1], 7.690000)
        @Assert(src[2], 6.770000)
    }
}


