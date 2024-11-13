//package lottie.utils.expressions
package lottie.property

//TODO: 未实现，编译用
//TODO: 自定义数据类型 ExpressionInterface，是所有 XXXExpressionInterface 的父类/父接口。
public open class ExpressionInterface {

    //TODO：父类[ExpressionInterface]中存在的成员变量：mn/nm/_name/numProperties/propertyIndex/ix/ind
    //TODO：父类[ExpressionInterface]中存在的成员变量：mn/nm/_name/numProperties/propertyGroup/interfaces/propertyIndex/ix/ind
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
    
    //public var propertyGroup: (Option<Int64>) -> ExpressionInterface
    //TODO: 暂未确认 interfaces 数组中数据类型，暂定为自定义数据类型 ExpressionInterface，是所有 XXXExpressionInterface 的父类/父接口。
    //public var interfaces: Array<ExpressionInterface> = Array<ExpressionInterface>()

    //TODO: "layers"."shapes".{"ty": "gr"} = ShapeGroup 中增加成员变量 cix
    public var propertyIndex: Int64 = 0
    //TODO: "layers"."shapes".{"ty": "gr"} = ShapeGroup 中增加成员变量 ix
    public var ix: Int64 = 0
    //TODO: 暂未确定 ind 数据类型。暂时写为 Int64 类型。
    public var ind: Int64 = 0

    //public var selfCalling: (Int64, String, Bool) -> ExpressionInterface
    //public open func selfCalling(valueInt64: Int64, valueString: String, isString!: Bool = false): ExpressionInterface { return this }
    //public open func selfCalling(value: Int64): ExpressionInterface { return this }
    //public open func selfCalling(value: String): ExpressionInterface { return this }

    //strokeInterfaceFactory----------------------------------------------------------------------------------
    var dash: HashMap<String, ExpressionPropertyInterface<ContentModelDK, Float64>> = HashMap<String, ExpressionPropertyInterface<ContentModelDK, Float64>>(0)
    //strokeInterfaceFactory----------------------------------------------------------------------------------


    public var isNull: Bool = false

    public init(
                //propertyGroup: (Option<Int64>) -> ExpressionInterface, 
                //selfCalling: (Int64, String, Bool) -> ExpressionInterface,
                isNull!: Bool = false
    ) {
        //this.propertyGroup = propertyGroup
        //this.selfCalling = selfCalling
        this.isNull = isNull
    }

}
