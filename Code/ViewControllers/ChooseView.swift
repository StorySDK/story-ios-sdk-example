//
//  ChooseView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.04.2023.
//

import UIKit
import SnapKit

final class ChooseView: UIView {
    weak var delegate: ChooseViewControllerDelegate?
    
    var groupIdText: String? {
        didSet {
            groupIdTextField.text = groupIdText
        }
    }
    
    private lazy var apiKeyLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .white
        lbl.text = "SDK Token"
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var apiKeyTextField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .lightGray
        tf.placeholder = "API Key"
        
        return tf
    }()
    
    private lazy var groupIdLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .white
        lbl.text = "Group ID"
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var groupIdTextField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .lightGray
        tf.placeholder = "Group ID"
        tf.isEnabled = false
        
        return tf
    }()
    
    private lazy var chooseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Setup", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onChoose), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var selectGroupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Select", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var openGroupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Open as onboarding", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onOpen), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var showAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Show App", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onShow), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addMultipleSubviews(with: [apiKeyLabel,
                                   apiKeyTextField,
                                   chooseButton,
                                   groupIdLabel,
                                   groupIdTextField,
                                   selectGroupButton,
                                   openGroupButton,
                                   showAllButton])
        
        apiKeyLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(15)
            $0.height.equalTo(20)
            $0.leading.equalTo(apiKeyTextField.snp.leading)
            $0.bottom.equalTo(apiKeyTextField.snp.top).offset(-8)
        }
        
        apiKeyTextField.snp.makeConstraints {
            $0.width.equalToSuperview().inset(15)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        chooseButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(apiKeyTextField.snp.bottom).offset(22)
        }
        
        groupIdLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(15)
            $0.height.equalTo(20)
            $0.leading.equalTo(groupIdTextField.snp.leading)
            $0.bottom.equalTo(groupIdTextField.snp.top).offset(-8)
        }
        
        groupIdTextField.snp.makeConstraints {
            $0.leading.equalTo(apiKeyTextField.snp.leading)
            $0.trailing.equalTo(selectGroupButton.snp.leading).inset(-15)
            $0.height.equalTo(44)
            $0.bottom.equalTo(openGroupButton.snp.top).offset(-22)
        }
        
        selectGroupButton.snp.makeConstraints {
            $0.width.equalTo(80)
            $0.height.equalTo(44)
            $0.trailing.equalToSuperview().offset(-15)
            $0.top.equalTo(groupIdTextField.snp.top)
        }
        
        openGroupButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-400)
        }
        
        showAllButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-100)
        }
        
        addTapTouch(self, action: #selector(switchFirstResponder))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onChoose() {
        guard let value = apiKeyTextField.text else { return }
        delegate?.setupAPIKey(apiKey: value)
    }
    
    @objc func onSelect() {
        resignFirstResponder()
        delegate?.selectGroup()
    }
    
    @objc func onOpen() {
        resignFirstResponder()
        delegate?.openAsOnboarding()
    }
    
    @objc func onShow() {
        delegate?.openApp()
    }
    
    @objc func switchFirstResponder() {
        endEditing(true)
    }
}
