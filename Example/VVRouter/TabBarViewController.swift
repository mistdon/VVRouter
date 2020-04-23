//
//  TabBarViewController.swift
//  VVRouter_Example
//
//  Created by mistdon on 2020/4/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import VVRouter

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let home = ViewController()
        let demo = DemoViewController()
        home.tabBarItem = UITabBarItem(title: "第一", image: nil, selectedImage: nil)
        demo.tabBarItem = UITabBarItem(title: "第二", image: nil, selectedImage: nil)
        self.viewControllers = [home, demo]
        
        VVRouter.shared.delegate = self
    }
}
extension TabBarViewController: VVRouterDelegate {
    func interceptRouter(url: URLConvertible) -> Bool {
        let _url = try? url.asURL()
        if _url?.absoluteString == "/tab_1"{
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                guard let selectVC = self?.viewControllers?[1] else { return }
                self?.selectedViewController = selectVC
            }
            return true
        } else {
            return false
        }
    }
}
