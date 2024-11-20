/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */
//package lottie.shape_items
package lottie.property

internal import std.collection.*
internal import lottie.bezier.*

public class ShapeTransformManager {

    protected var sequences: HashMap<String, Sequence>
    protected var sequenceList: ArrayList<Sequence>
    protected var transform_key_count: Int64

    public init() {
        this.sequences = HashMap<String, Sequence>()
        this.sequenceList = ArrayList<Sequence>()
        this.transform_key_count = 0
    }

    //lp--20241012
    public func addTransformSequence(transforms: ArrayList<AnimatableTransformElement>): Sequence {
        let len: Int64 = transforms.size
        var key: String = "_"
        for (i in 0..len) {
            key = transforms[i].transform.key + "_" + key
        }
        let sequence: Option<Sequence> = this.sequences.get(key)
        if (let Some(v) <- sequence) {
            return v
        } else {
            let seq: Sequence = Sequence(transforms: transforms.clone(), finalTransform: Matrix(), _mdf: false)
            this.sequences.put(key, seq)
            this.sequenceList.append(seq)
            return seq
        }
    }

    public func processSequence(sequence: Sequence, isFirstFrame: Bool) {
        var i = 0
        var len = sequence.transforms.size
        var _mdf = isFirstFrame
        while (i < len && !isFirstFrame) {
            if ((sequence.transforms[i] as AnimatableTransformElement).getOrThrow().transform.mProps._mdf) {
                _mdf = true
                break
            }
            i += 1
        }
        if (_mdf) {
            var props: Array<Float64>
            sequence.finalTransform.reset()
            var i = len - 1
            while (i >= 0) {
                props = (sequence.transforms[i] as AnimatableTransformElement).getOrThrow().transform.mProps.v.props
                sequence.finalTransform.transform(props[0], props[1], props[2], props[3], props[4], props[5], props[6], props[7], props[8], props[9], props[10], props[11], props[12], props[13], props[14], props[15])
                i -= 1
            }
        }
        sequence._mdf = _mdf
    }

    public func processSequences(isFirstFrame: Bool) {
        var len = this.sequenceList.size
        for (i in 0..len) {
            this.processSequence(this.sequenceList[i], isFirstFrame)
        }
    }

    public func getNewKey() {
        this.transform_key_count += 1
        return "_" + "${this.transform_key_count}"
    }
}

//lp--20241012
public class Sequence {

    protected var transforms: ArrayList<AnimatableTransformElement>
    protected var finalTransform: Matrix
    protected var _mdf: Bool

    public init(transforms!: ArrayList<AnimatableTransformElement> = ArrayList<AnimatableTransformElement>(), 
                finalTransform!: Matrix = Matrix(), _mdf!: Bool = false
    ) {
        this.transforms = transforms
        this.finalTransform = finalTransform
        this._mdf = _mdf
    }
}

public class Transform {

    public var opacity: Int64 = 0

    public var _opMdf: Bool = false

    public var key: String = ""

    public var op: Array<Object> = Array<Object>()

    public var mProps: MProp = MProp()

}
public class MProp {
    public var v: MPropv = MPropv()

    public var _mdf: Bool = false

}

public class MPropv {
    public var props: Array<Float64> = Array<Float64>()
}

