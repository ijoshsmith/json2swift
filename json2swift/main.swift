//
//  main.swift
//  json2swift
//
//  Created by Joshua Smith on 10/13/16.
//  Copyright © 2016 iJoshSmith. All rights reserved.
//

import Foundation

/* 
 * This tool and its documentation is hosted at https://github.com/ijoshsmith/json2swift
 */

// The first argument is the executable's file path, which is irrelevant.
let arguments = Array(CommandLine.arguments.dropFirst())
if let errorMessage = run(with: arguments) {
    print("Error: \(errorMessage)")
    exit(1)
}
else {
    print("Success: Created Swift data model(s)")
    exit(0)
}
