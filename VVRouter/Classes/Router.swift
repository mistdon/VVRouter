//
//  Router.swift
//  Router
//
//  Created by Don.shen on 2020/4/23.
//

import Foundation

public protocol RouterDelegate: AnyObject {
    /// intercept router for custom action
    func interceptRouter(url: URLConvertible) -> Bool
}
extension RouterDelegate {
    func interceptRouter(url: URLConvertible) -> Bool {
        return false
    }
}
public protocol RouterProtocol: AnyObject {
    
    static func router(url: String, params: [AnyObject]) -> UIViewController?
    
    static func routerActionType(rule: String) -> RouterActionType
}
public extension RouterProtocol where Self: UIViewController {
    static func routerActionType(rule: String) -> RouterActionType {
        return .push
    }
}
@objc open class Router: NSObject {
    
    public static let shared = Router()
    
    public weak var rootVC : UIViewController?
    
    public weak var delegate: RouterDelegate?
    
    /// default scheme name, for scheme open, like "ssr://home"
    public var scheme: String = "ssr"
    
    final var urlMaps: Dictionary<String, AnyClass> = [:]
    
    public class func fetchClass(key: String) -> AnyClass?{
        return Router.shared.urlMaps[key]
    }
    public class func registerRouters(dictionary: Dictionary<String, AnyClass>?) {
        guard let dict = dictionary else { return }
        Router.shared.urlMaps = dict
    }
    public class func registerRoute(key: String, module: AnyClass) {
        
        Router.shared.urlMaps.updateValue(module, forKey: key)
    }
    public class func removeRoute(key: String) {
        Router.shared.urlMaps.removeValue(forKey: key)
    }
    public class func removeAllRouters(){
        Router.shared.urlMaps.removeAll()
    }
    public class func isNative(url: URL) -> Bool{
        return url.scheme?.lowercased() == Router.shared.scheme
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
    public class func open(url: URLConvertible, from: UIViewController? = nil, actionType: RouterActionType = .none) -> Bool {
        if let res = Router.shared.delegate?.interceptRouter(url: url), res == true {
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
        var moduleType = Router.fetchClass(key: path) as? RouterProtocol.Type
        var routerRule = path
        if moduleType == nil {
            for p in Router.shared.urlMaps.keys{
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
                    moduleType = Router.fetchClass(key: path) as? RouterProtocol.Type
                    break
                }
            }
        }
        guard let resModuleType = moduleType else {
            return false
        }
        let module = resModuleType.router(url: routerRule as String , params: params)
        var type: RouterActionType
        if actionType != .none {
            type = actionType
        } else {
            type = resModuleType.routerActionType(rule: actionType.rawValue)
        }
        RouterAction.routerAction(fromViewController: from, toViewController: module, type: type)
        return true
    }
}
