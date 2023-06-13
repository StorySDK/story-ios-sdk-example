//
//  StartView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit
import SnapKit

final class StartView: UIView {
    weak var delegate: StartViewControllerDelegate?
    
    private lazy var selectGroupButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start Now", for: .normal)
        btn.backgroundColor = .systemOrange
        btn.addTarget(self, action: #selector(onSelect), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        
        addMultipleSubviews(with: [selectGroupButton,])
        
        selectGroupButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-150)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSelect() {
        //resignFirstResponder()
        delegate?.startNow()
    }
}
