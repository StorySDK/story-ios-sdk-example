#!/usr/bin/env swift

import Foundation
//import StorySDK


//print("Test UIKit")


#if canImport(UIKit)
    //import UIKit
    print("Test UIKit")
#else
    //import Cocoa
    print("Test Cocoa")
#endif

/*let script = CommandLine.arguments[0]
print("Script:", script)


let inputArgs = CommandLine.arguments.dropFirst()
print("Number of arguments:", inputArgs.count)

print(StorySDK.shared.configuration)

print("Arguments:")
for arg in inputArgs {
    print("-", arg)
}*/
