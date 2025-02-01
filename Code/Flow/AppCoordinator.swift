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
    func openMain()
    func openSettings(model: StoriesPlayerModel?, in vc: UIViewController)
    func openProjectSettings(model: ProjectSettingsModel, in vc: UIViewController)
    func openStories(group: SRStoryGroup, in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool)
    func openStories(index: Int, groups: [SRStoryGroup], in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool)
    func openScanQR(in vc: UIViewController)
    func showProjects(in vc: UIViewController)
    func showMenu(in vc: UIViewController)
    func showAddTokenDialog(in vc: UIViewController, model: SettingsModel?)
    func showError(_ message: String, in vc: UIViewController)
    
    func showAddTokenDialog(_ vc: UIViewController)
    
    func chooseProject(model: ProjectSettingsModel, from: UIViewController)
    func deleteProject(key: String, from: UIViewController)
    
    func openURL(_ url: URL?)
}

final class AppCoordinator: AppCoordinatorProtocol {
    var navigation: UINavigationController
    var projects: SettingsModel
    var onboarding: StoriesPlayerModel
    
    init(model: SettingsModel) {
        navigation = UINavigationController()
        self.projects = model
        self.onboarding = StoriesPlayerModel(apiKey: AppConfig.defaultAppAPIKey)
    }
    
    func start() {
        if projects.isEmpty {
            openOnboarding()
        } else {
            openMain()
        }
    }
    
    func openOnboarding() {
        let vc = OnboardingViewController(model: projects, storiesModel: onboarding)
        vc.coordinator = self
        
        navigation.pushViewController(vc, animated: false)
    }
    
    func openMain() {
        let vc = MainViewController(model: projects)
        vc.coordinator = self
        
        navigation.pushViewController(vc, animated: false)
    }
    
    func openSettings(model: StoriesPlayerModel?, in vc: UIViewController) {
        let controller = SettingsViewController(model: projects)
        controller.coordinator = self
        
        let settings = UINavigationController(rootViewController: controller)
        vc.present(settings, animated: true)
    }
    
    func openProjectSettings(model: ProjectSettingsModel, in vc: UIViewController) {
        let controller = ProjectSettingsViewController(model: model)
        controller.coordinator = self
        
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openStories(group: SRStoryGroup, in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool) {
        let controller = SRStoriesViewController(group)
        controller.delegate = delegate
        
        vc.present(controller, animated: animated)
    }
    
    func openStories(index: Int, groups: [SRStoryGroup], in vc: UIViewController,
                     delegate: SRStoryWidgetDelegate?, animated: Bool) {
        let controller = SRNavigationController(index: index, groups: groups,
                                                backgroundColor: UIColor.rgba(0x03050EFF))
        vc.present(controller, animated: animated)
    }
    
    func openScanQR(in vc: UIViewController) {
        let controller = ScanQRViewController(model: projects)
        
        let nvc = UINavigationController(rootViewController: controller)
        weak var wvc = controller
        
        let pvc = vc.presentedViewController ?? vc
        pvc.present(nvc, animated: true, completion: {
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
        
        if vc.presentedViewController == nil {
            vc.present(menu, animated: true)
        } else {
            vc.presentedViewController?.present(menu, animated: true)
        }
    }
    
    func showAddTokenDialog(_ vc: UIViewController) {
        showAddTokenDialog(in: vc, model: projects)
    }
    
    func showAddTokenDialog(in vc: UIViewController, model: SettingsModel?) {
        let dialog = UIAlertController(title: "Add SDK Token",
                                          message: nil,
                                     preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let done: UIAlertAction = UIAlertAction(title: "Done", style: .default, handler: { [weak dialog, weak self] _ in
            if let value = dialog?.textFields?.first?.text {
                if let result = model?.addProject(value: value) {
                    if !result {
                        self?.showError("This project already exists", in: vc)
                    }
                }
            }
        })
        
        dialog.addTextField(configurationHandler: { txtfield in
            txtfield.placeholder = "Enter SDK Token"
            txtfield.keyboardType = .asciiCapable
        })
        
        dialog.addAction(done)
        if vc.presentedViewController == nil {
            vc.present(dialog, animated: true)
        } else {
            vc.presentedViewController?.present(dialog, animated: true)
        }
    }
    
    func showError(_ message: String, in vc: UIViewController) {
        let appName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
        
        let alert = UIAlertController(title: "Error", message: "\(appName): \(message)", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        
        vc.present(alert, animated: true)
    }
    
    func chooseProject(model: ProjectSettingsModel, from: UIViewController) {
        from.dismiss(animated: true)
        projects.selected = model
    }
    
    func deleteProject(key: String, from: UIViewController) {
        projects.deleteProject(key: key)
        
        from.navigationController?.popViewController(animated: true)
    }
    
    func openURL(_ url: URL?) {
        guard let url = url else { return }
        guard UIApplication.shared.canOpenURL(url) else { return }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
