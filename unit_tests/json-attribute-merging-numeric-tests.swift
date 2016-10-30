//
//  json-attribute-merging-numeric-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/11/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let ri = JSONType.number(isRequired: true,  isFloatingPoint: false)
private let oi = JSONType.number(isRequired: false, isFloatingPoint: false)
private let rf = JSONType.number(isRequired: true,  isFloatingPoint: true)
private let of = JSONType.number(isRequired: false, isFloatingPoint: true)

class json_attribute_merging_numeric_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     i = Integral
     f = Floating Point
     */
    
    // MARK: - Both are required
    func test_ri_and_ri_yields_ri() { XCTAssertEqual(ri + ri, ri) }
    func test_ri_and_rf_yields_rf() { XCTAssertEqual(ri + rf, rf) }
    func test_rf_and_ri_yields_rf() { XCTAssertEqual(rf + ri, rf) }
    func test_rf_and_rf_yields_rf() { XCTAssertEqual(rf + rf, rf) }
    
    // MARK: - Both are optional
    func test_oi_and_oi_yields_oi() { XCTAssertEqual(oi + oi, oi) }
    func test_oi_and_of_yields_of() { XCTAssertEqual(oi + of, of) }
    func test_of_and_oi_yields_of() { XCTAssertEqual(of + oi, of) }
    func test_of_and_of_yields_of() { XCTAssertEqual(of + of, of) }
    
    // MARK: - One optional, one required
    func test_oi_and_ri_yields_oi() { XCTAssertEqual(oi + ri, oi) }
    func test_of_and_rf_yields_of() { XCTAssertEqual(of + rf, of) }
    func test_ri_and_oi_yields_oi() { XCTAssertEqual(ri + oi, oi) }
    func test_rf_and_of_yields_of() { XCTAssertEqual(rf + of, of) }
    
    // MARK: - One is a required number, the other is nullable
    func test_ri_and_nullable_yields_oi() { XCTAssertEqual(ri + .nullable, oi) }
    func test_rf_and_nullable_yields_of() { XCTAssertEqual(rf + .nullable, of) }
    func test_nullable_and_ri_yields_oi() { XCTAssertEqual(.nullable + ri, oi) }
    func test_nullable_and_rf_yields_of() { XCTAssertEqual(.nullable + rf, of) }
    
    // MARK: - One is an optional number, the other is nullable
    func test_oi_and_nullable_yields_oi() { XCTAssertEqual(oi + .nullable, oi) }
    func test_of_and_nullable_yields_of() { XCTAssertEqual(of + .nullable, of) }
    func test_nullable_and_oi_yields_oi() { XCTAssertEqual(.nullable + oi, oi) }
    func test_nullable_and_of_yields_of() { XCTAssertEqual(.nullable + of, of) }
}
