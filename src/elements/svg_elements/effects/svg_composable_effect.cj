/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights resvered.
 */


package lottie4cj.elements.svg_elements.effects
internal import lottie4cj.utils.helpers.*
internal import lottie4cj.elements.*
internal import lottie4cj.elements.svg_elements.*
public class SVGComposableEffect {

    public static func createMergeNode(resultId: String, ins: Array<String>): CreateNS {
        var feMerge = CreateNS("feMerge");
        feMerge.setAttribute("result", resultId);
        var feMergeNode: CreateNS
        for (i in 0..ins.size) {
            feMergeNode = CreateNS("feMergeNode");
            feMergeNode.setAttribute("in", ins[i]);
            feMerge.appendChild(feMergeNode);
        }
        return feMerge;
    }
}