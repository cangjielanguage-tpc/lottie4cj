// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.utils.helpers.*

main (){
    var src: String = BlendModes.getBlendMode(15)
    if (src != "luminosity") {
        return 1
    }
    return 0
}

