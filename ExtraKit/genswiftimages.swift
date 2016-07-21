#!/usr/bin/env xcrun --sdk macosx swift

import Foundation

extension String {
	mutating func addLine(line: String = "", tabs: Int = 0) {
		if tabs > 0 {
			self += String(count: tabs, repeatedValue: Character("\t"))
		}
		self += "\(line)\n"
	}
}

let outputPath = Process.arguments[1]

var outputString = ""
outputString.addLine("// autogenerated by genswiftimages.swift\n")
outputString.addLine("import UIKit\n")
outputString.addLine("enum Images: String {")

Process.arguments[2..<Process.arguments.count].forEach {
	let url = NSURL(fileURLWithPath: $0)
	outputString.addLine("case \(url.URLByDeletingPathExtension!.lastPathComponent!.stringByReplacingOccurrencesOfString("-", withString:"__"))", tabs:1)
}
outputString.addLine("")
outputString.addLine("var image: UIImage? {", tabs: 1)
outputString.addLine("return UIImage(named: rawValue.stringByReplacingOccurrencesOfString(\"__\", withString:\"-\"))", tabs: 2)
outputString.addLine("}", tabs: 1)
outputString.addLine("}")

print(outputString)
try! outputString.writeToFile(outputPath, atomically: true, encoding: NSUTF8StringEncoding)
