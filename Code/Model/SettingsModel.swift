//
//  SettingsModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import Foundation
import StorySDK

protocol SettingsModelDelegate: AnyObject {
    func didChange()
    func didSelect(project: ProjectSettingsModel)
}

class SettingsModel {
    var listOfProjects: [ProjectSettingsModel]
    var action: String = "+ Add project"
    var count: Int {
        return listOfProjects.count + 1
    }
    
    var isEmpty: Bool {
        return listOfProjects.isEmpty
    }
    
    var selected: ProjectSettingsModel? {
        didSet {
            if let selected = selected {
                delegate?.didSelect(project: selected)
            }
        }
    }
    
    weak var delegate: SettingsModelDelegate?
    
    init(list: [ProjectSettingsModel]) {
        self.listOfProjects = list
        self.selected = list.first
    }
    
    func addToken(value: String?) -> Bool {
        guard let value = value else { return false }
        guard !value.isEmpty else { return false }
        
        let configuration = SRConfiguration(sdkId: value, sdkAPIUrl: AppConfig.storySdkAPIUrl, needShowTitle: true)
        StorySDK.shared.configuration = configuration
        
        StorySDK.shared.getApp { [weak self] result in
            switch result {
            case .success(let app):
                let project = ProjectSettingsModel(projectName: app.title, apiKey: value)
                self?.listOfProjects.append(project)
                if self?.selected == nil {
                    self?.selected = project
                }
                
                self?.delegate?.didChange()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        
        return true
    }
}
