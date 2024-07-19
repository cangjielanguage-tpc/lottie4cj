// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*
public import std.collection.*
public import encoding.json.*

@Test
public class TestLottie4cjLayerParser{
    @TestCase
    func test_LayerParser_01():Unit {
        var jv_LayerParser_str=###"{
"ddd": 0,
"ind": 2,
"ty": 4,
"nm": "Shape Layer 2",
"td": 1,
"sr": 1,
"ks": {
"o": {
 "a": 0,
 "k": 100,
 "ix": 11
},
"r": {
 "a": 0,
 "k": 0,
 "ix": 10
},
"p": {
 "a": 1,
 "k": [
   {
     "i": {
       "x": 0.833,
       "y": 0.833
     },
     "o": {
       "x": 0.167,
       "y": 0.167
     },
     "t": 0,
     "s": [
       233,
       170,
       0
     ],
     "to": [
       -11.167,
       11,
       0
     ],
     "ti": [
       11.167,
       -11,
       0
     ]
   },
   {
     "t": 59,
     "s": [
       166,
       236,
       0
     ]
   }
 ],
 "ix": 2,
 "l": 2
},
"a": {
 "a": 0,
 "k": [
   0,
   0,
   0
 ],
 "ix": 1,
 "l": 2
},
"s": {
 "a": 0,
 "k": [
   100,
   100,
   100
 ],
 "ix": 6,
 "l": 2
}
},
"ao": 0,
"shapes": [
{
 "ty": "gr",
 "it": [
   {
     "d": 1,
     "ty": "el",
     "s": {
       "a": 0,
       "k": [
         332.711,
         332.711
       ],
       "ix": 2
     },
     "p": {
       "a": 0,
       "k": [
         0,
         0
       ],
       "ix": 3
     },
     "nm": "Ellipse Path 1",
     "mn": "ADBE Vector Shape - Ellipse",
     "hd": false
   },
   {
     "ty": "st",
     "c": {
       "a": 0,
       "k": [
         1,
         1,
         1,
         1
       ],
       "ix": 3
     },
     "o": {
       "a": 0,
       "k": 100,
       "ix": 4
     },
     "w": {
       "a": 0,
       "k": 2,
       "ix": 5
     },
     "lc": 1,
     "lj": 1,
     "ml": 4,
     "bm": 0,
     "nm": "Stroke 1",
     "mn": "ADBE Vector Graphic - Stroke",
     "hd": false
   },
   {
     "ty": "fl",
     "c": {
       "a": 0,
       "k": [
         1,
         0,
         0,
         1
       ],
       "ix": 4
     },
     "o": {
       "a": 0,
       "k": 100,
       "ix": 5
     },
     "r": 1,
     "bm": 0,
     "nm": "Fill 1",
     "mn": "ADBE Vector Graphic - Fill",
     "hd": false
   },
   {
     "ty": "tr",
     "p": {
       "a": 0,
       "k": [
         0.355,
         0.355
       ],
       "ix": 2
     },
     "a": {
       "a": 0,
       "k": [
         0,
         0
       ],
       "ix": 1
     },
     "s": {
       "a": 0,
       "k": [
         100,
         100
       ],
       "ix": 3
     },
     "r": {
       "a": 0,
       "k": 0,
       "ix": 6
     },
     "o": {
       "a": 0,
       "k": 100,
       "ix": 7
     },
     "sk": {
       "a": 0,
       "k": 0,
       "ix": 4
     },
     "sa": {
       "a": 0,
       "k": 0,
       "ix": 5
     },
     "nm": "Transform"
   }
 ],
 "nm": "Ellipse 1",
 "np": 3,
 "cix": 2,
 "bm": 0,
 "ix": 1,
 "mn": "ADBE Vector Group",
 "hd": false
}
],
"ip": 0,
"op": 60,
"st": 0,
"ct": 1,
"bm": 0
}"###
        var jv=JsonValue.fromStr(jv_LayerParser_str)
        var jo=jv.asObject()
        var re=LayerParser.parse(jo)
        @Assert(re.masksProperties.toString(),"[]")
        @Assert(re.ef.toString(),"[]")
        @Assert(re.shapes.size,1)
    }
    @TestCase
    func test_LayerParser_02():Unit {
        var jv_LayerParser_str=###"{
"sa": {
       "a": 0,
       "k": 0,
       "ix": 5
     }
}"###
        var jv=JsonValue.fromStr(jv_LayerParser_str)
        var jo=jv.asObject()
        var re=LayerParser.parse(jo)
        @Assert(re.masksProperties.toString(),"[]")
        @Assert(re.ef.toString(),"[]")
        @Assert(re.shapes.size,0)
    }
    @TestCase
    func test_LayerParser_03():Unit {
        var flag=1
        try{
            LayerParser.parse(JsonNull())
        }catch(e:JsonException){
            if(e.toString().contains("Fail to convert to JsonObject")){
                flag=0
            }
        }
        @Assert(flag,0)
    }
}