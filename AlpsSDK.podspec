Pod::Spec.new do |s|
  s.name = 'AlpsSDK'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.version = '0.5.1'
  s.authors = 'Matchmore Alps SDK Team'
  s.homepage = 'http://matchmore.io'
  s.summary = 'Alps iOS SDK in Swift'
  s.source = { :git => 'https://github.com/MatchMore/alps-ios-sdk.git' }
  s.license = 'MIT license'
  s.source_files = 'AlpsSDK/**/*.swift'
  s.dependency 'SwiftWebSocket', '~> 2.6'
end
