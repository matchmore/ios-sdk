# coding: utf-8
platform :ios, '9.0'
use_frameworks!

target 'AlpsSDK' do
    pod 'Alps', :path => '../alps-ios-api/'
#   pod 'Alps', :git => 'https://github.com/MatchMore/alps-ios-api.git', :tag => '0.4.0'

    # Logging
    pod 'SwiftyBeaver', '~> 1.4'
end

target 'AlpsSDKTests' do
    # Testing description and matching
    pod 'Nimble', '~> 7.0'
    pod 'Quick', '~> 1.2'
    
    # Main SDK
#    pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git', :tag => '0.4.0'
    pod 'AlpsSDK', :path => '../alps-ios-sdk/'

    # Networking
    pod 'Alamofire', '~> 4.5'
end
