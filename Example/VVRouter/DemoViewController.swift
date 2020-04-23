//
//  DemoViewController.swift
//  Router_Example
//
//  Created by mistdon on 2020/4/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import VVRouter
class ClosureSleeve {
    let closure: () -> ()
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    @objc func invoke(){
        closure()
    }
}
extension UIControl{
    func addAction(for controlEvents: UIControl.Event = .primaryActionTriggered, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}
extension UIViewController {
    func addTapButton(_ color: UIColor, closure: @escaping () -> Void) {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 100, y: 300, width: view.bounds.width - 200, height: 100)
        btn.backgroundColor = color
        btn.addAction(action: closure)
        view.addSubview(btn)
    }
}

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightText
        self.addTapButton(.red) {
            Router.open(url: URL(string: "ssr://red/112")!, from: self.navigationController)
        }
    }
}
class BlueViewController: UIViewController, RouterProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        self.addTapButton(.white) {
            Router.open(url: "/tab_1")
        }
    }
    static func router(url: String, params: [AnyObject]) -> UIViewController? {
        return BlueViewController()
    }
}
class RedViewController: UIViewController, RouterProtocol {
    
    var roomId: Int32 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print("redVC.roomId = \(roomId)")
        print("actionTypeStyle = \(String(describing: self.actionStringType))")
        self.addTapButton(.yellow) {
            Router.open(url:"ssr://yellow/welcome")
        }
    }
    static func router(url: String, params: [AnyObject]) -> UIViewController? {
         if url == "/red/(\\d+)" {
              let yellowVC = RedViewController()
              if let roomId = params[1].int32Value {
                  yellowVC.roomId = roomId
              }
              return yellowVC
          }
          return YellowViewController()
    }
}
class YellowViewController: UIViewController {

    var bookname: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        print("yellowVC.bookname = \(bookname)")
        self.addTapButton(.red) {
            Router.open(url: "/blue", from: self, actionType: .present)
        }
    }
}
extension YellowViewController: RouterProtocol {
    static func router(url: String, params: [AnyObject]) -> UIViewController? {
        if url == "/yellow/(\\S+)" {
            let yellowVC = YellowViewController()
            if let bookname = params[1] as? String {
                yellowVC.bookname = bookname
            }
            return yellowVC
        }
        return YellowViewController()
    }
}
