// DEPENDENCE: ./files/Marker.json
// EXEC: cjc %import-path %L %l %f
// EXEC: ./main

public import std.fs.*
public import std.sync.*

public import lottie4cj.parser.*
public import lottie4cj.model.*

main (){

    let filename: String = "Marker.json"
    let str: String = readFile(filename)

    let data: AnimationData = AnimationDataParser.parse(str)

    //5. 打印 - AnimationData.markers
    let markers: Array<Marker> = data.markers

    var sum: Int64 = test_01(markers)
    if (sum != 0) {
        return sum
    }
    sum = test_02(markers)
    if (sum != 0) {
        return sum
    }
    
    return 0
}

//5. 打印 - AnimationData.markers
func test_01(markers: Array<Marker>): Int64 {
    let markers1: Marker = markers[0]
    if(markers1.tm != 14.0000005702317 || markers1.cm != "Marker A" || markers1.dr != 30.0000012219251) {
        return -1
    }
    return 0
}

func test_02(markers: Array<Marker>): Int64 {
    let markers2: Marker = markers[1]
    if(markers2.tm != 33.0000013441176 || markers2.cm != "Marker B\r" || markers2.dr != 0.0) {
        return -2
    }
    if(markers2.toString() == "") {
        return -3
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

