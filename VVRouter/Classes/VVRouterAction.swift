//
//  VVRouterAction.swift
//  VVRouter
//
//  Created by shendong on 2020/4/23.
//

import Foundation

@objc public extension UIViewController{
    private struct AssociateKeys{
        static var typeStringKey = "typeStringKey.vvrouter"
    }
    @objc var actionStringType: String?{
        set{
            objc_setAssociatedObject(self, &AssociateKeys.typeStringKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
        }
        get{
            return objc_getAssociatedObject(self, &AssociateKeys.typeStringKey) as? String
        }
    }
}
@objc public enum VVRouterActionType: Int, RawRepresentable {
    case none = -1, push, present
    public typealias RawValue = String
    public var rawValue: RawValue{
        switch self {
        case .none:
            return "none"
        case .push:
            return "push"
        case .present:
            return "present"
        default:
            return "none"
        }
    }
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "none":
            self = .none
        case "push":
            self = .push
        case "present":
            self = .present
        default:
            self = .none
        }
    }
}
@objc public class VVRouterAction: NSObject{
    @objc public class func routerAction(fromViewController: UIViewController?, toViewController: UIViewController?, type: VVRouterActionType){
        var from = fromViewController
        if from == nil { from = VVRouter.shared.rootVC }
        guard let fromVC = from, let  toVC = toViewController else { return }
        if toVC is UINavigationController{
            let navi: UINavigationController = toVC as! UINavigationController
            navi.topViewController?.actionStringType = type.rawValue
        }else{
            toVC.actionStringType = type.rawValue
        }
        if type == .push {
            if fromVC is UINavigationController{
                let navi: UINavigationController = fromVC as! UINavigationController
                toVC.hidesBottomBarWhenPushed = true
                navi.show(toVC, sender: nil)
            }else{
                toVC.hidesBottomBarWhenPushed = true
                fromVC.navigationController?.show(toVC, sender: nil)
            }
            return
        }else if type == .present {
            if fromVC.isBeingPresented{
                if fromVC is UINavigationController{
                    self.routerAction(fromViewController: fromVC, toViewController: toVC, type: .present)
                    return
                }
                return
            }else{
                fromVC.present(toVC, animated: true, completion: nil)
            }
        }
    }
}
