// DEPENDENCE: ./files/Marker.json
// DEPENDENCE: ./test_shapes_05_result.cj
// EXEC: cjc %import-path %L %l %f ./test_shapes_05_result.cj
// EXEC: ./main

from std import fs.*
from std import sync.*

from lottie4cj import parser.*
from lottie4cj import model.*

main (){

    let filename: String = "Marker.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)
    let gr: ShapeGroup = (data.layers[0].shapes[0] as ShapeGroup).getOrThrow()

    var sum: Int64 = test_00(data)
    if (sum != 0) {
        return sum
    }

    sum = test_01(gr)
    if (sum != 0) {
        return sum
    }

    return 0
}

//0. 打印json文件最外层 - AnimationData
func test_00(data: AnimationData): Int64 {
    //println("------------------------------------------------------------------0")
    //println(data.toString())
    //println(shapes_05_str0 == data.toString())

    if(shapes_05_str0 != data.toString()) {
        return -2
    }
    return 0
}


func test_01(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------2-2-[tr]")
    //println(gr.it[2].toString())
    //println(shapes_05_str == gr.it[2].toString())

    if(shapes_05_str != gr.it[2].toString()) {
        return -1
    }
    return 0
}

func readFile(path: String): String {
    let file: File = File(path, OpenOption.Open(true, true))
    let len: Int64 = file.length
    var buf: Array<Byte> = Array<Byte>(len, item: 0)
    file.read(buf)
    file.close()

    return String.fromUtf8(buf)
}
