//
//  ViewController.swift
//  StorySDKExample
//
//  Created by Aleksei Cherepanov on 11.05.2022.
//

import UIKit
import StorySDK

class ViewController: UIViewController {
    let widget = SRStoryWidget()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupLayout()
        addEvents()
        fetchData()
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
    
    func presentError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}

extension ViewController: SRStoryWidgetDelegate {
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        presentError(error)
    }
    
    func onWidgetGroupPresent(_ group: StoryGroup, widget: SRStoryWidget) {
        StorySDK.shared.getStories(group) { [weak self] result in
            switch result {
            case .success(let stories):
                let vc = StoriesViewController(stories, for: group, activeOnly: false)
                self?.present(vc, animated: true)
            case .failure(let error):
                self?.presentError(error)
            }
        }
    }
}
