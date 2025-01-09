/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is BlendModes.
 */
package lottie.utils.helpers
import ohos.state_macro_manage.*
import std.core.Object
import tpc.UIKit.*
internal import tpc.UIKit.component_interop.*
internal import tpc.ImageKit.image.*
enum MultiType {
    | INT(Int64)
    | FLOAT(Float64)
    | BOOL(Bool)
    | STR(String)
    | CHAR(Rune)
    | ARRAY1(Array<Int64>)
    | ARRAY2(Array<Float64>)
    | ARRAY3(Array<String>)
    | NULL
}

public struct UnionType <: Equatable<UnionType> &
                            Equatable<Int64> &
                            Equatable<Float64> &
                            Equatable<Bool> &
                            Equatable<String> &
                            Equatable<Array<Int64>> &
                            Equatable<Array<Float64>> &
                            Equatable<Array<String>> &
                            Equatable<Rune> & ToString & Hashable {
    private var value: MultiType
    public init(v: Int64) { this.value = INT(v) }
    public init(v: Float64) { this.value = FLOAT(v) }
    public init(v: Bool) { this.value = BOOL(v) }
    public init(v: String) { this.value = STR(v) }
    public init(v: Rune) { this.value = CHAR(v) }
    public init(v: Array<Int64>) { this.value = ARRAY1(v) }
    public init(v: Array<Float64>) { this.value = ARRAY2(v) }
    public init(v: Array<String>) { this.value = ARRAY3(v) }
    public init() { this.value = NULL }

    public mut func setValue(v: UnionType) { this.value = v.value }
    public mut func setValue(v: Int64) { this.value = INT(v) }
    public mut func setValue(v: Float64) { this.value = FLOAT(v) }
    public mut func setValue(v: Bool) { this.value = BOOL(v) }
    public mut func setValue(v: String) { this.value = STR(v) }
    public mut func setValue(v: Rune) { this.value = CHAR(v) }
    public mut func setValue(v: Array<Int64>) { this.value = ARRAY1(v) }
    public mut func setValue(v: Array<Float64>) { this.value = ARRAY2(v) }
    public mut func setValue(v: Array<String>) { this.value = ARRAY3(v) }

    public operator func == (that: Array<Float64>): Bool {
        match (this.value) {
            case ARRAY2(a) => a == that
            case _ => false
        }
    }
    public operator func != (that: Array<Float64>): Bool {
        !(this == that)
    }
    public operator func == (that: Array<String>): Bool {
        match (this.value) {
            case ARRAY3(a) => a == that
            case _ => false
        }
    }
    public operator func != (that: Array<String>): Bool {
        !(this == that)
    }
    public operator func == (that: Array<Int64>): Bool {
        match (this.value) {
            case ARRAY1(a) => a == that
            case _ => false
        }
    }
    public operator func != (that: Array<Int64>): Bool {
        !(this == that)
    }
    public operator func == (that: Int64): Bool {
        match (this.value) {
            case INT(v) => v == that
            case _ => false
        }
    }
    public operator func != (that: Int64): Bool {
        !(this == that)
    }

    public operator func == (that: Float64): Bool {
        match (this.value) {
            case FLOAT(v) => v == that
           case _ => false
        }
    }
    public operator func != (that: Float64): Bool {
        !(this == that)
    }
    public operator func == (that: Bool): Bool {
        match (this.value) {
            case BOOL(v) => v == that
            case _ => false
        }
    }
    public operator func != (that: Bool): Bool {
        !(this == that)
    }
    public operator func == (that: String): Bool {
        match (this.value) {
            case STR(v) => v == that
            case _ => false
        }
    }
    public operator func != (that: String): Bool {
        !(this == that)
    }
    public operator func == (that: Rune): Bool {
        match (this.value) {
            case CHAR(v) => v == that
            case _ => false
        }
    }
    public operator func != (that: Rune): Bool {
        !(this == that)
    }
    public operator func == (that: UnionType): Bool {
        match ((this.value, that.value)) {
            case (NULL, NULL) => true
            case (INT(v), INT(w)) => v == w
            case (FLOAT(v), FLOAT(w)) => v == w
            case (BOOL(v), BOOL(w)) => v == w
            case (STR(v), STR(w)) => v == w
            case (CHAR(v), CHAR(w)) => v == w
            case _ => false
        }
    }
    public operator func != (that: UnionType): Bool {
        return !(this == that)
    }
    public func toString(): String {
        match (value) {
            case INT(v) => v.toString()
            case FLOAT(v) => v.toString()
            case BOOL(v) => v.toString()
            case STR(v) => v.toString()
            case CHAR(v) => v.toString()
            case ARRAY1(v) => v.toString()
            case ARRAY2(v) => v.toString()
            case ARRAY3(v) => v.toString()
            case NULL => throw Exception("NULL value")
        }
    }

    public func hashCode(): Int64 {
        match (value) {
            case INT(v) => v.hashCode()
            case FLOAT(v) => v.hashCode()
            case BOOL(v) => v.hashCode()
            case STR(v) => v.hashCode()
            case CHAR(v) => v.hashCode()
            case _ => throw Exception("NULL value")
        }
    }

    public func getValue<T>(): T {
        match (value) {
            case INT(v) => if (let Some(w) <- (v as T)) { return w }
            case FLOAT(v) => if (let Some(w) <- (v as T)) { return w }
            case BOOL(v) => if (let Some(w) <- (v as T)) { return w }
            case STR(v) => if (let Some(w) <- (v as T)) { return w }
            case CHAR(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY1(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY2(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY3(v) => if (let Some(w) <- (v as T)) { return w }
            case _ => ()
        }
        throw Exception("NULL value")
    }
    public func getValue<T>(t: T): T  {
        match (value) {
            case INT(v) => if (let Some(w) <- (v as T)) { return w }
            case FLOAT(v) => if (let Some(w) <- (v as T)) { return w }
            case BOOL(v) => if (let Some(w) <- (v as T)) { return w }
            case STR(v) => if (let Some(w) <- (v as T)) { return w }
            case CHAR(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY1(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY2(v) => if (let Some(w) <- (v as T)) { return w }
            case ARRAY3(v) => if (let Some(w) <- (v as T)) { return w }
            case _ => ()
        }
        return t
    }
}

public class LottieCanvasRenderingContext2D {
    public let ctx2d: CanvasRenderingContext2D
    public init(ctx: CanvasRenderingContext2D) {
        this.ctx2d = ctx
    }
    public func fillStyle(color: Color): Unit {
        this.ctx2d.fillStyle(color)
    }
    public func fillStyle(color: UInt32): Unit {
        this.ctx2d.fillStyle(color)
    }
    public func fillStyle(color: CanvasGradient): Unit {
        this.ctx2d.fillStyle(color)
    }
    public func lineWidth(width: Float64): Unit {
        this.ctx2d.lineWidth(width)
    }
    public func lineWidth(width: Int64): Unit {
        this.ctx2d.lineWidth(width)
    }
    public func strokeStyle(color: Color): Unit {
        this.ctx2d.strokeStyle(color)
    }
    public func strokeStyle(color: UInt32): Unit {
        this.ctx2d.strokeStyle(color)
    }
    public func strokeStyle(gradient: CanvasGradient): Unit {
        this.ctx2d.strokeStyle(gradient)
    }
    public func lineCap(value: CanvasLineCap): Unit {
        this.ctx2d.lineCap = value
    }
    public func lineJoin(value: CanvasLineJoin): Unit {
        this.ctx2d.lineJoin = value
    }
    public func miterLimit(limit: Float64): Unit {
        this.ctx2d.miterLimit = limit
    }
    public func miterLimit(limit: Int64): Unit {
        this.ctx2d.miterLimit = Float64(limit)
    }
    public func font( style!: FontStyle = FontStyle.Normal, weight!: FontWeight = FontWeight.Normal, size!: Length = 14.px, family!: String = "sans-serif" ): Unit {
        //this.ctx2d.font = Font(style:style, weight:weight,size:size,family:family)
        this.ctx2d.font = "${size.value}.px "+family
    }
    public func textAlign(align: CanvasTextAlign): Unit {
        this.ctx2d.textAlign = align
    }
    public func textBaseline(baseline: CanvasTextBaseline): Unit {
        this.ctx2d.textBaseline = baseline
    }
    public func globalAlpha(alpha: Float64): Unit {
        this.ctx2d.globalAlpha= alpha
    }
    public func globalAlpha(alpha: Int64): Unit {
        this.ctx2d.globalAlpha = Float64(alpha)
    }
    public func lineDash(dashArr: Array<Float64>): Unit {
        this.ctx2d.setLineDash(dashArr)
    }
    public func lineDash(dashArr: Array<Int64>): Unit {
        var tmps = Array<Float64>(dashArr.size,item: 0.0)
        for (i in 0..dashArr.size) {
            tmps[i] = Float64(dashArr[i])
        }
        this.ctx2d.setLineDash(tmps)
    }
    public func lineDashOffset(offset: Float64): Unit {
        this.ctx2d.lineDashOffset =offset
    }
    public func lineDashOffset(offset: Int64): Unit {
        this.ctx2d.lineDashOffset = Float64(offset)
    }
    public func globalCompositeOperation(operation: String): Unit {
        this.ctx2d.globalCompositeOperation = operation
    }
    public func shadowBlur(blur: Float64): Unit {
        this.ctx2d.shadowBlur = blur
    }
    public func shadowBlur(blur: Int64): Unit {
        this.ctx2d.shadowBlur = Float64(blur)
    }
    public func shadowColor(color: Color): Unit {
        this.ctx2d.shadowColor =UInt32ToRGB(color.toUInt32())
    }
    public func shadowColor(color: UInt32): Unit {
        this.ctx2d.shadowColor = UInt32ToRGB(color)
    }
    public func shadowOffsetX(offset: Float64): Unit {
        this.ctx2d.shadowOffsetX = offset
    }
    public func shadowOffsetX(offset: Int64): Unit {
        this.ctx2d.shadowOffsetX = Float64(offset)
    }
    public func shadowOffsetY(offset: Float64): Unit {
        this.ctx2d.shadowOffsetY = offset
    }
    public func shadowOffsetY(offset: Int64): Unit {
        this.ctx2d.shadowOffsetY = Float64(offset)
    }
    public func imageSmoothingEnabled(enabled: Bool): Unit {
        this.ctx2d.imageSmoothingEnabled = enabled
    }
    public func imageSmoothingQuality(quality: ImageSmoothingQuality): Unit {
        this.ctx2d.imageSmoothingQuality = quality
    }
    public func fillRect(x: Float64, y: Float64, width: Float64, height: Float64): Unit {
        this.ctx2d.fillRect(x,y,width,height)
    }
    public func fillRect(x: Int64, y: Int64, width: Int64, height: Int64): Unit {
        this.ctx2d.fillRect(Float64(x),Float64(y),Float64(width),Float64(height))
    }
    public func strokeRect(x: Float64, y: Float64, width: Float64, height: Float64): Unit {
        this.ctx2d.strokeRect(x,y,width,height)
    }
    public func strokeRect(x: Int64, y: Int64, width: Int64, height: Int64): Unit {
        this.ctx2d.strokeRect(Float64(x),Float64(y),Float64(width),Float64(height))
    }
    public func clearRect(x: Float64, y: Float64, width: Float64, height: Float64): Unit {
        this.ctx2d.clearRect(x,y,width,height)
    }
    public func clearRect(x: Int64, y: Int64, width: Int64, height: Int64): Unit {
        this.ctx2d.clearRect(x,y,width,height)
    }
    public func fillText(text: String, x: Float64, y: Float64): Unit {
        this.ctx2d.fillText(text,x,y)
    }
    public func fillText(text: String, x: Int64, y: Int64): Unit {
        this.ctx2d.fillText(text,Float64(x),Float64(y))
    }
    public func strokeText(text: String, x: Float64, y: Float64): Unit {
        this.ctx2d.strokeText(text, x,y)
    }
    public func strokeText(text: String, x: Int64, y: Int64): Unit {
        this.ctx2d.strokeText(text, Float64(x),Float64(y))
    }
    public func measureText(text: String): TextMetrics {
        this.ctx2d.measureText(text)
    }
    public func stroke(): Unit {
        this.ctx2d.stroke()
    }
    public func stroke(path2D: Path2D): Unit {
        this.ctx2d.stroke(path2D)
    }
    public func beginPath(): Unit {
        this.ctx2d.beginPath()
    }
    public func moveTo(x: Float64, y: Float64): Unit {
        this.ctx2d.moveTo(x,y)
    }
    public func moveTo(x: Int64, y: Int64): Unit {
        this.ctx2d.moveTo(x,y)
    }
    public func lineTo(x: Float64, y: Float64): Unit {
        this.ctx2d.lineTo(x,y)
    }
    public func lineTo(x: Int64, y: Int64): Unit {
        this.ctx2d.lineTo(x,y)
    }
    public func closePath(): Unit{
        this.ctx2d.closePath()
    }
    public func bezierCurveTo(cp1x: Float64, cp1y: Float64, cp2x: Float64, cp2y: Float64, x: Float64, y: Float64): Unit {
        this.ctx2d.bezierCurveTo(cp1x, cp1y, cp2x,cp2y,x,y)
    }
    public func bezierCurveTo(cp1x: Int64, cp1y: Int64, cp2x: Int64, cp2y: Int64, x: Int64, y: Int64): Unit {
        this.ctx2d.bezierCurveTo(Float64(cp1x), Float64(cp1y), Float64(cp2x),Float64(cp2y),Float64(x),Float64(y))
    }
    public func quadraticCurveTo(cpx: Float64, cpy: Float64, x: Float64, y: Float64): Unit {
        this.ctx2d.quadraticCurveTo(cpx, cpy, x,y)
    }
    public func quadraticCurveTo(cpx: Int64, cpy: Int64, x: Int64, y: Int64): Unit {
        this.ctx2d.quadraticCurveTo(Float64(cpx), Float64(cpy), Float64(x),Float64(y))
    }
    public func arc(
        x: Int64,
        y: Int64,
        radius: Int64,
        startAngle: Int64,
        endAngle: Int64,
        anticlockwise!: Bool = false
    ): Unit {
        this.ctx2d.arc(Float64(x),Float64(y),Float64(radius), Float64(startAngle), Float64(endAngle),anticlockwise)
    }

    public func arcTo(x1: Float64, y1: Float64, x2: Float64, y2: Float64, radius: Float64): Unit {
        this.ctx2d.arcTo(x1, y1,x2,y2,radius)
    }
    public func arcTo(x1: Int64, y1: Int64, x2: Int64, y2: Int64, radius: Int64): Unit {
        this.ctx2d.arcTo(x1, y1,x2,y2,radius)
    }
    public func ellipse(
        x: Float64,
        y: Float64,
        radiusX: Float64,
        radiusY: Float64,
        rotation: Float64,
        startAngle: Float64,
        endAngle: Float64,
        anticlockwise!: Bool = false
    ): Unit {
        this.ctx2d.ellipse(x,y,radiusX, radiusY, rotation, startAngle, endAngle, anticlockwise)
    }
    public func ellipse(
        x: Int64,
        y: Int64,
        radiusX: Int64,
        radiusY: Int64,
        rotation: Int64,
        startAngle: Int64,
        endAngle: Int64,
        anticlockwise!: Bool = false
    ): Unit {
        this.ctx2d.ellipse(Float64(x),Float64(y),Float64(radiusX), Float64(radiusY), Float64(rotation), Float64(startAngle), Float64(endAngle), anticlockwise)
    }
    public func rect(x: Float64, y: Float64, width: Float64, height: Float64): Unit {
        this.ctx2d.rect(x,y,width,height)
    }
    public func rect(x: Int64, y: Int64, width: Int64, height: Int64): Unit {
        this.ctx2d.rect(x,y,width,height)
    }
    public func fill(): Unit {
        this.ctx2d.fill()
    }
    public func clip(): Unit {
        this.ctx2d.clip()
    }
    public func rotate(angle: Float64): Unit {
        this.ctx2d.rotate(angle)
    }
    public func rotate(angle: Int64): Unit {
        this.ctx2d.rotate(Float64(angle))
    }
    public func scale(x: Float64, y: Float64): Unit {
        this.ctx2d.scale(x,y)
    }
    public func scale(x: Int64, y: Int64): Unit {
        this.ctx2d.scale(Float64(x),Float64(y))
    }
    public func transform(
        scaleX: Float64,
        skewX: Float64,
        skewY: Float64,
        scaleY: Float64,
        translateX: Float64,
        translateY: Float64
    ): Unit {
        this.ctx2d.transform(scaleX,skewX, skewY, scaleY, translateX,translateY)
    }
    public func transform(
        scaleX: Int64,
        skewX: Int64,
        skewY: Int64,
        scaleY: Int64,
        translateX: Int64,
        translateY: Int64
    ): Unit {
        this.ctx2d.transform(scaleX,skewX, skewY, scaleY, translateX,translateY)
    }
    public func setTransform(
        scaleX: Float64,
        skewX: Float64,
        skewY: Float64,
        scaleY: Float64,
        translateX: Float64,
        translateY: Float64
    ): Unit {
        this.ctx2d.setTransform(scaleX,skewX, skewY, scaleY, translateX,translateY)
    }
    public func setTransform(
        scaleX: Int64,
        skewX: Int64,
        skewY: Int64,
        scaleY: Int64,
        translateX: Int64,
        translateY: Int64
    ): Unit {
        this.ctx2d.setTransform(Float64(scaleX),Float64(skewX), Float64(skewY), Float64(scaleY), Float64(translateX),Float64(translateY))
    }
    public func translate(x: Float64, y: Float64): Unit {
        this.ctx2d.translate(x,y)
    }
    public func translate(x: Int64, y: Int64): Unit {
        this.ctx2d.translate(Float64(x),Float64(y))
    }
    public func restore(): Unit {
        this.ctx2d.restore()
    }
    public func save(): Unit {
        this.ctx2d.save()
    }
    public func createLinearGradient(x0: Float64, y0: Float64, x1: Float64, y1: Float64): CanvasGradient {
        this.ctx2d.createLinearGradient(x0,y0,x1,y1)
    }
    public func createLinearGradient(x0: Int64, y0: Int64, x1: Int64, y1: Int64): CanvasGradient {
        this.ctx2d.createLinearGradient(Float64(x0),Float64(y0),Float64(x1),Float64(y1))
    }
    public func createRadialGradient(x0: Float64, y0: Float64, r0: Float64, x1: Float64, y1: Float64, r1: Float64): CanvasGradient {
        this.ctx2d.createRadialGradient(x0,y0,r0,x1,y1,r1)
    }
    public func createRadialGradient(x0: Int64, y0: Int64, r0: Int64, x1: Int64, y1: Int64, r1: Int64): CanvasGradient {
        this.ctx2d.createRadialGradient(Float64(x0),Float64(y0),Float64(r0),Float64(x1),Float64(y1),Float64(r1))
    }
    public func drawImage(image: ImageBitmap, dx: Float64, dy: Float64): Unit {
        this.ctx2d.drawImage(image,dx,dy)
    }
    public func drawImage(image: ImageBitmap, dx: Int64, dy: Int64): Unit {
        this.ctx2d.drawImage(image,Float64(dx),Float64(dx))
    }
    public func drawImage(image: ImageBitmap, dx: Float64, dy: Float64, dWidth: Float64, dHeight: Float64): Unit {
        this.ctx2d.drawImage(image,dx,dy,dWidth,dHeight)
    }
    public func drawImage(image: ImageBitmap, dx: Int64, dy: Int64, dWidth: Int64, dHeight: Int64): Unit {
        this.ctx2d.drawImage(image,Float64(dx),Float64(dy),Float64(dWidth),Float64(dHeight))
    }
    public func drawImage(
        image: ImageBitmap,
        sx: Float64,
        sy: Float64,
        sWidth: Float64,
        sHeight: Float64,
        dx: Float64,
        dy: Float64,
        dWidth: Float64,
        dHeight: Float64
    ): Unit {
        this.ctx2d.drawImage(image, sx, sy, sWidth,sHeight,dx,dy,dWidth,dHeight)
    }
    public func drawImage(
        image: ImageBitmap,
        sx: Int64,
        sy: Int64,
        sWidth: Int64,
        sHeight: Int64,
        dx: Int64,
        dy: Int64,
        dWidth: Int64,
        dHeight: Int64
    ): Unit {
        this.ctx2d.drawImage(image, Float64(sx), Float64(sy), Float64(sWidth),Float64(sHeight),Float64(dx),Float64(dy),Float64(dWidth),Float64(dHeight))
    }

    public func drawImage(image: PixelMap, dx: Float64, dy: Float64): Unit {
        this.ctx2d.drawImage(image,dx,dy)
    }
    public func drawImage(image: PixelMap, dx: Int64, dy: Int64): Unit {
        this.ctx2d.drawImage(image,Float64(dx),Float64(dy))
    }
    public func drawImage(image: PixelMap, dx: Float64, dy: Float64, dWidth: Float64, dHeight: Float64): Unit {
        this.ctx2d.drawImage(image,dx,dy,dWidth,dHeight)
    }
    public func drawImage(image: PixelMap, dx: Int64, dy: Int64, dWidth: Int64, dHeight: Int64): Unit {
        this.ctx2d.drawImage(image,Float64(dx),Float64(dy),Float64(dWidth),Float64(dHeight))
    }
    public func drawImage(
        image: PixelMap,
        sx: Float64,
        sy: Float64,
        sWidth: Float64,
        sHeight: Float64,
        dx: Float64,
        dy: Float64,
        dWidth: Float64,
        dHeight: Float64
    ): Unit {
        this.ctx2d.drawImage(image, sx, sy, sWidth,sHeight,dx,dy,dWidth,dHeight)
    }
    public func drawImage(
        image: PixelMap,
        sx: Int64,
        sy: Int64,
        sWidth: Int64,
        sHeight: Int64,
        dx: Int64,
        dy: Int64,
        dWidth: Int64,
        dHeight: Int64
    ): Unit {
        this.ctx2d.drawImage(image, Float64(sx), Float64(sy), Float64(sWidth),Float64(sHeight),Float64(dx),Float64(dy),Float64(dWidth),Float64(dHeight))
    }
    public func getPixelMap(left: Float64, top: Float64, width: Float64, height: Float64): PixelMap {
        this.ctx2d.getPixelMap(left, top, width, height)
    }
    public func getPixelMap(left: Int64, top: Int64, width: Int64, height: Int64): PixelMap {
        this.ctx2d.getPixelMap(Float64(left), Float64(top), Float64(width), Float64(height))
    }

}
func UInt32ToRGB(i: UInt32): String {
    "rgb(${(i & 0xFF0000) >> 16},${(i & 0x00ff00) >> 8},${i & 0x0000ff})"
}
