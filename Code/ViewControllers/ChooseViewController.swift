//
//  ChooseViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.04.2023.
//

import UIKit

import StorySDK

protocol ChooseViewControllerDelegate: AnyObject {
    func selectGroup()
    func openAsOnboarding()
    func apply(apiKey: String)
}

final class ChooseViewController: UIViewController {
    private lazy var customView: ChooseView = ChooseView(frame: CGRect.zero)
    
    private weak var model: StoriesPlayerModel?
    private let storyWidget = SRStoryWidget()
    
    private var groups: [SRStoryGroup]?
    
    private var delayedOpenGroupId: String?
    private var modelLoaded: Bool = false
    
    private var selectedGroupIndex: Int = 0 {
        didSet {
            if let group = groups?[selectedGroupIndex] {
                customView.groupIdText = String("\(group.title) (\(group.id))")
            }
        }
    }
    
    init(model: StoriesPlayerModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        customView.delegate = self
        
        view.addSubview(customView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        customView.apiKeyText = model?.apiKey
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ChooseViewController: ChooseViewControllerDelegate {
    func selectGroup() {
        let vc = GroupPickerViewController(model: groups?.compactMap { String("\($0.title) - \($0.id)" )} )
        vc.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3)
        
        let alert = UIAlertController(title: "Select the group", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { UIAlertAction in
            self.selectedGroupIndex = vc.selectedRow
        }))
        
        alert.setValue(vc, forKey: "contentViewController")
        
        
        present(alert, animated: true)
    }
    
    func openAsOnboarding() {
        guard (groups?.count ?? 0) > selectedGroupIndex else { return }
        
        if let group = groups?[selectedGroupIndex] {
            model?.openAsOnboarding(groupId: group.id)
        }
    }
    
    func apply(apiKey: String) {
        model?.apiKey = apiKey
        dismiss(animated: true)
    }
}

extension ChooseViewController: SRStoryWidgetDelegate {
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
        self.groups = groups
        
        if let group = groups.first {
            customView.groupIdText = String("\(group.title) (\(group.id))")
        }
    }
}
