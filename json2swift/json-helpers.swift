//
//  json-helpers.swift
//  json2swift
//
//  Created by Joshua Smith on 10/13/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

extension Dictionary {
    /// Fills a new dictionary with key-value pairs.
    init(entries: [(Key, Value)]) {
        self.init(minimumCapacity: entries.count)
        entries.forEach { self[$0] = $1 }
    }
}
