//
//  ProjectSettingsModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import Foundation

class ProjectSettingsModel: Codable {
    var projectName: String
    var apiKey: String
    
    init(projectName: String, apiKey: String) {
        self.projectName = projectName
        self.apiKey = apiKey
    }
}
