// DEPENDENCE: ./files/name.json
// DEPENDENCE: ./test_layer_04_result.cj
// EXEC: cjc %import-path %L %l %f ./test_layer_04_result.cj
// EXEC: ./main


from std import fs.*
from std import sync.*

from lottie4cj import parser.*
from lottie4cj import model.*

main (){

    var sum: Int64 = test_01()
    if (sum != 0) {
        return sum
    }

    return 0
}

//4. 打印 - AnimationData.layers.[t]
func test_01(): Int64 {
    let filename: String = "name.json"
    let str: String = readFile(filename)
    let data: AnimationData = AnimationDataParser.parse(str)

    //println("-------------------------------------------------------------------------------------2-layers-[t]")
    //println(data.layers[0].t.toString())
    if(layer_04_str_t != data.layers[0].t.toString()) {
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

