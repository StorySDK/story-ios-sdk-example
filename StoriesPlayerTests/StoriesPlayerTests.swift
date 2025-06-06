//
//  StoriesPlayerTests.swift
//  StoriesPlayerTests
//
//  Created by Ingvarr Alef on 03.05.2023.
//

import XCTest
import StorySDK
@testable import StoriesPlayer

class StoriesPlayerTests: XCTestCase, SRStoryWidgetDelegate {
    func onWidgetGroupClose() {
        //
    }
    
    private let apiKey = AppConfig.defaultAppAPIKey
    private let storyWidget = SRStoryWidget()
    private var expectation: XCTestExpectation?
    
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        
    }
    
    func onWidgetGroupPresent(index: Int, groups: [SRStoryGroup], widget: SRStoryWidget) {
        
    }
    
    func onWidgetMethodCall(_ selectorName: String?) {
        
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        if groups.count > 0 {
            expectation?.fulfill()
        }
        
        expectation = nil
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyWidget.delegate = self
    }
    
    override func tearDown() {
        storyWidget.delegate = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadStorySDK() {
        let model = StoriesPlayerModel(apiKey: apiKey)
        
        expectation = expectation(description: "Fetch stories")
        model.setup(widget: storyWidget)
        model.fetchData()
        
        waitForExpectations(timeout: 3.0)
    }
}
