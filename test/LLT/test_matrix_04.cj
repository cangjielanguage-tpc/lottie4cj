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
        var src = src1.applyToX(0.1,-36.9,-6.77)
        @Assert(src, 0.100000)
    }

    @TestCase
    public func testsMatrix02(): Unit {
        var src1 = Matrix()
        var src = src1.applyToY(-1.6,3.9,4.6)
        @Assert(src, 3.900000)
    }

    @TestCase
    public func testsMatrix03(): Unit {
        var src1 = Matrix()
        var src = src1.applyToZ(-1.06,13.9,-6.7)
        @Assert(src, -6.700000)
    }

    @TestCase
    public func testsMatrix04(): Unit {
        var src1 = Matrix()
        var src = src1.getInverseMatrix()
        @Assert(src.isIdentity(), true)
    }

    @TestCase
    public func testsMatrix05(): Unit {
        var src1 = Matrix()
        var src = src1.inversePoint(Array<Float64>(16,item:0.862))
        @Assert(src[0], 0.862000)
    }
}


