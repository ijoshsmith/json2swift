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
    
    func test_to_swift_struct_name_removes_underscore() {
        let jsonName = "fake_name"
        XCTAssertEqual(jsonName.toSwiftStructName(), "FakeName")
    }
    
    func test_to_swift_property_name_removes_hyphen() {
        let jsonName = "fake-name"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "fakeName")
    }
    
    func test_to_swift_property_name_removes_leading_underscore() {
        let jsonName = "_foo"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "foo")
    }
    
    func test_to_swift_property_name_removes_trailing_underscore() {
        let jsonName = "foo_"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "foo")
    }
    
    func test_to_swift_property_name_removes_separator_underscore() {
        let jsonName = "foo_bar"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "fooBar")
    }
    
    func test_to_swift_property_name_removes_two_consecutive_separator_underscores() {
        let jsonName = "foo__bar"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "fooBar")
    }
    
    func test_to_swift_property_name_preserves_trailing_caps() {
        let jsonName = "SomeHTML"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "someHTML")
    }
    
    func test_to_swift_property_name_adds_underscore_before_initial_number() {
        let jsonName = "4th_item"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "_4thItem")
    }
    
    // MARK: - Avoiding Swift keywords
    
    func test_to_swift_property_name_keyword_has_underscore_prefix() {
        let jsonName = "private"
        XCTAssertEqual(jsonName.toSwiftPropertyName(), "_private")
    }
}
