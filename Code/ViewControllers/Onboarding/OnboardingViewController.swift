//
//  OnboardingViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 12.06.2023.
//

import UIKit
import StorySDK
import SnapKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func startNow()
}

final class OnboardingViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    weak var model: SettingsModel?
    weak var storiesModel: StoriesPlayerModel?
    
    private let widget = SRStoryWidget()

    init(model: SettingsModel, storiesModel: StoriesPlayerModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.model?.delegate = self
        
        self.storiesModel = storiesModel
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        widget.isHidden = true
        
        setupLayout()
        widget.delegate = self
        
        storiesModel?.setup(widget: widget, onboardingFilter: false)
        storiesModel?.reloadApp()
    }
    
    @objc func showAddTokenDialog() {
        startNow()
    }
    
    // selector for custom action from onboarding
    @objc func openApp() {
        startNow()
    }
    
    private func setupLayout() {
        view.addMultipleSubviews(with: [widget])
        
        widget.snp.remakeConstraints {
            $0.leading.trailing.top.equalTo(view)
        }
    }
}

extension OnboardingViewController: OnboardingViewControllerDelegate {
    func startNow() {
        coordinator?.showMenu(in: self)
    }
}

extension OnboardingViewController: SettingsModelDelegate {
    func didChange() {
        coordinator?.openMain()
        dismiss(animated: true)
    }
    
    func didSelect(project: ProjectSettingsModel?) {
        
    }
}

extension OnboardingViewController: SRStoryWidgetDelegate {
    func onWidgetGroupClose() {
        coordinator?.openMain()
    }
    
    func onWidgetErrorReceived(_ error: Error, widget: SRStoryWidget) {
        print(error)
    }
    
    func onWidgetGroupPresent(index: Int, groups: [SRStoryGroup], widget: SRStoryWidget) {
        guard groups.count > index else { return }
        let group = groups[index]
        
        coordinator?.openStories(group: group, in: self,
                                 delegate: self, animated: false)
    }
    
    func onWidgetGroupsLoaded(groups: [SRStoryGroup]) {
        storiesModel?.openAsOnboarding(groupId: AppConfig.onboardingGroup)
    }
    
    @objc private func dismiss() {
        coordinator?.openMain()
        dismiss(animated: true)
    }
    
    func onWidgetMethodCall(_ selectorName: String?) {
        guard let selectorName = selectorName else { return }
        
        let sel = NSSelectorFromString(selectorName)
        if canPerformAction(sel, withSender: self) {
            performSelector(onMainThread: sel, with: nil, waitUntilDone: true)
        }
    }
}
