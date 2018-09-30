//
//  AppDelegate.swift
//  LionheartOtherAppsViewController
//
//  Created by dlo on 08/31/2017.
//  Copyright (c) 2017 dlo. All rights reserved.
//

import UIKit
import LionheartOtherAppsViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = LionheartOtherAppsViewController(developerID: 548052593, affiliateCode: "1l3vbEC")
        let navigation = UINavigationController(rootViewController: controller)
        let _window = UIWindow(frame: UIScreen.main.bounds)
        _window.rootViewController = navigation
        _window.makeKeyAndVisible()
        window = _window
        return true
    }
}

