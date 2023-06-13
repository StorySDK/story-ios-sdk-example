//
//  ProjectSettingsView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import UIKit
import SnapKit

final class ProjectSettingsView: UIView {
    //weak var delegate: <#CustomViewControllerDelegate#>?
        
    var apiKeyText: String? {
        didSet {
            apiKeyTextField.text = apiKeyText
        }
    }
    
    private lazy var apiKeyLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spBlack
        lbl.text = "SDK Token"
        lbl.textAlignment = .left
        
        return lbl
    }()
    
    private lazy var apiKeyTextField: UITextField = {
        let tf = UITextField(frame: .zero)
        tf.backgroundColor = .white
        tf.textColor = .spDark2
        tf.placeholder = "API Key"
        tf.layer.cornerRadius = 12.0
        
        return tf
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.spBackground
        
        addMultipleSubviews(with: [apiKeyLabel,
                                   apiKeyTextField,])
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
