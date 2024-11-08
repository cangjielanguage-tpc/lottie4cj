/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

/**
 * @file This file is BaseElement.
 */
package lottie.utils


class Processes {
    var onComplete: (AnimationData) -> Unit
    var onError: () -> Unit
    init(onComplete: (AnimationData) -> Unit, onError: () -> Unit) {
        this.onComplete = onComplete
        this.onError = onError
    }
}

//TODO: 暂时定名为Data，后续根据情况调整
class Data <: ToString {
    //TODO: type 是关键字，此成员变量改为 types
    var types: String

    //TODO：CanvasRenderingContext2D 是仓颉UI中的画布组件，暂时不联合编译
    //var context2D: CanvasRenderingContext2D
    var animation: AnimationData
    
    var path: String
    var fullPath: String
    var id: String
    var status: String
    
    init(types!: String = "", 
        //context2D!: CanvasRenderingContext2D,
        animation!: AnimationData = AnimationData(),
        path!: String = "", fullPath!: String = "", id!: String = "", status!: String = ""
    ) {
        this.types = types
        //this.context2D = context2D
        this.animation = animation
        this.path = path
        this.fullPath = fullPath
        this.id = id
        this.status = status
    }

    public func toString(): String {
        return "types = ${types}\n" +
                "path = ${path}\n" +
                "fullPath = ${fullPath}\n" +
                "id = ${id}\n" +
                "status = ${status}"
    }
}

func default_Data_To_Unit(data: Data): Unit {}
func default_Data_To_AnimationData(data: Data): Unit { return () }

func checkVersion(minimum: Array<Int64>, animVersionString: String): Bool {
    //var animVersion = animVersionString ? animVersionString.split('.') : [100, 100, 100]
    
    var animVersion: Array<Int64> = [100, 100, 100]
    let lines: Array<String> = animVersionString.split(".", removeEmpty: true)
    if (lines.size >= 3) {
        animVersion[0] = Int64.parse(lines[0])
        animVersion[1] = Int64.parse(lines[1])
        animVersion[2] = Int64.parse(lines[2])
    }
    
    if (minimum[0] > animVersion[0]) {
        return true
    } else if (animVersion[0] > minimum[0]) {
        return false
    }
    if (minimum[1] > animVersion[1]) {
        return true
    } else if (animVersion[1] > minimum[1]) {
        return false
    }
    if (minimum[2] > animVersion[2]) {
        return true
    } else if (animVersion[2] > minimum[2]) {
        return false
    }
    //后续使用都是 if(checkVersion(minimum, animVersionString)), 在 if 判断中，if(null) = if(false)，故返回 false
    return false
}

//class checkText {
func checkText(animationData: AnimationData): Unit {
    var minimumVersion: Array<Int64> = [4, 4, 14]

    func updateTextLayer(textLayer: Layer): Unit {
        /**
         * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
         * 而在 cj 中: 
         * 2. layer.t.d.k[{s: documentData, t: 0}] 中 k 如果是数组，解析后 LayerT.LayerTD.k(Array<Keyframe<DocumentData>>) 数组中有一个/多个 Keyframe<ShapeData>，解析的结果在 Keyframe 中
         * 备注：见用例 test_layer_04.cj
         * 备注：cj 处理后的数据结构也基本和 json 一致。故本函数不做任何处理！
         * 备注：只处理 layer.t.d.k[0] 中 t != 0.0的情况。
         */
        let layerTD: LayerTD = textLayer.t.d
        if (layerTD.k.size == 1 && layerTD.k[0].t != 0.0) {
            layerTD.k[0].t = 0.0
        }
    }

    func iterateLayers(layers: Array<Layer>): Unit {
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ty == 5) {
                updateTextLayer(layers[i])
            }
        }
    }

    //不调用 checkText，不执行 return func (animationData) 中的逻辑
    //return func (animationData: AnimationData): Unit {
        if (checkVersion(minimumVersion, animationData.v)) {
            iterateLayers(animationData.layers)
            if (animationData.assets.size > 0) {
                let len: Int64 = animationData.assets.size
                for (i in 0..len) {
                    if (animationData.assets[i].layers.size > 0) {
                        iterateLayers(animationData.assets[i].layers)
                    }
                }
            }
        }
    //}
}

//class checkChars {
func checkChars(animationData: AnimationData, completeShapes: (Array<ContentModel>) -> Unit): Unit {
    var minimumVersion: Array<Int64> = [4, 7, 99]

    //不调用 checkChars，不执行 return func (animationData) 中的逻辑
    //return func (animationData: AnimationData): Unit {
        let chars: Array<FontCharacter> = animationData.chars
        if (chars.size > 0 && !checkVersion(minimumVersion, animationData.v)) {
            let len: Int64 = chars.size
            for (i in 0..len) {
                let charData: FontCharacter = chars[i]
                if (charData.data.shapes.size > 0) {
                    //TODO： 调用 DataManager.completeShapes-------------------------------------------------2024.07.04
                    completeShapes(charData.data.shapes)
                    charData.data.ip = 0
                    charData.data.op = 99999
                    charData.data.st = 0
                    charData.data.sr = 1
                    let arrayKeyframePoint: Array<Keyframe<PointF>> = [Keyframe<PointF>(k: PointF())]
                    charData.data.ks = AnimatableTransform(
                      a: ArrayKeyframePointF(k: arrayKeyframePoint),
                      p: AnimatableSplitDimensionPathValue(k: arrayKeyframePoint),
                      s: ArrayKeyframeArrayFloat64(k: [Keyframe<Array<Float64>>(k: [100.0, 100.0])]),
                      r: ArrayKeyframeFloat64(k: [Keyframe<Float64>(k: 0.0)]),
                      o: ArrayKeyframeInt64(k: [Keyframe<Int64>(k: 100)])
                    )
                    //TODO: 在 json 中找不到 chars[i].t------------------------------------------------------2024.07.04
                    //if (!chars[i].t) {
                    //    charData.data.shapes.push(
                    //      {
                    //        ty: 'no',
                    //      }
                    //    )
                    //    charData.data.shapes[0].it.push(
                    //      {
                    //        p: { k: [0, 0], a: 0 },
                    //        s: { k: [100, 100], a: 0 },
                    //        a: { k: [0, 0], a: 0 },
                    //        r: { k: 0, a: 0 },
                    //        o: { k: 100, a: 0 },
                    //        sk: { k: 0, a: 0 },
                    //        sa: { k: 0, a: 0 },
                    //        ty: 'tr',
                    //      }
                    //    )
                    //}
                }
            }
        }
    //}
}

//TODO: 在 json 中找不到 layers[i].t.p,此步执行无意义！--4------------------------------------------------------2024.07.04
/*
class checkPathProperties {
    var minimumVersion: Array<Int64> = [5, 7, 15]

    //TODO: 在 json 中找不到 layers[i].t.p--3-----------------------------------------------------------------2024.07.04
    //func updateTextLayer(textLayer: Layer): Unit {
    //  var pathData = textLayer.t.p
    //  if (typeof pathData.a === 'number') {
    //    pathData.a = {
    //      a: 0,
    //      k: pathData.a,
    //    }
    //  }
    //  if (typeof pathData.p === 'number') {
    //    pathData.p = {
    //      a: 0,
    //      k: pathData.p,
    //    }
    //  }
    //  if (typeof pathData.r === 'number') {
    //    pathData.r = {
    //      a: 0,
    //      k: pathData.r,
    //    }
    //  }
    //}

    func iterateLayers(layers: Array<Layer>): Unit {
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ty == 5) {
                //TODO: 在 json 中找不到 layers[i].t.p,此步执行无异议！--2---------------------------------------2024.07.04
                updateTextLayer(layers[i])
            }
        }
    }

    //不调用 checkPathProperties，不执行 return func (animationData) 中的逻辑
    return func (animationData: AnimationData) {
        //TODO：调用 DataManager.checkVersion----------------------------------------------------------------2024.07.04
        if (checkVersion(minimumVersion, animationData.v)) {
            //TODO: 在 json 中找不到 layers[i].t.p,此步执行无异议！--1-------------------------------------------2024.07.04
            iterateLayers(animationData.layers)
            if (animationData.assets.size > 0) {
                let len: Int64 = animationData.assets.size
                for (i in 0..len) {
                    if (animationData.assets[i].layers.size > 0) {
                        //TODO: 在 json 中找不到 layers[i].t.p,此步执行无异议！--1-------------------------------2024.07.04
                        iterateLayers(animationData.assets[i].layers)
                    }
                }
            }
        }
    }
}
*/

//class checkColors {
func checkColors(animationData: AnimationData): Unit {
    var minimumVersion: Array<Int64> = [4, 1, 9]

    func iterateShapes(shapes: Array<ContentModel>): Unit {
        let len: Int64 = shapes.size
        var jLen: Int64 = 0
        for (i in 0..len) {
            if (shapes[i].ty == "gr") {
                iterateShapes((shapes[i] as ShapeGroup).getOrThrow().it)
            } else if (shapes[i].ty == "fl" || shapes[i].ty == "st") {
                /**
                 * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
                 * 而在 cj 中:
                 * 1. shapes[i].{"ty": "fl"}.c.k 如果是对象，解析后 ShapeFill.c(Array<Keyframe<Array<Float64>>>) 数组中只有一个 Keyframe<Array<Float64>>，解析的结果在 Keyframe.k 中
                 * 2. shapes[i].{"ty": "fl"}.c.k 如果是数组，解析后 ShapeFill.c(Array<Keyframe<Array<Float64>>>) 数组中有多个 Keyframe<Array<Float64>>，解析的结果在 Keyframe.(t/s/o/i) 中
                 * 备注：见用例 test_shapes_08.cj
                 */
                //TODO: 是否将 ShapeFill/ShapeStroke 的 c 重新封装一下？？？
                
                //TODO: (ty == "fl"/"st")-将再次加工处理的数据 c_k，储存到 ShapeFill/ShapeStroke.c 中。
                var c: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
                var c_k: Array<Keyframe<Array<Float64>>> = Array<Keyframe<Array<Float64>>>()
                if (shapes[i].ty == "fl") {
                    //TODO: 【已确认，c和c_k互不影响】-注意已经取出来并转换后的对象，修改 c_k 后，原数组中 shapes[i].c_k 值变了么？？？
                    let shape: ShapeFill = (shapes[i] as ShapeFill).getOrThrow()
                    c = shape.c
                    c_k = Array<Keyframe<Array<Float64>>>(c.size, item: Keyframe<Array<Float64>>())
                    shape.c = c_k
                } else if (shapes[i].ty == "st") {
                    //TODO: 【已确认，c和c_k互不影响】注意已经取出来并转换后的对象，修改 c_k 后，原数组中 shapes[i].c_k 值变了么？？？
                    let shape: ShapeStroke = (shapes[i] as ShapeStroke).getOrThrow()
                    c = shape.c
                    c_k = Array<Keyframe<Array<Float64>>>(c.size, item: Keyframe<Array<Float64>>())
                    shape.c = c_k
                }
                
                if (c.size > 1) { // json 中 k 是一个数组 => 数据保存在 ShapeFill/ShapeStroke.c[i](Keyframe<Array<Float64>>).k [外]
                    jLen = c.size
                    for (j in 0..jLen) {
                        let keyframe: Keyframe<Array<Float64>> = Keyframe<Array<Float64>>()
                        //keyframe.kIsArray = true
                        if (let Some(v) <- c[j].s) {
                            let s: Array<Float64> = Array<Float64>(4, item: 0.0)
                            s[0] = v[0] / 255.0
                            s[1] = v[1] / 255.0
                            s[2] = v[2] / 255.0
                            s[3] = v[3] / 255.0
                            keyframe.s = s
                        }
                        if (let Some(v) <- c[j].e) {
                            let e: Array<Float64> = Array<Float64>(4, item: 0.0)
                            e[0] = v[0] / 255.0
                            e[1] = v[1] / 255.0
                            e[2] = v[2] / 255.0
                            e[3] = v[3] / 255.0
                            keyframe.e = e
                        }
                        c_k[j] = keyframe
                    }
                } else if (c.size == 1) { // json 中 k 是一个对象 => 数据保存在 ShapeFill/ShapeStroke.c[i](Keyframe<Array<Float64>>).k [中]
                    let keyframe: Keyframe<Array<Float64>> = Keyframe<Array<Float64>>()
                    //keyframe.kIsArray = false
                    if (let Some(v) <- c[0].k) {
                        let k: Array<Float64> = Array<Float64>(4, item: 0.0)
                        k[0] = v[0] / 255.0
                        k[1] = v[1] / 255.0
                        k[2] = v[2] / 255.0
                        k[3] = v[3] / 255.0
                        keyframe.k = k
                    }
                    c_k[0] = keyframe
                }
            }
        }
    }

    func iterateLayers(layers: Array<Layer>): Unit {
        let len: Int64 = layers.size
        for (i in 0..len) {
            if (layers[i].ty == 4) {
                iterateShapes(layers[i].shapes)
            }
        }
    }

    //不调用 checkColors，不执行 return func (animationData) 中的逻辑
    //return func (animationData: AnimationData): Unit {
        if (checkVersion(minimumVersion, animationData.v)) {
            iterateLayers(animationData.layers)
            if (animationData.assets.size > 0) {
                let len: Int64 = animationData.assets.size
                for (i in 0..len) {
                    if (animationData.assets[i].layers.size > 0) {
                        iterateLayers(animationData.assets[i].layers)
                    }
                }
            }
        }
    //}
}

//class checkShapes {
func checkShapes(animationData: AnimationData, completeShapes: (Array<ContentModel>) -> Unit, convertPathsToAbsoluteValues: (ShapeData) -> Unit): Unit {
    var minimumVersion: Array<Int64> = [4, 4, 18]

    func completeClosingShapes(arr: Array<ContentModel>): Unit {
        let len: Int64 = arr.size
        var jLen: Int64 = 0
        var shape: ContentModel = ContentModel()
        for (i in (len - 1)..=0:-1) {
            shape = arr[i]
            if (shape.ty == "sh") {
                let sh: ShapePath = (shape as ShapePath).getOrThrow()
                /**
                 * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
                 * 而在 cj 中:
                 * 1. "shapes".{"ty": "sh"}.ks.k 如果是对象，解析后 ShapePath.ks(Array<Keyframe<ShapeData>>) 数组中只有一个 Keyframe<ShapeData>，解析的结果在 Keyframe.k 中
                 * 2. "shapes".{"ty": "sh"}.ks.k 如果是数组，解析后 ShapePath.ks(Array<Keyframe<ShapeData>>) 数组中有多个 Keyframe<ShapeData>，解析的结果在 Keyframe 中
                 * 备注：见用例 test_shapes_07.cj
                 */
                if (sh.ks.size == 1) { // k 是一个对象
                    if (let Some(v) <- sh.ks[0].k) { //"k"
                        v.c = sh.closed
                    }
                } else if (sh.ks.size > 1) { // json 中 k 是一个数组
                    jLen = sh.ks.size
                    for (j in 0..jLen) {
                        if (let Some(v) <- sh.ks[j].s) {
                            //convertPathsToAbsoluteValues(v)
                            v.c = sh.closed
                        }
                        if (let Some(v) <- sh.ks[j].e) {
                            //convertPathsToAbsoluteValues(v)
                            v.c = sh.closed
                        }
                    }
                }
            } else if (shape.ty == "gr") {
                completeClosingShapes((shape as ShapeGroup).getOrThrow().it)
            }
        }
    }

    func iterateLayers(layers: Array<Layer>): Unit {
        var layerData: Layer = Layer()
        let len: Int64 = layers.size
        var jLen: Int64 = 0
        var kLen: Int64 = 0
        for (i in 0..len) {
            layerData = layers[i]
            if (layerData.hasMask) {
                let maskProps: Array<Mask> = layerData.masksProperties
                jLen = maskProps.size
                var mask: Mask = Mask()
                for (j in 0..jLen) {
                    /**
                     * cj 和 arkts 不同的是，arkts 拿到的数据结构和 json 完全一致。
                     * 而在 cj 中:
                     * 1. masksProperties.pt.k 如果是对象，解析后 masksProperties.pt(Array<Keyframe<ShapeData>>) 数组中只有一个 Keyframe<ShapeData>，解析的结果在 Keyframe.k 中
                     * 2. masksProperties.pt.k 如果是数组，解析后 masksProperties.pt(Array<Keyframe<ShapeData>>)  数组中有多个 Keyframe<ShapeData>，解析的结果在 Keyframe 中
                     * 备注：见用例 test_layer_03.cj
                     */
                    mask = maskProps[j]
                    if (mask.pt.size == 1) { // json 中 k 是一个对象 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [中] 
                        if (let Some(v) <- mask.pt[0].k) { //"k"
                            //TODO: 【已确认，值正常被修改】-注意已经取出来并转换后的对象，修改 c 后，原数组中 ShapeData.c 值变了么？？？  -- 【已确认，值正常被修改】
                            v.c = mask.cl
                        }
                    } else if (mask.pt.size > 1) { // json 中 k 是一个数组 => 数据保存在 Mask.pt[i](Keyframe<Array<Float64>>).k [外]
                        kLen = mask.pt.size
                        for (k in 0..kLen) {
                            if (let Some(v) <- mask.pt[k].s) {
                                //TODO: 【已确认，值正常被修改】-注意已经取出来并转换后的对象，修改 c 后，原数组中 ShapeData.c 值变了么？？？  -- 【已确认，值正常被修改】
                                v.c = mask.cl
                            }
                            if (let Some(v) <- mask.pt[k].e) {
                                //TODO:【已确认，值正常被修改】-注意已经取出来并转换后的对象，修改 c 后，原数组中 ShapeData.c 值变了么？？？  -- 【已确认，值正常被修改】
                                v.c = mask.cl
                            }
                        }
                    }
                }
            }
            if (layerData.ty == 4) {
                completeClosingShapes(layerData.shapes)
            }
        }
    }

    //不调用 checkShapes，不执行 return func (animationData) 中的逻辑
    //return func (animationData: AnimationData): Unit {
        if (checkVersion(minimumVersion, animationData.v)) {
            iterateLayers(animationData.layers)
            if (animationData.assets.size > 0) {
                let len: Int64 = animationData.assets.size
                for (i in 0..len) {
                    if (animationData.assets[i].layers.size > 0) {
                        iterateLayers(animationData.assets[i].layers)
                    }
                }
            }
        }
    //}
}

