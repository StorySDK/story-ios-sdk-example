//
//  StartViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit
import SnapKit

protocol StartViewControllerDelegate: AnyObject {
    func startNow()
}

final class StartViewController: UIViewController {
    weak var coordinator: AppCoordinatorProtocol?
    
    private lazy var customView: StartView = StartView(frame: CGRect.zero)
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        customView.delegate = self
        
        view.addSubview(customView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension StartViewController: StartViewControllerDelegate {
    func startNow() {
        //coordinator?.openMain(in: self)
        coordinator?.showMenu(in: self)
    }
}
