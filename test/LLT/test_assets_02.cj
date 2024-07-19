// DEPENDENCE: ./files/AndroidWave.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){

    var sum: Int64 = test_01()
    if (sum != 0) {
        return sum
    }

    return 0
}

func test_01(): Int64 {
    let filename: String = "AndroidWave.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)
    let assets: Array<Asset> = data.assets
    let assets0: Asset = assets[0]

    if(assets.size != 1 || assets0.id != "comp_0" || assets0.w != 0 || assets0.h != 0) {
        return -1
    }

    if(assets0.p != "" || assets0.u != "") {
        return -2
    }
    if(assets0.layers.size != 1) {
        return -3
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

