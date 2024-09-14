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
    testsMatrix.testsMatrix06()
    testsMatrix.testsMatrix07()

    return 0
}

@Test
public class TestsMatrix {

    @TestCase
    public func testsMatrix01(): Unit {
        var src1 = Matrix()
        let data = Array<Float64>(16,repeat: 6.95)
        var src = src1.inversePoints(Array<Array<Float64>>(16,repeat:data))
        @Assert(src[0][1], 6.950000)
    }

    @TestCase
    public func testsMatrix02(): Unit {
        var src1 = Matrix()
        let data = Array<Float64>(16,repeat: 6.95)
        let data1 = Array<Float64>(16,repeat: -15.5)
        let data2 = Array<Float64>(16,repeat: 0.39)
        var src = src1.applyToTriplePoints(data,data1,data2)
        @Assert(src[0], 6.950000)
    }

    @TestCase
    public func testsMatrix03(): Unit {
        var src1 = Matrix()
        var src = src1.applyToPointArray(-1.06,13.9,-6.7)
        @Assert(src[0], -1.060000)
        @Assert(src[1], 13.900000)
        @Assert(src[2], -6.700000)
    }

    @TestCase
    public func testsMatrix04(): Unit {
        var src1 = Matrix()
        var src = src1.applyToPointStringified(-0.735,96662.6)
        @Assert(src, "-0.735000,96662.600000")
    }

    @TestCase
    public func testsMatrix05(): Unit {
        var src1 = Matrix()
        var src = src1.roundMatrixProperty(0.862)
        @Assert(src, 0.862000)
    }

    @TestCase
    public func testsMatrix06(): Unit {
        var src1 = Matrix()
        src1.applyToPointStringified(-0.735,96662.6)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(1.000000,0.000000,0.000000,1.000000,0.000000,0.000000)")
    }

    @TestCase
    public func testsMatrix07(): Unit {
        var src1 = Matrix()
        src1.applyToPointStringified(-0.735,96662.6)
        src1.scale(0.91,7.669,sz:6.7)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(0.910000,0.000000,0.000000,7.669000,0.000000,0.000000)")
        src1.reset()
        var sres = src1.to2dCSS()
        @Assert(sres, "matrix(1.000000,0.000000,0.000000,1.000000,0.000000,0.000000)")
    }
    
}


