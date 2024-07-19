// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.elements.*

main (){
    var src: CvContextData = CvContextData()
    src.duplicate()
    if (src.getOpacity() != 1) {
        return 1
    }
    return 0
}

