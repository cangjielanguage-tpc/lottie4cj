package elements

from std import collection.*

public class ProcessedElement {

    protected var elem: Object
    protected var pos: Object
    public init(element: Object, position: Object) {
        this.elem = element
        this.pos = position
    }
}