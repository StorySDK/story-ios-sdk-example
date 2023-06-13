//
//  ProjectSettingsViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import UIKit
import SnapKit

final class ProjectSettingsViewController: UIViewController {
    private lazy var customView: ProjectSettingsView = ProjectSettingsView(frame: .zero)
    private weak var model: ProjectSettingsModel?
    
    init(model: ProjectSettingsModel) {
        super.init(nibName: nil, bundle: nil)
        self.model = model
        
        self.title = model.projectName
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        //customView.delegate = self
        
        customView.apiKeyText = model?.apiKey
        view.addSubview(customView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
