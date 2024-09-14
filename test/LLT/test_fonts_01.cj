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

    //3. 打印 - AnimationData.fonts
    let fonts: Fonts = data.fonts
    if (fonts.toString() == "") {
        return 1
    }

    var sum: Int64 = test_01(fonts)
    if (sum != 0) {
        return sum
    }
    
    return 0
}

//3. 打印 - AnimationData.fonts
func test_01(fonts: Fonts): Int64 {
    let list: Array<Font> = fonts.list
    let font: Font = list[0]
    if(list.size != 1 || font.fName != "Helvetica" || font.fFamily != "Helvetica") {
        return -1
    }
    if(font.fStyle != "Regular" || font.ascent != 72.8994140625) {
        return -2
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

