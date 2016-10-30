//
//  json-attribute-merging-boolean-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/11/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let rb = JSONType.bool(isRequired: true)
private let ob = JSONType.bool(isRequired: false)

class json_attribute_merging_boolean_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     b = Boolean
     */
    
    // MARK: - Bool and Bool
    func test_rb_and_rb_yields_rb() { XCTAssertEqual(rb + rb, rb) }
    func test_ob_and_ob_yields_ob() { XCTAssertEqual(ob + ob, ob) }
    func test_ob_and_rb_yields_ob() { XCTAssertEqual(ob + rb, ob) }
    func test_rb_and_ob_yields_ob() { XCTAssertEqual(rb + ob, ob) }
    
    // MARK: - Bool and Nullable
    func test_rb_and_nullable_yields_ob() { XCTAssertEqual(rb + .nullable, ob) }
    func test_ob_and_nullable_yields_ob() { XCTAssertEqual(ob + .nullable, ob) }
    func test_nullable_and_rb_yields_ob() { XCTAssertEqual(.nullable + rb, ob) }
    func test_nullable_and_ob_yields_ob() { XCTAssertEqual(.nullable + ob, ob) }
}
