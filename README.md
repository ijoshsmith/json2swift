# json2swift

![Overview](/images/json2swift.jpg)

A macOS command line tool that generates excellent Swift data models based on JSON data.

It takes care of the boring error-prone grunt work of consuming JSON data in your app.

Feel free to modify the code it creates for you.

Written and unit tested in Swift 4.2.

## Features

- Generates immutable Swift struct definitions
- Generates thread-safe code to create structs from JSON data
- Performs sophisticated type inference to detect URLs, parse dates, etc.
- Creates properties with *required* values whenever possible, but *optional* if necessary
- Processes a single JSON file or a directory of JSON files

## What is code generation?

Using a JSON-to-Swift code generator is very different from using a JSON library API. If you have never worked with a code generator before, check out [this blog post](https://ijoshsmith.com/2016/11/03/swift-json-library-vs-code-generation/) for a quick overview.

## How to get it

- Download the `json2swift` app binary from the latest [release](https://github.com/ijoshsmith/json2swift/releases)
- Copy `json2swift` to your desktop
- Open a Terminal window and run this command to give the app permission to execute:

```
chmod +x ~/Desktop/json2swift
```

Or build the tool in Xcode yourself:

- Clone the repository / Download the source code
- Build the project
- Open a Finder window to the executable file

![How to find the executable](/images/show_in_finder.png)

- Drag `json2swift` from the Finder window to your desktop

## How to install it

Assuming that the `json2swift` app is on your desktop…

Open a Terminal window and run this command:
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
Now that a copy of `json2swift` is in your search path, delete it from your desktop.

You're ready to go! 🎉

## How to use it

Open a Terminal window and pass `json2swift` a JSON file path:
```
json2swift /path/to/some/data_file.json
```
The tool creates a file with the same path as the input file, but with a `.swift` extension. In the example above, the output file is `/path/to/some/data_file.swift`.

Alternatively, you can create Swift data models for all JSON files in a directory via:
```
json2swift /path/to/some/directory/
```
When the tool generates only one Swift file, it includes utility methods that are used for JSON processing in that file. When generating multiple Swift files the utility methods are placed in `JSONUtilities.swift`.

It is possible to pass a 2nd argument to set the root struct name:
```
json2swift /path/to/some/data_file.json app-data
```

The generated struct will then be named `AppData` instead of the default `RootType`.

The source code download includes an `example` directory with a `club_sample.json` file so that you can test it out.

For more info to help get started, check out [Generating Models from JSON with json2swift](https://littlebitesofcocoa.com/283-generating-models-from-json-with-json2swift) by [Jake Marsh](https://github.com/jakemarsh).

## Structure and property names

This tool has no reliable way to create good names for the Swift structs it generates. It follows a simple heuristic to convert names found in JSON attributes to Swift-friendly names, and leaves a `// TODO` comment reminding a developer to rename the structs. 

There are precautions in place to ensure that Swift property names are valid. If the generated property names do not meet your needs, rename them as you see fit. Remember, this tool creates a starting point, feel free to change the code it created for you.

## Date parsing

`json2swift` has special support for JSON attributes with formatted date string values. If you provide a date format "hint" it will generate the necessary code to parse the date strings into `Date` objects using the provided format. For example:
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

*Tip: For an array with multiple elements, add the `DATE_FORMAT=` hint to the date attribute of only one element. It isn't necessary to add the hint to every element.*

## Type inference

What sets this JSON-to-Swift converter apart from the others is its type inference capabilities. The net result is Swift code that uses the most appropriate data types possible. This functionality really shines when analyzing an array of elements. 

For example, suppose `json2swift` analyzes this JSON:
```json
[
    {
        "nickname": "Johnson Rod",
        "quantity": 8
    },
    {
        "nickname": null,
        "quantity": 10.5
    }
]
```
What should be the data types of the `nickname` and `quantity` properties? If this tool only inspected the first element in the array, as other JSON-to-Swift converters do, it would arrive at the wrong answer of `String` and `Int`, respectively. Here is the output of `json2swift` which uses the correct data types for both properties:
```swift
struct RootType: CreatableFromJSON {
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
Note that `nickname` is an _optional_ `String` and `quantity` is a `Double` (not an `Int`) in order to accommodate the values found in both elements of the sample JSON data.

The type inference logic can only perform well if the JSON it analyzes has enough information about the data set. If the generated code doesn't work with all possible values that might be encountered in production, feel free to modify it as you see fit.

## How does it work?

For a high-level overview of how this tool works, check out [this brief article](https://ijoshsmith.com/2016/11/10/json2swift-a-peek-under-the-hood/).
