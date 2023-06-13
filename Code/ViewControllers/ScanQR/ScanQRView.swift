//
//  ScanQRView.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 12.06.2023.
//

import UIKit

final class ScanQRView: UIView {
    weak var delegate: ScanQRViewControllerDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
