#
# Be sure to run `pod lib lint jarvis-cashback-ios.podspec' to ensure this is a
# valid spec before submitting.

Pod::Spec.new do |s|
s.name             = 'jarvis-cashback-ios'
s.version          = '9.0.0.0'
s.summary          = 'Cashback library will helpful to implement cashback feature in jarvis'
s.ios.deployment_target = '11.0'
s.swift_version = '5.0'

s.description      = <<-DESC
Cashback library will helpful to implement cashback feature in jarvis. Developer can install the pod and access cashback feature with its manager classes
DESC

s.homepage          = 'https://bitbucket.org/paytmteam/jarvis-cashback-ios'
s.license           = { :type => 'MIT', :file => 'LICENSE' }
s.author            = { 'Nasib Ali' => 'nasib.ali@paytm.com' }
s.source            = { :git => 'git@bitbucket.org:paytmteam/jarvis-cashback-ios.git', :tag => s.version.to_s }
s.exclude_files     = 'jarvis-cashback-ios/**/*.plist'

s.source_files = 'jarvis-cashback-ios/Classes/**/*.{Swift,h,m}'
s.resources = 'jarvis-cashback-ios/Classes/**/*.storyboard','jarvis-cashback-ios/Classes/**/*.xib','jarvis-cashback-ios/Classes/**/*.json','jarvis-cashback-ios/Classes/**/*.strings','jarvis-cashback-ios/Classes/**/*.xcassets'
s.public_header_files = 'jarvis-cashback-ios/Classes/**/*.h'

s.dependency 'jarvis-utility-ios'
s.dependency 'jarvis-network-ios'
s.dependency 'jarvis-locale-ios'
s.dependency 'lottie-ios', '2.5.0'
s.dependency 'jarvis-storefront-ios'
end
