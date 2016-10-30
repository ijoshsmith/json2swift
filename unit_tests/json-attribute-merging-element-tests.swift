//
//  json-attribute-merging-element-tests.swift
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
private let rex = JSONType.element(isRequired: true,  schema: schemaX)
private let oex = JSONType.element(isRequired: false, schema: schemaX)
private let rey = JSONType.element(isRequired: true,  schema: schemaY)
private let oey = JSONType.element(isRequired: false, schema: schemaY)
private let rem = JSONType.element(isRequired: true,  schema: schemaM)
private let oem = JSONType.element(isRequired: false, schema: schemaM)

class json_attribute_merging_element_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     e = Element
     x = Schema X
     y = Schema Y
     m = Merged Schema (X + Y)
     */
    
    // MARK: - Element and Nullable
    func test_re_and_nullable_yields_oe() { XCTAssertEqual(rex + .nullable, oex) }
    func test_oe_and_nullable_yields_oe() { XCTAssertEqual(oex + .nullable, oex) }
    func test_nullable_and_re_yields_oe() { XCTAssertEqual(.nullable + rex, oex) }
    func test_nullable_and_oe_yields_oe() { XCTAssertEqual(.nullable + oex, oex) }
    
    // MARK: - Elements with same schema
    func test_re_and_re_yields_re() { XCTAssertEqual(rex + rex, rex) }
    func test_re_and_oe_yields_oe() { XCTAssertEqual(rex + oex, oex) }
    func test_oe_and_re_yields_oe() { XCTAssertEqual(oex + rex, oex) }
    func test_oe_and_oe_yields_oe() { XCTAssertEqual(oex + oex, oex) }
    
    // MARK: - Elements with different schemas
    func test_rex_and_rey_yields_rem() { XCTAssertEqual(rex + rey, rem) }
    func test_rey_and_rex_yields_rem() { XCTAssertEqual(rey + rex, rem) }
    func test_rex_and_oey_yields_oem() { XCTAssertEqual(rex + oey, oem) }
    func test_rey_and_oex_yields_oem() { XCTAssertEqual(rey + oex, oem) }
    func test_oex_and_rey_yields_oem() { XCTAssertEqual(oex + rey, oem) }
    func test_oey_and_rex_yields_oem() { XCTAssertEqual(oey + rex, oem) }
    func test_oex_and_oey_yields_oem() { XCTAssertEqual(oex + oey, oem) }
    func test_oey_and_oex_yields_oem() { XCTAssertEqual(oey + oex, oem) }
}
