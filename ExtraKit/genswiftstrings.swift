#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

var outputString = "// autogenerated by genswiftstrings.swift\n\nimport Foundation\n\n"

func generateStringsSourceFile(stringsPath: String) {
	let tmpPath = "/var/tmp/strings.plist"
	system("plutil -convert binary1 \(stringsPath) -o \(tmpPath)")
	guard let stringsDict = NSDictionary(contentsOfFile: tmpPath) else { return }
	
	outputString += "enum Strings: String\n{\n"

	stringsDict.allKeys.forEach {
		outputString += "\tcase \($0)\n"
	}
	outputString += "}\n"
}

func generateFormatStringsSourceFile(stringsDictPath: String) {
	guard let stringsDict = NSDictionary(contentsOfFile: stringsDictPath) else { return }
	
	outputString += "\nenum FormatStrings: String\n{\n"

	stringsDict.allKeys.forEach {
		outputString += "\tcase \($0)\n"
	}
	outputString += "}\n"
}

let outputPath = Process.arguments[2]

generateStringsSourceFile(Process.arguments[1])

if Process.arguments.count >= 4 {
	generateFormatStringsSourceFile(Process.arguments[3])
}

try! outputString.writeToFile(outputPath, atomically: true, encoding: NSUTF8StringEncoding)
