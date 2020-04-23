# VVRouter

[![CI Status](https://img.shields.io/travis/wonderland.don@gmail.com/VVRouter.svg?style=flat)](https://travis-ci.org/wonderland.don@gmail.com/VVRouter)
[![Version](https://img.shields.io/cocoapods/v/VVRouter.svg?style=flat)](https://cocoapods.org/pods/VVRouter)
[![License](https://img.shields.io/cocoapods/l/VVRouter.svg?style=flat)](https://cocoapods.org/pods/VVRouter)
[![Platform](https://img.shields.io/cocoapods/p/VVRouter.svg?style=flat)](https://cocoapods.org/pods/VVRouter)

## Getting Started

VVRouter is a URL routing library with protocol, It is designed to make it very easy to jump to any viewController。Use regular matching to bind `rules` and `viewController`
```swift
Router.open(url: "/pageDetail/1234567")
```
#### Global configuration
```swift
Router.registerRouters(dictionary: ["/blue": BlueViewController.self,
                                    "/red/(\\d+)": RedViewController.self,
                                    "/yellow/(\\S+)": YellowViewController.self])
```
or you can use enum :
```swift
enum RouterUrl : String {
    case demo = "/demo"
    case blue = "/blue"
    case red  = "/red/(\\d+)"
    case yellow = "/yellow/(\\S+)"
}
Router.registerRouters(dictionary: [RouterUrl.demo.rawValue: DemoViewController.self,
                                    RouterUrl.blue.rawValue: BlueViewController.self,
                                    RouterUrl.red.rawValue: RedViewController.self,
                                    RouterUrl.yellow.rawValue: YellowViewController.self])
```
If you want a default rootViewController to push, you can set like below:
```swift
Router.shared.rootVC = self.window?.rootViewController
```
#### Protocol
 All ViewController support VVRouter must confim `VVRouterProtocol`
 ```swift
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
 ```
 #### Used
 ```swift
Router.open(url:"ssr://yellow/welcome")
Router.open(url:URL(string: "ssr://yellow/welcome")!)
Router.open(url:"ssr://yellow/welcome", from: self.navigationController)
Router.open(url:"ssr://yellow/welcome", from: self.navigationController, actionType: .push)
 ```
 > The default open action type is push， also support present
 
 Supprt UIApplication open
 ```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
     return Router.open(url: url)
 }
 ```
For some routes that need to be handled  by yourself, you can intercept by `VVRouterDelegate`
```swift
func interceptRouter(url: URLConvertible) -> Bool {
    // do some stuff
    return true
}
```
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

VVRouter require iOS 9.0. swift_version: 5.0

## Installation

VVRouter is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'VVRouter'
```

## Author

wonderland.don@gmail.com

## License

VVRouter is available under the MIT license. See the LICENSE file for more info.
