// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

from std import fs.*
from std import sync.*

from lottie4cj import elements.*

main (){
    var src: CvContextData = CvContextData()
    src.duplicate()
    if (src.getOpacity() != 1) {
        return 1
    }
    return 0
}

