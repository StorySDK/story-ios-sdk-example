//
//  SettingsViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit
import SnapKit
import Combine

protocol SettingsViewControllerDelegate: AnyObject {
    func choose(project: ProjectSettingsModel)
    func settings(project: ProjectSettingsModel)
    func addProject()
    func openPrivacyPolicyURL()
    func openTermsofUseURL()
}

final class SettingsViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    
    private lazy var customView: SettingsView = SettingsView(frame: .zero)
    private weak var model: SettingsModel?
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(model: SettingsModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        
        self.title = "Settings"
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        customView.model = model
        customView.delegate = self
        
        view.addSubview(customView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func reload() {
        customView.reload()
    }
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func choose(project: ProjectSettingsModel) {
        coordinator?.chooseProject(model: project, from: self)
    }
    
    func settings(project: ProjectSettingsModel) {
        coordinator?.openProjectSettings(model: project, in: self)
    }
    
    func addProject() {
        coordinator?.showMenu(in: self)
    }
    
    func openPrivacyPolicyURL() {
        coordinator?.openURL(URL(string: "https://www.termsfeed.com/live/71f7c932-062f-43f9-afa5-d13dffa22423"))
    }
    
    func openTermsofUseURL() {
        coordinator?.openURL(URL(string: "https://www.termsfeed.com/live/cfba5e97-d9bb-4eec-9fe4-12c235df17a2"))
    }
}
