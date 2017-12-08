# coding: utf-8
platform :ios, '9.0'
use_frameworks!

target 'AlpsSDK' do
    # Alps API
    pod 'Alps', '~> 0.5.1'
    # Socket
    pod 'Starscream', '~> 3.0'
end

target 'AlpsSDKTests' do
    # Testing description and matching
    pod 'Nimble', '~> 7.0'
    pod 'Quick', '~> 1.2'
end

post_install do |installer|
    myTargets = ['SwiftWebSocket']
    
    installer.pods_project.targets.each do |target|
        if myTargets.include? target.name
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
