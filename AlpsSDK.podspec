Pod::Spec.new do |s|
  s.name = 'AlpsSDK'
  s.ios.deployment_target = '10.0'
  s.osx.deployment_target = '10.11'
  s.version = '0.5.0'
  s.authors = 'Matchmore Alps SDK Team'
  s.license = 'Apache License, Version 2.0'
  s.homepage = 'http://matchmore.io'
  s.summary = 'Alps iOS SDK in Swift'
  s.source = { :git => 'https://github.com/MatchMore/alps-ios-sdk.git' }
  s.license = 'MIT license'
  s.source_files = 'AlpsSDK/**/*.swift'
  s.dependency 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git'
  s.dependency 'SwiftWebSocket', '~> 2.6'
end
