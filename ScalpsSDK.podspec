Pod::Spec.new do |s|
  s.name = 'ScalpsSDK'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.version = '0.0.1'
  s.source = { :git => 'https://scalps@bitbucket.org/scalps/ios-sdk.git', :tag => 'v1.0.0' }
  s.license = 'Apache License, Version 2.0'
  s.source_files = 'Scalps/Scalps/**/*.swift'
  s.dependency 'Scalps'
end
