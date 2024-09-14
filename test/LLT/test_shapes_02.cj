// DEPENDENCE: ./files/playing.json
// DEPENDENCE: ./test_shapes_02_result.cj
// EXEC: cjc %import-path %L %l %f ./test_shapes_02_result.cj
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

 //0. 打印json文件最外层 - AnimationData.layers.[st]---[st中带有d]
func test_01(): Int64 {
    let filename: String = "playing.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)

    let gr: ShapeGroup = (data.layers[0].shapes[0] as ShapeGroup).getOrThrow()
    //println("------------------------------------------------------------------2-2-[st]")
    //println(gr.it[1].toString())

    if(shapes_02_str != shapes_02_str) {
        return -1
    }

    return 0
}

func readFile(path: String): String {
    let file: File = File(path, OpenOption.Open(true, true))
    let len: Int64 = file.length
    var buf: Array<Byte> = Array<Byte>(len, repeat: 0)
    file.read(buf)
    file.close()

    return String.fromUtf8(buf)
}

