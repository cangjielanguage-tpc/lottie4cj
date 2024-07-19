// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){

    var sum: Int64 = test_00()
    if (sum != 0) {
        return sum
    }

    return 0
}

func test_00(): Int64 {
    let c: Color = Color(4, 5, 6, 7)
    //println(c.toString())

    if(c.a != 4 || c.r != 5 || c.g != 6 || c.b != 7) {
        return -1
    }

    if(c.toString() != "Color{a: 4, r: 5, g: 6, b: 7}") {
        return -2
    }
    return 0
}
