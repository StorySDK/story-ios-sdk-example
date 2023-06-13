//
//  AppCoordinator.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10.06.2023.
//

import UIKit
import StorySDK

protocol AppCoordinatorProtocol: AnyObject {
    var navigation: UINavigationController { get set }
    func start()
    
    func openOnboarding()
    func openMain(project: ProjectSettingsModel)
    func openSettings(model: StoriesPlayerModel?, in vc: UIViewController)
    func openProjectSettings(model: ProjectSettingsModel, in vc: UIViewController)
    func openStories(group: SRStoryGroup, in vc: UIViewController)
    func openScanQR(in vc: UIViewController)
    func showProjects(in vc: UIViewController)
    func showMenu(in vc: UIViewController)
    func showAddTokenDialog(in vc: UIViewController, model: SettingsModel?)
    func showError(_ message: String, in vc: UIViewController)
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigation: UINavigationController
    var projects: SettingsModel
    
    init(model: SettingsModel) {
        navigation = UINavigationController()
        self.projects = model
    }
    
    func start() {
        if projects.isEmpty {
            openOnboarding()
        } else {
            openMain(project: AppConfig.defaultProject)
        }
    }
    
    func openOnboarding() {
        let vc = OnboardingViewController(model: projects)
        vc.coordinator = self
        
        navigation.pushViewController(vc, animated: false)
    }
    
//    func openMain(in vc: UIViewController) {
    func openMain(project: ProjectSettingsModel) {
        //let vc = MainViewController(model: StoriesPlayerModel(apiKey: project.apiKey))
//        let vc = MainViewController(model: StoriesPlayerModel(apiKey: AppConfig.defaultAppAPIKey))
        
        let vc = MainViewController(model: projects)
        vc.coordinator = self
        
        navigation.pushViewController(vc, animated: false)
    }
    
//    func openSettings(model: StoriesPlayerModel?, in vc: UIViewController) {
//        //let settings = ChooseViewController(model: model)
//        //let settings = SettingsViewController()
//
//        let settings = UINavigationController(rootViewController: ProjectSettingsViewController(model: AppConfig.defaultProject))
//        vc.present(settings, animated: true)
//    }
    
    func openSettings(model: StoriesPlayerModel?, in vc: UIViewController) {
        //let settings = ChooseViewController(model: model)
        //let settings = SettingsViewController()
        
        let controller = SettingsViewController(model: projects)
        controller.coordinator = self
        
        let settings = UINavigationController(rootViewController: controller)
        vc.present(settings, animated: true)
    }
    
    func openProjectSettings(model: ProjectSettingsModel, in vc: UIViewController) {
        let controller = ProjectSettingsViewController(model: model)
        //vc.coordinator = self
        
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openStories(group: SRStoryGroup, in vc: UIViewController) {
        let controller = SRStoriesViewController(group)
        vc.present(controller, animated: true)
    }
    
    func openScanQR(in vc: UIViewController) {
        let controller = ScanQRViewController(model: projects)
        
        let nvc = UINavigationController(rootViewController: controller)
        weak var wvc = controller
        vc.present(nvc, animated: true, completion: {
            wvc?.startScanningQR()
        })
    }
    
    func showProjects(in vc: UIViewController) {
        let menu = UIAlertController(title: "Choose project",
                                          message: nil,
                                     preferredStyle: .actionSheet)
        for app in projects.listOfProjects {
            let item = UIAlertAction(title: app.projectName, style: .default) { [weak self] action in
                if let index = menu.actions.firstIndex(of: action) {
                    let project = self?.projects.listOfProjects[index]
                    self?.projects.selected = project
                }
            }
            
            menu.addAction(item)
        }
        
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.present(menu, animated: true)
    }
    
    func showMenu(in vc: UIViewController) {
        let menu = UIAlertController(title: nil,
                                          message: nil,
                                          preferredStyle: .actionSheet)
        let scanQR = UIAlertAction(title: "Scan QR",
                                   style: .default) { [weak self] _ in
            self?.openScanQR(in: vc)
        }
        let addToken = UIAlertAction(title: "Add SDK token manually",
                                   style: .default) { [weak self] _ in
            self?.showAddTokenDialog(in: vc, model: self?.projects)
        }
        menu.addAction(scanQR)
        menu.addAction(addToken)
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        vc.present(menu, animated: true)
    }
    
    func showAddTokenDialog(in vc: UIViewController, model: SettingsModel?) {
        let dialog = UIAlertController(title: "Add SDK Token",
                                          message: nil,
                                     preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let done: UIAlertAction = UIAlertAction(title: "Done", style: .default, handler: { [weak dialog] _ in
            if let value = dialog?.textFields?.first?.text {
                model?.addToken(value: value)
            }
        })
        
        dialog.addTextField(configurationHandler: { txtfield in
            txtfield.placeholder = "Enter SDK Token"
            txtfield.keyboardType = .asciiCapable
        })
        
        dialog.addAction(done)
        vc.present(dialog, animated: true)
    }
    
    func showError(_ message: String, in vc: UIViewController) {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        
        let alert = UIAlertController(title: "Error", message: "\(appName): There are no active groups", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        vc.present(alert, animated: true)
    }
}
