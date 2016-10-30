//
//  json-attribute-merging-text-tests.swift
//  json2swift
//
//  Created by Joshua Smith on 10/11/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import XCTest

private let rd = JSONType.date(isRequired: true,  format: "M/d/yyyy")
private let od = JSONType.date(isRequired: false, format: "M/d/yyyy")
private let ru = JSONType.url(isRequired: true)
private let ou = JSONType.url(isRequired: false)
private let rs = JSONType.string(isRequired: true)
private let os = JSONType.string(isRequired: false)

class json_attribute_merging_text_tests: XCTestCase {
    /*
     Method Naming Convention
     r = Required
     o = Optional
     d = Date
     u = URL
     s = String
     */
    
    // MARK: - String and String yields String
    func test_rs_and_rs_yields_rs() { XCTAssertEqual(rs + rs, rs) }
    func test_rs_and_os_yields_os() { XCTAssertEqual(rs + os, os) }
    func test_os_and_rs_yields_os() { XCTAssertEqual(os + rs, os) }
    func test_os_and_os_yields_os() { XCTAssertEqual(os + os, os) }
    
    // MARK: - String and Nullable yields Optional String
    func test_rs_and_nullable_yields_os() { XCTAssertEqual(rs + .nullable, os) }
    func test_os_and_nullable_yields_os() { XCTAssertEqual(os + .nullable, os) }
    func test_nullable_and_rs_yields_os() { XCTAssertEqual(.nullable + rs, os) }
    func test_nullable_and_os_yields_os() { XCTAssertEqual(.nullable + os, os) }
    
    // MARK: - URL and URL yields URL
    func test_ru_and_ru_yields_ru() { XCTAssertEqual(ru + ru, ru) }
    func test_ru_and_ou_yields_ou() { XCTAssertEqual(ru + ou, ou) }
    func test_ou_and_ru_yields_ou() { XCTAssertEqual(ou + ru, ou) }
    func test_ou_and_ou_yields_ou() { XCTAssertEqual(ou + ou, ou) }
    
    // MARK: - URL and Nullable yields Optional URL
    func test_ru_and_nullable_yields_ou() { XCTAssertEqual(ru + .nullable, ou) }
    func test_ou_and_nullable_yields_ou() { XCTAssertEqual(ou + .nullable, ou) }
    func test_nullable_and_ru_yields_ou() { XCTAssertEqual(.nullable + ru, ou) }
    func test_nullable_and_ou_yields_ou() { XCTAssertEqual(.nullable + ou, ou) }
    
    // MARK: - URL and String yields String
    func test_ru_and_rs_yields_rs() { XCTAssertEqual(ru + rs, rs) }
    func test_ru_and_os_yields_os() { XCTAssertEqual(ru + os, os) }
    func test_ou_and_rs_yields_os() { XCTAssertEqual(ou + rs, os) }
    func test_ou_and_os_yields_os() { XCTAssertEqual(ou + os, os) }
    
    // MARK: - Date and Date yields Date
    func test_rd_and_rd_yields_rd() { XCTAssertEqual(rd + rd, rd) }
    func test_rd_and_od_yields_od() { XCTAssertEqual(rd + od, od) }
    func test_od_and_rd_yields_od() { XCTAssertEqual(od + rd, od) }
    func test_od_and_od_yields_od() { XCTAssertEqual(od + od, od) }
    
    // MARK: - Different date formats
    func test_different_date_formats_yields_first_format() {
        let dateTypeA = JSONType.date(isRequired: true, format: "first-format")
        let dateTypeB = JSONType.date(isRequired: true, format: "second-format")
        XCTAssertEqual(dateTypeA + dateTypeB, dateTypeA)
    }
    
    // MARK: - Date and Nullable yields Optional Date
    func test_rd_and_nullable_yields_od() { XCTAssertEqual(rd + .nullable, od) }
    func test_od_and_nullable_yields_od() { XCTAssertEqual(od + .nullable, od) }
    func test_nullable_and_rd_yields_od() { XCTAssertEqual(.nullable + rd, od) }
    func test_nullable_and_od_yields_od() { XCTAssertEqual(.nullable + od, od) }

    // MARK: - Date and URL yields String
    func test_rd_and_ru_yields_rs() { XCTAssertEqual(rd + ru, rs) }
    func test_rd_and_ou_yields_os() { XCTAssertEqual(rd + ou, os) }
    func test_od_and_ru_yields_os() { XCTAssertEqual(od + ru, os) }
    func test_od_and_ou_yields_os() { XCTAssertEqual(od + ou, os) }
    
    // MARK: - Date and String yields Date (to allow for only one attribute to need a DATE_FORMAT)
    func test_rd_and_rs_yields_rd() { XCTAssertEqual(rd + rs, rd) }
    func test_rd_and_os_yields_od() { XCTAssertEqual(rd + os, od) }
    func test_od_and_rs_yields_od() { XCTAssertEqual(od + rs, od) }
    func test_od_and_os_yields_od() { XCTAssertEqual(od + os, od) }
}
