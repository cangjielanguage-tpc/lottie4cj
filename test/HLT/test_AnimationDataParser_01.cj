// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj
// data_file: data.json
public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.math.*
public import encoding.json.*
public import std.fs.*
@Test
public class TestLottie4cjAnimationDataParser{

    @TestCase
    func test_AnimationDataParser_01():Unit {
        let file: File = File("./data.json", OpenOption.Open(true, true))
        let len: Int64 = file.length
        var buf: Array<Byte> = Array<Byte>(len, repeat: 0)
        file.read(buf)
        file.close()
        var cur=String.fromUtf8(buf)
        let ad= AnimationDataParser.parse(cur)
        var exp_re="""
AnimationData {
w  = 400
h  = 400
ip = 0.000000
op = 60.000000
fr = 60.000000
v  = 5.10.2
nm  = Benchmark
ddd = 0
layers.size = 5
assets.size = 1
fonts = Fonts: {
 list = [Font {
fName   = Helvetica
fFamily = Helvetica
fStyle  = Regular
ascent  = 72.899414
fOrigin = 
origin  = -1
fPath   = 
fClass  = 
fWeight = 
}]
 }
chars.size = 9
markers.size = 0
}"""
       @Assert(ad.toString(),exp_re)
    }
    @TestCase
    func test_AnimationDataParser_02():Unit {
        let file: File = File("./data.json", OpenOption.Open(true, true))
        let len: Int64 = file.length
        var buf: Array<Byte> = Array<Byte>(len, repeat: 0)
        file.read(buf)
        file.close()
        var cur="""
{
  "v": "5.10.2",
  "fr": 60,
  "ip": 0,
  "op": 60,
  "w": 400,
  "h": 400,
  "nm": "Benchmark",
  "ddd": 0,
  "assets": [
    {
      "id": "image_0",
      "w": 80,
      "h": 80,
      "u": "",
      "p": "data:image/png;base64,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",
      "e": 1
    }
  ],
  "fonts": {
    "list": [
      {
        "fName": "Helvetica",
        "fFamily": "Helvetica",
        "fStyle": "Regular",
        "ascent": 72.8994140625
      }
    ]
  }
"""
        var flag=1
        try{
            AnimationDataParser.parse(cur)
        }catch(e:JsonException){
            if(e.toString().contains("the json data is Non-standard")){
                 flag=0
            }
        }
        @Assert(flag,0)
    }
}