//
//  ChooseViewController.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.04.2023.
//

import UIKit

protocol ChooseViewControllerDelegate: AnyObject {
    func setupAPIKey(apiKey: String)
}

final class ChooseViewController: UIViewController {
    private lazy var customView: ChooseView = ChooseView(frame: CGRect.zero)
    
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
        view.backgroundColor = .systemGreen
        
        customView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ChooseViewController: ChooseViewControllerDelegate {
    func setupAPIKey(apiKey: String) {
        let model = StoriesPlayerModel(apiKey: apiKey)
        navigationController?.pushViewController(MainViewController(model: model),
                                                 animated: true)
    }
}
