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
    
    private lazy var privacyLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spGray2
        lbl.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        lbl.text = "Privacy Policy"
        lbl.textAlignment = .center
        lbl.addTapTouch(self, action: #selector(onPrivacyTap))
        
        return lbl
    }()
    
    private lazy var termsLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spGray2
        lbl.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        lbl.text = "Terms of Use"
        lbl.textAlignment = .center
        lbl.addTapTouch(self, action: #selector(onTermsTap))
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .spBackground
        
        addMultipleSubviews(with: [settingsTableView, privacyLabel, termsLabel, ])
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
        
        privacyLabel.snp.remakeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(18)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(termsLabel.snp.top).offset(-14)
        }
        
        termsLabel.snp.remakeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(18)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-23)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        settingsTableView.reloadData()
    }
    
    @objc func onAddProject() {
        delegate?.addProject()
    }
    
    @objc func onPrivacyTap() {
        delegate?.openPrivacyPolicyURL()
    }
    
    @objc func onTermsTap() {
        delegate?.openTermsofUseURL()
    }
}

extension SettingsView: SettingsModelDelegate {
    func didChange() {
        setNeedsLayout()
        layoutIfNeeded()
        settingsTableView.reloadData()
    }
    
    func didSelect(project: ProjectSettingsModel?) {}
}
