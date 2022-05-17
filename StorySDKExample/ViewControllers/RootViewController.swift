//
//  RootViewController.swift
//  StorySDKExample
//
//  Created by Aleksei Cherepanov on 17.05.2022.
//

import UIKit

class RootViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
    }
    
    private func addViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyboardVc = storyboard.instantiateViewController(withIdentifier: "GroupsViewController")
        let manualVc = ManualViewController()
        
        viewControllers = [manualVc, storyboardVc]
    }
}
