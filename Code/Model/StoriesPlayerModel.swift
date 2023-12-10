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
    
    func setup(widget: SRStoryWidget, onboardingFilter: Bool = true) {
        self.widget = widget
        
        let locale = Locale.preferredLanguages[0]
        let languageCode = Locale(identifier: locale).languageCode ?? "en"
        
        let configuration = SRConfiguration(language: languageCode,
                                            sdkId: apiKey, sdkAPIUrl: AppConfig.storySdkAPIUrl, needShowTitle: true, onboardingFilter: onboardingFilter)
        StorySDK.shared.configuration = configuration
        StorySDK.shared.logLevel = .debug
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
