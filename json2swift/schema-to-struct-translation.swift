//
//  schema-to-struct-translation.swift
//  json2swift
//
//  Created by Joshua Smith on 10/22/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

// MARK: - JSONElementSchema --> SwiftStruct
internal extension SwiftStruct {
    static func create(from jsonElementSchema: JSONElementSchema) -> SwiftStruct {
        let name = jsonElementSchema.name.toSwiftStructName()
        let properties = SwiftProperty.createProperties(forStructBasedOn: jsonElementSchema)
        let parameters = SwiftParameter.createParameters(for: properties)
        let initializer = SwiftInitializer(parameters: parameters)
        let failableInitializer = SwiftFailableInitializer.create(forStructBasedOn: jsonElementSchema)
        let nestedStructs = createNestedStructs(forElementsIn: jsonElementSchema)
        return SwiftStruct(name: name,
                           properties: properties,
                           initializer: initializer,
                           failableInitializer: failableInitializer,
                           nestedStructs: nestedStructs)
    }
    
    private static func createNestedStructs(forElementsIn jsonElementSchema: JSONElementSchema) -> [SwiftStruct] {
        return jsonElementSchema.attributes.values.flatMap(SwiftStruct.tryToCreate(fromJSONType:))
    }
    
    private static func tryToCreate(fromJSONType jsonType: JSONType) -> SwiftStruct? {
        if let schema = jsonType.jsonElementSchema {
            return SwiftStruct.create(from: schema)
        }
        else {
            return nil
        }
    }
}

// MARK: - JSONElementSchema --> SwiftProperty
fileprivate extension SwiftProperty {
    static func createProperties(forStructBasedOn jsonElementSchema: JSONElementSchema) -> [SwiftProperty] {
        return jsonElementSchema.attributes.map { (name, type) in
            createProperty(basedOnJSONAttribute: name, and: type)
        }
    }
    
    private static func createProperty(basedOnJSONAttribute attributeName: String, and attributeType: JSONType) -> SwiftProperty {
        let propertyName = attributeName.toSwiftPropertyName()
        let propertyType = SwiftType.createType(from: attributeType)
        return SwiftProperty(name: propertyName, type: propertyType)
    }
}

// MARK: - SwiftProperty --> SwiftParameter
fileprivate extension SwiftParameter {
    static func createParameters(for properties: [SwiftProperty]) -> [SwiftParameter] {
        return properties.map { SwiftParameter(name: $0.name, type: $0.type) }
    }
}

// MARK: - JSONType --> SwiftType
fileprivate extension SwiftType {
    static func createType(from jsonType: JSONType) -> SwiftType {
        let typeName   = jsonType.swiftTypeName
        let isOptional = jsonType.isRequired == false
        return SwiftType(name: typeName, isOptional: isOptional)
    }
}

// MARK: - JSONType --> Swift type name
fileprivate extension JSONType {
    var swiftTypeName: String {
        switch self {
        case let .element(_, schema):                                  return schema.name.toSwiftStructName()
        case let .elementArray(_, elementSchema, hasNullableElements): return nameForArray(of: elementSchema, hasNullableElements)
        case let .valueArray(_, valueType):                            return nameForArray(of: valueType)
        case let .number(_, isFloatingPoint):                          return isFloatingPoint ? "Double" : "Int"
        case     .date:                                                return "Date"
        case     .url:                                                 return "URL"
        case     .string:                                              return "String"
        case     .bool:                                                return "Bool"
        case     .nullable, .anything:                                 return "Any"
        case     .emptyArray:                                          return "[Any?]"
        }
    }
    
    private func nameForArray(of schema: JSONElementSchema, _ hasOptionalElements: Bool) -> String {
        return nameForArray(of: schema.name.toSwiftStructName(), hasOptionalElements: hasOptionalElements)
    }
    
    private func nameForArray(of valueType: JSONType) -> String {
        return nameForArray(of: valueType.swiftTypeName, hasOptionalElements: valueType.isRequired == false)
    }
    
    private func nameForArray(of typeName: String, hasOptionalElements: Bool) -> String {
        let fullTypeName = hasOptionalElements
            ? typeName + "?"
            : typeName
        return "[" + fullTypeName + "]"
    }
}
