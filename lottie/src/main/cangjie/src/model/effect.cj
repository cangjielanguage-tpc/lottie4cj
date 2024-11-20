/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

/**
 * @file This file is a Effect structure.
 */
package lottie.model

/*
 * "layers": [
 *   "ef": [
 *     {
 *       "ty":25,
 *       "nm":"Drop Shadow2",
 *       "np":8,
 *       "mn":"ADBE Drop Shadow",
 *       "ix":1,
 *       "en":1,
 *       "ef":[
 *            {
 *              "ty":2,
 *              "nm":"Shadow Color",
 *              "mn":"ADBE Drop Shadow-0001",
 *              "ix":1,
 *              "v":{ "a":1, "k":[...], "ix":1 }
 *            },...
 *       ]
 *     }
 *   ]
 * ]
*/
public class Effect <: LayerEF {

    public let v: ContentModelPK

    /**
     * Create a Effect instance based on parameters.
     *
     * @param ty - Type of Int64, the value of ty.
     * @param nm - Type of String, the value of nm.
     * @param v - Type of ContentModelPK, the value of v.
     * @param isNull - Type of Bool, the value of isNull.
     */
    public init(ty!: Int64 = 0, nm!: String = "", v!: ContentModelPK = ContentModelPK(), 
                mn!: String = "", ix!: Int64 = 0,
                isNull!: Bool = true
    ){
        super(ty, nm, Array<Effect>())
        this.v = v
        this.mn = mn
        this.ix = ix
        this.isNull = isNull
    }

    /**
     * Return to convert the instance into a string and return.
     *
     * @return Type of String, converted String.
     */
    public func toString(): String {
        return "Effect: {\n" +
               "ty = ${ty},\n" +
               "nm = ${nm},\n" +
               "v = ${v}\n}"
    }
}
