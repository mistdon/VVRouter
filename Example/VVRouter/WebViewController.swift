//
//  WebViewController.swift
//  VVRouter_Example
//
//  Created by mistdon on 2020/4/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var wkWebView : WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = WKWebViewConfiguration()
        wkWebView = WKWebView(frame: view.bounds, configuration: configuration)
        view.addSubview(wkWebView)
    }
}
