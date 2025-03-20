//
//  AppLauncher.swift
//  Lumiform
//
//  Created by Patricio Guzman on 20/03/2025.
//

import Foundation

@main
struct AppLauncher {
    
    static func main() throws {
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
            || NSClassFromString("XCTestCase") != nil {
            TestApp.main()
        } else {
            LumiformApp.main()
        }
    }
    
}
