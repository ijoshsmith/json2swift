//
//  json-attribute-merging-empty-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/29/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let schemaX = JSONElementSchema(name: "schema", attributes: [:])

private let rax = JSONType.elementArray(isRequired: true,  elementSchema: schemaX, hasNullableElements: false)
private let oax = JSONType.elementArray(isRequired: false, elementSchema: schemaX, hasNullableElements: false)

private let ras = JSONType.valueArray(isRequired: true,  valueType: .string(isRequired: true))
private let oas = JSONType.valueArray(isRequired: false, valueType: .string(isRequired: true))

class json_attribute_merging_empty_array_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     a = Array
     x = Schema X
     s = String
     */
 
    // MARK: - Empty Array and Empty Array
    func test_emptyArray_and_emptyArray_yields_emptyArray() { XCTAssertEqual(.emptyArray + .emptyArray, .emptyArray) }
    
    // MARK: - Element Array and Empty Array
    func test_rax_and_emptyArray_yields_rax() { XCTAssertEqual(rax + .emptyArray, rax) }
    func test_oax_and_emptyArray_yields_oax() { XCTAssertEqual(oax + .emptyArray, oax) }
    func test_emptyArray_and_rax_yields_rax() { XCTAssertEqual(.emptyArray + rax, rax) }
    func test_emptyArray_and_oax_yields_oax() { XCTAssertEqual(.emptyArray + oax, oax) }
    
    // MARK: - Value Array and Empty Array
    func test_ras_and_emptyArray_yields_ras() { XCTAssertEqual(ras + .emptyArray, ras) }
    func test_oas_and_emptyArray_yields_oas() { XCTAssertEqual(oas + .emptyArray, oas) }
    func test_emptyArray_and_ras_yields_ras() { XCTAssertEqual(.emptyArray + ras, ras) }
    func test_emptyArray_and_oas_yields_oas() { XCTAssertEqual(.emptyArray + oas, oas) }
}
