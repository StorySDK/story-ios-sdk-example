//
//  StoryViewController.swift
//  StorySDKExample
//
//  Created by Aleksei Cherepanov on 17.05.2022.
//

import UIKit
import StorySDK

class StoryViewController: UIViewController {
    @IBOutlet weak var widget: SRStoryWidget!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widget.delegate = self
        widget.load()
    }
}

extension StoryViewController: SRStoryWidgetDelegate {
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        presentError(error)
    }
    
    func onWidgetGroupPresent(_ group: StoryGroup, widget: SRStoryWidget) {
        StorySDK.shared.getStories(group) { [weak self] result in
            switch result {
            case .success(let stories):
                let vc = SRStoriesViewController(stories, for: group, activeOnly: false)
                self?.present(vc, animated: true)
            case .failure(let error):
                self?.presentError(error)
            }
        }
    }
}
