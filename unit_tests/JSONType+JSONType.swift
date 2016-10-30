//
//  JSONType+JSONType.swift
//  json2swift
//
//  Created by Joshua Smith on 10/14/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

extension JSONType {
    /// A shortcut function that helps create concise unit tests.
    static func +(lhs: JSONType, rhs: JSONType) -> JSONType {
        return lhs.findCompatibleType(for: rhs)
    }
}
