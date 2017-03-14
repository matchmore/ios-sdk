Pod::Spec.new do |s|
  s.name = 'ScalpsSDK'
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.9'
  s.version = '0.0.2'
  s.authors = 'Scalps Team'
  s.homepage = 'http://scalps.io'
  s.summary = 'Scalps iOS SDK in Swift'
  s.source = { :git => 'https://scalps@bitbucket.org/scalps/ios-sdk.git', :tag => s.version }
  s.license = 'BSD 3-Clause License'
  s.source_files = 'ScalpsSDK/**/*.swift'
  s.dependency 'Scalps'
end
