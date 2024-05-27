/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GlobalData structure.
 */
package global_data

import model.*
import utils.*

public class CompSize {
    public let w: Float64                          // 0 = width       // View width
    public let h: Float64                          // 1 = height      // View height

    public init(w!: Float64 = 0.0, h!: Float64 = 0.0){
        this.w = w
        this.h = h
    }
}

public class TransformCanvas {
    public var tx: Int64 = 0

    public var ty: Int64 = 0

    public var w: Int64 = 0

    public var h: Int64 = 0

    public var sx: Int64 = 0

    public var sy: Int64 = 0
}


public class CanvasContext {

    public var globalCompositeOperation: String = ""

    public var filter: String = ""

    public func clearRect(x: Int64, y: Int64, w: Int64, h: Int64) {
        //TODO
    }

    public func restoreLayer() {
        //TODO
    }
}

//TODO: 未完全实现
public class GlobalData {

    public var blendMode: Int64 = 0
    public var canvasContext: CanvasContext = CanvasContext()
    public var transformCanvas: TransformCanvas = TransformCanvas()
    
    public var frameId: Int64 = 0
    public var frameRate: Float64 = 0.0
    public var nm: String = ""
    public var compSize: CompSize = CompSize()
    
    public var progressiveLoad: Bool = false

    public var fontManager: FontManager = FontManager()

    public func getAssetsPath(assetData: Asset): String { return "" }

}
