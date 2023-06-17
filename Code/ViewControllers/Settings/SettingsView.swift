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
            model?.delegate = self
        }
    }
    
    private lazy var settingsTableView: SettingsTableView = {
        let v = SettingsTableView(frame: .zero, model: model)
        v.layer.cornerRadius = 14.0
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .spBackground
        
        addMultipleSubviews(with: [settingsTableView])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h: CGFloat = CGFloat(model?.count ?? 1) * 46.0
        
        settingsTableView.snp.remakeConstraints {
            $0.width.equalToSuperview().inset(16)
            $0.height.equalTo(h)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(100)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        settingsTableView.reloadData()
    }
    
    @objc func onChooseProject() {
        //delegate?.chooseProject()
    }
    
    @objc func onAddProject() {
        delegate?.addProject()
    }
}

extension SettingsView: SettingsModelDelegate {
    func didChange() {
        setNeedsLayout()
        layoutIfNeeded()
        settingsTableView.reloadData()
    }
    
    func didSelect(project: ProjectSettingsModel?) {
    }
}
