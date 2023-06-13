//
//  AppConfig.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 13.05.2023.
//

import Foundation
import StorySDK

struct AppConfig {
    static let storySdkAPIUrl = "https://api.diffapp.link/sdk/v1/"
    //static let defaultAppAPIKey = "d75574ef-a2f2-4b1b-8550-8f93f40cf281"
    static let defaultAppAPIKey = "24204ab4-d0fd-4676-aa23-b118b2bb926a"
    
    static let defaultProject = ProjectSettingsModel(projectName: "Test 1",
                                                     apiKey: AppConfig.defaultAppAPIKey)
}
