// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from std import fs.*
from std import sync.*

from lottie4cj import utils.helpers.*

main (){
    var src: String = BlendModes.getBlendMode(15)
    if (src != "luminosity") {
        return 1
    }
    return 0
}

