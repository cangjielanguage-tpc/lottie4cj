// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.pool.*

main (){
    var returnTag: String = ""
    try {
        var src = BezierData(-10,PointData())
    }catch (e: IllegalArgumentException) {
        returnTag = e.toString()
    }
    if (returnTag != "IllegalArgumentException: The length of points cannot be negative.") {
        return 1
    }
    return 0
}
