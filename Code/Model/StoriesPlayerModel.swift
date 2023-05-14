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
        
        let configuration = SRConfiguration(sdkId: apiKey, sdkAPIUrl: AppConfig.storySdkAPIUrl, needShowTitle: true)
        StorySDK.shared.configuration = configuration
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
