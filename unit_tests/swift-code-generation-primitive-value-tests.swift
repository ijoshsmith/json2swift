//
//  swift-code-generation-primitive-value-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/21/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

class swift_code_generation_primitive_value_tests: XCTestCase {
    func test_any() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .any)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? Any")
    }
    
    func test_emptyArray() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .emptyArray)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? [Any?]")
    }
    
    func test_bool() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .bool)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? Bool")
    }
    
    func test_date() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .date(format: "M/d/yyyy"))
        XCTAssertEqual(transformation.letStatement, "let p = Date(json: json, key: \"a\", format: \"M/d/yyyy\")")
    }
    
    func test_double() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .double)
        XCTAssertEqual(transformation.letStatement, "let p = Double(json: json, key: \"a\")")
    }
    
    func test_int() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .int)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? Int")
    }
    
    func test_string() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .string)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? String")
    }
    
    func test_url() {
        let transformation = TransformationFromJSON.toPrimitiveValue(attributeName: "a", propertyName: "p", type: .url)
        XCTAssertEqual(transformation.letStatement, "let p = URL(json: json, key: \"a\")")
    }
}
