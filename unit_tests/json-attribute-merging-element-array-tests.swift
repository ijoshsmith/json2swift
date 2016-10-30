//
//  json-attribute-merging-element-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/12/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let stringAttributeName = "string-attribute"
private let boolAttributeName   = "bool-attribute"
private let dateAttributeName   = "date-attribute"
private let schemaX = JSONElementSchema(name: "schema", attributes: [
    stringAttributeName: .string(isRequired: false),
    boolAttributeName:   .bool(  isRequired: true),
    dateAttributeName:   .date(  isRequired: true, format: "MM/dd/yyyy")
    ])
private let schemaY = JSONElementSchema(name: "schema", attributes: [
    stringAttributeName: .string(isRequired: true),
    boolAttributeName:   .bool(  isRequired: false),
    dateAttributeName:   .date(  isRequired: true, format: "MM/dd/yyyy")
    ])
private let schemaM = JSONElementSchema(name: "schema", attributes: [
    stringAttributeName: .string(isRequired: false),
    boolAttributeName:   .bool(  isRequired: false),
    dateAttributeName:   .date(  isRequired: true, format: "MM/dd/yyyy")
    ])
private let rax = JSONType.elementArray(isRequired: true,  elementSchema: schemaX, hasNullableElements: false)
private let oax = JSONType.elementArray(isRequired: false, elementSchema: schemaX, hasNullableElements: false)
private let ray = JSONType.elementArray(isRequired: true,  elementSchema: schemaY, hasNullableElements: false)
private let oay = JSONType.elementArray(isRequired: false, elementSchema: schemaY, hasNullableElements: false)
private let ram = JSONType.elementArray(isRequired: true,  elementSchema: schemaM, hasNullableElements: false)
private let oam = JSONType.elementArray(isRequired: false, elementSchema: schemaM, hasNullableElements: false)

private let oaxn = JSONType.elementArray(isRequired: false, elementSchema: schemaX, hasNullableElements: true)

class json_attribute_merging_element_array_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     n = Nullable Elements
     a = Array
     x = Schema X
     y = Schema Y
     m = Merged Schema (X + Y)
     */
    
    // MARK: - Array and Nullable
    func test_ra_and_nullable_yields_oa() { XCTAssertEqual(rax + .nullable, oaxn) }
    func test_oa_and_nullable_yields_oa() { XCTAssertEqual(oax + .nullable, oaxn) }
    func test_nullable_and_ra_yields_oa() { XCTAssertEqual(.nullable + rax, oaxn) }
    func test_nullable_and_oa_yields_oa() { XCTAssertEqual(.nullable + oax, oaxn) }
    
    // MARK: - Arrays with same schema
    func test_ra_and_ra_yields_ra() { XCTAssertEqual(rax + rax, rax) }
    func test_ra_and_oa_yields_oa() { XCTAssertEqual(rax + oax, oax) }
    func test_oa_and_ra_yields_oa() { XCTAssertEqual(oax + rax, oax) }
    func test_oa_and_oa_yields_oa() { XCTAssertEqual(oax + oax, oax) }
    
    // MARK: - Arrays with different schemas
    func test_rax_and_ray_yields_ram() { XCTAssertEqual(rax + ray, ram) }
    func test_ray_and_rax_yields_ram() { XCTAssertEqual(ray + rax, ram) }
    func test_rax_and_oay_yields_oam() { XCTAssertEqual(rax + oay, oam) }
    func test_ray_and_oax_yields_oam() { XCTAssertEqual(ray + oax, oam) }
    func test_oax_and_ray_yields_oam() { XCTAssertEqual(oax + ray, oam) }
    func test_oay_and_rax_yields_oam() { XCTAssertEqual(oay + rax, oam) }
    func test_oax_and_oay_yields_oam() { XCTAssertEqual(oax + oay, oam) }
    func test_oay_and_oax_yields_oam() { XCTAssertEqual(oay + oax, oam) }
}
