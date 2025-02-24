//
//  AppDelegate.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 18.02.25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let tasksViewController = TaskRouter.createModule()
        let navigationController = UINavigationController(rootViewController: tasksViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

