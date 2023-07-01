//
//  SettingsModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import Foundation
import StorySDK
import Combine

protocol SettingsModelDelegate: AnyObject {
    func didChange()
    func didSelect(project: ProjectSettingsModel?)
}

class SettingsModel {
    static let projectsKey = "StoriesPlayer-Projects"
    
    var listOfProjects: [ProjectSettingsModel] = []
    var action: String = "+ Add project"
    var count: Int {
        listOfProjects.count + 1
    }
    
    var isEmpty: Bool {
        listOfProjects.isEmpty
    }
    
    @Published var selected: ProjectSettingsModel?
    
    weak var delegate: SettingsModelDelegate?
    
    init() {
        let list = load() ?? []
        self.listOfProjects = list
        self.selected = list.first
    }
    
    func addProject(value: String?) -> Bool {
        guard let value = value else { return false }
        guard !value.isEmpty else { return false }
        
        guard listOfProjects.firstIndex(where: { $0.apiKey == value }) == nil else {
            return false
        }
        
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
                
                self?.save(list: self?.listOfProjects)
                self?.delegate?.didChange()
            case .failure(let error):
                print("Error:", error.localizedDescription)
            }
        }
        
        return true
    }
    
    func deleteProject(key: String) {
        listOfProjects.removeAll(where: {$0.apiKey == key})
        save(list: listOfProjects)
        delegate?.didChange()
    }
    
    private func save(list: [ProjectSettingsModel]?) {
        guard let list = list else { return }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(list)
            
            UserDefaults.standard.set(data, forKey: SettingsModel.projectsKey)
        } catch {
            print("Unable to encode ProjectSettingsModel (\(error))")
        }
    }
    
    private func load() -> [ProjectSettingsModel]? {
        if let data = UserDefaults.standard.data(forKey: SettingsModel.projectsKey) {
            do {
                let decoder = JSONDecoder()
                let list = try decoder.decode([ProjectSettingsModel].self, from: data)
                
                return list
            } catch {
                print("Unable to decode ProjectSettingsModel (\(error))")
            }
        }
        
        return nil
    }
}
