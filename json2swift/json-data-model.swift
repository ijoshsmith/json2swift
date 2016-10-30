//
//  json-data-model.swift
//  json2swift
//
//  Created by Joshua Smith on 10/10/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

/// The prefix to use on a sample JSON attribute whose value is a date string.
/// This provides a hint to the JSON analyzer that the corresponding property is a Date.
/// For example, use "DATE_FORMAT=MM/dd/yyyy" for an attribute whose values are like "12/25/2016".
let dateFormatPrefix = "DATE_FORMAT="

typealias JSONValue = Any
typealias JSONElement = [String: JSONValue]

// MARK: - JSONType
indirect enum JSONType {
    case element(     isRequired: Bool, schema: JSONElementSchema)
    case elementArray(isRequired: Bool, elementSchema: JSONElementSchema, hasNullableElements: Bool)
    case valueArray(  isRequired: Bool, valueType: JSONType)
    case number(      isRequired: Bool, isFloatingPoint: Bool)
    case date(        isRequired: Bool, format: String)
    case url(         isRequired: Bool)
    case string(      isRequired: Bool)
    case bool(        isRequired: Bool)
    case nullable   // For an attribute that is missing or has a null value.
    case anything   // For an attribute with multiple values of unrelated types.
    case emptyArray // For an attribute that contains an empty array.
}

extension JSONType {
    var isRequired: Bool {
        switch self {
        case let .element     (isRequired, _):    return isRequired
        case let .elementArray(isRequired, _, _): return isRequired
        case let .valueArray  (isRequired, _):    return isRequired
        case let .number      (isRequired, _):    return isRequired
        case let .date        (isRequired, _):    return isRequired
        case let .url         (isRequired):       return isRequired
        case let .string      (isRequired):       return isRequired
        case let .bool        (isRequired):       return isRequired
        case     .nullable, .anything:            return false
        case     .emptyArray:                     return true
        }
    }
    
    var jsonElementSchema: JSONElementSchema? {
        switch self {
        case let .element(_, schema):                return schema
        case let .elementArray(_, elementSchema, _): return elementSchema
        default:                                     return nil
        }
    }
}

extension JSONType: Equatable {
    static func ==(lhs: JSONType, rhs: JSONType) -> Bool {
        switch (lhs, rhs) {
        case let (.element(r1, a),          .element(r2, b)):          return r1 == r2 && a == b
        case let (.elementArray(r1, a, n1), .elementArray(r2, b, n2)): return r1 == r2 && a == b && n1 == n2
        case let (.valueArray(r1, a),       .valueArray(r2, b)):       return r1 == r2 && a == b
        case let (.number(r1, a),           .number(r2, b)):           return r1 == r2 && a == b
        case let (.date(r1, a),             .date(r2, b)):             return r1 == r2 && a == b
        case let (.url(r1),                 .url(r2)):                 return r1 == r2
        case let (.string(r1),              .string(r2)):              return r1 == r2
        case let (.bool(r1),                .bool(r2)):                return r1 == r2
        case     (.nullable,                .nullable):                return true
        case     (.anything,                .anything):                return true
        case     (.emptyArray,              .emptyArray):              return true
        default:                                                       return false
        }
    }
}

// MARK: - JSONElementSchema
typealias JSONAttributeMap = [String: JSONType]
struct JSONElementSchema {
    let name: String
    let attributes: JSONAttributeMap
    
    init(name: String, attributes: JSONAttributeMap = [:]) {
        self.name = name
        self.attributes = attributes
    }
}

extension JSONElementSchema: Equatable {}
func ==(lhs: JSONElementSchema, rhs: JSONElementSchema) -> Bool {
    return lhs.name == rhs.name && lhs.attributes == rhs.attributes
}
