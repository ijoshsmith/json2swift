//
//  json-schema-inference-element-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/10/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let dummyName = "fake-element"

class json_schema_inference_element_tests: XCTestCase {
    func test_null() {
        let jsonElement = ["null-attribute": NSNull()]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["null-attribute"] {
            XCTAssertEqual(type, .nullable)
        }
        else { XCTFail() }
    }
    
    func test_bool() {
        let jsonElement = ["bool-attribute": true]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["bool-attribute"] {
            XCTAssertEqual(type, .bool(isRequired: true))
        }
        else { XCTFail() }
    }
    
    func test_integer() {
        let jsonElement = ["int-attribute": 42]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["int-attribute"] {
            XCTAssertEqual(type, .number(isRequired: true, isFloatingPoint: false))
        }
        else { XCTFail() }
    }
    
    func test_floating_point() {
        let jsonElement = ["floating-point-attribute": 3.14]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["floating-point-attribute"] {
            XCTAssertEqual(type, .number(isRequired: true, isFloatingPoint: true))
        }
        else { XCTFail() }
    }
    
    func test_string() {
        let jsonElement = ["string-attribute": "some text"]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["string-attribute"] {
            XCTAssertEqual(type, .string(isRequired: true))
        }
        else { XCTFail() }
    }
    
    func test_url() {
        let jsonElement = ["url-attribute": "http://ijoshsmith.com"]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["url-attribute"] {
            XCTAssertEqual(type, .url(isRequired: true))
        }
        else { XCTFail() }
    }
    
    func test_date() {
        let jsonElement = ["date-attribute": "DATE_FORMAT=MM/dd/yyyy"]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["date-attribute"] {
            XCTAssertEqual(type, .date(isRequired: true, format: "MM/dd/yyyy"))
        }
        else { XCTFail() }
    }
    
    func test_element() {
        let jsonElement = [
            "element-attribute": [
                "string-attribute": "some text"
            ]
        ]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: dummyName)
        if let type = schema.attributes["element-attribute"] {
            let expectedSchema = JSONElementSchema(
                name: "element-attribute",
                attributes: ["string-attribute": .string(isRequired: true)])
            XCTAssertEqual(type, .element(isRequired: true, schema: expectedSchema))
        }
        else { XCTFail() }
    }
    
    func test_element_array() {
        let jsonElementArray = [
            "array-attribute": [
                [
                    "string-attribute": "some text"
                ]
            ]
        ]
        let schema = JSONElementSchema.inferred(from: jsonElementArray, named: dummyName)
        if let type = schema.attributes["array-attribute"] {
            let expectedSchema = JSONElementSchema(
                name: "array-attribute",
                attributes: ["string-attribute": .string(isRequired: true)])
            XCTAssertEqual(type, .elementArray(isRequired: true, elementSchema: expectedSchema, hasNullableElements: false))
        }
        else { XCTFail() }
    }
}
