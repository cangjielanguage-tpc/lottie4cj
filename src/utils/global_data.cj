/*
 * Copyright (c) Cangjie Library Team 2024-2024. All rights resvered.
 */

/**
 * @file This file is a GlobalData structure.
 */
package utils

public class CompSize {
    public let w: Int64                          // 0 = width       // View width
    public let h: Int64                          // 1 = height      // View height

    public init(w!: Int64 = 0, h!: Int64 = 0){
        this.w = w
        this.h = h
    }
}

//TODO: 未完全实现
public class GlobalData {

    public var frameId: Int64 = 0
    public var frameRate: Float64 = 0.0
    public var nm: String = ""
    public var compSize: CompSize = CompSize()

    public var fontManager: FontManager = FontManager()

    public func getAssetsPath(assetData: Asset): String { return "" }

}
