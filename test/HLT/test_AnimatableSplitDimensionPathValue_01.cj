// 3rd_party_lib:lottie4cj/build/lottie4cj
// 3rd_party_lib_ohos:lottie4cj/build/aarch64-linux-ohos/lottie4cj

public import lottie4cj.parser.*
public import lottie4cj.model.*

@Test
public class TestLottie4cjAnimatableSplitDimensionPathValue{
    @TestCase
    func test_AnimatableSplitDimensionPathValue_toString_01():Unit {
        var kfp=Keyframe<PointF>()
        var kff=Keyframe<Float64>()
        var akff=Array<Keyframe<Float64>>(34,item:kff)
        var akfp=Array<Keyframe<PointF>>(334,item:kfp)
        var asdp=AnimatableSplitDimensionPathValue(k:akfp,x:akff,y:akff)
        @Assert(asdp.toString(),"AnimatableSplitDimensionPathValue: {\n" +
                                                         "k = ${akfp}\n" +
                                                         "x = ${akff}\n" +
                                                         "y = ${akff}\n}")
        @Assert(asdp.k.toString(),akfp.toString())
        @Assert(asdp.x.toString(),akff.toString())
        @Assert(asdp.y.toString(),akff.toString())
    }
    @TestCase
    func test_AnimatableSplitDimensionPathValue_toString_02():Unit {
        var akff=Array<Keyframe<Float64>>()
        var akfp=Array<Keyframe<PointF>>()
        var asdp=AnimatableSplitDimensionPathValue(k:akfp,x:akff,y:akff)
        @Assert(asdp.toString(),"AnimatableSplitDimensionPathValue: {\n" +
                                                         "k = ${akfp}\n" +
                                                         "x = ${akff}\n" +
                                                         "y = ${akff}\n}")
        @Assert(asdp.k.toString(),akfp.toString())
        @Assert(asdp.x.toString(),akff.toString())
        @Assert(asdp.y.toString(),akff.toString())
    }
    @TestCase
    func test_AnimatableSplitDimensionPathValue_toString_03():Unit {
        var akff=Array<Keyframe<Float64>>()
        var akfp=Array<Keyframe<PointF>>()
        var asdp=AnimatableSplitDimensionPathValue()
        @Assert(asdp.toString(),"AnimatableSplitDimensionPathValue: {\n" +
                                                         "k = ${akfp}\n" +
                                                         "x = ${akff}\n" +
                                                         "y = ${akff}\n}")
        @Assert(asdp.k.toString(),akfp.toString())
        @Assert(asdp.x.toString(),akff.toString())
        @Assert(asdp.y.toString(),akff.toString())
    }
}