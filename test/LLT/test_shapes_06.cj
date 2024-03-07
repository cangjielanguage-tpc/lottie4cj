// DEPENDENCE: ./files/shapes.json
// DEPENDENCE: ./test_shapes_06_result.cj
// EXEC: cjc %import-path %L %l %f ./test_shapes_06_result.cj
// EXEC: ./main

from std import fs.*
from std import sync.*
//from lottie4cj import lottie4cj.*

from lottie4cj import parser.*
from lottie4cj import model.*



main (){
    let filename: String = "shapes.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)
    let gr: ShapeGroup = (data.layers[0].shapes[0] as ShapeGroup).getOrThrow()

    var sum: Int64 = test_0(data)
    if (sum != 0) {
        return sum
    }

    sum = test_00(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_01(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_02(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_03(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_04(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_05(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_06(gr)
    if (sum != 0) {
        return sum
    }


    sum = test_07(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_08(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_09(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_010(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_011(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_012(gr)
    if (sum != 0) {
        return sum
    }
    sum = test_013(gr)
    if (sum != 0) {
        return sum
    }

    return 0
}


func test_0(data: AnimationData): Int64 {
    //0. 打印json文件最外层 - AnimationData
    //println(data.toString())
    //println(shapes_06_str0 == data.toString())
    //println("------------------------------------------------------------------0")

    if(shapes_06_str0 != data.toString()) {
        return -1
    }
    return 0
}

func test_00(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-0-[gr]")
    //println(gr.toString())

    if(gr.nm != "Repeater Shape") {
        return -2
    }
    if(gr.hd != false) {
        return -3
    }
    if(gr.it.size != 14) {
        return -4
    }
    if(gr.toString() == "") {
        return -5
    }
    return 0
}

func test_01(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-1-[st]")
    //println(gr.it[0].toString())
    //println(shapes_06_str1 == gr.it[0].toString())

    if(shapes_06_str1 != gr.it[0].toString()) {
        return 1
    }
    return 0
}

func test_02(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-2-[gs]")
    //println(gr.it[1].toString())
    //println(shapes_06_str2 == gr.it[1].toString())

    if(shapes_06_str2 != gr.it[1].toString()) {
        return 2
    }
    return 0
}

func test_03(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-3-[fl]")
    //println(gr.it[2].toString().toArray())
    //println(shapes_06_str3 == gr.it[2].toString())

    if(shapes_06_str3 != gr.it[2].toString()) {
        return 3
    }
    return 0
}

func test_04(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-4-[gf]")
    //println(gr.it[3].toString())
    //println(gr.it[3].toString().endsWith(shapes_06_str4))

    if(!gr.it[3].toString().endsWith(shapes_06_str4)) {
        return 4
    }
    return 0
}

func test_05(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-5-[tr]")
    //println(gr.it[4].toString())
    //println(shapes_06_str5 == gr.it[4].toString())

    if(shapes_06_str5 != gr.it[4].toString()) {
        return 5
    }
    return 0
}

func test_06(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-6-[sh]")
    //println(gr.it[5].toString())
    //println(shapes_06_str6 == gr.it[5].toString())

    if(shapes_06_str6 != gr.it[5].toString()) {
        return 6
    }
    return 0
}

func test_07(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-7-[el]")
    //println(gr.it[6].toString())
    //println(shapes_06_str7 == gr.it[6].toString())

    if(shapes_06_str7 != gr.it[6].toString()) {
        return 7
    }
    return 0
}

func test_08(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-8-[rc]")
    //println(gr.it[7].toString())
    //println(shapes_06_str8 == gr.it[7].toString())

    if(shapes_06_str8 != gr.it[7].toString()) {
        return 8
    }
    return 0
}

func test_09(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-9-[tm]")
    //println(gr.it[8].toString())
    //println(shapes_06_str9 == gr.it[8].toString())

    if(shapes_06_str9 != gr.it[8].toString()) {
        return 9
    }
    return 0
}

func test_010(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-10-[sr]")
    //println(gr.it[9].toString())
    //println(shapes_06_str10 == gr.it[9].toString())

    if(shapes_06_str10 != gr.it[9].toString()) {
        return 10
    }
    return 0
}

func test_011(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-11-[mm]")
    //println(gr.it[10].toString())
    //println(shapes_06_str11 == gr.it[10].toString())

    if(shapes_06_str11 != gr.it[10].toString()) {
        return 11
    }
    return 0
}

func test_012(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-12-[rp]")
    //println(gr.it[11].toString())
    //println(shapes_06_str12 == gr.it[11].toString())

    if(shapes_06_str12 != gr.it[11].toString()) {
        return 12
    }
    return 0
}

func test_013(gr: ShapeGroup): Int64 {
    //println("------------------------------------------------------------------1-13-[rd]")
    //println(gr.it[12].toString())
    //println(shapes_06_str13 == gr.it[12].toString())
    //println("------------------------------------------------------------------1-13-[rd]")
    //println(gr.it[13].toString())
    //println(shapes_06_str131 == gr.it[13].toString())

    if(shapes_06_str13 != gr.it[12].toString()) {
        return 13
    }
    if(shapes_06_str131 != gr.it[13].toString()) {
        return 131
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

