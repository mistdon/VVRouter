#
# Be sure to run `pod lib lint VVRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'VVRouter'
  s.version          = '0.1.0'
  s.summary          = 'A powerful swift router library for iOS'
 
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "A router library for iOS, support route to any ViewController which have been register"

  s.homepage         = 'https://github.com/mistdon/VVRouter'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wonderland.don@gmail.com' => '' }
  s.source           = { :git => 'https://github.com/mistdon/VVRouter.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.swift_version    = '5.0'
  s.requires_arc      = true
  s.ios.deployment_target = '9.0'

  s.source_files = 'VVRouter/Classes/**/*.swift'
  
  # s.resource_bundles = {
  #   'VVRouter' => ['VVRouter/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
