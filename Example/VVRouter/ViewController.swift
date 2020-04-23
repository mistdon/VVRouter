//
//  ViewController.swift
//  VVRouter
//
//  Created by wonderland.don@gmail.com on 04/22/2020.
//  Copyright (c) 2020 wonderland.don@gmail.com. All rights reserved.
//

import UIKit
import VVRouter

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.addTapButton(.blue) {
            VVRouter.open(url: URL(string: "VV://blue")!, from: self.navigationController)
        }
    }
}

