//
//  json-schema-inference.swift
//  json2swift
//
//  Created by Joshua Smith on 10/10/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

// MARK: - JSONElementSchema extension
extension JSONElementSchema {
    static func inferred(from jsonElementArray: [JSONElement], named name: String) -> JSONElementSchema {
        let jsonElement = [name: jsonElementArray]
        let schema = JSONElementSchema.inferred(from: jsonElement, named: name)
        let (_, attributeType) = schema.attributes.first!
        switch attributeType {
        case .elementArray(_, let elementSchema, _): return elementSchema
        case .emptyArray:                            return JSONElementSchema(name: name)
        default:                                     abort()
        }
    }
    
    static func inferred(from jsonElement: JSONElement, named name: String) -> JSONElementSchema {
        let attributes = createAttributeMap(for: jsonElement)
        return JSONElementSchema(name: name, attributes: attributes)
    }

    private static func createAttributeMap(for jsonElement: JSONElement) -> JSONAttributeMap {
        let attributes = jsonElement.map { (name, value) -> (String, JSONType) in
            let type = JSONType.inferType(of: value, named: name)
            return (name, type)
        }
        return JSONAttributeMap(entries: attributes)
    }
}

// MARK: - JSONType extension
fileprivate extension JSONType {
    static func inferType(of value: Any, named name: String) -> JSONType {
        switch value {
        case let element as JSONElement: return inferType(of: element,  named: name)
        case let array   as [Any]:       return inferType(of: array, named: name)
        case let nsValue as NSValue:     return inferType(of: nsValue)
        case let string  as String:      return inferType(of: string)
        case             is NSNull:      return .nullable
        default:
            assertionFailure("Unexpected type of value in JSON: \(value)")
            abort()
        }
    }
    
    private static func inferType(of element: JSONElement, named name: String) -> JSONType {
        let schema = JSONElementSchema.inferred(from: element, named: name)
        return .element(isRequired: true, schema: schema)
    }
    
    private static func inferType(of array: [Any], named name: String) -> JSONType {
        let arrayWithoutNulls = array.filter { $0 is NSNull == false }
        if let elements = arrayWithoutNulls as? [JSONElement] {
            let hasNullableElements = arrayWithoutNulls.count < array.count
            return inferType(ofElementArray: elements, named: name, hasNullableElements: hasNullableElements)
        }
        else {
            return inferType(ofValueArray: array, named: name)
        }
    }
    
    private static func inferType(ofElementArray elementArray: [JSONElement], named name: String, hasNullableElements: Bool) -> JSONType {
        if elementArray.isEmpty { return .emptyArray }
        let schemas = elementArray.map { jsonElement in JSONElementSchema.inferred(from: jsonElement, named: name) }
        let mergedSchema = JSONElementSchema.inferredByMergingAttributes(of: schemas, named: name)
        return .elementArray(isRequired: true, elementSchema: mergedSchema, hasNullableElements: hasNullableElements)
    }
    
    private static func inferType(ofValueArray valueArray: [JSONValue], named name: String) -> JSONType {
        if valueArray.isEmpty { return .emptyArray }
        let valueType = inferValueType(of: valueArray, named: name)
        return .valueArray(isRequired: true, valueType: valueType)
    }
    
    private static func inferValueType(of values: [JSONValue], named name: String) -> JSONType {
        let types = values.map { inferType(of: $0, named: name) }
        switch types.count {
        case 0:  abort() // Should never introspect an empty array.
        case 1:  return types[0]
        default: return types.dropFirst().reduce(types[0]) { $0.findCompatibleType(with: $1) }
        }
    }
    
    private static func inferType(of nsValue: NSValue) -> JSONType {
        if nsValue.isBoolType {
            return .bool(isRequired: true)
        }
        else {
            return .number(isRequired: true, isFloatingPoint: nsValue.isFloatType)
        }
    }
    
    private static func inferType(of string: String) -> JSONType {
        if let dateFormat = string.extractDateFormat() {
            return .date(isRequired: true, format: dateFormat)
        }
        else if string.isWebAddress {
            return .url(isRequired: true)
        }
        else {
            return .string(isRequired: true)
        }
    }
}

// MARK: - String extension
fileprivate extension String {
    func extractDateFormat() -> String? {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return String.extractDateFormat(from: trimmed)
    }
    
    private static func extractDateFormat(from string: String) -> String? {
        guard let prefixRange = string.range(of: dateFormatPrefix) else { return nil }
        guard prefixRange.lowerBound == string.startIndex else { return nil }
        return string.substring(from: prefixRange.upperBound)
    }
    
    var isWebAddress: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil && url.host != nil
    }
}

// MARK: - NSValue extension
fileprivate extension NSValue {
    var isBoolType:  Bool { return CFNumberGetType(self as! CFNumber) == CFNumberType.charType }
    var isFloatType: Bool { return CFNumberIsFloatType(self as! CFNumber) }
}
