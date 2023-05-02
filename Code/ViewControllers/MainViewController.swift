//
//  MainViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 08.04.2023.
//


import UIKit
import StorySDK

class MainViewController: UIViewController, SRStoryWidgetDelegate {
    private var model: StoriesPlayerModel?
    
    let widget = SRStoryWidget()
    
    init(model: StoriesPlayerModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        print(error)
    }
    
    func onWidgetGroupPresent(index: Int, groups: [SRStoryGroup], widget: SRStoryWidget) {
        guard groups.count > index else { return }
        let group = groups[index]
        
        let vc = SRStoriesViewController(group)
        present(vc, animated: true)
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        
    }
    
    func setupLayout() {
        widget.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(widget)
        
        NSLayoutConstraint.activate([
            widget.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            widget.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            widget.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupLayout()
        
        widget.delegate = self
        
        model?.setup(widget: widget)
        reloadApp()
        
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchData)
        )
    }
    
    @objc func fetchData() {
        model?.fetchData()
    }
    
    @objc func reloadApp() {
        model?.reloadApp()
    }
}
