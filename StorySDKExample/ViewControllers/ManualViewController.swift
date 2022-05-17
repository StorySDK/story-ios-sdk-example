//
//  ManualViewController.swift
//  StorySDKExample
//
//  Created by Aleksei Cherepanov on 11.05.2022.
//

import UIKit
import StorySDK

final class ManualViewController: UIViewController {
    let widget = SRStoryWidget()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        addEvents()
        fetchData()
        tabBarItem = UITabBarItem(
            title: "Manual",
            image: .init(systemName: "pencil"),
            tag: 0
        )
    }
    
    func setupLayout() {
        view.addSubview(widget)
        widget.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            widget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            widget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func addEvents() {
        widget.delegate = self
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchData)
        )
    }
    
    @objc func fetchData() {
        widget.load()
    }
}

extension ManualViewController: SRStoryWidgetDelegate {
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
