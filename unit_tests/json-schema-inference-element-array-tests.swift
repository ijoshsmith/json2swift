//
//  json-schema-inference-element-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/13/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let dummyName = "fake-array"

class json_schema_inference_element_array_tests: XCTestCase {
    func test_empty_array() {
        let elementArray = [JSONElement]()
        let schema = JSONElementSchema.inferred(from: elementArray, named: dummyName)
        XCTAssertEqual(schema.name, dummyName)
        XCTAssertTrue(schema.attributes.isEmpty)
    }
    
    func test_one_element_array() {
        let elementArray = [
            [
                "numeric-attribute": 42
            ]
        ]
        let schema = JSONElementSchema.inferred(from: elementArray, named: dummyName)
        if let attribute = schema.attributes["numeric-attribute"] {
            XCTAssertEqual(attribute, .number(isRequired: true, isFloatingPoint: false))
        }
        else { XCTFail() }
    }
    
    func test_two_element_array() {
        let elementArray = [
            [
                "numeric-attribute": 42
            ],
            [
                "numeric-attribute": 3.14
            ]
        ]
        let schema = JSONElementSchema.inferred(from: elementArray, named: dummyName)
        if let attribute = schema.attributes["numeric-attribute"] {
            XCTAssertEqual(attribute, .number(isRequired: true, isFloatingPoint: true))
        }
        else { XCTFail() }
    }
    
    func test_three_element_array() {
        let elementArray = [
            [
                "url-attribute": "http://abc.com/kitty.png"
            ],
            [
                "url-attribute": NSNull()
            ],
            [
                "url-attribute": "http://xyz.org/foo?q=bar"
            ]
        ]
        let schema = JSONElementSchema.inferred(from: elementArray, named: dummyName)
        if let attribute = schema.attributes["url-attribute"] {
            XCTAssertEqual(attribute, .url(isRequired: false))
        }
        else { XCTFail() }
    }
    
    func test_three_element_array_with_two_attributes_per_element() {
        let elementArray = [
            [
                "string-attribute": "apple",
                "bool-attribute": true
            ],
            [
                "string-attribute": "banana",
                "bool-attribute": false
            ],
            [
                "string-attribute": "cherry"
                // Omitting bool-attribute makes it optional.
            ]
        ]
        let schema = JSONElementSchema.inferred(from: elementArray, named: dummyName)
        XCTAssertEqual(schema.attributes.count, 2)
        
        if let stringAttribute = schema.attributes["string-attribute"] {
            XCTAssertEqual(stringAttribute, .string(isRequired: true))
        }
        else { XCTFail() }
        
        if let boolAttribute = schema.attributes["bool-attribute"] {
            XCTAssertEqual(boolAttribute, .bool(isRequired: false))
        }
        else { XCTFail() }
    }
    
    func test_element_array_with_null_value() {
        let elementArray: Any = [
            [
                "string-attribute": "apple",
                "bool-attribute": true
            ],
            NSNull(),
            [
                "string-attribute": "banana",
                "bool-attribute": false
            ]
        ]
        let schema = JSONElementSchema.inferred(from: ["array-attribute": elementArray], named: "foo")
        XCTAssertEqual(schema.attributes.count, 1)
        
        if let arrayAttribute = schema.attributes["array-attribute"] {
            if case let .elementArray(isRequired, elementSchema, hasNullableElements) = arrayAttribute {
                XCTAssertTrue(isRequired)
                XCTAssertEqual(elementSchema.name, "array-attribute")
                XCTAssertEqual(elementSchema.attributes.count, 2)
                XCTAssertTrue(hasNullableElements)
            }
            else { XCTFail() }
        }
        else { XCTFail() }
    }
}
