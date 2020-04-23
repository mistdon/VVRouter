//
//  AppDelegate.swift
//  VVRouter
//
//  Created by wonderland.don@gmail.com on 04/23/2020.
//  Copyright (c) 2020 wonderland.don@gmail.com. All rights reserved.
//

import UIKit
import VVRouter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let naviVC = UINavigationController(rootViewController: TabBarViewController())
        self.window?.rootViewController = naviVC
        
        VVRouter.registerRouter(dictionary: ["/demo": DemoViewController.self,
                                             "/blue": BlueViewController.self,
                                             "/red/(\\d+)": RedViewController.self,
                                             "/yellow/(\\S+)": YellowViewController.self])
        VVRouter.shared.rootVC = self.window?.rootViewController
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return VVRouter.open(url: url)
    }

}

