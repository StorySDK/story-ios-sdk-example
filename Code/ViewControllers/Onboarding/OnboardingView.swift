//
//  OnboardingView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 12.06.2023.
//

import UIKit

final class OnboardingView: UIView {
    weak var delegate: OnboardingViewControllerDelegate?
    
    private let playerImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: "onboarding-final"))
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spDark2
        lbl.text = "Player for stories"
        lbl.font = UIFont.systemFont(ofSize: 24.0, weight: UIFont.Weight.bold)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.textColor = .spGray2
        lbl.numberOfLines = 0
        lbl.text = "You can test all widgets, video, images and text"
        lbl.font = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.medium)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    private lazy var startNowButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start Now", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .spPrimary
        btn.layer.cornerRadius = 12.0
        btn.addTarget(self, action: #selector(onStartNow), for: .touchUpInside)
        
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addMultipleSubviews(with: [playerImage,
                                   titleLabel,
                                   subtitleLabel,
                                   startNowButton,])
        
        playerImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(76)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(24)
            $0.height.equalTo(29)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(startNowButton.snp.top).offset(-86)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.width.equalToSuperview().inset(24)
            $0.height.equalTo(44)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        startNowButton.snp.makeConstraints {
            $0.width.equalToSuperview().inset(16)
            $0.height.equalTo(48)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-30)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onStartNow() {
        delegate?.startNow()
    }
}
