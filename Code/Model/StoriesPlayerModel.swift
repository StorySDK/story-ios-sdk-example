//
//  StoriesPlayerModel.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.04.2023.
//

import Foundation
import StorySDK

class StoriesPlayerModel {
    private var apiKey: String
    private weak var widget: SRStoryWidget?
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func setup(widget: SRStoryWidget) {
        self.widget = widget
        
        StorySDK.shared.configuration = SRConfiguration(sdkId: apiKey)
        StorySDK.shared.configuration.language = "en"
        StorySDK.shared.configuration.needShowTitle = true
    }
    
    func openAsOnboarding(groupId: String) {
        widget?.openAsOnboarding(groupId: groupId)
    }
    
    func fetchData() {
        widget?.load()
    }
    
    func reloadApp() {
        widget?.reload()
    }
}
