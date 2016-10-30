//
//  name-translation-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/22/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

class name_translation_tests: XCTestCase {

    // MARK: - Swift names from JSON names
    
    func test_to_swift_struct_name_unchanged_if_valid() {
        let jsonName = "MyStruct"
        XCTAssertEqual(jsonName.toSwiftStructName(), "MyStruct")
    }
    
    func test_to_swift_property_name_unchanged_if_valid() {
        let jsonName = "someProperty"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "someProperty")
    }
    
    func test_to_swift_struct_name_removes_hyphen() {
        let jsonName = "fake-name"
        XCTAssertEqual(jsonName.toSwiftStructName(), "FakeName")
    }
    
    func test_to_swift_property_name_removes_hyphen() {
        let jsonName = "fake-name"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "fakeName")
    }
    
    func test_to_swift_property_name_preserves_trailing_with_underscore() {
        let jsonName = "fake-name_"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "fakeName_")
    }
    
    func test_to_swift_property_name_preserves_trailing_caps() {
        let jsonName = "SomeHTML"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "someHTML")
    }
    
    // MARK: - Avoiding Swift keywords
    
    func test_to_swift_property_name_keyword_has_underscore_prefix() {
        let jsonName = "private"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "_private")
    }
}
