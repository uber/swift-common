class SomeChildClass: SomeParent {
    let a = "haha"

    override var myOtherProperty: Int {
        return someMethod()
    }

    override func myMethod(_ arg1: Int, arg2: String, _: Object) -> String {
        return ""
    }

    func voidReturnType() {
        
    }
}
