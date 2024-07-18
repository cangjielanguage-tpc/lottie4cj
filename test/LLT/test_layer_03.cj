// DEPENDENCE: ./files/MaskInv.json
// DEPENDENCE: ./test_layer_03_result.cj
// EXEC: cjc %import-path %L %l %f ./test_layer_03_result.cj
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){
    let filename: String = "MaskInv.json"
    let str: String = readFile(filename)
    let data: AnimationData = AnimationDataParser.parse(str)

    let masksProperties: Array<Mask> = data.layers[0].masksProperties

    var sum: Int64 = test_00(masksProperties)
    if (sum != 0) {
        return sum
    }
    sum = test_01(masksProperties)
    if (sum != 0) {
        return sum
    }

    return 0
}

//2-layers-[masksProperties]
func test_00(masksProperties: Array<Mask>): Int64 {
    let mask: Mask = masksProperties[0]
    //println("-------------------------------------------------------------------------------------2-layers-[masksProperties]")
    //println(mask.toString())
    if(layer_03_str_masksProperties_00 != mask.toString()) {
        return -1
    }

    return 0
}

func test_01(masksProperties: Array<Mask>): Int64 {
    let mask: Mask = masksProperties[1]
    //println("-------------------------------------------------------------------------------------2-layers-[masksProperties]")
    //println(mask.toString())
    if(layer_03_str_masksProperties_01 != mask.toString()) {
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

