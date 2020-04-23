//
//  AppDelegate.swift
//  Router
//
//  Created by wonderland.don@gmail.com on 04/23/2020.
//  Copyright (c) 2020 wonderland.don@gmail.com. All rights reserved.
//

import UIKit
import VVRouter

//extension RouterUrl {
//    case demo = "/demo"
//    case blue = "/blue"
//
//}

enum RouterUrl : String {
    case demo = "/demo"
    case blue = "/blue"
    case red  = "/red/(\\d+)"
    case yellow = "/yellow/(\\S+)"
}



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let naviVC = UINavigationController(rootViewController: TabBarViewController())
        self.window?.rootViewController = naviVC
        Router.registerRouters(dictionary: [RouterUrl.demo.rawValue: DemoViewController.self,
                                            RouterUrl.blue.rawValue: BlueViewController.self,
                                            RouterUrl.red.rawValue: RedViewController.self,
                                            RouterUrl.yellow.rawValue: YellowViewController.self])
        
        Router.registerRouters(dictionary: ["/demo": DemoViewController.self,
                                             "/blue": BlueViewController.self,
                                             "/red/(\\d+)": RedViewController.self,
                                             "/yellow/(\\S+)": YellowViewController.self])
        Router.shared.rootVC = self.window?.rootViewController
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Router.open(url: url)
    }

}

