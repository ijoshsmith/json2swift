//
//  swift-code-generation-primitive-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/21/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

class swift_code_generation_primitive_array_tests: XCTestCase {
    
    // MARK: - Array with required primitive values
    
    func test_array_of_required_any() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .any, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? [Any?]") // Any is treated as optional.
    }
    
    func test_array_of_required_bool() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .bool, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? [Bool]")
    }
    
    func test_array_of_required_date() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .date(format: "M/d/yyyy"), hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [String]).flatMap({ $0.toDateArray(withFormat: \"M/d/yyyy\") })")
    }
    
    func test_array_of_required_double() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .double, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [NSNumber]).map({ $0.toDoubleArray() })")
    }
    
    func test_array_of_required_int() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .int, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? [Int]")
    }
    
    func test_array_of_required_string() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .string, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = json[\"a\"] as? [String]")
    }
    
    func test_array_of_required_url() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .url, hasOptionalElements: false)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [String]).flatMap({ $0.toURLArray() })")
    }
    
    // MARK: - Array with optional primitive values

    func test_array_of_optional_any() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .any, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalValueArray() as [Any?] })")
    }
    
    func test_array_of_optional_bool() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .bool, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalValueArray() as [Bool?] })")
    }
    
    func test_array_of_optional_date() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .date(format: "M/d/yyyy"), hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalDateArray(withFormat: \"M/d/yyyy\") })")
    }
    
    func test_array_of_optional_double() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .double, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalDoubleArray() })")
    }
    
    func test_array_of_optional_int() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .int, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalValueArray() as [Int?] })")
    }
    
    func test_array_of_optional_string() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .string, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalValueArray() as [String?] })")
    }
    
    func test_array_of_optional_url() {
        let transformation = TransformationFromJSON.toPrimitiveValueArray(attributeName: "a", propertyName: "p", elementType: .url, hasOptionalElements: true)
        XCTAssertEqual(transformation.letStatement, "let p = (json[\"a\"] as? [Any]).map({ $0.toOptionalURLArray() })")
    }
}
