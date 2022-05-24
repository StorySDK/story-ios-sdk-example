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
        let vc = SRStoriesViewController(group)
        present(vc, animated: true)
    }
}
