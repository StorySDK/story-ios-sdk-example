//
//  MainViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 08.04.2023.
//

import UIKit
import StorySDK

class MainViewController: UIViewController, SRStoryWidgetDelegate {
    weak var model: SettingsModel?
    
    var storiesModel: StoriesPlayerModel?
    let widget = SRStoryWidget()
    
    weak var coordinator: AppCoordinatorProtocol?
    
    private var titleLabel: UILabel = {
        let lbl = UILabel(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 40)))
        
        return lbl
    }()
    
    init(model: SettingsModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.model = model
        self.model?.delegate = self
        
        if let apiKey = model.selected?.apiKey {
            self.storiesModel = StoriesPlayerModel(apiKey: apiKey)
        }
        
        self.storiesModel?.delegate = self
        
        let vi = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 200, height: 40)))
        vi.backgroundColor = .clear//.green
        titleLabel.text = model.selected?.projectName
        
        vi.addSubview(titleLabel)
        
        vi.addTapTouch(self, action: #selector(onTitleTap))
        self.navigationItem.titleView = vi
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
        
        coordinator?.openStories(group: group, in: self)
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        if groups.count == 0 {
            let errorMsg = "There are no active groups"
            coordinator?.showError(errorMsg, in: self)
        }
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
        
        storiesModel?.setup(widget: widget)
        reloadApp()
        
        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "arrow.counterclockwise"),
            style: .plain,
            target: self,
            action: #selector(fetchData)
        )
        
        navigationItem.leftBarButtonItem = .init(
            image: .init(systemName: "circle.grid.hex.fill"),
            style: .plain,
            target: self,
            action: #selector(onSettingsTap)
        )
    }
    
    @objc func fetchData() {
        storiesModel?.fetchData()
    }
    
    @objc func onSettingsTap() {
        coordinator?.openSettings(model: storiesModel, in: self)
    }
    
    @objc func onTitleTap() {
        model?.delegate = self
        coordinator?.showProjects(in: self)
    }
    
    @objc func reloadApp() {
        storiesModel?.reloadApp()
    }
}

extension MainViewController: StoriesPlayerModelDelegate {
    func apiKeyDidChanged() {
        storiesModel?.setup(widget: widget)
        reloadApp()
    }
}

extension MainViewController: SettingsModelDelegate {
    func didChange() {
    }
    
    func didSelect(project: ProjectSettingsModel) {
        titleLabel.text = project.projectName
        storiesModel?.apiKey = project.apiKey
    }
}
