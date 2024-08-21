主要接口
# lottie4cj 库

## 介绍
lottie是一个动画库，它可以解析Adobe After Effects软件通过Bodymovin插件导出的json格式的动画，并在移动设备上进行本地渲染。

## 1 实现json解析器。

前置条件：NA     
场景：    
1. 需要实现将json动画数据解析为AnimationItem动画实例；
2. 实现构建AnimationItem动画实例；
3. 实现静态资源加载处理功能；
约束： 只支持UTF-8字符编码     
性能： 可参考 java 对标库性能用例，与对标库持平    
可靠性： NA  

### 1.1 实现将 json 数据解析为 AnimationData 对象


#### 1.1.1 model 动画json格式数据封装类

##### 1.1.1.1 AnimationData 及其内部数据结构类型

###### 1.1.1.1.1 AnimationData

```cangjie 
/**
 * After Effects/Bodymovin复合模型。这是动画将从中创建的序列化模型。
 * 同步json中的键和值数据格式.
 */
public class AnimationData <: ToString {
    
    public let w: Int64       /* 视图宽 */
    public let h: Int64       /* 视图高 */
    public let ip: Float64    /* 起始关键帧 */
    public let op: Float64    /* 结束关键帧 */
    public let fr: Float64    /* 帧率 */
    public let v: String      /* bodymovin 的版本 */
    public let fonts: Fonts   /* 字体 */
    public let nm: String     /* 名称 */
    public let ddd: Int64     /* 是否为3D */
    
    /**
     * 基于该参数创建一个 AnimationData 实例。  
     * 
     * 参数 w - w 对应的值
     * 参数 h - h 对应的值
     * 参数 ip - ip 对应的值
     * 参数 op - op 对应的值
     * 参数 fr - fr 对应的值
     * 参数 v - v 对应的值
     * 参数 layers - layers 对应的值
     * 参数 assets - assets 对应的值
     * 参数 fonts - fonts 对应的值
     * 参数 chars - chars 对应的值
     * 参数 markers - markers 对应的值
     * 参数 nm - nm 对应的值
     * 参数 ddd - ddd 对应的值
     */
    public init(
        w!: Int64 = 0, 
        h!: Int64 = 0, 
        ip!: Float64 = 0.0, 
        op!: Float64 = 0.0, 
        fr!: Float64 = 0.0, 
        v!: String = "",
        layers!: Array<Layer> = Array<Layer>(), 
        assets!: Array<Asset> = Array<Asset>(), 
        fonts!: Fonts = Fonts(), 
        chars!: Array<FontCharacter> = Array<FontCharacter>(),
        markers!: Array<Marker> = Array<Marker>(), 
        nm!: String = "", 
        ddd!: Int64 = 0
    )
   
    /**
     * 获取 AnimationData 的图层信息 layers。
     */
    public prop layers: Array<Layer>

    /**
     * 获取 AnimationData 的资源信息 assets。
     */
    public prop assets: Array<Asset>

    /**
     * 获取 AnimationData 的 chars。
     */
    public prop chars: Array<FontCharacter>

    /**
     * 获取 AnimationData 的蒙层集合 markers。
     */
    public prop markers: Array<Marker>
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.2 Asset 资源信息

```cangjie
/**
 * 描述嵌入在Lottie json文件中的图像资产的数据类。
 */
public class Asset <: ToString {

    public let id: String  /* 图片id */
    public let w: Int64    /* 图片宽度 */
    public let h: Int64    /* 图片高度 */
    public let p: String   /* 图片名称 */
    public let u: String   /* 图片路径 */

    /**
     * 基于该参数创建一个 Asset 实例。  
     * 
     * 参数 id - id 对应的值
     * 参数 layers - layers 对应的值
     * 参数 w - w 对应的值
     * 参数 h - h 对应的值
     * 参数 p - p 对应的值
     * 参数 u - u 对应的值
     */
    public init(id: String, layers: Array<Layer>, w: Int64, h: Int64, p: String, u: String)

    /**
     * 获取 Asset 的layers layers。
     */
    public prop layers: Array<Layer>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.3 Fonts 字体

```cangjie
public class Fonts <: ToString {
    
    /**
     * 基于该参数创建一个 Fonts 实例。  
     * 
     * 参数 list - list 对应的值
     */
    public init(list!: Array<Font> = Array<Font>())

    /**
     * 获取 Fonts 的 list 数据。
     */
    public prop list: Array<Font> {

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.4 Font

```cangjie
public class Font <: ToString {

    public let fFamily: String    /* 封装 fFamily 对应数据 */
    public let fName: String      /* 封装 fName 对应数据 */
    public let fStyle: String     /* 封装 fStyle 对应数据 */
    public let ascent: Float64    /* 封装 ascent 对应数据 */

    /**
     * 基于该参数创建一个 Font 实例。  
     * 
     * 参数 fFamily - fFamily 对应的值
     * 参数 fName - fName 对应的值
     * 参数 fStyle - fStyle 对应的值
     * 参数 ascent - ascent 对应的值
     */
    public init(fFamily: String, fName: String, fStyle: String, ascent: Float64)
    
    /**
     * 获取 fName 值。
     * 
     * 返回值 String - fName 值。
     */
    public func getName (): String
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.5 CharsData

```cangjie
public class CharsData <: ToString {
    
    /**
     * 基于该参数创建一个 CharsData 实例。  
     * 
     * 参数 shapes - shapes 对应的值
     */
    public init(shapes!: Array<ContentModel> = Array<ContentModel>())

    /**
     * 获取 CharsData 的 shapes 数据。
     */
    public prop shapes: Array<ContentModel> {

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.6 FontCharacter

```cangjie
/**
 * "chars" - json中对应的数据类型。
 */
public class FontCharacter <: Hashable&ToString {

    public let ch: String           /* 封装 ch 对应数据 */       
    public let size: Float64        /* 封装 size 对应数据 */      
    public let w: Float64           /* 封装 w 对应数据 */       
    public let style: String        /* 封装 style 对应数据 */     
    public let fFamily: String      /* 封装 fFamily 对应数据 */  
    public let data: CharsData      /* 封装 data 对应数据 */   

    /**
     * 基于该参数创建一个 FontCharacter 实例。  
     * 
     * 参数 data - data 对应的值
     * 参数 ch - ch 对应的值
     * 参数 size - size 对应的值
     * 参数 w - w 对应的值
     * 参数 style - style 对应的值
     * 参数 fFamily - fFamily 对应的值
     */
    public init(data: CharsData, ch: String, size: Float64, w: Float64, style: String, fFamily: String)
    
    /**
     * 返回 FontCharacter hashCode 值。
     * 
     * 参数 ch - ch 对应的值
     * 参数 fFamily - fFamily 对应的值
     * 参数 style - style 对应的值
     * 返回值 Int64 - FontCharacter 的 hashCode 值。
     */
    public static func hashFor (ch: String, fFamily: String, style: String): Int64
    
    /**
     * 返回 FontCharacter hashCode 值。
     * 
     * 返回值 Int64 - FontCharacter 的 hashCode 值。
     */
    public func hashCode (): Int64
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.1.7 Marker 蒙层集合

```cangjie
public class Marker <: ToString {

    public let cm: String       /* 封装 cm 对应数据 */
    public let tm: Float64      /* 封装 tm 对应数据 */
    public let dr: Float64      /* 封装 dr 对应数据 */

    /**
     * 基于该参数创建一个 Marker 实例。  
     * 
     * 参数 cm - cm 对应的值
     * 参数 tm - tm 对应的值
     * 参数 dr - dr 对应的值
     */
    public init(cm: String, tm: Float64, dr: Float64)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

##### 1.1.1.2 Layer图层信息 及其内部数据结构类型

###### 1.1.1.2.1 Layer 图层信息

```cangjie
public class Layer <: ToString {

    public let nm: String                   /* 图层名称 */
    public let ind: Int64                   /* layer的ID，唯一  */     
    public let refId: String                /* 引用的资源，图片/预合成层 */
    public let ty: Int64                    /* 图层类型 */
    public let parent: Int64                /* 封装 paren 对应数据 */
    public let sw: Int64                    /* 图层宽度 */
    public let sh: Int64                    /* 高度 */
    public let sc: String                   /* 颜色 */
    public let ks: AnimatableTransform      /* 变换。对应 AE 中的变换设置 */
    public let tt: Int64                    /* 封装 tt 对应数据 */
    public let t: LayerT                    /* 封装 t 对应数据 */
    public let sr: Float64                  /* 封装 sr 对应数据 */      
    public let st: Float64                  /* 该图层 开始时间  */
    public let w: Float64                   /* 封装 w 对应数据 */           
    public let h: Float64                   /* 封装 h 对应数据 */            
    public let ip: Float64                  /* 该图层开始关键帧 */
    public let op: Float64                  /* 该图层结束关键帧  */
    public let tm: ContentModelDK           /* 封装 tm 对应数据 */                  
    public let cl: String                   /* 后缀，如: .png */
    public let hd: Bool                     /* 封装 hd 对应数据 */
    public let ao: Int64                    /* 是否自动跟踪  */               
    public let bm: Int64                    /* 混合模式  */               

    /**
     * 基于该参数创建一个 Layer 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 ind - ind 对应的值
     * 参数 refId - refId 对应的值
     * 参数 ty - ty 对应的值
     * 参数 parent - parent 对应的值
     * 参数 sw - sw 对应的值
     * 参数 sh - sh 对应的值
     * 参数 sc - sc 对应的值
     * 参数 ks - ks 对应的值
     * 参数 tt - tt 对应的值
     * 参数 masksProperties - masksProperties 对应的值
     * 参数 shapes - shapes 对应的值
     * 参数 t - t 对应的值
     * 参数 ef - ef 对应的值
     * 参数 sr - sr 对应的值
     * 参数 st - st 对应的值
     * 参数 w - w 对应的值
     * 参数 h - h 对应的值
     * 参数 ip - ip 对应的值
     * 参数 op - op 对应的值
     * 参数 tm - tm 对应的值
     * 参数 cl - cl 对应的值
     * 参数 hd - hd 对应的值
     * 参数 ao - ao 对应的值
     * 参数 bm - bm 对应的值
     */
    public init(
        nm!: String = "",
        ind!: Int64 = 0,
        refId!: String = "",
        ty!: Int64 = 0,
        parent!: Int64 = -1,
        sw!: Int64 = 0,
        sh!: Int64 = 0,
        sc!: String = "",
        ks!: AnimatableTransform = AnimatableTransform(),
        tt!: Int64 = 0,
        masksProperties!: Array<Mask> = Array<Mask>(),
        shapes!: Array<ContentModel> = Array<ContentModel>(),
        t!: LayerT = LayerT(),
        ef!: Array<LayerEF> = Array<LayerEF>(),
        sr!: Float64 = 0.0,
        st!: Float64 = 0.0,
        w!: Float64 = 0.0,
        h!: Float64 = 0.0,
        ip!: Float64 = 0.0,
        op!: Float64 = 0.0,
        tm!: ContentModelDK = ContentModelDK(),
        cl!: String = "",
        hd!: Bool = false,
        ao!: Int64 = 0,
        bm!: Int64 = 0
    )

    /**
     * 获取 Layer 的mask列表 masksProperties 数据。
     */
    public prop masksProperties: Array<Mask>

    /**
     * 获取 Layer 的形状图层 shapes 数据。
     */
    public prop shapes: Array<ContentModel>

    /**
     * 获取 Layer 的形状图层 ef 数据。
     */
    public prop ef: Array<LayerEF>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.2 AnimatableTransform
变换。对应 AE 中的变换设置

```cangjie
public class AnimatableTransform <: ContentModel {
    /* 封装 p 对应的数据 */
    public let p: AnimatableSplitDimensionPathValue
    /* 封装 r 对应的数据 */
    public let r: ArrayKeyframeFloat64

    /**
     * 基于该参数创建一个 AnimatableTransform 实例。  
     * 
     * 参数 a - a 对应的值
     * 参数 p - p 对应的值
     * 参数 s - s 对应的值
     * 参数 r - r 对应的值
     * 参数 o - o 对应的值
     * 参数 so - so 对应的值
     * 参数 eo - eo 对应的值
     * 参数 sk - sk 对应的值
     * 参数 sa - sa 对应的值
     * 参数 ty - ty 对应的值
     */
    public init(
        a!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        r!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        so!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        eo!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        sk!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        sa!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        ty!: String = ""
    )

    /**
     * 获取 AnimatableTransform 的类型值。
     */
    public override prop types: Int8

    /**
     * 获得 AnimatableTransform 的 a 值。
     */
    public prop a: Array<Keyframe<PointF>>

    /**
     * 获得 AnimatableTransform 的 s 值。
     */
    public prop s: Array<Keyframe<Array<Float64>>>

    /**
     * 获得 AnimatableTransform 的 o 值。
     */
    public prop o: Array<Keyframe<Int64>>

    /**
     * 获得 AnimatableTransform 的 so 值。
     */
    public prop so: Array<Keyframe<Float64>>

    /**
     * 获得 AnimatableTransform 的 eo 值。
     */
    public prop eo: Array<Keyframe<Float64>>

    /**
     * 获得 AnimatableTransform 的 sk 值。
     */
    public prop sk: Array<Keyframe<Float64>>

    /**
     * 获得 AnimatableTransform 的 sa 值。
     */
    public prop sa: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.3 Mask 
mask 列表

```cangjie
public class Mask <: ToString {

    public let cl: Bool         /* 封装 cl 对应数据 */
    public let inv: Bool        /* 封装 inv 对应数据 */
    public let mode: String     /* 封装 mode 对应数据 */
    public let nm: String       /* 封装 nm 对应数据 */

    /**
     * 基于该参数创建一个 Mask 实例。  
     * 
     * 参数 cl - cl 对应的值
     * 参数 inv - inv 对应的值
     * 参数 mode - mode 对应的值
     * 参数 pt - pt 对应的值
     * 参数 o - o 对应的值
     * 参数 x - x 对应的值
     * 参数 nm - nm 对应的值
     */
    public init(
        cl!: Bool = false,
        inv!: Bool= false,
        mode!: String = "",
        pt!: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>(),
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        x!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        nm!: String = ""
    )

    /**
     * 获取 Mask 的 pt 的值。
     */
    public prop pt: Array<Keyframe<ShapeData>>

    /**
     * 获取 Mask 的 o 的值。
     */
    public prop o: Array<Keyframe<Int64>>

    /**
     * 获取 Mask 的 x 的值。
     */
    public prop x: Array<Keyframe<Int64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.4 Effect

```cangjie
public class Effect <: ToString {

     public let ty: Int64             /* 封装 ty 对应数据 */
     public let nm: String            /* 封装 nm 对应数据 */
     public let v: ContentModelPK     /* 封装 v 对应数据 */
     public let isNull: Bool          /* 是否是空对象 */

    /**
     * 基于该参数创建一个 Effect 实例。  
     * 
     * 参数 ty - ty 对应的值
     * 参数 nm - nm 对应的值
     * 参数 v - v 对应的值
     * 参数 isNull - 是否是空实例
     */
    public init(ty!: Int64 = 0, nm!: String = "", v!: ContentModelPK = ContentModelPK(), isNull!: Bool = true)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.5 LayerTD

```cangjie
public class LayerTD <: ToString {
    
    /**
     * 基于该参数创建一个 LayerTD 实例。  
     * 
     * 参数 k - k 对应的值
     */
    public init(k!: Array<Keyframe<DocumentData>> = Array<Keyframe<DocumentData>>())

    /**
     * 获得 LayerTD 的 k 的值。
     */
    public prop k: Array<Keyframe<DocumentData>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.6 LayerT

```cangjie
public class LayerT <: ToString {

    public let d: LayerTD           /* 封装 d 对应的数据 */

    /**
     * 基于该参数创建一个 LayerT 实例。  
     * 
     * 参数 d - d 对应的值
     * 参数 a - a 对应的值
     */
    public init(d!: LayerTD = LayerTD(), a!: Array<AnimatableTextPropertiesA> = Array<AnimatableTextPropertiesA>())

    /**
     * 获得 LayerT 的 a 的值。
     */
    public prop a: Array<AnimatableTextPropertiesA> 

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.2.7 LayerEF

```cangjie
public class LayerEF <: ToString {

    public let ty: Int64      /* 封装 ty 对应的数据 */ 
    public let nm: String     /* 封装 nm 对应的数据 */

    /**
     * 基于该参数创建一个 LayerEF 实例。  
     * 
     * 参数 ty - ty 对应的值
     * 参数 nm - nm 对应的值
     * 参数 ef - ef 对应的值
     */
    public init(ty: Int64, nm: String, ef: Array<Effect>)

    /**
     * 获得 LayerEF 的 ef 的值。
     */
    public prop ef: Array<Effect>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

##### 1.1.1.3 Shapes 对应的 ContentModel 及其 子类

###### 1.1.1.3.1 ContentModel

```cangjie
public open class ContentModel <: ToString {

    /**
     * 获取 ContentModel 的类型值。
     */
    public open prop types: Int8
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public open func toString (): String
}
```

###### 1.1.1.3.2 CircleShape
此数据类型用于 shapes 中 {"ty": "el"} 时。

```cangjie
public class CircleShape <: ContentModel {

    public let nm: String                                /* 封装 nm 对应的数据 */
    public let p: AnimatableSplitDimensionPathValue      /* 封装 p  对应的数据 */
    public let hd: Bool                                  /* 封装 hd 对应的数据 */
    public let d: Int64                                  /* 封装 d  对应的数据 */
   
    /**
     * 基于该参数创建一个 CircleShape 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 p - p 对应的值
     * 参数 s - s 对应的值
     * 参数 hd - hd 对应的值
     * 参数 d - d 对应的值
     */
    public init(
        nm!: String = "", 
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(), 
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(), 
        hd!: Bool = false, 
        d!: Int64 = 0
    )

    /**
     * 获得 CircleShape 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 CircleShape 的 s 的值。
     */
    public prop s: Array<Keyframe<PointF>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.3 GradientFill
此数据类型用于 shapes 中 {"ty": "gf"} 时。

```cangjie
public class GradientFill <: ContentModel {

    public let nm: String              /* 封装 nm 对应的数据 */
    public let g: ContentModelP        /* 封装 g  对应的数据 */
    public let t: Int64                /* 封装 t  对应的数据 */
    public let r: Int64                /* 封装 r  对应的数据 */
    public let hd: Bool                /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 GradientFill 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 g - g 对应的值
     * 参数 o - o 对应的值
     * 参数 t - t 对应的值
     * 参数 s - s 对应的值
     * 参数 e - e 对应的值
     * 参数 r - r 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        nm!: String = "", 
        g!: ContentModelP = ContentModelP(), 
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(), 
        t!: Int64 = 0,
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(), 
        e!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(), 
        r!: Int64 = 0, 
        hd!: Bool = false
    )

    /**
     * 获得 GradientFill 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 得到 GradientFill 的 o 的值。
     */
    public prop o: Array<Keyframe<Int64>>

    /**
     * 得到 GradientFill 的 s 的值。
     */
    public prop s: Array<Keyframe<PointF>>

    /**
     * 得到 GradientFill 的 e 的值。
     */
    public prop e: Array<Keyframe<PointF>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.4 GradientStroke
此数据类型用于 shapes 中 {"ty": "gs"} 时。

```cangjie
public class GradientStroke <: ContentModel {

    public let nm: String              /* 封装 nm 对应的数据 */
    public let g: ContentModelP        /* 封装 g  对应的数据 */
    public let t: Int64                /* 封装 t  对应的数据 */
    public let lc: Int64               /* 封装 lc 对应的数据 */
    public let lj: Int64               /* 封装 lj 对应的数据 */
    public let ml: Float64             /* 封装 ml 对应的数据 */
    public let hd: Bool                /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 GradientStroke 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 g - g 对应的值
     * 参数 o - o 对应的值
     * 参数 t - t 对应的值
     * 参数 s - s 对应的值
     * 参数 e - e 对应的值
     * 参数 w - w 对应的值
     * 参数 lc - lc 对应的值
     * 参数 lj - lj 对应的值
     * 参数 ml - ml 对应的值
     * 参数 hd - hd 对应的值
     * 参数 d - d 对应的值
     */
    public init(
        nm!: String = "", 
        g!: ContentModelP = ContentModelP(), 
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(), 
        t!: Int64 = 0,
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(), 
        e!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(), 
        w!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        lc!: Int64 = 0, 
        lj!: Int64 = 0, 
        ml!: Float64 = 0.0, 
        hd!: Bool = false, 
        d!: Array<ContentModelD> = Array<ContentModelD>()
    )

    /**
     * 获得 GradientStroke 的 type 的值。
     */
    public override prop types: Int8 {

    /**
     * 获得 GradientStroke 的 o 的值。
     */
    public prop o: Array<Keyframe<Int64>> {

    /**
     * 获得 GradientStroke 的 s 的值。
     */
    public prop s: Array<Keyframe<PointF>> {

    /**
     * 获得 GradientStroke 的 e 的值。
     */
    public prop e: Array<Keyframe<PointF>> {

    /**
     * 获得 GradientStroke 的 w 的值。
     */
    public prop w: Array<Keyframe<Float64>>
    
    /**
     * 获得 GradientStroke 的 d 的值。
     */
    public prop d: Array<ContentModelD> 

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.5 MergePaths
此数据类型用于 shapes 中 {"ty": "mm"} 时。

```cangjie
public class MergePaths <: ContentModel {

    public let nm: String      /* 封装 nm 对应的数据 */
    public let mm: Int64       /* 封装 mm 对应的数据 */
    public let hd: Bool        /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 MergePaths 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 mm - mm 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(nm!: String = "", mm!: Int64 = 0, hd!: Bool = false)

    /**
     * 获得 MergePaths 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.6 PolystarShape
此数据类型用于 shapes 中 {"ty": "sr"} 时。

```cangjie
public class PolystarShape <: ContentModel {

    public let nm: String                                 /* 封装 nm 对应的数据 */
    public let sy: Int64                                  /* 封装 sy 对应的数据 */
    public let p: AnimatableSplitDimensionPathValue       /* 封装 p  对应的数据 */
    public let hd: Bool                                   /* 封装 hd 对应的数据 */
    public let d: Int64                                   /* 封装 d  对应的数据 */

    /**
     * 基于该参数创建一个 PolystarShape 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 sy - sy 对应的值
     * 参数 pt - pt 对应的值
     * 参数 p - p 对应的值
     * 参数 r - r 对应的值
     * 参数 or - or 对应的值
     * 参数 os - os 对应的值
     * 参数 ir - ir 对应的值
     * 参数 is2 - is 对应的值
     * 参数 hd - hd 对应的值
     * 参数 d - d 对应的值
     */
    public init(
        nm!: String = "",
        sy!: Int64 = 0,
        pt!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        or!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        os!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        ir!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        is2!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        hd!: Bool = false,
        d!: Int64 = 0
    )

    /**
     * 获取 PolystarShape 的类型 type 的值。
     */
    public override prop types: Int8

    /**
      * 获取 PolystarShape 的 pt 的值。
     */
    public prop pt: Array<Keyframe<Float64>>

    /**
     * 获取 PolystarShape 的 r 的值。
     */
    public prop r: Array<Keyframe<Float64>>

    /**
     * 获取 PolystarShape 的 or 的值。
     */
    public prop or: Array<Keyframe<Float64>>

    /**
     * 获取 PolystarShape 的 os 的值。
     */
    public prop os: Array<Keyframe<Float64>>

    /**
     * 获取 PolystarShape 的 ir 的值。
     */
    public prop ir: Array<Keyframe<Float64>>

    /**
     * 获取 PolystarShape 的 is 的值。
     */
    public prop is2: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.7 RectangleShape
此数据类型用于 shapes 中 {"ty": "rc"} 时。

```cangjie
public class RectangleShape <: ContentModel {

    public let nm: String                                /* 封装 nm 对应的数据 */
    public let p: AnimatableSplitDimensionPathValue      /* 封装 p  对应的数据 */
    public let hd: Bool                                  /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 RectangleShape 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 p - p 对应的值
     * 参数 s - s 对应的值
     * 参数 r - r 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        nm!: String = "",
        p!: AnimatableSplitDimensionPathValue = AnimatableSplitDimensionPathValue(),
        s!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        hd!: Bool = false
    )

    /**
     * 获得 RectangleShape 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 RectangleShape 的 s 的值。
     */
    public prop s: Array<Keyframe<PointF>>

    /**
     * 获得 RectangleShape 的 r 的值。
     */
    public prop r: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.8 Repeater
此数据类型用于 shapes 中 {"ty": "rp"} 时。

```cangjie
public class Repeater <: ContentModel {

    public let nm: String                      /* 封装 nm 对应的数据 */
    public let tr: AnimatableTransform         /* 封装 tr 对应的数据 */
    public let hd: Bool                        /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 Repeater 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 c - c 对应的值
     * 参数 o - o 对应的值
     * 参数 tr - tr 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        nm!: String = "",
        c!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        o!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        tr!: AnimatableTransform = AnimatableTransform(),
        hd!: Bool = false
    )

    /**
     * 获得 Repeater 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 Repeater 的 c 的值。
     */
    public prop c: Array<Keyframe<Float64>>

    /**
     * 获得 Repeater 的 o 的值。
     */
    public prop o: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.9 RoundedCorners
此数据类型用于 shapes 中 {"ty": "rd"} 时。

```cangjie
public class RoundedCorners <: ContentModel {

    public let nm: String            /* 封装 nm 对应的数据 */
    public let hd: Bool              /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 RoundedCorners 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 r - r 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(nm!: String = "", r!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(), hd!: Bool = false)

    /**
     * 获得 RoundedCorners 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 RoundedCorners 的 r 的值。
     */
    public prop r: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.10 ShapeFill
此数据类型用于 shapes 中 {"ty": "fl"} 时。

```cangjie
public class ShapeFill <: ContentModel {

    public let nm: String                /* 封装 nm 对应的数据 */
    public let fillEnabled: Bool         /* 封装 fillEnabled 对应的数据 */
    public let r: Int64                  /* 封装 r 对应的数据 */
    public let hd: Bool                  /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 ShapeFill 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 c - c 对应的值
     * 参数 o - o 对应的值
     * 参数 fillEnabled - fillEnabled 对应的值
     * 参数 r - r 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        nm!: String = "", 
        c!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(), 
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        fillEnabled!: Bool = false, 
        r!: Int64 = 0, 
        hd!: Bool = false
    )

    /**
     * 获得 ShapeFill 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 ShapeFill 的 c 的值。
     */
    public prop c: Array<Keyframe<Array<Float64>>>

    /**
     * 获得 ShapeFill 的 o 的值。
     */
    public prop o: Array<Keyframe<Int64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.11 ShapeGroup
此数据类型用于 shapes 中 {"ty": "gr"} 时。

```cangjie
public class ShapeGroup <: ContentModel {

    public let nm: String           /* 封装 nm 对应的数据 */
    public let hd: Bool             /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 ShapeGroup 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 it - it 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(nm: String, it: Array<ContentModel>, hd: Bool)

    /**
     * 获得 ShapeGroup 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 ShapeGroup 的 it 的值。
     */
    public prop it: Array<ContentModel> 

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.12 ShapePath
此数据类型用于 shapes 中 {"ty": "sh"} 时。

```cangjie
public class ShapePath <: ContentModel {

    public let nm: String          /* 封装 nm 对应的数据 */
    public let ind: Int64          /* 封装 ind 对应的数据 */
    public let hd: Bool            /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 ShapePath 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 ind - ind 对应的值
     * 参数 ks - ks 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        nm!: String = "", 
        ind!: Int64 = 0, 
        ks!: Array<Keyframe<ShapeData>> = Array<Keyframe<ShapeData>>(), 
        hd!: Bool = false
    )

    /**
     * 获得 ShapePath 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 ShapePath 的 ks 的值。
     */
    public prop ks: Array<Keyframe<ShapeData>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.13 ShapeStroke
此数据类型用于 shapes 中 {"ty": "st"} 时。

```cangjie
public class ShapeStroke <: ContentModel {

    public let nm: String           /* 封装 nm 对应的数据 */
    public let lc: Int64            /* 封装 lc 对应的数据 */
    public let lj: Int64            /* 封装 lj 对应的数据 */
    public let ml: Float64          /* 封装 ml 对应的数据 */
    public let hd: Bool             /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 ShapeStroke 实例。  
     * 
     * 参数 nm - nm 对应的值
     * 参数 c - c 对应的值
     * 参数 w - w 对应的值
     * 参数 o - o 对应的值
     * 参数 lc - lc 对应的值
     * 参数 lj - lj 对应的值
     * 参数 ml - ml 对应的值
     * 参数 hd - hd 对应的值
     * 参数 d - d 对应的值
     */
    public init(
        nm!: String = "", 
        c!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(), 
        w!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(), 
        o!: Array<Keyframe<Int64>> = Array<Keyframe<Int64>>(),
        lc!: Int64 = 0, 
        lj!: Int64 = 0, 
        ml!: Float64 = 0.0, 
        hd!: Bool = false, 
        d!: Array<ContentModelD> = Array<ContentModelD>()
    )

    /**
     * 获得 ShapeStroke 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 ShapeStroke 的 c 的值。
     */
    public prop c: Array<Keyframe<Array<Float64>>>

    /**
     * 获得 ShapeStroke 的 w 的值。
     */
    public prop w: Array<Keyframe<Float64>>

    /**
     * 获得 ShapeStroke 的 o 的值。
     */
    public prop o: Array<Keyframe<Int64>>

    /**
     * 获得 ShapeStroke 的 d 的值。
     */
    public prop d: Array<ContentModelD>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.3.14 ShapeTrimPath
此数据类型用于 shapes 中 {"ty": "tm"} 时。

```cangjie
public class ShapeTrimPath <: ContentModel {

    public let nm: String        /* 封装 nm 对应的数据 */
    public let m: Int64          /* 封装 m  对应的数据 */
    public let hd: Bool          /* 封装 hd 对应的数据 */

    /**
     * 基于该参数创建一个 ShapeTrimPath 实例。  
     * 
     * 参数 s - s 对应的值
     * 参数 e - e 对应的值
     * 参数 o - o 对应的值
     * 参数 nm - nm 对应的值
     * 参数 m - m 对应的值
     * 参数 hd - hd 对应的值
     */
    public init(
        s!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(), 
        e!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(), 
        o!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        nm!: String = "", 
        m!: Int64 = 0, 
        hd!: Bool = false
    )

    /**
     * 获得 ShapeTrimPath 的 type 的值。
     */
    public override prop types: Int8

    /**
     * 获得 ShapeTrimPath 的 s 的值。
     */
    public prop s: Array<Keyframe<Float64>>

    /**
     * 获得 ShapeTrimPath 的 e 的值。
     */
    public prop e: Array<Keyframe<Float64>>

    /**
     * 获得 ShapeTrimPath 的 o 的值。
     */
    public prop o: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

##### 1.1.1.4 动画 json 数据封装用到的其他结构类型

###### 1.1.1.4.1 AnimatableSplitDimensionPathValue

```cangjie
public class AnimatableSplitDimensionPathValue <: ToString {
    
    /*
     * 根据参数创建 AnimatableSplitDimensionPathValue 实例。 
     * 
     * 参数 k - k对应的值
     * 参数 x - x对应的值
     * 参数 y - y对应的值
     */
    public init(
        k!: Array<Keyframe<PointF>> = Array<Keyframe<PointF>>(),
        x!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        y!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>()
    )
    
    /**
     * 获取 AnimatableSplitDimensionPathValue 的 k 值。
     */
    public prop k: Array<Keyframe<PointF>>

    /**
     * 获取 AnimatableSplitDimensionPathValue 的 x 值。
     */
    public prop x: Array<Keyframe<Float64>>

    /**
     * 获取 AnimatableSplitDimensionPathValue 的 y 值。
     */
    public prop y: Array<Keyframe<Float64>>
    
    /*
     * 返回 AnimatableSplitDimensionPathValue 类的字符串表示。
     * 
     * 返回值 String - AnimatableSplitDimensionPathValue 类的字符串表示。
     */
    public func toString (): String
}
```

###### 1.1.1.4.2 AnimatableTextPropertiesA

```cangjie
public class AnimatableTextPropertiesA <: ToString {
    
     /* 封装 a 对应数据 */
    public let a: AnimatableTextProperties
    
    /*
     * 基于参数创建一个 AnimatableTextPropertiesA 实例。
     * 
     * 参数 a - a对应的值
     */
    public init(a!: AnimatableTextProperties = AnimatableTextProperties())
    
    /*
     * 将实例转换为字符串并返回。 
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.3 AnimatableTextProperties

```cangjie
public class AnimatableTextProperties <: ToString {
    
    /* 封装 fc 对应的数据 */
    public let fc: ArrayKeyframeArrayFloat64
    /* 封装 t 对应的数据 */
    public let t: ArrayKeyframeFloat64
    
    /*
     * 基于该参数创建一个 AnimatableTextProperties 实例。 
     * 
     * 参数 fc - fc对应的值
     * 参数 sc - sc对应的值
     * 参数 sw - sw对应的值
     * 参数 t - t对应的值
     */
    public init(
        fc!: ArrayKeyframeArrayFloat64 = ArrayKeyframeArrayFloat64(),
        sc!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>(),
        sw!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>(),
        t!: ArrayKeyframeFloat64 = ArrayKeyframeFloat64()
    )

    /**
     * 获取 AnimatableTextProperties 的 sc 的值。
     */
    public prop sc: Array<Keyframe<Array<Float64>>>

    /**
     * 获取 AnimatableTextProperties 的 sw 的值。
     */
    public prop sw: Array<Keyframe<Float64>>

    /*
     * 将实例转换为字符串并返回。 
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.4 ArrayKeyframeArrayFloat64

```cangjie
public class ArrayKeyframeArrayFloat64 <: ToString {
    
    /**
     * 基于该参数创建一个 ArrayKeyframeArrayFloat64 实例。  
     * 
     * 参数 k - k 对应的值
     */
    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>())

    /**
     * 获取 ArrayKeyframeArrayFloat64 的 k 值。
     */
    public prop k: Array<Keyframe<Array<Float64>>> {

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.5 ArrayKeyframeFloat64

```cangjie
public class ArrayKeyframeFloat64 <: ToString {
    
    /**
     * 基于该参数创建一个 ArrayKeyframeFloat64 实例。  
     * 
     * 参数 k - k 对应的值
     */
    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>())

    /**
     * 获取 ArrayKeyframeFloat64 的 k 值。
     */
    public prop k: Array<Keyframe<Float64>> {

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.6 ContentModelP

```cangjie
public open class ContentModelP <: ToString {

    public let p: Int64     /* 封装 p 对应的数据 */

    /**
     * 基于该参数创建一个 ContentModelP 实例。  
     * 
     * 参数 p - p 对应的值
     * 参数 k - k 对应的值
     */
    public init(p!: Int64 = 0, k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>())

    /**
     * 获取 ContentModelP 的 k 值。
     */
    public prop k: Array<Keyframe<Array<Float64>>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.7 ContentModelPK

```cangjie
public open class ContentModelPK <: ToString {
    
    /**
     * 基于该参数创建一个 ContentModelPK 实例。  
     * 
     * 参数 k - k 对应的值
     */
    public init(k!: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>())

    /**
     * 获取 ContentModelPK 的 k 值。
     */
    public prop k: Array<Keyframe<Array<Float64>>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.8 ContentModelD

```cangjie
public open class ContentModelD <: ToString {

    public let n: String         /* 封装 n 对应的数据 */  
    public let v: ContentModelDK /* 封装 v 对应的数据 */ 

    /**
     * 基于该参数创建一个 ContentModelD 实例。  
     * 
     * 参数 n - n 对应的值
     * 参数 v - v 对应的值
     */
    public init(n!: String = "", v!: ContentModelDK = ContentModelDK())
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.9 ContentModelDK

```cangjie
public open class ContentModelDK <: ToString {
    
    /**
     * 基于该参数创建一个 ContentModelDK 实例。  
     * 
     * 参数 k - k 对应的值
     */
    public init(k!: Array<Keyframe<Float64>> = Array<Keyframe<Float64>>())

    /**
     * 获取 ContentModelDK 的 k 值。
     */
    public prop k: Array<Keyframe<Float64>>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.10 Color

```cangjie
public class Color <: ToString {

    public let a: Int64     /* 封装 a 对应的数据 */
    public let r: Int64     /* 封装 r 对应的数据 */
    public let g: Int64     /* 封装 g 对应的数据 */
    public let b: Int64     /* 封装 b 对应的数据 */

    /**
     * 基于该参数创建一个 Color 实例。  
     * 
     * 参数 a - a 对应的值
     * 参数 r - r 对应的值
     * 参数 g - g 对应的值
     * 参数 b - b 对应的值
     */
    public init(a: Int64, r: Int64, g: Int64, b: Int64)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.11 DocumentData

```cangjie
public class DocumentData <: ToString {

    public let t: String             /* 封装 t 对应的数据 */
    public let f: String             /* 封装 f 对应的数据 */
    public let s: Float64            /* 封装 s 对应的数据 */
    public let j: Int64              /* 封装 j 对应的数据 */
    public let tr: Int64             /* 封装 tr 对应的数据 */
    public let lh: Float64           /* 封装 lh 对应的数据 */
    public let ls: Float64           /* 封装 ls 对应的数据 */
    public let sw: Float64           /* 封装 sw 对应的数据 */
    public let of: Bool              /* 封装 of 对应的数据 */
    public let ps: PointF            /* 封装 ps 对应的数据 */
    public let sz: PointF            /* 封装 sz 对应的数据 */

    /**
     * 基于该参数创建一个 DocumentData 实例。  
     * 
     * 参数 t - t 对应的值
     * 参数 f - f 对应的值
     * 参数 s - s 对应的值
     * 参数 j - j 对应的值
     * 参数 tr - tr 对应的值
     * 参数 lh - lh 对应的值
     * 参数 ls - ls 对应的值
     * 参数 fc - fc 对应的值
     * 参数 sc - sc 对应的值
     * 参数 sw - sw 对应的值
     * 参数 of - of 对应的值
     * 参数 ps - ps 对应的值
     * 参数 sz - sz 对应的值
     */
    public init(
        t!: String = "", 
        f!: String = "",
        s!: Float64 = 0.0,
        j!: Int64 = 0, 
        tr!: Int64 = 0,
        lh!: Float64 = 0.0, 
        ls!: Float64 = 0.0,
        fc!: Array<Float64> = Array<Float64>(), 
        sc!: Array<Float64> = Array<Float64>(),
        sw!: Float64 = 0.0,
        of!: Bool = false,
        ps!: PointF = PointF(), 
        sz!: PointF = PointF()
    )

    /**
     * 获得 DocumentData 的 fc 的值。
     */
    public prop fc: Array<Float64>

    /**
     * 获得 DocumentData 的 sc 的值。
     */
    public prop sc: Array<Float64>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.12 Keyframe

```cangjie
public class Keyframe<T> <: ToString {

    public let k: Option<T>     /* 封装 k  对应的数据 */
    public let t: Float64       /* 封装 t  对应的数据 */
    public let s: Option<T>     /* 封装 s  对应的数据 */
    public let e: Option<T>     /* 封装 e  对应的数据 */
    public let o: PointF        /* 封装 o  对应的数据 */
    public let i: PointF        /* 封装 i  对应的数据 */
    public let h: Int64         /* 封装 h  对应的数据 */
    public let to: PointF       /* 封装 to 对应的数据 */
    public let ti: PointF       /* 封装 ti 对应的数据 */

    /**
     * 基于该参数创建一个 Keyframe 实例。  
     * 
     * 参数 k - k 对应的值
     * 参数 t - t 对应的值
     * 参数 s - s 对应的值
     * 参数 e - e 对应的值
     * 参数 o - o 对应的值
     * 参数 i - i 对应的值
     * 参数 h - h 对应的值
     * 参数 to - to 对应的值
     * 参数 ti - ti 对应的值
     */
    public init(
        k!: Option<T> = Option<T>.None,
        t!: Float64 = 0.0,
        s!: Option<T> = Option<T>.None,
        e!: Option<T> = Option<T>.None,
        o!: PointF = PointF(),
        i!: PointF = PointF(),
        h!: Int64 = 0,
        to!: PointF = PointF(),
        ti!: PointF = PointF()
    )
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.13 PointF

```cangjie
public class PointF <: ToString {

    public let x: Float64       /* 封装 x 对应的数据 */ 
    public let y: Float64       /* 封装 y 对应的数据 */

    /**
     * 基于该参数创建一个 PointF 实例。  
     * 
     * 参数 x - x 对应的值
     * 参数 y - y 对应的值
     */
    public init(x!: Float64 = 0.0, y!: Float64 = 0.0)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

###### 1.1.1.4.14 ShapeData

```cangjie
public class ShapeData <: ToString {

    public let c: Bool         /* 封装 c 对应的数据 */

    /**
     * 基于该参数创建一个 AnimatableTextProperties 实例。  
     * 
     * 参数 c - c 对应的值
     * 参数 v - v 对应的值
     * 参数 i - i 对应的值
     * 参数 o - o 对应的值
     */
    public init(
        c!: Bool = false,
        v!: Array<PointF> = Array<PointF>(),
        i!: Array<PointF> = Array<PointF>(),
        o!: Array<PointF> = Array<PointF>()
    )

    /**
     * 获得 ShapeData 的 v 的值。
     */
    public prop v: Array<PointF>

    /**
     * 获得 ShapeData 的 i 的值。
     */
    public prop i: Array<PointF>

    /**
     * 获得 ShapeData 的 o 的值。
     */
    public prop o: Array<PointF>

    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```


#### 1.1.2 动画json格式数据解析

##### 1.1.2.1 AnimationDataParser
用于lottie json的解析器，它解析为AnimationData对象。

```cangjie
/**
 * 用于lottie json的解析器，它解析为AnimationData对象。
 */
public class AnimationDataParser {
    
    /**
     * 将动画的 json 数据，解析封装到 AnimationData 实例中。
     * 
     * 参数 reader - 动画的 json 数据字符串。
     * 返回值 AnimationData - 封装动画的 json 数据的实例。
     */
    public static func parse (reader: String): AnimationData
}
```

##### 1.1.2.2 LayerParser
动画的 json 数据中的 "layers" 的数据被 LayerParser 解析成 Layer 对象。

```cangjie
/**
 * 动画的 json 数据中的 "layers" 的数据被 LayerParser 解析成 Layer 对象。
 */
public class LayerParser {
    
    /**
     * 动画的 json 数据中的 "layers" 的数据，解析封装到相应的 Layer 实体类中。
     * 
     * 参数 reader - 动画的 json 数据中的 "layers" 的数据。
     * 返回值 Layer - 封装动画的 "layers" 数据的实例。
     */
    public static func parse (reader: JsonValue): Layer
}
```

##### 1.1.2.3 AnimatableTransformParser
动画的 json 数据中的 "ks" 的数据，解析封装到相应的 AnimatableTransform 实体类中。

```cangjie
public class AnimatableTransformParser {
    
    /**
     * 动画的 json 数据中的 "ks" 的数据，解析封装到相应的 AnimatableTransform 实体类中。
     * 
     * 参数 jsonObject - 动画的 json 数据中的 "ks" 的数据。
     * 返回值 AnimatableTransform - 封装动画的 "ks" 数据的实例。
     */
    public static func parse (jsonObject: JsonObject): AnimatableTransform
}
```

##### 1.1.2.4 动画json格式数据解析，用到的其他数据解析

###### 1.1.2.4.1 AnimatablePathValueParser

```cangjie
public class AnimatablePathValueParser {
    
    /**
     * 动画的 json 数据中的特殊 "p" 的数据，解析封装到相应的 Keyframe<PointF> 实例数组中。
     * 应用于 "shapes".{"ty": "rc"/"el"/"sr"} 中的 "p" 数据解析
     * 
     * 参数 reader - 动画的 json 数据中的特殊 "p" 的数据。
     * 返回值 Array<Keyframe<PointF>> - 封装动画的特殊 "p" 数据的实例数组。
     */
    public static func parse (reader: JsonValue): Array<Keyframe<PointF>>
}
```

###### 1.1.2.4.2 AnimatableTextPropertiesParser

```cangjie
public class AnimatableTextPropertiesParser {
    
    /**
     * 动画的 json 数据中的特殊 "a" 的数据，解析封装到相应的 AnimatableTextProperties 实例中。
     * 应用于 "layers"."t"."a" 中的 "a" 数据解析
     * 
     * 参数 reader - 动画的 json 数据中的特殊 "a" 的数据。 
     * 返回值 AnimatableTextProperties - 封装动画的特殊 "a" 数据的实例数组。 
     */
    public static func parse (reader: JsonObject): AnimatableTextProperties
}
```

###### 1.1.2.4.3 AnimatableValueParser

```cangjie
public class AnimatableValueParser {
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到相应的 Keyframe<Float64> 实例数组中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Keyframe<Float64>> - 封装动画的指定数据的实例数组。 
     */
    public static func parseFloat (reader: JsonValue): Array<Keyframe<Float64>>
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到相应的 Keyframe<Array<Float64>> 实例数组中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Keyframe<Array<Float64>>> - 封装动画的指定数据的实例数组。 
     */
    public static func parseArrayFloat (reader: JsonValue): Array<Keyframe<Array<Float64>>>
}
```

###### 1.1.2.4.4 interface ValueParser<T>

```cangjie
public interface ValueParser<T> {

    /**
     * 动画的 json 数据中的指定数据，解析封装到相应的数组中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 T - 封装动画的指定数据的数组。 
     */
    func parse(reader: JsonValue): T
}
```

###### 1.1.2.4.5 GradientColorParser

```cangjie
public class GradientColorParser <: ValueParser<Array<Float64>> {
    
    /**
     * 基于该参数创建一个 ValueParser 实例。  
     * 
     * 参数 colorPoints - colorPoints 对应的值
     */
    public init (colorPoints: Int64)
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到相应的数组中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Float64> - 封装动画的指定数据的数组。 
     */
    public func parse (reader: JsonValue): Array<Float64>
}
```

###### 1.1.2.4.6 IntegerParser

```cangjie
public class IntegerParser <: ValueParser<Int64> {

    /**
     * 获取 IntegerParser 实例。
     *
     * 返回值 IntegerParser - IntegerParser instance.
     */
    public static let INSTANCE: IntegerParser

    /**
     * 动画的 json 数据中的指定数据，解析为数值。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Int64 - 解析为数值。
     */
    public func parse (reader: JsonValue): Int64
}
```

###### 1.1.2.4.7 FloatParser

```cangjie
public class FloatParser <: ValueParser<Float64> {

    /**
     * 获取 FloatParser 实例。
     *
     * 返回值 FloatParser - FloatParser instance.
     */
    public static let INSTANCE: FloatParser
    
    /**
     * 动画的 json 数据中的指定数据，解析为数值。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Float64 - 解析为数值。
     */
    public func parse (reader: JsonValue): Float64
}
```

###### 1.1.2.4.8 ArrayFloat64Parser

```cangjie
public class ArrayFloat64Parser <: ValueParser<Array<Float64>> {
    
    /**
     * 获取 ArrayFloat64Parser 实例。
     *
     * 返回值 ArrayFloat64Parser - ArrayFloat64Parser instance.
     */
    public static let INSTANCE: ArrayFloat64Parser
    
    /**
     * 动画的 json 数据中的指定数据，解析为数组。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Float64> - 解析为数组。
     */
    public func parse (reader: JsonValue): Array<Float64>
}
```

###### 1.1.2.4.9 PointFParser

```cangjie
public class PointFParser <: ValueParser<PointF> {
    
    /**
     * 获取 PointFParser 实例。
     *
     * 返回值 PointFParser - PointFParser instance.
     */
    public static let INSTANCE: PointFParser
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到对应的实体类中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 PointF - 解析封装到此实体类中。
     */
    public func parse (reader: JsonValue): PointF
}
```

###### 1.1.2.4.10 DocumentDataParser

```cangjie
public class DocumentDataParser <: ValueParser<DocumentData> {
    
    /**
     * 获取 DocumentDataParser 实例。
     *
     * 返回值 DocumentDataParser - DocumentDataParser instance.
     */
    public static let INSTANCE: DocumentDataParser
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到对应的实体类中。
     * 
     * 参数 jv - 动画的 json 数据中的指定数据。
     * 返回值 DocumentData - 解析封装到此实体类中。
     */
    public func parse (jv: JsonValue): DocumentData
}
```

###### 1.1.2.4.11 ShapeDataParser

```cangjie
public class ShapeDataParser <: ValueParser<ShapeData> {
    
    /**
     * 获取 ShapeDataParser 实例。
     *
     * 返回值 ShapeDataParser - ShapeDataParser instance.
     */
    public static let INSTANCE: ShapeDataParser
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到对应的实体类中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 ShapeData - 解析封装到此实体类中。
     */
    public func parse (reader: JsonValue): ShapeData
}
```

###### 1.1.2.4.12 PathParser

```cangjie
public class PathParser <: ValueParser<PointF> {
    
    /**
     * 获取 PathParser 实例。
     *
     * 返回值 PathParser - PathParser instance.
     */
    public static let INSTANCE: PathParser
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到对应的实体类中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 PointF - 解析封装到此实体类中。
     */
    public func parse (reader: JsonValue): PointF
}
```

###### 1.1.2.4.13 ScaleXYParser

```cangjie
public class ScaleXYParser <: ValueParser<Array<Float64>> {
    
    /**
     * 获取 ScaleXYParser 实例。
     *
     * 返回值 ScaleXYParser - ScaleXYParser instance.
     */
    public static let INSTANCE: ScaleXYParser
    
    /**
     * 动画的 json 数据中的指定数据，解析为数组。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Float64> - 解析为数组。
     */
    public func parse (reader: JsonValue): Array<Float64>
}
```

###### 1.1.2.4.14 ColorParser

```cangjie
public class ColorParser <: ValueParser<Array<Float64>> {
    
    /**
     * 获取 ColorParser 实例。
     *
     * 返回值 ColorParser - ColorParser instance.
     */
    public static let INSTANCE: ColorParser
    
    /**
     * 动画的 json 数据中的指定数据，解析为数组。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Array<Float64> - 解析为数组。
     */
    public func parse (reader: JsonValue): Array<Float64>
    
    /**
     * 动画的 json 数据中的指定数据，解析封装到对应的实体类中。
     * 
     * 参数 reader - 动画的 json 数据中的指定数据。
     * 返回值 Color - 解析封装到此实体类中。
     */
    public func parseColor (reader: JsonValue): Color
}
```

##### 1.1.1.2 示例

```cangjie

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
    println(0)
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
```

执行结果如下：

```shell
0
```


## 2. elements 包

### 2.1 BaseElement 类

```cangjie
public open class BaseElement<: Equatable<BaseElement> {
    
    /**
     * 基于参数创建 BaseElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)

    /**
     * 检查 masks 数据。
     * 
     * 返回值 Bool - 返回检查 masks 数据的结果。
     */
    public func checkMasks (): Bool
    
    /**
     * 设置混合模式。 
     */
    public func setBlendMode (): Unit

}
```

### 2.2 ITextElement 类

```cangjie
public class ITextElement<: BaseElement {
    
    /**
     * 基于参数创建 ITextElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
    
    /**
     * 准备 Frame。
     * 
     * 参数 num - Float64 数据类型。
     */
    public func prepareFrame (num: Float64): Unit
    
    /**
     * 创建路径形状。
     * 
     * 参数 matrixHelper - Matrix 数据类型。
     * 参数 shapes - Array<ContentModel> 数据类型，shapes 的值。
     * 返回值 String - 路径形状。
     */
    public func createPathShape (matrixHelper: Matrix, shapes: Array<ContentModel>): String
    
    /**
     * 更新文档数据。
     * 
     * 参数 newData - Option<DocumentData> 数据类型，新的文档数据。
     * 参数 index - Option<Int64> 数据类型。
     */
    public func updateDocumentData (newData: Option<DocumentData>, index: Option<Int64>)

    /**
     * 可以调整字体大小
     * 
     * 参数 canResize - Bool 数据类型，设置是否可以调整字体大小。
     */
    public func canResizeFont (canResize: Bool)

    /**
     * 设置最小字体大小
     * 
     * 参数 fontValue - Option<Float64> 数据类型，要设置最小字体大小。
     */
    public func setMinimumFontSize (fontSize: Option<Float64>)
    
    /**
     * 将文本属性应用于矩阵。
     * 
     * 参数 documentData - DocumentData 数据类型。
     * 参数 matrixHelper - Matrix 数据类型。
     * 参数 lineNumber - Int64 数据类型。
     * 参数 xPos - Float64 数据类型。
     * 参数 yPos - Float64 数据类型。
     */
    public func applyTextPropertiesToMatrix (documentData: DocumentData, matrixHelper: Matrix, lineNumber: Int64, xPos: Float64, yPos: Float64)
    
    /**
     * 构建颜色。
     * 
     * 参数 colorData - Array<Float64> 数据类型，颜色数据值。
     * 返回值 String - 
     */
    public func buildColor (colorData: Array<Float64>): String
    
    /**
     * 获取一个空的 LetterProps。
     * 
     * 返回值 LetterProps - 空的 LetterProps。
     */
    public func emptyProp (): LetterProps

}
```

### 2.3 IShapeElement 类

```cangjie
public class IShapeElement<: BaseElement {
    
    /**
     * 基于参数创建 IShapeElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
    
    /**
     * 将形状添加到修改器。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     */
    public func addShapeToModifiers (data: Layer): Unit
    
    /**
     * 确定它是否是动画修改器中的形状。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 返回值 Bool - 是否是动画修改器中的形状。
     */
    public func isShapeInAnimatedModifiers (data: Layer): Bool
    
    /**
     * 渲染修改器。
     */
    public func renderModifiers (): Unit
    
    /**
     * 搜索已处理的元素。
     * 
     * 参数 elem - BaseElement 数据类型，已处理的元素。
     * 返回值 Int64 - 返回已处理元素的 pos。
     */
    public func searchProcessedElement (elem: BaseElement): Int64
    
    /**
     * 添加已处理的元素。
     * 
     * 参数 elem - BaseElement 数据类型，已处理的元素。
     * 参数 pos - BaseElement 数据类型，已处理元素的 pos。
     */
    public func addProcessedElement (elem: BaseElement, pos: Int64): Unit

}
```

### 2.4 ICompElement 类

```cangjie
public class ICompElement<: BaseElement {
    
    /**
     * 基于参数创建 ICompElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
    
    /**
     * 准备 Frame。
     * 
     * 参数 num - Float64 数据类型。
     */
    public func prepareFrame (num: Float64): Unit
    
    /**
     * 渲染内部内容。
     */
    public func renderInnerContent (): Unit
    
    /**
     * 渲染形状颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组RGBA。
     * 参数 endColor - Array<Int64> 数据类型，结束颜色数组RGBA。
     * 参数 index - Int64 数据类型，相应层次结构中元素的下标值。
     */
    public func renderShapeColor (color: Array<Int64>, endColor: Array<Int64>, index: Int64)
    
    /**
     * 渲染形状颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组RGBA。
     * 参数 endColor - Int64 数据类型。
     * 参数 index - Int64 数据类型，相应层次结构中元素的下标值。
     */
    public func renderShapeColor (color: Array<Int64>, endColor: Int64, index: Int64)
    
    /**
     * 渲染形状颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组RGBA。
     * 参数 index - Int64 数据类型，相应层次结构中元素的下标值。
     */
    public func renderShapeColor (color: Array<Int64>, index: Int64)
    
    /**
     * 设置元素值。
     * 
     * 参数 elems - Array<BaseElement> 数据类型，要设置的元素值。
     */
    public func setElements (elems: Array<BaseElement>): Unit
    
    /**
     * 获取元素值。
     * 
     * 返回值 Array<BaseElement> - Array<BaseElement> 数据类型，获取的元素值。
     */
    public func getElements (): Array<BaseElement>
    
    /**
     * 摧毁元素。
     */
    public func destroyElements (): Unit
    
    /**
     * 摧毁。
     */
    public func destroy (): Unit
}
```

### 2.5 SourceRect 类

```cangjie
public class SourceRect {
    
    /**
     * 基于参数创建 SourceRect 实例。
     * 
     * 参数 top - Int64 数据类型。
     * 参数 left - Int64 数据类型。
     * 参数 width - Int64 数据类型。
     * 参数 height - Int64 数据类型。
     */
    public init (top: Int64, left: Int64, width: Int64, height: Int64)
}
```

### 2.6 IImageElement 类

```cangjie
public class IImageElement<: BaseElement {
    
    /**
     * 基于参数创建 IImageElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
    
    /**
     * 创建内容。
     */
    public func createContent (): Unit
    
    /**
     * 返回 sourceRect 值。
     * 
     * 返回值 SourceRect - sourceRect值。
     */
    public func sourceRectAtTime (): SourceRect
}
```

### 2.7 NullElement 类

```cangjie
public class NullElement<: BaseElement {
    
    /**
     * 基于参数创建 NullElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
}
```

### 2.8 ISolidElement 类

```cangjie
public class ISolidElement<: BaseElement {
    
    /**
     * 基于参数创建 ISolidElement 实例。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     */
    public init (data: Layer, globalData: GlobalData)
    
    /**
     * 创建内容。
     */
    public func createContent (): Unit
}
```

### 2.9 CvContextData 类

```cangjie
public class CvContextData{

    /*
     * CvContextData 构造器
     */
    public init() 

    /**
     * 复制保存的操作
     * 
     */
    public func duplicate(): Unit

    /**
     * 重置数据
     * 
     */
    public func reset(): Unit

    /**
     * 根据保存的数据设置矩阵参数
     * 
     * 返回值 Array<Float64> - 保存的数据
     */
    public func popTransform(): Array<Float64>

    /**
     * pop不透明度
     * 
     * 返回值 Int64 - pop不透明度
     */
    public func popOpacity(): Int64

    /**
     * pop对象
     * 
     * 返回值 (Array<Float64>,Int64) - pop对象
     */
    public func pop(): (Array<Float64>,Int64)

    /**
     * 推送数据
     * 
     */
    public func push(): Unit

    /**
     * 获取矩阵对象
     * 
     * 返回值 Matrix - 矩阵对象
     */
    public func getTransform(): Matrix

    /**
     * 获取不透明度
     * 
     * 返回值 Int64 - 不透明度
     */
    public func getOpacity(): Int64

    /**
     * 设置不透明度
     * 参数 value - 不透明度
     */
    public func setOpacity(value: Int64): Unit

}
```

### 2.10 Matrix 类

```cangjie
public class Matrix {

    /*
     * Matrix 构造器
     */
    public init()

    /**
     * 当前坐标轴进行顺时针旋转
     * 参数 id - 添加的对象
     *
     * 返回值 Matrix - 当前对象
     */
    public func rotate(angle: Float64): Matrix

    /**
     * 当前围绕X轴进行顺时针旋转
     * 参数 angle - 旋转角度值
     *
     * 返回值 Matrix - 当前对象
     */
    public func rotateX(angle: Float64): Matrix

    /**
     * 当前围绕Y轴进行顺时针旋转
     * 参数 angle - 旋转角度值
     *
     * 返回值 Matrix - 当前对象
     */
    public func rotateY(angle: Float64): Matrix

    /**
     * 当前围绕Z轴进行顺时针旋转
     * 参数 angle - 旋转角度值
     *
     * 返回值 Matrix - 当前对象
     */
    public func rotateZ(angle: Float64): Matrix

    /**
     * 当前X轴顺时针方向倾斜
     * 参数 ax - X轴倾斜的角度
     * 参数 angle - 旋转角度值
     *
     * 返回值 Matrix - 当前对象
     */
    public func skewFromAxis(ax: Float64, angle: Float64): Matrix
    
    /**
     * 按照缩放比例进行缩放
     * 参数 sx - 设置水平方向的缩放值
     * 参数 sy - 设置垂直方向的缩放值
     * 参数 sz - 设置z轴方向的缩放值
     *
     * 返回值 Matrix - 当前对象
     */
    public func scale(sx: Float64, sy: Float64, sz!: Float64 = 1.0): Matrix

    /**
     * 重置现有的变换矩阵并创建新的变换矩阵
     * 参数 a - 设置props数据
     * 参数 b - 设置props数据
     * 参数 c - 设置props数据
     * 参数 d - 设置props数据
     * 参数 e - 设置props数据
     * 参数 f - 设置props数据
     * 参数 g - 设置props数据
     * 参数 f - 设置props数据
     * 参数 i - 设置props数据
     * 参数 j - 设置props数据
     * 参数 k - 设置props数据
     * 参数 l - 设置props数据
     * 参数 m - 设置props数据
     * 参数 n - 设置props数据
     * 参数 o - 设置props数据
     * 参数 p - 设置props数据
     *
     * 返回值 Matrix - 当前对象
     */
    public func setTransform(a: Float64, b: Float64, c: Float64, d: Float64, e: Float64, f: Float64, g: Float64, h: Float64,i: Float64, j: Float64, k: Float64, l: Float64, m: Float64, n: Float64, o: Float64, p: Float64): Matrix

    /**
     * 移动当前坐标系的原点
     * 参数 sx - 设置X轴平移量
     * 参数 sy - 设置Y轴平移量
     * 参数 sz - 设置Z轴方向的缩放值
     *
     * 返回值 Matrix - 当前对象
     */
    public func translate(tx: Float64, ty: Float64, tz!: Float64 = 0.0): Matrix

    /**
     * 设置变换矩阵
     * 参数 a2 - 设置props数据
     * 参数 b2 - 设置props数据
     * 参数 c2 - 设置props数据
     * 参数 d2 - 设置props数据
     * 参数 e2 - 设置props数据
     * 参数 f2 - 设置props数据
     * 参数 g2 - 设置props数据
     * 参数 f2 - 设置props数据
     * 参数 i2 - 设置props数据
     * 参数 j2 - 设置props数据
     * 参数 k2 - 设置props数据
     * 参数 l2 - 设置props数据
     * 参数 m2 - 设置props数据
     * 参数 n2 - 设置props数据
     * 参数 o2 - 设置props数据
     * 参数 p2 - 设置props数据
     *
     * 返回值 Matrix - 当前对象
     */
    public func transform(a2: Float64, b2: Float64, c2: Float64, d2: Float64, e2: Float64, f2: Float64, g2: Float64,
        h2: Float64, i2: Float64, j2: Float64, k2: Float64, l2: Float64, m2: Float64, n2: Float64, o2: Float64,
        p2: Float64): Matrix

    /**
     * 判断是否是单位矩阵
     * 
     * 返回值 Bool - 是否是单位矩阵
     */
    public func isIdentity(): Bool

    /**
     * 判断是否相等
     * 参数 matr - Matrix对象
     *
     * 返回值 Bool - 判断矩阵是否相等
     */
    public func equals(matr: Matrix): Bool

    /**
     * 复制矩阵的内容
     * 参数 matr - Matrix对象
     *
     * 返回值 Matrix - 复制矩阵
     */
    public func clone(matr: Matrix): Matrix

    /**
     * 设置Props属性内容
     * 参数 props - props属性数据
     *
     */
    public func cloneFromProps(props: Array<Float64>): Unit

    /**
     * 位置点的数据
     * 参数 x - x点的位置
     * 参数 y - y点的位置
     * 参数 z - z点的位置
     *
     * 返回值 (Float64,Float64,Float64) - 位置点的数据
     */
    public func applyToPoint(x: Float64, y: Float64, z: Float64): (Float64,Float64,Float64)

    /**
     * 应用点的数据
     * 参数 x - x点的位置
     *
     * 返回值 Float64 - 位置点的数据
     */
    public func applyToX(x: Float64, y: Float64, z: Float64): Float64

    /**
     * 应用点的数据
     * 参数 y - y点的位置
     *
     * 返回值 Float64 - 位置点的数据
     */
    public func applyToY(x: Float64, y: Float64, z: Float64): Float64

    /**
     * 应用点的数据
     * 参数 z - z点的位置
     *
     * 返回值 Float64 - 位置点的数据
     */
    public func applyToZ(x: Float64, y: Float64, z: Float64): Float64

    /**
     * 获取逆矩阵
     *
     * 返回值 Matrix - Matrix
     */
    public func getInverseMatrix(): Matrix

    /**
     * 获取单个反转点
     * 参数 pt - 数据点内容
     *
     * 返回值 (Float64,Float64,Float64) - 数据点内容
     */
    public func inversePoint(pt: Array<Float64>): (Float64,Float64,Float64)

    /**
     * 获取所有反转点
     * 参数 pt - 数据点内容
     *
     * 返回值 Array<(Float64,Float64,Float64)> - 数据点内容
     */
    public func inversePoints(pts: Array<Array<Float64>>): Array<(Float64,Float64,Float64)>

    /**
     * 获取三相点
     * 参数 pt1 - 数据点内容
     * 参数 pt2 - 数据点内容
     * 参数 pt3 - 数据点内容
     *
     * 返回值 Array<Float64> - 数据点内容
     */
    public func applyToTriplePoints(pt1: Array<Float64>, pt2: Array<Float64>, pt3: Array<Float64>): Array<Float64>

    /**
     * 获取点阵列
     * 参数 x - x点内容
     * 参数 y - y点内容
     * 参数 z - z点内容
     *
     * 返回值  (Float64,Float64,Float64) - 数据点内容
     */
    public func applyToPointArray(x: Float64, y: Float64, z: Float64): (Float64,Float64,Float64)

    /**
     * 获取点字符串化
     * 参数 x - x点内容
     * 参数 y - y点内容
     *
     * 返回值 String - 字符串内容
     */
    public func applyToPointStringified(x: Float64, y: Float64): String

    /**
     * CSS矩阵转换
     *
     * 返回值 String - 字符串内容
     */
    public func toCSS(): String

    /**
     * 圆形矩阵处理
     * 参数 Float64 - 点内容
     *
     * 返回值 Float64 - 数据内容
     */
    public func roundMatrixProperty(val: Float64): Float64

    /**
     * CSS2d矩阵转换
     *
     * 返回值 String - 字符串内容
     */
    public func to2dCSS(): String

    /**
     * 重置矩阵
     *
     */
    public func reset(): Unit

}
```

## 3. renderers 包

### 3.1 BaseRenderer 类

```cangjie
public abstract class BaseRenderer {
    
    /**
     * 检查图层。
     * 
     * 参数 num - Float64 数据类型。
     */
    public func checkLayers (num: Float64): Unit
    
    /**
     * 处理图层数据并创建相应的元素。
     * 
     * 参数 layer - Layer 数据类型，封装动画的 “layers” 数据的实例。
     * 返回值 BaseElement - 处理图层数据并创建相应的元素实例。
     */
    public func createItem (layer: Layer): BaseElement
    
    /**
     * 处理图层数据并创建Camera Element。
     * 
     * 参数 data - Layer 数据类型，封装动画的 “layers” 数据的实例。
     * 返回值 BaseElement - 处理图层数据并创建相应的 Camera 元素实例。
     * 备注：不支持，调用直接抛出异常。
     */
    public func createCamera (data: Layer): BaseElement
    
    /**
     * 生成所有元素。
     */
    public func buildAllItems (): Unit
    
    /**
     * 包括图层。
     * 
     * 参数 newLayers - Array<Layer> 数据类型，封装动画的 “layers” 数据的实例。
     */
    public func includeLayers (newLayers: Array<Layer>)
    
    /**
     * 初始化所有元素。
     */
    public func initItems (): Unit
    
    /**
     * 生成元素父级。
     * 
     * 参数 element - BaseElement 数据类型。
     * 参数 parentName - Int64 数据类型。
     * 参数 hierarchy - ArrayList<BaseElement> 数据类型。
     */
    public func buildElementParenting (element: BaseElement, parentName: Int64, hierarchy: ArrayList<BaseElement>): Unit
    
    /**
     * 添加挂起的元素。
     * 
     * 参数 element - BaseElement 数据类型。
     */
    public func addPendingElement (element: BaseElement)
    
    /**
     * 搜索额外的 assets。
     * 
     * 参数 assets - Array<Asset> 数据类型。
     */
    public func searchExtraCompositions (assets: Array<Asset>)
    
    /**
     * 按 id 获取元素。
     * 
     * 参数 ind - Int64 数据类型，元素 id。
     * 返回值 Option<BaseElement> - 获取的元素
     */
    public func getElementById (ind: Int64): Option<BaseElement>
    
    /**
     * 按 path 获取元素。
     * 
     * 参数 paths - Array<Int64> 数据类型，path 值。
     * 返回值 Option<BaseElement> - 获取的元素
     */
    public func getElementByPath (paths: Array<Int64>): Option<BaseElement>
    
    /**
     * 按 path 获取元素。
     * 
     * 参数 paths - Array<Int64> 数据类型，path 值。
     * 返回值 Option<BaseElement> - 获取的元素
     */
    public func getElementByPath (paths: Array<String>): Option<BaseElement>
    
    /**
     * 设置全局数据。
     * 
     * 参数 animData - AnimationData 数据类型，封装动画的 json 数据的实例。
     * 参数 fontsContainer - CreateTag 数据类型。
     */
    public func setupGlobalData (animData: AnimationData, fontsContainer: CreateTag): Unit
}
```

### 3.2 CanvasRenderer 类

```cangjie
public class CanvasRenderer<: CanvasRendererBase {
    
    /**
     * 基于参数创建 CanvasRenderer 实例。 
     * 
     * 参数 animationItem - AnimationItem 数据类型。
     * 参数 config - Option<RenderConfig> 数据类型。
     */
    public init (animationItem: AnimationItem, config: Option<RenderConfig>)
    
    /**
     * 创建 Comp 元素。
     * 
     * 参数 data - Layer 数据类型。
     * 返回值 BaseElement - BaseElement 数据类型。
     */
    public func createComp (data: Layer): BaseElement
}
```

### 3.3 CanvasRendererBase 类

```cangjie
public abstract class CanvasRendererBase<: BaseRenderer {
    
    /**
     * 基于参数创建 CanvasRendererBase 实例。
     * 
     * 参数 animationItem - AnimationItem 数据类型。
     * 参数 config - Option<RenderConfig> 数据类型。
     */
    public init (animationItem: AnimationItem, config: Option<RenderConfig>)

    /**
     * 创建 Null 元素。
     * 
     * 参数 data - Layer 数据类型，封装动画的“层”数据的实例。
     * 返回值 NullElement - Null 元素。
     */
    public func createNull (data: Layer): NullElement
    
    /**
     * ctx 变换。
     * 
     * 参数 props - Array<Float64> 数据类型。
     */
    public func ctxTransform (props: Array<Float64>): Unit
    
    /**
     * ctx 不透明度
     * 
     * 参数 op - Int64 数据类型。
     */
    public func ctxOpacity (op: Int64): Unit
    
    /**
     * 重置。
     */
    public func reset (): Unit
    
    /**
     * 保存。
     * 
     * 参数 actionFlag - Bool 数据类型。
     */
    public func save (actionFlag: Bool): Unit
    
    /**
     * 恢复。
     * 
     * 参数 actionFlag - Bool 数据类型。
     */
    public func restore (actionFlag: Bool): Unit
    
    /**
     * 动画配置。
     * 
     * 参数 animData - AnimationData 数据类型，封装动画的json数据的实例。
     */
    public func configAnimation (animData: AnimationData): Unit
    
    /**
     * 更新内容模式。
     * 
     * 参数 contentMode - String 数据类型，内容模式。
     */
    public func updateContentMode (contentMode: String): Unit
    
    /**
     * 更新容器大小
     * 
     * 参数 width - Int64 数据类型。
     * 参数 height - Int64 数据类型。
     */
    public func updateContainerSize (width: Int64, height: Int64): Unit
    
    /**
     * 摧毁。
     */
    public func destroy (): Unit
    
    /**
     * 修改动画颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组 RGBA。
     * 参数 endColor - Array<Int64> 数据类型，结束颜色数组 RGBA。
     * 参数 layer - Int64 数据类型，层次的下标值。
     * 参数 index - Int64 数据类型，对应层次里面的 elements 的下标值。
     */
    public func changeColor (color: Array<Int64>, endColor: Array<Int64>, layer: Int64, index: Int64): Unit
    
    /**
     * 修改动画颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组 RGBA。
     * 参数 endColor - Int64 数据类型。
     * 参数 layer - Int64 数据类型，层次的下标值。
     * 参数 index - Int64 数据类型，对应层次里面的 elements 的下标值。
     */
    public func changeColor (color: Array<Int64>, endColor: Int64, layer: Int64, index: Int64): Unit
    
    /**
     * 修改动画颜色。
     * 
     * 参数 color - Array<Int64> 数据类型，启动颜色数组 RGBA。
     * 参数 layer - Int64 数据类型，层次的下标值。
     * 参数 index - Int64 数据类型，对应层次里面的 elements 的下标值。
     */
    public func changeColor (color: Array<Int64>, layer: Int64, index: Int64): Unit
    
    /**
     * 渲染帧。
     * 
     * 参数 num - Int64 数据类型。
     * 参数 forceRender - Bool 数据类型，是否强制渲染。
     */
    public func renderFrame (num: Int64, forceRender: Bool): Unit
    
    /**
     * 构建元素。
     * 
     * 参数 pos - Int64 数据类型。
     */
    public func buildItem (pos: Int64): Unit
    
    /**
     * 检查挂起的元素。
     */
    public func checkPendingElements (): Unit

}
```


## 4. utils 包

### 4.1 

#### 4.1.1 FontProps 类

```cangjie
public class FontProps {
    
    /**
     * 基于参数创建FontProps实例。
     * 
     * 参数 style - String 数据类型。
     * 参数 weight - String 数据类型。
     */
    public init (style: String, weight: String)
}
```

####  4.1.2 getFontProperties 函数

```cangjie
/**
 * 获取字体属性。
 * 
 * 参数 style - String 数据类型。
 * 参数 weight - String 数据类型。
 */
public func getFontProperties(fontData: Font): FontProps
```

#### 4.1.3 common 文件

```cangjie
public class CreateElementID {
    
    /**
     * 创建元素ID
     * 
     * 返回值 String - 元素ID。
     */
    public static func createID (): String
}
```

```cangjie
/**
 * 获取默认曲线分段值。
 * 
 * 返回值 Int64 - 默认曲线分段值。
 */
public func getDefaultCurveSegments(): Int64
```

#### 4.1.4 FontManager 类

```cangjie
public class FontManager {
    
    /**
     * 创建 FontManager 实例。 
     * 
     */
    public init ()
    
    /**
     * 根据名称获取 Font。
     * 
     * 参数 name - String 数据类型，封装globalData数据的实例。
     * 返回值 Font - Font 数据类型，根据名称获取 Font。
     */
    public func getFontByName (name: String): Font
    
    /**
     * 获取字符数据。
     * 
     * 参数 char - String 数据类型。
     * 参数 style - String 数据类型。
     * 参数 font - String 数据类型。
     * 返回值 FontCharacter - 获取的字符数据。
     */
    public func getCharData (char: String, style: String, font: String): FontCharacter
    
    /**
     * 判断是否是修饰符。
     * 
     * 参数 firstCharCode - UInt32 数据类型，第一个字符代码。
     * 参数 secondCharCode - UInt32 数据类型，第二个字符代码。
     * 返回值 Bool - 是否是修饰符。
     */
    public static func isModifier (firstCharCode: UInt32, secondCharCode: UInt32): Bool
    
    /**
     * 判断是否是零宽度 Joiner。
     * 
     * 参数 firstCharCode - UInt32 数据类型，第一个字符代码。
     * 参数 secondCharCode - UInt32 数据类型，第二个字符代码。
     * 返回值 Bool - 是否是零宽度 Joiner。
     */
    public static func isZeroWidthJoiner (firstCharCode: UInt32, secondCharCode: UInt32): Bool
    
    /**
     * 判断是否是组合字符
     * 
     * 参数 char - UInt32 数据类型，判断char是否是组合字符。
     * 返回值 Bool - 判断是否是组合字符。
     */
    public static func isCombinedCharacter (char: UInt32): Bool
}
```

#### 4.1.5 BezierData 类

```cangjie
public class BezierData {
    
    /**
     * 创建 BezierData 实例。
     */
    public init ()
    
    /**
     * 基于参数创建 BezierData 实例。
     * 
     * 参数 len - Int64 数据类型，points 数组的长度。
     * 参数 empty - PointData 数据类型，points 数组类型。
     * 
     * 异常 IllegalArgumentException：如果 len 小于 0，抛出异常
     */
    public init (len: Int64, empty: PointData)
    
    /**
     * 基于参数创建 BezierData 实例。
     * 
     * 参数 segmentLength - Int64 数据类型，segmentLength 的值。
     * 参数 points - Array<PointData> 数据类型，points 的值。
     */
    public init (segmentLength: Int64, points: Array<PointData>)
    
    /**
     * 判断当前 BezierData 是否是 Null。
     * 
     * 返回值 Bool - 当前 BezierData 是否是 Null。
     */
    public func isNull (): Bool
}
```

#### 4.1.6 PointData 类

```cangjie
public class PointData {
    
    /**
     * 创建 PointData 实例。
     */
    public init ()
    
    /**
     * 基于参数创建 PointData 实例。
     * 
     * 参数 partialLength - Int64 数据类型。
     * 参数 point - Array<Float64> 数据类型。
     */
    public init (partialLength: Int64, point: Array<Float64>)
}
```

#### 4.1.7 Bez 类

```cangjie
public class Bez {
    
    /**
     * 判断点是否在 2D 线上。
     * 
     * 参数 x1 - Float64 数据类型，x1 的值。
     * 参数 y1 - Float64 数据类型，y1 的值。
     * 参数 x2 - Float64 数据类型，x2 的值。
     * 参数 y2 - Float64 数据类型，y2 的值。
     * 参数 x3 - Float64 数据类型，x3 的值。
     * 参数 y3 - Float64 数据类型，y3 的值。
     * 返回值 Bool - Bool 数据类型，结果值。
     */
    public static func pointOnLine2D (x1: Float64, y1: Float64, x2: Float64, y2: Float64, x3: Float64, y3: Float64): Bool
    
    /**
     * 判断点是否在 3D 线上。
     * 
     * 参数 x1 - Float64 数据类型，x1 的值。
     * 参数 y1 - Float64 数据类型，y1 的值。
     * 参数 z1 - Float64 数据类型，z1 的值。
     * 参数 x2 - Float64 数据类型，x2 的值。
     * 参数 y2 - Float64 数据类型，y2 的值。
     * 参数 z2 - Float64 数据类型，z2 的值。
     * 参数 x3 - Float64 数据类型，x3 的值。
     * 参数 y3 - Float64 数据类型，y3 的值。
     * 参数 z3 - Float64 数据类型，z3 的值。
     * 返回值 Bool - Bool 数据类型，结果值。
     */
    public static func pointOnLine3D (x1: Float64, y1: Float64, z1: Float64, x2: Float64, y2: Float64, z2: Float64, x3: Float64, y3: Float64, z3: Float64): Bool
    
    /**
     * 构建Bezier数据。
     * 
     * 返回值 (Array<Float64>,Array<Float64>,Array<Float64>,Array<Float64>)->BezierData - 函数类型。
     */
    public func buildBezierData (): (Array<Float64>,Array<Float64>,Array<Float64>,Array<Float64>)->BezierData
}
```

#### 4.1.8 DataManager 类(2024.07.25)

```cangjie
public class DataManager {
    
    /**
     * 加载动画数据。
     * 
     * 参数 path - String 数据类型，动画数据文件路径。
     * 参数 onComplete - String 数据类型，加载成功回调函数。
     * 参数 onError - String 数据类型，加载失败回调函数。
     */
    public func loadAnimation (path: String, onComplete: (AnimationData)->Unit, onError: ()->Unit)
    
    /**
     * 加载数据。
     * 
     * 参数 path - String 数据类型，动画数据文件路径。
     * 参数 onComplete - String 数据类型，加载成功回调函数。
     * 参数 onError - String 数据类型，加载失败回调函数。
     */
    public func loadData (path: String, onComplete: (AnimationData)->Unit, onError: ()->Unit)
    
    /**
     * 完成动画数据加载。
     * 
     * 参数 anim - AnimationData 数据类型，已经从json格式解析封装好的动画数据。
     * 参数 onComplete - String 数据类型，加载成功回调函数。
     * 参数 onError - String 数据类型，加载失败回调函数。
     */
    public func completeAnimation (anim: AnimationData, onComplete: (AnimationData)->Unit, onError: ()->Unit)
}
```


#### 4.1.9 OB 类(2024.07.25)

```cangjie
public class OB<T> <: ToString {
    
    /**
     * 基于参数创建OB<T>实例。
     * 
     * 参数 img - 泛型数据类型。
     * 参数 assetData - Asset 数据类型。
     */
    public init (img: T, assetData: Asset)
    
    /**
     * 返回实例的字符串表示。 
     * 
     * 返回值 String - 返回实例的字符串表示。
     */
    public func toString (): String
}
```

#### 4.1.10 ImagePreloader 类(2024.07.25)

```cangjie
public class ImagePreloader<T>  {
    
    /**
     * 创建ImagePreloader<T>实例。
     */
    public init ()
    
    /**
     * 图像已加载。
     */
    public func imageLoaded (): Unit
    
    /**
     * 录像已加载。
     */
    public func footageLoaded (): Unit
    
    /**
     * 创建图像数据。
     * 应用于SVG环境。
     * 
     * 参数 assetData - Asset 数据类型。
     * 返回值 OB<CreateNS> - OB<CreateNS> 数据类型，图像数据。
     */
    public func createImageData (assetData: Asset): OB<CreateNS>
    
    /**
     * 创建图像数据。
     * 适用于非SVG环境。
     * 
     * 参数 assetData - Asset 数据类型。
     * 返回值 OB<CreateNS> - OB<CreateNS> 数据类型，图像数据。
     */
    public func createImgData (assetData: Asset): OB<CreateNS>
    
    /**
     * 加载资源。
     * 
     * 参数 assets - Array<Asset> 数据类型。
     * 参数 cb - 函数数据类型，()->Unit。
     */
    public func loadAssets (assets: Array<Asset>, cb: ()->Unit): Unit
    
    /**
     * 设置原始路径。
     * 
     * 参数 path - String 数据类型，原始路径。
     */
    public func setPath (path: String): Unit
    
    /**
     * 设置资源路径。
     * 
     * 参数 path - String 数据类型，资源路径。
     */
    public func setAssetsPath (path: String): Unit
    
    /**
     * 获取资源。
     * 
     * 参数 assetData - Asset 数据类型。
     * 返回值 Option<T> - Option<T> 数据类型。
     */
    public func getAsset (assetData: Asset): Option<T>
    
    /**
     * 销毁 ImagePreloader。
     */
    public func destroy (): Unit
    
    /**
     * 判断图像已加载并完成。
     * 
     * 返回值 Bool - Bool 数据类型。
     */
    public func loadedImages (): Bool
    
    /**
     * 判断录像已加载并完成。
     * 
     * 返回值 Bool - Bool 数据类型。
     */
    public func loadedFootages (): Bool
    
    /**
     * 设置缓存类型。
     * 
     * 参数 types - String 数据类型。
     * 参数 elementHelper - CreateNS 数据类型。
     */
    public func setCacheType (types: String, elementHelper: CreateNS): Unit
}
```

#### 4.1.11 PolynomialBezier 类(2024.07.25)

```cangjie
public class PolynomialBezier {
    
    /**
     * 基于参数创建 PolynomialBezier 实例。
     * 
     * 参数 p0 - Array<Float64> 数据类型。
     * 参数 p1a - Array<Float64> 数据类型。
     * 参数 p2a - Array<Float64> 数据类型。
     * 参数 p3 - Array<Float64> 数据类型。
     * 参数 linearize - Bool 数据类型。
     */
    public init (p0: Array<Float64>, p1a: Array<Float64>, p2a: Array<Float64>, p3: Array<Float64>, linearize: Bool)
    
    /**
     * 获取 point。
     * 
     * 参数 t - Float64 数据类型。
     * 返回值 Array<Float64> - Array<Float64> 数据类型。
     */
    public func point (t: Float64): Array<Float64>
    
    /**
     * 获取导数。
     * 
     * 参数 t - Float64 数据类型。
     * 返回值 Array<Float64> - Array<Float64> 数据类型。
     */
    public func derivative (t: Float64): Array<Float64>
    
    /**
     * 获取切线角度。
     * 
     * 参数 t - Float64 数据类型。
     * 返回值 Float64 - Float64 数据类型。
     */
    public func tangentAngle (t: Float64): Float64
    
    /**
     * 获取正常角度。
     * 
     * 参数 t - Float64 数据类型。
     * 返回值 Float64 - Float64 数据类型。
     */
    public func normalAngle (t: Float64): Float64
    
    /**
     * 找到拐点。
     * 
     * 返回值 Array<Float64> - Array<Float64> 数据类型。
     */
    public func inflectionPoints (): Array<Float64>
    
    /**
     * 分割多项式贝塞尔曲线。
     * 
     * 参数 t - Float64 数据类型。
     * 返回值 Array<PolynomialBezier> - Array<PolynomialBezier> 数据类型。
     */
    public func split (t: Float64): Array<PolynomialBezier>
    
    /**
     * 获取界限。
     * 
     * 返回值 PointArray - PointArray 数据类型。
     */
    public func bounds (): PointArray
    
    /**
     * 获取边界框。
     * 
     * 返回值 BoundingBoxObject - BoundingBoxObject 数据类型。
     */
    public func boundingBox (): BoundingBoxObject
    
    /**
     * 获取交点。
     * 
     * 参数 other - PolynomialBezier 数据类型。
     * 参数 tolerance1 - Float64 数据类型。
     * 参数 maxRecursion1 - Int64 数据类型。
     * 返回值 ArrayList<Int64> - ArrayList<Int64> 数据类型。
     */
    public func intersections (other: PolynomialBezier, tolerance1: Float64, maxRecursion1: Int64): ArrayList<Int64>
    
    /**
     * 形状段。
     * 
     * 参数 shapePath - ShapeData 数据类型。
     * 参数 index - Int64 数据类型。
     * 返回值 PolynomialBezier - PolynomialBezier 数据类型。
     */
    public static func shapeSegment (shapePath: ShapeData, index: Int64): PolynomialBezier
    
    /**
     * 形状段倒置。
     * 
     * 参数 shapePath - ShapeData 数据类型。
     * 参数 index - Int64 数据类型。
     * 返回值 PolynomialBezier - PolynomialBezier 数据类型。
     */
    public static func shapeSegmentInverted (shapePath: ShapeData, index: Int64): PolynomialBezier
}
```

##### 4.1.11.1 floatEqual 函数(2024.07.25)

```cangjie
/**
 * 浮动相等。
 * 
 * 参数 a - Float64 数据类型。
 * 参数 b - Float64 数据类型。
 * 返回值 Bool - Bool 数据类型。
 */
public func floatEqual(a: Float64, b: Float64): Bool
```

##### 4.1.11.2 lineIntersection 函数(2024.07.25)

```cangjie
/**
 * 计算直线交点。
 * 
 * 参数 start1 - Array<Float64> 数据类型。
 * 参数 end1 - Array<Float64> 数据类型。
 * 参数 start2 - Array<Float64> 数据类型。
 * 参数 end2 - Array<Float64> 数据类型。
 * 返回值 Array<Float64> - Array<Float64> 数据类型。
 */
public func lineIntersection(start1: Array<Float64>, end1: Array<Float64>, start2: Array<Float64>, end2: Array<Float64>): Array<Float64>
```

##### 4.1.11.3 polarOffset 函数(2024.07.25)

```cangjie
/**
 * 计算极坐标偏移。
 * 
 * 参数 p - Array<Float64> 数据类型。
 * 参数 angle - Float64 数据类型。
 * 参数 length - Float64 数据类型。
 * 返回值 Array<Float64> - Array<Float64> 数据类型。
 */
public func polarOffset(p: Array<Float64>, angle: Float64, length: Float64): Array<Float64> 
```

##### 4.1.11.4 pointDistance 函数(2024.07.25)

```cangjie
/**
 * 计算点距离。
 * 
 * 参数 p1 - Array<Float64> 数据类型。
 * 参数 p2 - Array<Float64> 数据类型。
 * 返回值 Float64 - Float64 数据类型。
 */
public func pointDistance(p1: Array<Float64>, p2: Array<Float64>): Float64
```

##### 4.1.11.5 pointEqual 函数(2024.07.25)

```cangjie
/**
 * 判断点是否相等的。
 * 
 * 参数 p1 - Array<Float64> 数据类型。
 * 参数 p2 - Array<Float64> 数据类型。
 * 返回值 Bool - Bool 数据类型。
 */
public func pointEqual(p1: Array<Float64>, p2: Array<Float64>): Bool
```


#### 4.1.12 ExtremaPoint 类(2024.07.25)
```cangjie
public class ExtremaPoint {
    /**
     * 基于参数创建 ExtremaPoint 实例。
     *
     * 参数 min - Float64 数据类型，min 对应的值。
     * 参数 max - Float64 数据类型，max 对应的值。
     */
    public init (min!: Float64 = 0.0, max!: Float64 = 0.0)
}
```

#### 4.1.13 PointArray 类(2024.07.25)

```cangjie
public class PointArray {
    
    /**
     * 基于参数创建 PointArray 实例。
     * 
     * 参数 x - ExtremaPoint 数据类型.
     * 参数 y - ExtremaPoint 数据类型.
     */
    public init (x: ExtremaPoint, y: ExtremaPoint)
}
```

#### 4.1.14 BoundingBoxObject 类(2024.07.25)
```cangjie
public class BoundingBoxObject {
    /**
     * 基于参数创建 BoundingBoxObject 实例。
     *
     * 参数 left - Float64 数据类型， left 对应的值。
     * 参数 right - Float64 数据类型， right 对应的值。
     * 参数 top - Float64 数据类型， top 对应的值。
     * 参数 bottom - Float64 数据类型， bottom 对应的值。
     * 参数 width - Float64 数据类型， width 对应的值。
     * 参数 height - Float64 数据类型， height 对应的值。
     * 参数 cx - Float64 数据类型， cx 对应的值。
     * 参数 cy - Float64 数据类型， cy 对应的值。
     * 参数 bez - PolynomialBezier 数据类型, bez 对应的值。
     * 参数 t - Int64 数据类型, t 对应的值。
     * 参数 t1 - Int64 数据类型, t1 对应的值。
     * 参数 t2 - Int64 数据类型, t2 对应的值。
     */
    public init(
        left!: Float64 = 0.0, right!: Float64 = 0.0, top!: Float64 = 0.0, bottom!: Float64 = 0.0,
        width!: Float64 = 0.0, height!: Float64 = 0.0, cx!: Float64 = 0.0, cy!: Float64 = 0.0,
        bez!: PolynomialBezier = PolynomialBezier(), t!: Int64 = 0, t1!: Int64 = 0, t2!: Int64 = 0)
}
```





### 4.2 utils.helpers 包

#### 4.2.1 CreateTag 类

```cangjie
public open class CreateTag {
    
    /**
     * 基于参数创建 CreateTag 实例。 
     * 
     * 参数 types - String 数据类型。
     */
    public init (types: String)
}
```

#### 4.2.2 CreateNS 类

```cangjie
public class CreateNS<: Equatable<CreateNS> {
    
    /**
     * 基于参数创建 CreateNS 实例。 
     * 
     * 参数 types - String 数据类型。
     */
    public init (types: String)
    
    /**
     * 基于参数创建 CreateNS 实例。 
     * 
     * 参数 types - String 数据类型。
     * 参数 svg - String 数据类型。
     */
    public init (types: String, svg: String)
    
    /**
     * 设置 CreateNS 实例中属性。
     * 
     * 参数 n - String 数据类型。
     * 参数 k - String 数据类型。
     * 参数 v - String 数据类型。
     */
    public func setAttributeNS (n: String, k: String, v: String): Unit
    
    /**
     * 设置 CreateNS 实例中属性。
     * 
     * 参数 k - String 数据类型。
     * 参数 v - String 数据类型。
     */
    public func setAttribute (k: String, v: String): Unit
    
    /**
     * 将子项附加到 CreateNS 实例。
     * 
     * 参数 element - Option<CreateNS> 数据类型，将子项附加到 CreateNS 实例。
     */
    public func appendChild (element: Option<CreateNS>): Unit
    
    /**
     * 当前 CreateNS 实例的 childs 数组中，插入 newNode，在 referenceNode 之前。
     * 
     * 参数 newNode - CreateNS 数据类型，要插入到 childs 数组中的 CreateNS 实例。
     * 参数 referenceNode - CreateNS 数据类型，在 referenceNode 之前插入 newNode。
     */
    public func insertBefore (newNode: CreateNS, referenceNode: CreateNS): Unit
    
    /**
     * 检查当前 CreatNS 是否等于目标。
     * 
     * 参数 that - CreateNS 数据类型，和当前实例比较的对象。
     * 返回值 Bool - 比较结果。
     */
    public operator func == (that: CreateNS): Bool
    
    /**
     * 检查当前 CreatNS 是否不等于目标。
     * 
     * 参数 that - CreateNS 数据类型，和当前实例比较的对象。
     * 返回值 Bool - 比较结果。
     */
    public operator func != (that: CreateNS): Bool
}
```

#### 4.2.3 BlendModes 类

```cangjie
public class BlendModes {
    
    /**
     * 获取混合模式值。
     * 
     * 参数 mode - Int64 数据类型，获取混合模式的下标。
     * 返回值 String - 混合模式值。
     */
    public static func getBlendMode (mode: Int64): String
}
```


### 4.3 utils.expressions 包

#### 4.3.1 TextExpressionInterface 类

```cangjie
public class TextExpressionInterface {
    
    /**
     * 实现内部自调用函数。
     * 
     * 参数 elem - ITextElement 数据类型，文本层元素实例。
     * 返回值 ThisLayerFunctionText - TextExpressionInterface 实际封装的逻辑。
     */
    public func selfCalling (elem: ITextElement): ThisLayerFunctionText
}
```

#### 4.3.2 SourceText 类

```cangjie
public class SourceText {
    /**
     * 创建 SourceText 实例。
     */
    public init(){}
}
```

#### 4.3.3 ThisLayerFunctionText 类

```cangjie
public class ThisLayerFunctionText {

    /**
     * 实现内部自调用函数。
     * 
     * 参数 name - String 数据类型。
     * 返回值 Option<SourceText> - sourceText 值。
     */
    public func selfCalling (name: String): Option<SourceText>
    
    /**
     * 获取 ThisLayerFunctionText 的 sourceText 值。
     */
    public prop sourceText: SourceText
}
```

#### 4.3.4 LayerExpressionInterface 类

```cangjie
public class LayerExpressionInterface {
    
    /**
     * 基于参数创建一个 LayerExpressionInterface 实例。
     * 
     * 参数 elem - BaseElement 数据类型。
     */
    public init (elem: BaseElement)
    
    /**
     * 实现内部自调用函数。
     * 
     * 参数 elem - BaseElement 数据类型。
     * 返回值 ThisLayerFunction - LayerExpressionInterface 实际封装的逻辑。
     */
    public func selfCalling (elem: BaseElement): ThisLayerFunction
}
```

#### 4.3.5 ThisLayerFunction 类

```cangjie
public class ThisLayerFunction {
    
    /**
     * 基于参数创建 ThisLayerFunction 实例。
     * 
     * 参数 elem - BaseElement 数据类型。
     * 参数 layerExpression - LayerExpressionInterface 数据类型。
     */
    public init (elem: BaseElement, layerExpression: LayerExpressionInterface)
    
    /**
     * 实现内部自调用函数。
     * 
     * 参数 name - String 数据类型。
     * 参数 num - Int64 数据类型。
     * 返回值 Option<ExpressionInterface> - 对应的 ExpressionInterface 实例。
     */
    public func selfCalling (name: String, num: Int64): Option<ExpressionInterface>
    
    /**
     * 获取 BaseElement 中 Layer 的 isInRange 值。
     */
    public prop active: Bool
}
```

#### 4.3.6 MaskManagerInterface 类

```cangjie
public class MaskManagerInterface {
    
    /**
     * 基于参数创建一个 MaskManagerInterface 实例。
     * 
     * 参数 data - BaseElement 数据类型。
     */
    public init (data: BaseElement)
    
    /**
     * 基于参数创建一个 MaskManagerInterface 实例。
     * 
     * 参数 mask - ViewData 数据类型。
     * 参数 data - BaseElement 数据类型。
     */
    public init (mask: ViewData, data: BaseElement)
}
```

#### 4.3.7 CompExpressionInterface 类

```cangjie
public class CompExpressionInterface {
    
    /**
     * 实现内部自调用函数。
     * 
     * 参数 comp - ICompElement 数据类型，合成层元素实例。
     * 返回值 ThisLayerFunctionComp - CompExpressionInterface 实际封装的逻辑。
     */
    public func selfCalling (comp: ICompElement): ThisLayerFunctionComp
}
```

#### 4.3.8 ThisLayerFunctionComp 类

```cangjie
public class ThisLayerFunctionComp {
    
    /**
     * 实现内部自调用函数。
     * 
     * 参数 name - String 数据类型。
     * 返回值 Option<LayerExpressionInterface> - 对应的 LayerExpressionInterface 实例。
     */
    public func selfCalling (name: String): Option<LayerExpressionInterface>
    
    /**
     * 获取 ICompElement 中 Layer 的 nm 的值。
     */
    public prop _name: String
}
```


### 4.4 utils.shapes 包

#### 4.4.1 buildShapeString 函数

```cangjie
/**
 * 生成形状字符串。
 *
 * 参数 pathNodes - ShapeData 数据类型。
 * 参数 length - Int64 数据类型。
 * 参数 closed - Bool 数据类型。
 * 参数 mat - Matrix 数据类型。
 * 返回值 String - 转换后的字符串。
 */
public func buildShapeString(pathNodes: ShapeData, length: Int64, closed: Bool, mat: Matrix): String
```

#### 4.4.2 ShapeCollection 类(2024.07.25)

```cangjie
public class ShapeCollection {
    
    /**
     * 创建 ShapeCollection 实例。 
     */
    public init ()
    
    /**
     * 添加图形。
     * 
     * 参数 shapeData - ShapePathForShapePool 数据类型。
     */
    public func addShape (shapeData: ShapePathForShapePool): Unit
    
    /**
     * 释放图形。
     */
    public func releaseShapes (): Unit
}
```

#### 4.4.3 ShapePathForShapePool 类(2024.07.25)

```cangjie
public class ShapePathForShapePool<: ToString {
    
    /**
     * 构造 ShapePathForShapePool 实例。
     */
    public init ()
    
    /**
     * 释放。
     */
    public func release (): Unit
    
    /**
     * 设置路线数据。
     * 
     * 参数 closed - Bool 数据类型。
     * 参数 len - Int64 数据类型。
     */
    public func setPathData (closed: Bool, len: Int64): Unit
    
    /**
     * 设置长度。
     * 
     * 参数 len - Int64 数据类型。
     */
    public func setLength (len: Int64): Unit
    
    /**
     * 在指定位置pos设置x和y的值。
     * 
     * 参数 x - Float64 数据类型，x 的值。
     * 参数 y - Float64 数据类型，y 的值。
     * 参数 types - String 数据类型,为名称是types的变量的指定下标设置x和y的值。
     * 参数 pos - Int64 数据类型，为名称是types的变量的下标pos设置x和y的值。
     * 参数 replace - Bool 数据类型，是否生成新元素进行替换。
     */
    public func setXYAt (x: Float64, y: Float64, types: String, pos: Int64, replace: Bool): Unit
    
    /**
     * 在指定位置pos设置x和y的值。
     * 
     * 参数 vX - Float64 数据类型，设置 v 中的下标 pos 处 x 的值。
     * 参数 vY - Float64 数据类型，设置 v 中的下标 pos 处 y 的值。
     * 参数 oX - Float64 数据类型，设置 o 中的下标 pos 处 x 的值。
     * 参数 oY - Float64 数据类型，设置 o 中的下标 pos 处 y 的值。
     * 参数 iX - Float64 数据类型，设置 i 中的下标 pos 处 x 的值。
     * 参数 iY - Float64 数据类型，设置 i 中的下标 pos 处 y 的值。
     * 参数 pos - Int64 数据类型，设置下标 pos 处 x 和 y 的值。
     * 参数 replace - Bool 数据类型，是否生成新元素进行替换。
     */
    public func setTripleAt (vX: Float64, vY: Float64, oX: Float64, oY: Float64, iX: Float64, iY: Float64, pos: Int64, replace: Bool): Unit
    
    /**
     * 反转
     * 
     * 返回值 ShapePathForShapePool - ShapePathForShapePool 数据类型。
     */
    public func reverse (): ShapePathForShapePool
    
    /**
     * 从当前 ShapePathForShapePool 获取长度值。
     * 
     * 返回值 Int64 - Int64 数据类型。
     */
    public func length (): Int64
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```


### 4.5 utils.text 包

#### 4.5.1 TextProperty 类

```cangjie
public class TextProperty {
    
    /**
     * 基于参数创建一个TextProperty实例。
     *
     * 参数 globalData - GlobalData 数据类型，封装globalData数据的实例。
     * 参数 data - LayerT 数据类型，封装动画的“layers.t”数据的实例。
     */
    public TextProperty(globalData: GlobalData, data: LayerT)
    
    /**
     * 复制数据。
     * 
     * 参数 obj - DocumentData 数据类型，复制数据到此实例。
     * 参数 data - Option<DocumentData> 数据类型，要复制的数据。
     * 返回值 DocumentData - DocumentData 数据类型，返回复制后的数据。
     */
    public func copyData (obj: DocumentData, data: Option<DocumentData>): DocumentData
    
    /**
     * 设置当前数据。
     * 
     * 参数 data - Option<DocumentData> 数据类型，文本数据。
     */
    public func setCurrentData (data: DocumentData): Unit
    
    /**
     * 搜索属性
     * 
     * 返回值 Bool - Option<DocumentData> 数据类型，文本数据。
     */
    public func searchProperty (): Bool
    
    /**
     * 搜索关键帧。
     * 
     * 返回值 Bool - Bool 数据类型。
     */
    public func searchKeyframes (): Bool
    
    /**
     * 添加效果。
     * 
     * 参数 effectFunction - (DocumentData, String) -> DocumentData 函数数据类型。
     */
    public func addEffect (effectFunction: (DocumentData, String) -> DocumentData)
    
    /**
     * 获取数据。
     */
    public func getValue (): Unit
    
    /**
     * 获取文本数据。
     * 
     * 参数 finalValue - Option<DocumentData> 数据类型，文本数据。
     */
    public func getValue (finalValue: Option<DocumentData>): Unit
    
    /**
     * 获取关键帧值。
     * 
     * 参数 data - DocumentData 数据类型，文本数据。
     * 参数 t - String 数据类型。
     * 返回值 DocumentData - DocumentData 数据类型，关键帧值。
     */
    public func getKeyframeValue (data: DocumentData, t: String): DocumentData
    
    /**
     * 生成最终文本。
     * 
     * 参数 text - String 数据类型。
     * 返回值 ArrayList<String> - ArrayList<String> 数据类型。
     */
    public func buildFinalText (text: String): ArrayList<String>
    
    /**
     * 完整的文本数据。
     * 
     * 参数 documentData - DocumentData 数据类型，文本数据。
     */
    public func completeTextData (documentData: DocumentData)
    
    /**
     * 更新文档数据
     * 
     * 参数 newData - Option<DocumentData> 数据类型，新的文档数据。
     * 参数 indexs - Option<Int64> 数据类型。
     */
    public func updateDocumentData (newData: Option<DocumentData>, indexs: Option<Int64>): Unit
    
    /**
     * 重新计算
     * 
     * 参数 index - Int64 数据类型。
     */
    public func recalculate (index: Int64): Unit
    
    /**
     * 可以调整字体大小
     * 
     * 参数 canResize - Bool 数据类型，设置是否可以调整字体大小。
     */
    public func canResizeFont (canResize: Bool): Unit
    
    /**
     * 设置最小字体大小
     * 
     * 参数 fontValue - Option<Float64> 数据类型，要设置最小字体大小。
     */
    public func setMinimumFontSize (fontValue: Option<Float64>): Unit
}
```

#### 4.5.2 LetterProps 类

```cangjie
public class LetterProps {
    
    /**
     * 创建LetterProps实例。
     */
    public init ()
    
    /**
     * 基于参数创建LetterProps实例。
     * 
     * 参数 o - Int64 数据类型。
     * 参数 sw - Int64 数据类型。
     * 参数 sc - String 数据类型。
     * 参数 fc - String 数据类型。
     * 参数 m - String 数据类型。
     * 参数 p - Array<Float64> 数据类型。
     */
    public init (o: Int64, sw: Int64, sc: String, fc: String, m: String, p: Array<Float64>)
    
    /**
     * Update the LetterProps instance.
     *
     * 参数 o - Int64 数据类型。
     * 参数 sw - Int64 数据类型。
     * 参数 sc - String 数据类型。
     * 参数 fc - String 数据类型。
     * 参数 m - String 数据类型。
     * 参数 p - Array<Float64> 数据类型。
     * 返回值 Bool - 更新LetterProps实例的结果。
     */
    public func update(o: Int64, sw: Int64, sc: String, fc: String, m: String, p: Array<Float64>): Bool
}
```

### 4.6 utils.markers 包(2024.07.25)

#### 4.6.1 markerParser 函数(2024.07.25)

```cangjie
/**
 * 标记解析器。
 *
 * 参数 _markers - Array<Marker> 数据类型，蒙层集合。
 * 返回值 Array<MarkerData> - 标记处理 _markers 数据。
 */
public func markerParser(_markers: Array<Marker>): Array<MarkerData>
```


### 4.7 utils.pooling 包(2024.07.25)

#### 4.7.1 BezierLengthElement 类(2024.07.25)

```cangjie
public open class BezierLengthElement<: ToString {
    
    /**
     * 基于参数创建 BezierLengthElement 实例。
     * 
     * 参数 addedLength - Int64 数据类型。
     * 参数 percents - Array<Float64> 数据类型。
     * 参数 lengths - Array<Float64> 数据类型。
     */
    public init (addedLength: Int64, percents: Array<Float64>, lengths: Array<Float64>)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

#### 4.7.2 PoolFactory 类(2024.07.25)

```cangjie
public class PoolFactory<T>  {
    
    /**
     * 根据参数创建 PoolFactory<T> 实例。
     * 
     * 参数 initialLength - Int64 数据类型。
     * 参数 _create - ()->T 函数数据类型。
     * 参数 _release - Option<(T)->Unit> 数据类型。
     */
    public init (initialLength: Int64, _create: ()->T, _release: Option<(T)->Unit>)
    
    /**
     * 创建一个新元素。
     * 
     * 返回值 T - 泛型数据类型。
     */
    public func newElement(): T
    
    /*
     * 释放元素 element。
     * 
     * 参数 element - 泛型数据类型，释放此 element。
     */
    public func release(element: T): Unit
}
```

#### 4.7.3 SegmentsLengthElement 类(2024.07.25)

```cangjie
public open class SegmentsLengthElement<: ToString {
    
    /**
     * 基于参数创建 SegmentsLengthElement 实例。
     * 
     * 参数 lengths - Array<BezierLengthElement> 数据类型。
     * 参数 totalLength - Int64 数据类型。
     */
    public init (lengths: Array<BezierLengthElement>, totalLength: Int64)
    
    /**
     * 将实例转换为字符串并返回。
     * 
     * 返回值 String - 转换后的字符串。
     */
    public func toString (): String
}
```

#### 4.7.4 shapeCollectionPool 类(2024.07.25)

```cangjie
public class shapeCollectionPool {
    
    /**
     * 创建一个新的 ShapeCollection 实例。
     * 
     * 返回值 ShapeCollection - 创建的新的 ShapeCollection 实例。
     */
    public func newShapeCollection (): ShapeCollection
    
    /**
     * 释放实例
     * 
     * 参数 shapeCollection - ShapeCollection 数据类型，释放该实例。
     */
    public func release (shapeCollection: ShapeCollection): Unit
}
```



## 5. third_party 包

### 5.1 BezierEasing 类

```cangjie
public class BezierEasing {
    
    /**
     * 通过 bezier 宽松获得的值。
     * 
     * 参数 x - Float64 数据类型。
     * 返回值 Float64 - 通过 bezier 宽松获得的值。
     */
    public func getOfBezierEasing (x: Float64): Float64
}
```

### 5.2 BezierFactory 类

```cangjie
public class BezierFactory {
    
    /**
     * 基于参数获取 BezierEasing 实例。
     * 
     * 参数 a - Float64 数据类型。
     * 参数 b - Float64 数据类型。
     * 参数 c - Float64 数据类型。
     * 参数 d - Float64 数据类型。
     * 参数 nm - String 数据类型。
     * 返回值 BezierEasing - BezierEasing 实例。
     */
    public func getBezierEasing (a: Float64, b: Float64, c: Float64, d: Float64, nm: String): BezierEasing
}
```


