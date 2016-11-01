//
//  json-attribute-merging.swift
//  json2swift
//
//  Created by Joshua Smith on 10/11/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

// MARK: - JSONElementSchema extension
extension JSONElementSchema {
    static func inferredByMergingAttributes(of schemas: [JSONElementSchema], named name: String) -> JSONElementSchema {
        switch schemas.count {
        case 0:  return JSONElementSchema(name: name)
        case 1:  return schemas[0]
        default: return schemas.dropFirst().reduce(schemas[0], merge(schema:withSchema:))
        }
    }
    
    private static func merge(schema: JSONElementSchema, withSchema otherSchema: JSONElementSchema) -> JSONElementSchema {
        return schema.merged(with: otherSchema)
    }
    
    fileprivate func merged(with schema: JSONElementSchema) -> JSONElementSchema {
        let mergedAttributes = JSONType.merge(attributes: attributes, with: schema.attributes)
        return JSONElementSchema(name: name, attributes: mergedAttributes)
    }
}

// MARK: - JSONType extension
extension JSONType {
    fileprivate static func merge(attributes: JSONAttributeMap, with otherAttributes: JSONAttributeMap) -> JSONAttributeMap {
        let attributeNames = Set(Array(attributes.keys) + Array(otherAttributes.keys))
        let mergedAttributes = attributeNames.map { name -> (String, JSONType) in
            let type = attributes[name] ?? .nullable
            let otherType = otherAttributes[name] ?? .nullable
            let compatibleType = type.findCompatibleType(with: otherType)
            return (name, compatibleType)
        }
        return JSONAttributeMap(entries: mergedAttributes)
    }
    
    // This method is internal to enable unit test access.
    internal func findCompatibleType(with type: JSONType) -> JSONType {
        return JSONType.compatible(with: self, and: type)
    }
    
    private static func compatible(with type1: JSONType, and type2: JSONType) -> JSONType {
        switch (type1, type2) {
        // Element
        case let (.element(r1, s1), .element(r2, s2)): return .element(isRequired: r1 && r2, schema: s1.merged(with: s2))
        case let (.element(_,  s),  .nullable):        return .element(isRequired: false,    schema: s)
        case let (.nullable,        .element(_,  s)):  return .element(isRequired: false,    schema: s)

        // Element Array
        case let (.elementArray(r1, s1, n1), .elementArray(r2, s2, n2)): return .elementArray(isRequired: r1 && r2, elementSchema: s1.merged(with: s2), hasNullableElements: n1 || n2)
        case let (.elementArray(_,  s,  n1), .nullable):                 return .elementArray(isRequired: false,    elementSchema: s,                   hasNullableElements: n1)
        case let (.nullable,                 .elementArray(_,  s,  n2)): return .elementArray(isRequired: false,    elementSchema: s,                   hasNullableElements: n2)
        
        // Value Array
        case let (.valueArray(r1, t1), .valueArray(r2, t2)): return .valueArray(isRequired: r1 && r2, valueType: t1.findCompatibleType(with: t2))
        case let (.valueArray(_,  t),  .nullable):           return .valueArray(isRequired: false,    valueType: t)
        case let (.nullable,           .valueArray(_,  t)):  return .valueArray(isRequired: false,    valueType: t)
            
        // Numeric
        case let (.number(r1, fp1), .number(r2, fp2)): return .number(isRequired: r1 && r2, isFloatingPoint: fp1 || fp2)
        case let (.number(_,  fp),  .nullable):        return .number(isRequired: false,    isFloatingPoint: fp)
        case let (.nullable,        .number(_,  fp)):  return .number(isRequired: false,    isFloatingPoint: fp)

        // Text
        case let (.date(r1, f), .date(r2, _)): return .date(  isRequired: r1 && r2, format: f)
        case let (.date(r1, _), .url(r2)):     return .string(isRequired: r1 && r2)
        case let (.date(r1, f), .string(r2)):  return .date(  isRequired: r1 && r2, format: f)
        case let (.date(_,  f), .nullable):    return .date(  isRequired: false, format: f)
        case let (.nullable,    .date(_, f)):  return .date(  isRequired: false, format: f)
        case let (.url(r1),     .date(r2, _)): return .string(isRequired: r1 && r2)
        case let (.url(r1),     .url(r2)):     return .url(   isRequired: r1 && r2)
        case let (.url(r1),     .string(r2)):  return .string(isRequired: r1 && r2)
        case     (.url,         .nullable):    return .url(   isRequired: false)
        case     (.nullable,    .url):         return .url(   isRequired: false)
        case let (.string(r1),  .date(r2, f)): return .date(  isRequired: r1 && r2, format: f)
        case let (.string(r1),  .url(r2)):     return .string(isRequired: r1 && r2)
        case let (.string(r1),  .string(r2)):  return .string(isRequired: r1 && r2)
        case     (.string,      .nullable):    return .string(isRequired: false)
        case     (.nullable,    .string):      return .string(isRequired: false)
            
        // Boolean
        case let (.bool(r1), .bool(r2)): return .bool(isRequired: r1 && r2)
        case     (.bool,     .nullable): return .bool(isRequired: false)
        case     (.nullable, .bool):     return .bool(isRequired: false)
        
        // Nullable (e.g. both attribute values were null)
        case (.nullable, .nullable): return .nullable
            
        // Empty array
        case (.emptyArray,   .emptyArray):   return .emptyArray
        case (.elementArray, .emptyArray):   return type1
        case (.valueArray,   .emptyArray):   return type1
        case (.emptyArray,   .elementArray): return type2
        case (.emptyArray,   .valueArray):   return type2

        // Unrelated types
        default: return .anything
        }
    }
}
