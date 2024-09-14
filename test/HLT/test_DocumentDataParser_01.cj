// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*
public import std.collection.*
@Test
public class TestLottie4cjDocumentDataParser{
    @TestCase
    func test_DocumentDataParser_01():Unit {
        var dd=DocumentDataParser.INSTANCE
        var flag=1
        var illeagal=[JsonNull(),JsonBool(true),JsonString("JsonString"),JsonInt(128),JsonFloat(Float64(22)),JsonArray()]
        for (iv in 0..illeagal.size){
            flag=1
            try{
                dd.parse(illeagal[iv])
            }catch(e:JsonException){
                if(e.toString().contains("Fail to convert to JsonObject")){
                    flag=0
                }
            }
            @Assert(flag,0)
        }
    }
    @TestCase
    func test_DocumentDataParser_02():Unit {
        var dd=DocumentDataParser.INSTANCE
        var maps=HashMap<String,JsonValue>([("t",JsonString("123")),
                                            ("f",JsonString("134")),
                                            ("s",JsonFloat(135)),
                                            ("j",JsonInt(134)),
                                            ("tr",JsonInt(134)),
                                            ("lh",JsonFloat(135)),
                                            ("ls",JsonFloat(135)),
                                            ("fc",JsonArray([JsonInt(128),JsonInt(228)])),
                                            ("sc",JsonArray([JsonInt(128),JsonInt(228)])),
                                            ("sw",JsonFloat(135)),
                                            ("of",JsonBool(true)),
                                            ("ps",JsonArray([JsonInt(128),JsonInt(228)])),
                                            ("sz",JsonArray([JsonInt(128),JsonInt(228)]))
                                           ])
        var jo=JsonObject(maps)
        var re=dd.parse(jo)
        var exp_re=DocumentData(
                   t: "123",
                   f: "134",
                   s: Float64(135),
                   j: 134,
                   tr: 134,
                   lh: Float64(135),
                   ls: Float64(135),
                   fc: [Float64(128),Float64(228)],
                   sc: [Float64(128),Float64(228)],
                   sw: Float64(135),
                   of: true,
                   ps: [Float64(128),Float64(228)],
                   sz: [Float64(128),Float64(228)]
               )
        @Assert(re.toString(),exp_re.toString())
    }
    @TestCase
    func test_DocumentDataParser_03():Unit {
        var dd=DocumentDataParser.INSTANCE
        var jo=JsonObject()
        var re=dd.parse(jo)
        var exp_re=DocumentData(
                   t: "",
                   f: "",
                   s: Float64(0),
                   j: 0,
                   tr: 0,
                   lh: Float64(0),
                   ls: Float64(0),
                   fc: Array<Float64>(),
                   sc: Array<Float64>(),
                   sw: Float64(0),
                   of: false,
                   ps: Array<Float64>(),
                   sz: Array<Float64>()
               )
        @Assert(re.toString(),exp_re.toString())
    }
}