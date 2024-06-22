// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from std import fs.*
from std import sync.*

from lottie4cj import utils.*

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

