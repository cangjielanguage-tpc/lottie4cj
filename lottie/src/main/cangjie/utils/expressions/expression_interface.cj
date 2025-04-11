package lottie.utils.expressions

public open class ExpressionInterface {

    public var mn: String = ""
    public var nm: String = ""
    public var _name: String = ""
    public var _numProperties: Int64 = -1
    public open mut prop numProperties: Int64 {
        get() { _numProperties }
        set(value) {
            _numProperties = value
        }
    }

    /* "layers"."shapes".{"ty": "gr"} = ShapeGroup 中增加成员变量 cix  */
    public var propertyIndex: Int64 = 0
    /* "layers"."shapes".{"ty": "gr"} = ShapeGroup 中增加成员变量 ix  */
    public var ix: Int64 = 0
    public var ind: Int64 = 0

    var dash: HashMap<String, ExpressionPropertyInterface<ContentModelDK, Float64>> = HashMap<String, ExpressionPropertyInterface<ContentModelDK, Float64>>(24)

    public var isNull: Bool = false

    public init(isNull!: Bool = false) {
        this.isNull = isNull
    }

}
