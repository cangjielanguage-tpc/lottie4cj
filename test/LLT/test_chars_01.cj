// DEPENDENCE: ./files/benchmark.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){

    let filename: String = "benchmark.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)

    //4. 打印 - AnimationData.chars[测试shapes在专有用例中]
    let chars: Array<FontCharacter> = data.chars

    var sum: Int64 = test_00(chars)
    if (sum != 0) {
        return sum
    }

    sum = test_01(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_02(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_03(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_04(chars)
    if (sum != 0) {
        return sum
    }


    sum = test_05(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_06(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_07(chars)
    if (sum != 0) {
        return sum
    }
    sum = test_08(chars)
    if (sum != 0) {
        return sum
    }
    return 0
}

//4. 打印 - AnimationData.chars[测试shapes在专有用例中]
func test_00(chars: Array<FontCharacter>): Int64 {
    let chars0: FontCharacter = chars[0]
    //println(chars0.toString())

    if(chars0.ch != "B") {
        return -101
    }
    if(chars0.size != 72.0 || chars0.w != 66.7) {
        return -102
    }
    if(chars0.style != "Regular" || chars0.fFamily != "Helvetica") {
        return -103
    }
    if(chars0.data.shapes.size != 1) {
        return -104
    }
    if(chars0.toString() == "") {
        return -105
    }
    return 0
}

func test_01(chars: Array<FontCharacter>): Int64 {
    let chars1: FontCharacter = chars[1]
    if(chars1.ch != "e" || chars1.size != 72.0 || chars1.w != 55.62) {
        return -1
    }
    if(chars1.style != "Regular" || chars1.fFamily != "Helvetica" || chars1.data.shapes.size != 1) {
        return -11
    }
    return 0
}

func test_02(chars: Array<FontCharacter>): Int64 {
    let chars2: FontCharacter = chars[2]
    if(chars2.ch != "n" || chars2.size != 72.0 || chars2.w != 55.62) {
        return -2
    }
    if(chars2.style != "Regular" || chars2.fFamily != "Helvetica" || chars2.data.shapes.size != 1) {
        return -21
    }
    return 0
}

func test_03(chars: Array<FontCharacter>): Int64 {
    let chars3: FontCharacter = chars[3]
    if(chars3.ch != "c" || chars3.size != 72.0 || chars3.w != 50.0) {
        return -3
    }
    if(chars3.style != "Regular" || chars3.fFamily != "Helvetica" || chars3.data.shapes.size != 1) {
        return -31
    }
    return 0
}

func test_04(chars: Array<FontCharacter>): Int64 {
    let chars4: FontCharacter = chars[4]
    if(chars4.ch != "h" || chars4.size != 72.0 || chars4.w != 55.62) {
        return -4
    }
    if(chars4.style != "Regular" || chars4.fFamily != "Helvetica" || chars4.data.shapes.size != 1) {
        return -41
    }
    return 0
}

func test_05(chars: Array<FontCharacter>): Int64 {
    let chars5: FontCharacter = chars[5]
    if(chars5.ch != "m" || chars5.size != 72.0 || chars5.w != 83.3) {
        return -5
    }
    if(chars5.style != "Regular" || chars5.fFamily != "Helvetica" || chars5.data.shapes.size != 1) {
        return -51
    }
    return 0
}

func test_06(chars: Array<FontCharacter>): Int64 {
    let chars6: FontCharacter = chars[6]
    if(chars6.ch != "a" || chars6.size != 72.0 || chars6.w != 55.62) {
        return -6
    }
    if(chars6.style != "Regular" || chars6.fFamily != "Helvetica" || chars6.data.shapes.size != 1) {
        return -61
    }
    return 0
}

func test_07(chars: Array<FontCharacter>): Int64 {
    let chars7: FontCharacter = chars[7]
    if(chars7.ch != "r" || chars7.size != 72.0 || chars7.w != 33.3) {
        return -7
    }
    if(chars7.style != "Regular" || chars7.fFamily != "Helvetica" || chars7.data.shapes.size != 1) {
        return -71
    }
    return 0
}

func test_08(chars: Array<FontCharacter>): Int64 {
    let chars8: FontCharacter = chars[8]
    if(chars8.ch != "k" || chars8.size != 72.0 || chars8.w != 50.0) {
        return -8
    }
    if(chars8.style != "Regular" || chars8.fFamily != "Helvetica" || chars8.data.shapes.size != 1) {
        return -81
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

