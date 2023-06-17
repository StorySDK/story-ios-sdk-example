//
//  OnboardingViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 12.06.2023.
//

import UIKit
import SnapKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func startNow()
}

final class OnboardingViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    weak var model: SettingsModel?
    
    private lazy var customView: OnboardingView = OnboardingView(frame: .zero)
    
    init(model: SettingsModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        self.model?.delegate = self
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
        view.backgroundColor = .systemIndigo
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        if let project = model?.listOfProjects.first {
            coordinator?.openMain(project: project)
        }
    }
    
    func didSelect(project: ProjectSettingsModel?) {
        
    }
}
