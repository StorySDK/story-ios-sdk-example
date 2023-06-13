//
//  SettingsView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit

final class SettingsView: UIView {
    weak var delegate: SettingsViewControllerDelegate? {
        didSet {
            settingsTableView.actionDelegate = delegate
        }
    }
    weak var model: SettingsModel? {
        didSet {
            settingsTableView.model = model
        }
    }
    
    private lazy var settingsTableView: SettingsTableView = {
        let v = SettingsTableView(frame: .zero, model: model)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .spBackground
        
        addMultipleSubviews(with: [settingsTableView])
        
        settingsTableView.snp.makeConstraints {
            $0.width.equalToSuperview().inset(16)
            $0.height.equalTo(200)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onChooseProject() {
        //delegate?.chooseProject()
    }
    
    @objc func onAddProject() {
        delegate?.addProject()
    }
}
