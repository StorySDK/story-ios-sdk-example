//
//  StoriesPlayerModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.04.2023.
//

import Foundation
import StorySDK

protocol StoriesPlayerModelDelegate: AnyObject {
    func apiKeyDidChanged()
}

class StoriesPlayerModel {
    var apiKey: String {
        didSet {
            delegate?.apiKeyDidChanged()
        }
    }
    private weak var widget: SRStoryWidget?
    weak var delegate: StoriesPlayerModelDelegate?
    
    init(apiKey: String, delegate: StoriesPlayerModelDelegate? = nil) {
        self.apiKey = apiKey
        self.delegate = delegate
    }
    
    func setup(widget: SRStoryWidget) {
        self.widget = widget
        
        let configuration = SRConfiguration(sdkId: apiKey, sdkAPIUrl: AppConfig.storySdkAPIUrl, needShowTitle: true)
        StorySDK.shared.configuration = configuration
    }
    
    func openAsOnboarding(groupId: String) {
        widget?.openAsOnboarding(groupId: groupId)
    }
    
    func fetchData() {
        widget?.load()
    }
    
    func openSettings() {
        widget?.load()
    }
    
    func reloadApp() {
        widget?.reload()
    }
}
