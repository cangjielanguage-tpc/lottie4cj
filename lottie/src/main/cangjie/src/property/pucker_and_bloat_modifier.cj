/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */

//package lottie.utils.shapes
package lottie.property

public class PuckerAndBloatModifier <: ShapeModifier { 
    //TODO：拆分多继承问题 -- extendPrototype([ShapeModifier], PuckerAndBloatModifier)

    //"a": {"a": 0, "k": 0, "ix": 7} => 走【分支1】
    var amount: PropertyFactory<AK, Float64>
    var lineJoin: Int64 = 0

    public init(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer, dynamicProperties!: ArrayList<DynamicPropertyContainer>){
        super(data, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        
        let dp: DynamicPropertyContainer = DynamicPropertyContainer(elemGlobalData, elemData, dynamicProperties: this.dynamicProperties)
        this.amount = PropertyFactory<AK, Float64>(AK(), 0.0, dp, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
    }
    
    public func getValue(): Unit {
        this.processKeys()
    }
    
    public func initModifierProperties(data: ContentModel, elemGlobalData: GlobalData, elemData: Layer) {
        //TODO: 调用父级 ShapeModifier.init 时，会触发调用 this.initModifierProperties。也就是初始化会执行 this.getValue = this.processKeys

        /*
         * 只在 GradientStroke-"gs"/GradientFill-"gf" 中找到成员变量 a（已新增） 
         * "a": {"a": 0, "k": 0, "ix": 7} => 走【分支1】
         */
        if (data.ty == "gf") {
            let gf: GradientFill = (data as GradientFill).getOrThrow()
            //TODO: 传入的 tr.a 必须存在，否则代码运行异常。
            this.amount = PropertyFactory<AK, Float64>.getProp(gf.a, Float64(gf.a.k), 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        } else if (data.ty == "gs") {
            let gs: GradientStroke = (data as GradientStroke).getOrThrow()
            this.amount = PropertyFactory<AK, Float64>.getProp(gs.a, Float64(gs.a.k), 0.0, this, elemGlobalData, elemData, dynamicProperties: dynamicProperties)
        }

        this._isAnimated = this.amount.effectsSequence.size != 0
    }
    
    public func processPath(path: ShapeData, amount: Float64): ShapeData {
        var percent: Float64 = amount / 100.0
        var centerPoint: Array<Float64> = [0.0, 0.0]
        var pathLength: Int64 = path._length

        for (i in 0..pathLength) {
            centerPoint[0] += path.v[i].x
            centerPoint[1] += path.v[i].y
        }
        centerPoint[0] /= Float64(pathLength)
        centerPoint[1] /= Float64(pathLength)

        var clonedPath: ShapeData = ShapeData()  //shapePool.newElement()
        
        clonedPath.c = path.c
        var vX: Float64 = 0.0
        var vY: Float64 = 0.0
        var oX: Float64 = 0.0
        var oY: Float64 = 0.0
        var iX: Float64 = 0.0
        var iY: Float64 = 0.0
        for (i in 0..pathLength) {
            vX = path.v[i].x + (centerPoint[0] - path.v[i].x) * percent
            vY = path.v[i].y + (centerPoint[1] - path.v[i].y) * percent
            oX = path.o[i].x + (centerPoint[0] - path.o[i].x) * -percent
            oY = path.o[i].y + (centerPoint[1] - path.o[i].y) * -percent
            iX = path.i[i].x + (centerPoint[0] - path.i[i].x) * -percent
            iY = path.i[i].y + (centerPoint[1] - path.i[i].y) * -percent
            clonedPath.setTripleAt(vX, vY, oX, oY, iX, iY, i)
        }
        return clonedPath
    }
    
    public func processShapes(_isFirstFrame: Bool): Bool {
        var shapePaths: ArrayList<ShapeData> = ArrayList<ShapeData>()
        let len: Int64 = this.shapes.size
        var jLen: Int64 = 0
        var amount_v: Array<Float64> = this.amount.v
        
        if (amount_v.size > 0 && amount_v[0] != 0.0) {
            var localShapeCollection: ShapeCollection = ShapeCollection()
            for (i in 0..len) {
                var shapeData: ShapeDataShapeModifiers = this.shapes[i]
                localShapeCollection = shapeData.localShapeCollection
                if (!(!shapeData.shape._mdf && !this._mdf && !_isFirstFrame)) {
                    localShapeCollection.releaseShapes()
                    shapeData.shape._mdf = true
                    shapePaths = shapeData.shape.paths.shapes
                    jLen = shapeData.shape.paths._length
                    for (j in 0..jLen) {
                        localShapeCollection.addShape(this.processPath(shapePaths[j], amount_v[0]))
                    }
                }
                shapeData.shape.paths = shapeData.localShapeCollection
            }
        }
        if (!this.dynamicProperties.size > 0) {
            this._mdf = false
        }
        return true
    }

}
