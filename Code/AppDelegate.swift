//
//  AppDelegate.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 08.04.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinatorProtocol?
    var projects: SettingsModel!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //projects = SettingsModel(list: [AppConfig.defaultProject])
        // load projects
        projects = SettingsModel(list: [])
        
        coordinator = AppCoordinator(model: projects)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .systemBackground
        window?.rootViewController = coordinator?.navigation
        //window?.rootViewController = UINavigationController(rootViewController: MainViewController(model: StoriesPlayerModel(apiKey: AppConfig.defaultAppAPIKey)))
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
