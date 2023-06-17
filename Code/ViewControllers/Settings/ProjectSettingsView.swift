//
//  ProjectSettingsView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import UIKit
import SnapKit

final class ProjectSettingsView: UIView {
    weak var delegate: ProjectSettingsViewControllerDelegate?
        
    var apiKeyText: String? {
        didSet {
            apiKeyTextField.text = apiKeyText
        }
    }
    
    private let padding = 16.0
    
    private lazy var apiKeyLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spBlack
        lbl.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)
        lbl.text = "SDK Token"
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var apiKeyTextField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .spTableBackground
        tf.textColor = .spDark2
        tf.font = UIFont.systemFont(ofSize: 15.0, weight: UIFont.Weight.medium)
        tf.placeholder = "API Key"
        tf.layer.cornerRadius = 12.0
        
        return tf
    }()
    
    private lazy var deleteProjectButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.setTitle("Delete project", for: .normal)
        btn.setTitleColor(.spRose, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
        
        btn.addTarget(self, action: #selector(onDeleteTap), for: .touchUpInside)
        
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.spBackground
        
        addMultipleSubviews(with: [apiKeyLabel,
                                   apiKeyTextField,
                                   deleteProjectButton])
        
        apiKeyLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(padding)
            $0.height.equalTo(20)
            $0.leading.equalTo(apiKeyTextField.snp.leading)
            $0.bottom.equalTo(apiKeyTextField.snp.top).offset(-8)
        }
        
        apiKeyTextField.snp.makeConstraints {
            $0.width.equalToSuperview().inset(padding)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        let paddingView = UIView(frame: CGRectMake(0, 0, 18, apiKeyTextField.frame.height))
        apiKeyTextField.leftView = paddingView
        apiKeyTextField.leftViewMode = .always
        
        deleteProjectButton.snp.makeConstraints {
            $0.width.equalTo(277)
            $0.height.equalTo(22)
            $0.leading.equalTo(apiKeyLabel.snp.leading)
            $0.top.equalTo(apiKeyTextField.snp.bottom).offset(24)
        }
    }
    
    @objc func onDeleteTap() {
        delegate?.deleteProject()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
