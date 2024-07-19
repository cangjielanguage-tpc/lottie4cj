// DEPENDENCE: ./files/data_rawfile.json
// DEPENDENCE: ./test_layer_05_result.cj
// EXEC: cjc %import-path %L %l %f ./test_layer_05_result.cj
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){
    let filename: String = "data_rawfile.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)
    let ef: Array<LayerEF> = data.layers[0].ef

    var sum: Int64 = test_00(ef)
    if (sum != 0) {
        return sum
    }
    sum = test_01(ef)
    if (sum != 0) {
        return sum
    }
    return 0
}

//4. 打印 - AnimationData.layers.[ef]
func test_00(ef: Array<LayerEF>): Int64 {
    let ef0: LayerEF = ef[0]
    //println("-------------------------------------------------------------------------------------2-layers-[ef]")
    //println(ef0.toString())

    if(layer_05_str_ef_0 != ef0.toString()) {
        return -1
    }
    return 0
}

func test_01(ef: Array<LayerEF>): Int64 {
    let ef1: LayerEF = ef[1]
    //println("-------------------------------------------------------------------------------------2-layers-[ef]")
    //println(ef1.toString())

    if(layer_05_str_ef_1 != ef1.toString()) {
        return -2
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

