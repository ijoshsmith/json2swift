//
//  json-attribute-merging-value-array-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/14/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let rars = JSONType.valueArray(isRequired: true,   valueType: .string(isRequired: true))
private let raos = JSONType.valueArray(isRequired: true,   valueType: .string(isRequired: false))
private let oars = JSONType.valueArray(isRequired: false,  valueType: .string(isRequired: true))
private let oaos = JSONType.valueArray(isRequired: false,  valueType: .string(isRequired: false))

class json_attribute_merging_value_array_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     a = Array
     s = String
     */
    
    // MARK: - Arrays with same value type
    func test_rars_and_rars_yields_rars() { XCTAssertEqual(rars + rars, rars) }
    func test_rars_and_raos_yields_raos() { XCTAssertEqual(rars + raos, raos) }
    func test_raos_and_rars_yields_raos() { XCTAssertEqual(raos + rars, raos) }
    func test_raos_and_raos_yields_raos() { XCTAssertEqual(raos + raos, raos) }
    func test_rars_and_oars_yields_oars() { XCTAssertEqual(rars + oars, oars) }
    func test_rars_and_oaos_yields_oaos() { XCTAssertEqual(rars + oaos, oaos) }
    func test_raos_and_oars_yields_oaos() { XCTAssertEqual(raos + oars, oaos) }
    func test_raos_and_oaos_yields_oaos() { XCTAssertEqual(raos + oaos, oaos) }
    func test_oars_and_rars_yields_oars() { XCTAssertEqual(oars + rars, oars) }
    func test_oars_and_raos_yields_oaos() { XCTAssertEqual(oars + raos, oaos) }
    func test_oaos_and_rars_yields_oaos() { XCTAssertEqual(oaos + rars, oaos) }
    func test_oaos_and_raos_yields_oaos() { XCTAssertEqual(oaos + raos, oaos) }
    func test_oars_and_oars_yields_oars() { XCTAssertEqual(oars + oars, oars) }
    func test_oars_and_oaos_yields_oaos() { XCTAssertEqual(oars + oaos, oaos) }
    func test_oaos_and_oars_yields_oaos() { XCTAssertEqual(oaos + oars, oaos) }
    func test_oaos_and_oaos_yields_oaos() { XCTAssertEqual(oaos + oaos, oaos) }
}
