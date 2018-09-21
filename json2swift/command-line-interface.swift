//
//  command-line-interface.swift
//  json2swift
//
//  Created by Joshua Smith on 10/28/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

typealias ErrorMessage = String

func run(with arguments: [String]) -> ErrorMessage? {
    guard arguments.isEmpty == false else { return "Please provide a JSON file path or directory path." }
    
    let path = (arguments[0] as NSString).resolvingSymlinksInPath
    
    var isDirectory: ObjCBool = false
    guard FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) else { return "No such file or directory exists." }
    
    let jsonFilePaths: [String]
    if isDirectory.boolValue {
        guard let filePaths = findJSONFilePaths(in: path) else { return "Unable to read contents of directory." }
        guard filePaths.isEmpty == false else { return "The directory does not contain any JSON files." }
        jsonFilePaths = filePaths
    }
    else {
        jsonFilePaths = [path]
    }
    
    let jsonUtilitiesFilePath: String? = jsonFilePaths.count > 1
        ? (path as NSString).appendingPathComponent("JSONUtilities.swift")
        : nil

    let shouldIncludeUtils = jsonUtilitiesFilePath == nil
    let rootType = arguments.count >= 2 ? arguments[1] : "root-type"
    for jsonFilePath in jsonFilePaths {
        if let errorMessage = generateSwiftFileBasedOnJSON(inFile: jsonFilePath, includeJSONUtilities: shouldIncludeUtils, rootTypeName: rootType) {
            return errorMessage
        }
    }
    
    if let jsonUtilitiesFilePath = jsonUtilitiesFilePath {
        guard writeJSONUtilitiesFile(to: jsonUtilitiesFilePath) else { return "Unable to write JSON utilities file to \(jsonUtilitiesFilePath)" }
    }
    
    return nil
}


// MARK: - Finding JSON files in directory
private func findJSONFilePaths(in directory: String) -> [String]? {
    guard let jsonFileNames = findJSONFileNames(in: directory) else { return nil }
    return resolveAbsolutePaths(for: jsonFileNames, inDirectory: directory)
}

private func findJSONFileNames(in directory: String) -> [String]? {
    let isJSONFile: (String) -> Bool = { $0.lowercased().hasSuffix(".json") }
    do    { return try FileManager.default.contentsOfDirectory(atPath: directory).filter(isJSONFile) }
    catch { return nil }
}

private func resolveAbsolutePaths(for jsonFileNames: [String], inDirectory directory: String) -> [String] {
    return jsonFileNames.map { (directory as NSString).appendingPathComponent($0) }
}


// MARK: - Generating Swift file based on JSON
private func generateSwiftFileBasedOnJSON(inFile jsonFilePath: String, includeJSONUtilities: Bool, rootTypeName: String) -> ErrorMessage? {
    let url = URL(fileURLWithPath: jsonFilePath)
    let data: Data
    do    { data = try Data(contentsOf: url) }
    catch { return "Unable to read file: \(jsonFilePath)" }
    
    let jsonObject: Any
    do    { jsonObject = try JSONSerialization.jsonObject(with: data, options: []) }
    catch { return "File does not contain valid JSON: \(jsonFilePath)" }
    
    let jsonSchema: JSONElementSchema
    if      let jsonElement = jsonObject as? JSONElement   { jsonSchema = JSONElementSchema.inferred(from: jsonElement, named: rootTypeName) }
    else if let jsonArray   = jsonObject as? [JSONElement] { jsonSchema = JSONElementSchema.inferred(from: jsonArray,   named: rootTypeName) }
    else                                                   { return "Unsupported JSON format: must be a dictionary or array of dictionaries." }
    
    let swiftStruct = SwiftStruct.create(from: jsonSchema)
    let swiftCode = includeJSONUtilities
        ? SwiftCodeGenerator.generateCodeWithJSONUtilities(for: swiftStruct)
        : SwiftCodeGenerator.generateCode(for: swiftStruct)
    
    let swiftFilePath = (jsonFilePath as NSString).deletingPathExtension + ".swift"
    guard write(swiftCode: swiftCode, toFile: swiftFilePath) else { return "Unable to write to file: \(swiftFilePath)" }
    
    return nil
}

private func writeJSONUtilitiesFile(to filePath: String) -> Bool {
    let jsonUtilitiesCode = SwiftCodeGenerator.generateJSONUtilities()
    return write(swiftCode: jsonUtilitiesCode, toFile: filePath)
}

private func write(swiftCode: String, toFile filePath: String) -> Bool {
    do {
        try swiftCode.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        return true
    }
    catch {
        return false
    }
}
