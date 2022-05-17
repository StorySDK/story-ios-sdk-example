//
//  UIViewController.swift
//  StorySDKExample
//
//  Created by Aleksei Cherepanov on 17.05.2022.
//

import UIKit

extension UIViewController {func presentError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
}
