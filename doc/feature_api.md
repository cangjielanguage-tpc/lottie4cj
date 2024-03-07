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
    public init (w: Int64, h: Int64, ip: Float64, op: Float64, fr: Float64, v: String, 
        layers: Array<Layer>, assets: Array<Asset>, fonts: Fonts, chars: Array<FontCharacter>, 
        markers: Array<Marker>, nm: String, ddd: Int64)
   
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
    public init (id: String, layers: Array<Layer>, w: Int64, h: Int64, p: String, u: String)

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
    public init (list: Array<Font>)

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
    public init (fFamily: String, fName: String, fStyle: String, ascent: Float64)
    
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
    public init (shapes: Array<ContentModel>)

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
    public init (data: CharsData, ch: String, size: Float64, w: Float64, style: String, fFamily: String)
    
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
    public init (cm: String, tm: Float64, dr: Float64)
    
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
    public init (nm: String, ind: Int64, refId: String, ty: Int64, parent: Int64, sw: Int64, sh: Int64, sc: String, ks: AnimatableTransform, tt: Int64, masksProperties: Array<Mask>, shapes: Array<ContentModel>, t: LayerT, ef: Array<LayerEF>, sr: Float64, st: Float64, w: Float64, h: Float64, ip: Float64, op: Float64, tm: ContentModelDK, cl: String, hd: Bool, ao: Int64, bm: Int64)

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
    public init (a: Array<Keyframe<PointF>>, p: AnimatableSplitDimensionPathValue, s: Array<Keyframe<Array<Float64>>>, 
        r: ArrayKeyframeFloat64, o: Array<Keyframe<Int64>>, so: Array<Keyframe<Float64>>, 
        eo: Array<Keyframe<Float64>>, sk: Array<Keyframe<Float64>>, sa: Array<Keyframe<Float64>>, ty: String)


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
    public init (cl: Bool, inv: Bool, mode: String, pt: Array<Keyframe<ShapeData>>, o: Array<Keyframe<Int64>>, x: Array<Keyframe<Int64>>, nm: String)

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
    public init (ty: Int64, nm: String, v: ContentModelPK, isNull: Bool)
    
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
    public init (k: Array<Keyframe<DocumentData>>)

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
    public init (d: LayerTD, a: Array<AnimatableTextPropertiesA>)

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
    public init (ty: Int64, nm: String, ef: Array<Effect>)

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
    public init (nm: String, p: AnimatableSplitDimensionPathValue, s: Array<Keyframe<PointF>>, hd: Bool, d: Int64)

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
    public init (nm: String, g: ContentModelP, o: Array<Keyframe<Int64>>, t: Int64, s: Array<Keyframe<PointF>>, 
            e: Array<Keyframe<PointF>>, r: Int64, hd: Bool)

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
    public init (nm: String, g: ContentModelP, o: Array<Keyframe<Int64>>, t: Int64, s: Array<Keyframe<PointF>>, 
        e: Array<Keyframe<PointF>>, w: Array<Keyframe<Float64>>, lc: Int64, lj: Int64, ml: Float64, 
        hd: Bool, d: Array<ContentModelD>)

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
    public init (nm: String, mm: Int64, hd: Bool)

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
    public init (nm: String, sy: Int64, pt: Array<Keyframe<Float64>>, p: AnimatableSplitDimensionPathValue, 
        r: Array<Keyframe<Float64>>, or: Array<Keyframe<Float64>>, os: Array<Keyframe<Float64>>, 
        ir: Array<Keyframe<Float64>>, is2: Array<Keyframe<Float64>>, hd: Bool, d: Int64)

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
    public init (nm: String, p: AnimatableSplitDimensionPathValue, s: Array<Keyframe<PointF>>, 
        r: Array<Keyframe<Float64>>, hd: Bool)

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
    public init (nm: String, c: Array<Keyframe<Float64>>, o: Array<Keyframe<Float64>>, tr: AnimatableTransform, hd: Bool)

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
    public init (nm: String, r: Array<Keyframe<Float64>>, hd: Bool)

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
    public init (nm: String, c: Array<Keyframe<Array<Float64>>>, o: Array<Keyframe<Int64>>, 
            fillEnabled: Bool, r: Int64, hd: Bool)

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
    public init (nm: String, it: Array<ContentModel>, hd: Bool)

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
    public init (nm: String, ind: Int64, ks: Array<Keyframe<ShapeData>>, hd: Bool)

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
    public init (nm: String, c: Array<Keyframe<Array<Float64>>>, w: Array<Keyframe<Float64>>, 
            o: Array<Keyframe<Int64>>, lc: Int64, lj: Int64, ml: Float64, hd: Bool, d: Array<ContentModelD>)

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
    public init (s: Array<Keyframe<Float64>>, e: Array<Keyframe<Float64>>, o: Array<Keyframe<Float64>>, 
            nm: String, m: Int64, hd: Bool)

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
    public init (k: Array<Keyframe<PointF>>, x: Array<Keyframe<Float64>>, y: Array<Keyframe<Float64>>)
    
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
    public init (a: AnimatableTextProperties)
    
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
    public init (fc: ArrayKeyframeArrayFloat64, sc: Array<Keyframe<Array<Float64>>>, sw: Array<Keyframe<Float64>>, t: ArrayKeyframeFloat64)

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
    public init (k: Array<Keyframe<Array<Float64>>>)

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
    public init (k: Array<Keyframe<Float64>>)

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
    public init (p: Int64, k: Array<Keyframe<Array<Float64>>>)

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
    public init (k: Array<Keyframe<Array<Float64>>>)

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
    public init (n: String, v: ContentModelDK)
    
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
    public init (k: Array<Keyframe<Float64>>)

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
    public init (a: Int64, r: Int64, g: Int64, b: Int64)
    
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
    public init (t: String, f: String, s: Float64, j: Int64, tr: Int64, lh: Float64, ls: Float64, fc: Array<Float64>, sc: Array<Float64>, sw: Float64, of: Bool, ps: PointF, sz: PointF)

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
public class Keyframe<T>  <: ToString {

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
    public init (k: Option<T>, t: Float64, s: Option<T>, e: Option<T>, o: PointF, i: PointF, 
            h: Int64, to: PointF, ti: PointF)
    
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
    public init (x: Float64, y: Float64)
    
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
    public init (c: Bool, v: Array<PointF>, i: Array<PointF>, o: Array<PointF>)

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

from std import fs.*
from std import sync.*

from lottie4cj import parser.*
from lottie4cj import model.*

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
