//
//  SettingsViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit
import SnapKit

protocol SettingsViewControllerDelegate: AnyObject {
    func choose(project: ProjectSettingsModel)
    func addProject()
}

final class SettingsViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    
    private lazy var customView: SettingsView = SettingsView(frame: .zero)
    private weak var model: SettingsModel?
    
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
}

extension SettingsViewController: SettingsViewControllerDelegate {
    func choose(project: ProjectSettingsModel) {
        coordinator?.openProjectSettings(model: project, in: self)
    }
    
    func addProject() {
        coordinator?.showMenu(in: self)
    }
}
