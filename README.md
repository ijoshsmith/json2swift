# json2swift

A macOS command line tool that generates excellent Swift data models based on JSON data.

It takes care of the boring error-prone grunt work of consuming JSON data in your app.

Feel free to modify the code it creates for you.

Written and unit tested in Swift 3.

## Features

- Generates immutable Swift struct definitions
- Generates thread-safe code to create structs from JSON data
- Performs sophisticated type inference to detect URLs, parse dates, etc.
- Creates properties with required values whenever possible, but optional if necessary
- Processes a single JSON file or a directory of JSON files

## How to get it

- Clone the repository, or download the source code
- Build the project
- Open a Finder window to the executable file

![How to find the executable](/screenshots/show_in_finder.png)

- Copy `json2swift` to your desktop
- Open a Terminal window and run this command:
```
cp ~/Desktop/json2swift /usr/local/bin/
```
Verify `json2swift` is in your search path by running this in Terminal:
```
json2swift
```
You should see the tool respond like this:
```
Error: Please provide a JSON file path or directory path.
```
You're ready to go!

## How to use it

Open a Terminal window. Assuming you added the `json2swift` executable to your search path, it doesn't matter what your working directory is.

Pass `json2swift` a JSON file path:
```
json2swift /path/to/some/data_file.json
```
The tool will create a file with the same name as the input file, but with a `.swift` extension. In the example above, the file would be named `data_file.swift`.

Alternatively, you can create Swift data models for all JSON files in a directory via:
```
json2swift /path/to/some/directory/
```

When the tool generates only one Swift file, it includes utility methods that are used for JSON processing in that file. When generating multiple Swift files the utility methods are placed in `JSONUtilities.swift`.

The source code download includes an `example` directory with a `club_sample.json` file so that you can test it out.

## Structure and property names

This tool has no reliable way to create good names for the Swift structs it generates. It follows a simple heuristic to convert names found in JSON attributes to Swift-friendly names, and leaves a `// TODO` comment reminding a developer to rename the structs. 

There are precautions in place to ensure that Swift property names are valid. If the generated property names do not meet your needs, rename them as you see fit. Remember, this tool creates a starting point, feel free to change the code it created for you.

## Date parsing

This tool has special support for JSON attributes with formatted date string values. If you provide a date format "hint" it will generate the necessary code to parse the date strings into `Date` objects using the provided date format. For example:
```json
{
    "birthday": "1945-12-25"
}
```
Before being analyzed by the tool, this JSON should be changed to:
```json
{
    "birthday": "DATE_FORMAT=yyyy-MM-dd"
}
```
The resulting Swift data model struct will have a property defined as:
```swift
let birthday: Date
```
and will also have date parsing code that uses the specified date format.

Tip: For an array with multiple elements, you only need to add the `DATE_FORMAT=` hint to the date attribute of one element.

## Type inference

What sets this JSON-to-Swift converter apart from the others is its type inference capabilities. The net result is Swift code that uses the most appropriate data types possible, based on the analyzed JSON data. This functionality really shines when analyzing an array of elements. 

For example, suppose you have `json2swift` process this JSON data sample:
```json
[
    {
        "nickname": "Johnson Rod",
        "quantity": 8
    },
    {
        "nickname": null,
        "quantity": 10.5
    },
]
```
What should the data types of the `nickname` and `quantity` properties? If this tool only inspected the first element in the array, as other JSON-to-Swift converters do, it would arrive at the wrong answer of `String` and `Int`, respectively. Here is the output of `json2swift` which uses the correct data types for both properties:
```swift
struct RootType: CreatableFromJSON { // TODO: Rename this struct
    let nickname: String?
    let quantity: Double
    init(nickname: String?, quantity: Double) {
        self.nickname = nickname
        self.quantity = quantity
    }
    init?(json: [String: Any]) {
        guard let quantity = Double(json: json, key: "quantity") else { return nil }
        let nickname = json["nickname"] as? String
        self.init(nickname: nickname, quantity: quantity)
    }
}
```
Note that `nickname` is an _optional_ `String` and `quantity` is a `Double` in order to accommodate the values found in both elements of the sample JSON data.

The type inference logic can only perform well if the JSON it analyzes has enough information about the data set. If the generated code doesn't work with all possible values that might be encountered in production, feel free to modify the code as you see fit.
