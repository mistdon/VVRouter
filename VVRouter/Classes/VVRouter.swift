//
//  VVRouter.swift
//  VVRouter
//
//  Created by shendong on 2020/4/23.
//

import Foundation

import Foundation

public protocol VVRouterDelegate: AnyObject {
    /// intercept router for custom action
    func interceptRouter(url: URLConvertible) -> Bool
}
extension VVRouterDelegate {
    func interceptRouter(url: URLConvertible) -> Bool {
        return false
    }
}
public protocol VVRouterProtocol: AnyObject {
    
    static func router(url: String, params: [AnyObject]) -> UIViewController?
    
    static func routerActionType(rule: String) -> VVRouterActionType
}
public extension VVRouterProtocol where Self: UIViewController {
    static func routerActionType(rule: String) -> VVRouterActionType {
        return .push
    }
}
@objc open class VVRouter: NSObject {
    
    public static let shared = VVRouter()
    
    public weak var rootVC : UIViewController?
    
    public weak var delegate: VVRouterDelegate?
    
    /// default scheme name, for scheme open, like "ssr://home"
    public var scheme: String = "ssr"
    
    final var urlMaps: Dictionary<String, AnyClass> = [:]
    
    public class func fetchClass(key: String) -> AnyClass?{
        return VVRouter.shared.urlMaps[key]
    }
    public class func registerRouter(dictionary: Dictionary<String, AnyClass>?) {
        guard let dict = dictionary else { return }
        VVRouter.shared.urlMaps = dict
    }
    public class func registerRoute(key: String, module: AnyClass) {
        VVRouter.shared.urlMaps.updateValue(module, forKey: key)
    }
    public class func removeRoute(key: String) {
        VVRouter.shared.urlMaps.removeValue(forKey: key)
    }
    public class func removeAllRouters(){
        VVRouter.shared.urlMaps.removeAll()
    }
    public class func isNative(url: URL) -> Bool{
        return url.scheme?.lowercased() == VVRouter.shared.scheme
    }
    public class func isWeb(url: URL) -> Bool{
       let scheme = url.scheme?.lowercased()
       if let scheme = scheme{
           return (scheme == "http") || (scheme == "https")
       }else{
           return false
       }
    }
    @discardableResult
    public class func open(url: URLConvertible, from: UIViewController? = nil, actionType: VVRouterActionType = .none) -> Bool {
        if let res = VVRouter.shared.delegate?.interceptRouter(url: url), res == true {
            return false
        }
        let originUrl = try? url.asURL()
        guard var path: String = originUrl?.absoluteString as String? else{
            return true
        }
        if path.hasPrefix("//"){
            path = path.replacingOccurrences(of: "//", with: "/")
        }
        var params = [AnyObject]()
        var moduleType = VVRouter.fetchClass(key: path as String) as? VVRouterProtocol.Type
        var routerRule = path
        if moduleType == nil {
            for p in VVRouter.shared.urlMaps.keys{
                let regular = try! NSRegularExpression(pattern: p, options: .caseInsensitive) as NSRegularExpression
                let match = regular.firstMatch(in: path as String, options: .reportCompletion, range: NSMakeRange(0, path.count))
                if match == nil { continue }
                if let rematch = match, rematch.numberOfRanges > 0 {
                    for index in 0..<rematch.numberOfRanges{
                        let range = rematch.range(at: index)
                        let subParam = (path as NSString).substring(with: range)
                        if subParam.isEmpty == false{
                            params.append(subParam as AnyObject)
                        }
                    }
                    routerRule = p
                    moduleType = VVRouter.fetchClass(key: p as String) as? VVRouterProtocol.Type
                    break
                }
            }
        }
        guard let resModuleType = moduleType else {
            return false
        }
        let module = resModuleType.router(url: routerRule as String , params: params)
        var type: VVRouterActionType
        if actionType != .none {
            type = actionType
        } else {
            type = resModuleType.routerActionType(rule: actionType.rawValue)
        }
        VVRouterAction.routerAction(fromViewController: from, toViewController: module, type: type)
        return true
    }
}
