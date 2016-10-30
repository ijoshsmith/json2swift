//
//  name-translation.swift
//  json2swift
//
//  Created by Joshua Smith on 10/27/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

internal extension String {
    func toSwiftStructName() -> String {
        let name = self.capitalizedWithoutInvalidChars()
        return name.isEmpty ? "DefaultStructName" : name
    }
    
    func toSwiftPropertyName() -> String {
        let name = self.capitalizedWithoutInvalidChars().lowercasedFirstCharacter
        if      name.isEmpty        { return "defaultPropertyName" }
        else if name.isSwiftKeyword { return "_" + name }
        else                        { return name }
    }
    
    private func capitalizedWithoutInvalidChars() -> String {
        let trimmed = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let parts = trimmed.components(separatedBy: invalidSwiftNameCharacters)
        let capitalizedParts = parts.map { $0.uppercasedFirstCharacter }
        return capitalizedParts.joined()
    }
    
    private var uppercasedFirstCharacter: String {
        return self.modifyFirstCharacter(byApplying: { String($0).uppercased() })
    }
    
    private var lowercasedFirstCharacter: String {
        return self.modifyFirstCharacter(byApplying: { String($0).lowercased() })
    }
    
    private func modifyFirstCharacter(byApplying characterTransform: (Character) -> String) -> String {
        guard isEmpty == false else { return self }
        let firstChar = self.characters.first!
        let modifiedFirstChar = characterTransform(firstChar)
        let rangeOfFirstRange = Range(uncheckedBounds: (lower: startIndex, upper: index(after: startIndex)))
        return replacingCharacters(in: rangeOfFirstRange, with: modifiedFirstChar)
    }
    
    private var isSwiftKeyword: Bool {
        return swiftKeywords.contains(self)
    }
}

private let invalidSwiftNameCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_")).inverted
private let swiftKeywords: Set<String> = [
    "Any",
    "as",
    "associatedtype",
    "break",
    "case",
    "catch",
    "class",
    "continue",
    "default",
    "defer",
    "deinit",
    "do",
    "else",
    "enum",
    "extension",
    "fallthrough",
    "false",
    "fileprivate",
    "for",
    "func",
    "guard",
    "if",
    "import",
    "in",
    "init",
    "inout",
    "internal",
    "is",
    "let",
    "nil",
    "open",
    "operator",
    "private",
    "protocol",
    "public",
    "repeat",
    "rethrows",
    "return",
    "Self",
    "self",
    "static",
    "struct",
    "subscript",
    "super",
    "switch",
    "throw",
    "throws",
    "true",
    "try",
    "typealias",
    "var",
    "where",
    "while"
]
