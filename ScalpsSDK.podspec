Pod::Spec.new do |s|
  s.name = 'ScalpsSDK'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.version = '0.0.1'
  s.authors = 'Scalps Team'
  s.license = 'Apache License, Version 2.0'
  s.homepage = 'http://scalps.io'
  s.summary = 'Scalps iOS SDK in Swift'
  s.source = { :git => 'https://scalps@bitbucket.org/scalps/ios-sdk.git', :tag => s.version }
  s.license = 'Apache License, Version 2.0'
  s.source_files = 'ScalpsSDK/**/*.swift'
  s.dependency 'Scalps'
end
