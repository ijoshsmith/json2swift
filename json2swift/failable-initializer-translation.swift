//
//  failable-initializer-translation.swift
//  json2swift
//
//  Created by Joshua Smith on 10/28/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

// MARK: - JSONElementSchema --> SwiftFailableInitializer
internal extension SwiftFailableInitializer {
    static func create(forStructBasedOn jsonElementSchema: JSONElementSchema) -> SwiftFailableInitializer {
        let attributeMap = jsonElementSchema.attributes
        let allAttributeNames = Set(attributeMap.keys)
        let requiredAttributeNames = allAttributeNames.filter { attributeMap[$0]!.isRequired }
        let optionalAttributeNames = allAttributeNames.subtracting(requiredAttributeNames)
        let requiredTransformations: [TransformationFromJSON] = requiredAttributeNames.map {
            TransformationFromJSON.create(forAttributeNamed: $0, inAttributeMap: attributeMap)
        }
        let optionalTransformations: [TransformationFromJSON] = optionalAttributeNames.map {
            TransformationFromJSON.create(forAttributeNamed: $0, inAttributeMap: attributeMap)
        }
        return SwiftFailableInitializer(requiredTransformations: requiredTransformations,
                                        optionalTransformations: optionalTransformations)
    }
}

// MARK: - JSON attribute --> TransformationFromJSON
fileprivate extension TransformationFromJSON {
    static func create(forAttributeNamed attributeName: String, inAttributeMap attributeMap: JSONAttributeMap) -> TransformationFromJSON {
        let propertyName = attributeName.toSwiftPropertyName()
        let jsonType = attributeMap[attributeName]!
        switch jsonType {
        case let .element(_, schema):
            let swiftStruct = SwiftStruct.create(from: schema)
            return TransformationFromJSON.toCustomStruct(attributeName: attributeName,
                                                         propertyName: propertyName,
                                                         type: swiftStruct)
            
        case let .elementArray(_, elementSchema, hasNullableElements):
            let swiftStruct = SwiftStruct.create(from: elementSchema)
            return TransformationFromJSON.toCustomStructArray(attributeName: attributeName,
                                                              propertyName: propertyName,
                                                              elementType: swiftStruct,
                                                              hasOptionalElements: hasNullableElements)

        case let .valueArray(_, valueType):
            let elementType = SwiftPrimitiveValueType.create(from: valueType)
            let hasOptionalElements = valueType.isRequired == false
            return TransformationFromJSON.toPrimitiveValueArray(attributeName: attributeName,
                                                                propertyName: propertyName,
                                                                elementType: elementType,
                                                                hasOptionalElements: hasOptionalElements)
            
        default:
            let valueType = SwiftPrimitiveValueType.create(from: jsonType)
            return TransformationFromJSON.toPrimitiveValue(attributeName: attributeName,
                                                           propertyName: propertyName,
                                                           type: valueType)
        }
    }
}

// MARK: - JSONType --> SwiftPrimitiveValueType
fileprivate extension SwiftPrimitiveValueType {
    static func create(from jsonType: JSONType) -> SwiftPrimitiveValueType {
        switch jsonType {
        case .anything,
             .element,
             .elementArray,
             .emptyArray,
             .nullable,
             .valueArray:                     return .any
        case .number(_, let isFloatingPoint): return isFloatingPoint ? .double : .int
        case .date(_, let format):            return .date(format: format)
        case .url:                            return .url
        case .string:                         return .string
        case .bool:                           return .bool
        }
    }
}
