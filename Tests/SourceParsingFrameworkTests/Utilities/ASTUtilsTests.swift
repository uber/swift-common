//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import SourceKittenFramework
import XCTest
@testable import SourceParsingFramework

class ASTUtilsTests: AbstractSourceParsingTests {

    func test_inheritedTypes_withSingleLine_verifyResult() {
        let structure = self.structure(for: "SingleLineInheritedTypes.swift").substructures[0]
        let types = structure.inheritedTypes

        XCTAssertEqual(types, ["SuperClass<Blah,Foo,Bar>"])
    }

    func test_inheritedTypes_withMultiLine_verifyResult() {
        let structure = self.structure(for: "MultiLineInheritedTypes.swift").substructures[0]
        let types = structure.inheritedTypes

        XCTAssertEqual(types, ["SuperClass<Blah,Foo,Bar>"])
    }

    func test_type_name_verifyResults() {
        let structure = self.structure(for: "Types.swift")

        let myClass = structure.substructures[0]
        XCTAssertEqual(myClass.type, ASTType.class)
        XCTAssertEqual(myClass.name, "MyClass")
        XCTAssertEqual(myClass.substructures[0].type, ASTType.property)
        XCTAssertEqual(myClass.substructures[0].name, "a")
        XCTAssertEqual(myClass.substructures[1].type, ASTType.property)
        XCTAssertEqual(myClass.substructures[1].name, "myOtherProperty")
        XCTAssertEqual(myClass.substructures[1].returnType, "Int")
        XCTAssertEqual(myClass.substructures[2].type, ASTType.expressionCall)
        XCTAssertEqual(myClass.substructures[2].name, "someMethod")
        XCTAssertEqual(myClass.substructures[3].type, ASTType.method)
        XCTAssertEqual(myClass.substructures[3].name, "myMethod(_:arg2:_:)")
        XCTAssertEqual(myClass.substructures[3].returnType, "String")

        let myProtocol = structure.substructures[1]
        XCTAssertEqual(myProtocol.type, ASTType.protocol)
        XCTAssertEqual(myProtocol.name, "MyProtocol")

        let myStruct = structure.substructures[2]
        XCTAssertEqual(myStruct.type, ASTType.struct)
        XCTAssertEqual(myStruct.name, "MyStruct")

        let myGlobalLet = structure.substructures[3]
        XCTAssertEqual(myGlobalLet.type, ASTType.globalProperty)
        XCTAssertEqual(myGlobalLet.name, "globalLet")

        let myGlobalVar = structure.substructures[4]
        XCTAssertEqual(myGlobalVar.type, ASTType.globalProperty)
        XCTAssertEqual(myGlobalVar.name, "globalVar")
    }

    private func structure(for fileName: String) -> Structure {
        let fileUrl = fixtureUrl(for: fileName)
        let content = try! String(contentsOf: fileUrl)
        let file = File(contents: content)
        return try! Structure(file: file)
    }
}
