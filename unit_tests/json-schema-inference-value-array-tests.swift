//
//  json-schema-inference-value-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/14/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let dummyName = "fake-element"

class json_schema_inference_value_array_tests: XCTestCase {
    func test_array_of_integer() {
        let valuesArray = [
            "integers-attribute": [
                1, 2, 3
            ]
        ]
        let schema = JSONElementSchema.inferred(from: valuesArray, named: dummyName)
        if let type = schema.attributes["integers-attribute"] {
            let arrayOfInteger: JSONType =
                .valueArray(isRequired: true, valueType:
                    .number(isRequired: true, isFloatingPoint: false))
            XCTAssertEqual(type, arrayOfInteger)
        }
        else { XCTFail() }
    }
    
    func test_array_of_array_of_integer() {
        let valuesArray = [
            "integer-arrays-attribute": [
                [1, 2, 3],
                [4, 5],
                [6],
            ]
        ]
        let schema = JSONElementSchema.inferred(from: valuesArray, named: dummyName)
        if let type = schema.attributes["integer-arrays-attribute"] {
            let arrayOfArrayOfInteger: JSONType =
                .valueArray(isRequired: true, valueType:
                    .valueArray(isRequired: true, valueType:
                        .number(isRequired: true, isFloatingPoint: false)))
            XCTAssertEqual(type, arrayOfArrayOfInteger)
        }
        else { XCTFail() }
    }
    
    func test_array_of_array_of_optional_bool() {
        let valuesArray = [
            "boolean-arrays-attribute": [
                [true,  false,    true],
                [false, NSNull(), false],
                [false, false,    true],
            ]
        ]
        let schema = JSONElementSchema.inferred(from: valuesArray, named: dummyName)
        if let type = schema.attributes["boolean-arrays-attribute"] {
            let arrayOfArrayOfOptionalBoolean: JSONType =
                .valueArray(isRequired: true, valueType:
                    .valueArray(isRequired: true, valueType:
                        .bool(isRequired: false)))
            XCTAssertEqual(type, arrayOfArrayOfOptionalBoolean)
        }
        else { XCTFail() }
    }
    
    func test_array_of_optional_array_of_optional_string() {
        let valuesArray = [
            "string-arrays-attribute": [
                NSNull(),
                ["A", "B"],
                ["C", "D", NSNull()],
            ]
        ]
        let schema = JSONElementSchema.inferred(from: valuesArray, named: dummyName)
        if let type = schema.attributes["string-arrays-attribute"] {
            let arrayOfOptionalArrayOfOptionalString: JSONType =
                .valueArray(isRequired: true, valueType:
                    .valueArray(isRequired: false, valueType:
                        .string(isRequired: false)))
            XCTAssertEqual(type, arrayOfOptionalArrayOfOptionalString)
        }
        else { XCTFail() }
    }
    
    func test_url_array_and_empty_array() {
        let jsonArray = [
            [
                "url-array-attribute": [
                    "http://fake-url.com"
                ]
            ],
            [
                "url-array-attribute": [
                    // Empty array
                ]
            ]
        ]
        let schema = JSONElementSchema.inferred(from: jsonArray, named: dummyName)
        if let type = schema.attributes["url-array-attribute"] {
            let arrayOfRequiredURL: JSONType = .valueArray(isRequired: true, valueType: .url(isRequired: true))
            XCTAssertEqual(type, arrayOfRequiredURL)
        }
        else { XCTFail() }
    }
    
    func test_mixed_array() {
        let jsonArray = [
            "mixed-array-attribute": [
                "Hello, World!",
                "http://fake-url.com",
                42,
                NSNull(),
                3.14,
                true
            ]
        ]
        let schema = JSONElementSchema.inferred(from: jsonArray, named: dummyName)
        if let type = schema.attributes["mixed-array-attribute"] {
            let arrayOfAnything: JSONType = .valueArray(isRequired: true, valueType: .anything)
            XCTAssertEqual(type, arrayOfAnything)
        }
        else { XCTFail() }
    }
    
    func test_mixed_array_and_empty_array() {
        let jsonArray = [
            [
                "mixed-array-attribute": [
                    "Hello, World!",
                    "http://fake-url.com",
                    42,
                    NSNull(),
                    3.14,
                    true
                ]
            ],
            [
                "mixed-array-attribute": [
                    // Empty array
                ]
            ],
        ]
        let schema = JSONElementSchema.inferred(from: jsonArray, named: dummyName)
        if let type = schema.attributes["mixed-array-attribute"] {
            let arrayOfAnything: JSONType = .valueArray(isRequired: true, valueType: .anything)
            XCTAssertEqual(type, arrayOfAnything)
        }
        else { XCTFail() }
    }
}
