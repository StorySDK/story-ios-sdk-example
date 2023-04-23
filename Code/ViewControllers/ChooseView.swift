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
    
    private lazy var apiKeyTextField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .darkGray
        tf.placeholder = "API Key"
        
        return tf
    }()
    
    private lazy var chooseButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Setup", for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(onChoose), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        apiKeyTextField.translatesAutoresizingMaskIntoConstraints = false
        chooseButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(apiKeyTextField)
        addSubview(chooseButton)
        
        apiKeyTextField.snp.makeConstraints {
            $0.width.equalToSuperview().inset(15)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(chooseButton.snp.top).offset(-22)
        }
        
        chooseButton.snp.makeConstraints {
            $0.width.equalTo(200)
            $0.height.equalTo(44)
            $0.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onChoose() {
        guard let value = apiKeyTextField.text else { return }
        delegate?.setupAPIKey(apiKey: value)
    }
}
