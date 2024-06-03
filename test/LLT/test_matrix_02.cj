// DEPENDENCE: ./files/AndroidWave.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from std import fs.*
from std import sync.*
from std import unittest.*
from std import unittest.testmacro.*

from lottie4cj import elements.*
from lottie4cj import third_party.*

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
        src1.rotateZ(3.7)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(-0.848100,0.529836,-0.529836,-0.848100,0.000000,0.000000)")
    }

    @TestCase
    public func testsMatrix02(): Unit {
        var src1 = Matrix()
        src1.skew(0.36,1.36)
        var src = src1.isIdentity()
        @Assert(src, true)
    }

    @TestCase
    public func testsMatrix03(): Unit {
        var src1 = Matrix()
        src1.skewFromAxis(-1.3,0.36)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(-0.187586,0.447011,-3.155092,2.187586,0.000000,0.000000)")
    }

    @TestCase
    public func testsMatrix04(): Unit {
        var src1 = Matrix()
        src1.scale(0.91,7.669,sz:6.7)
        var src = src1.isIdentity()
        @Assert(src, false)
    }

    @TestCase
    public func testsMatrix05(): Unit {
        var src1 = Matrix()
        src1.setTransform(0.1,7.69,6.77,0.81,7.689,6.7,0.71,7.69,6.7,0.91,7.669,6.7,0.1,7.769,6.77,5.8)
        var src = src1.to2dCSS()
        @Assert(src, "matrix(0.100000,7.690000,7.689000,6.700000,0.100000,7.769000)")
    }
}


