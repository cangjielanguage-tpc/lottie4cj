// DEPENDENCE: ./files/layers.json
// DEPENDENCE: ./test_layer_01_result.cj
// EXEC: cjc %import-path %L %l %f ./test_layer_01_result.cj
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){

    let filename: String = "layers.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)

    var sum: Int64 = test_01(data)
    if (sum != 0) {
        return sum
    }

    sum = test_02(data)
    if (sum != 0) {
        return sum
    }
    sum = test_03(data)
    if (sum != 0) {
        return sum
    }
    return 0
}

//layers - 外层
func test_01(data: AnimationData): Int64 {
    //4. 打印 - AnimationData.layers
    //println("-------------------------------------------------------------------------------------1-layers")
    //println(data.layers.toString())
    let layers: Array<Layer> = data.layers
    let layers0: Layer = layers[0]

    if(layers.size != 1 || layers0.nm != "2016_2" || layers0.ind != 0 || layers0.ty != 0) {
        return -1
    }

    if(layers0.w != 1920.0 || layers0.h != 1080.0 || layers0.ip != 0.0 || layers0.op != 308.0 || layers0.st != 0.0) {
        return -2
    }
    if(layers0.refId != "comp_0") {
        return -3
    }
    if(layers0.toString() == "") {
        return -31
    }
    return 0
}

func test_02(data: AnimationData): Int64 {
    //println("-------------------------------------------------------------------------------------2-layers-[ks]")
    //println(data.layers[0].ks.toString())

    if(layer_01_str_ks != data.layers[0].ks.toString()) {
        return -4
    }
    return 0
}

func test_03(data: AnimationData): Int64 {
    //println("-------------------------------------------------------------------------------------3-layers-[tm]")
    //println(data.layers[0].tm.toString())

    if(layer_01_str_tm != data.layers[0].tm.toString()) {
        return -5
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

