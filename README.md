# Alps iOS SDK

`AlpsSDK` is a contextualized publish/subscribe model which can be used to model any geolocated or proximity based mobile application. Save time and make development easier by using our SDK. We are built on Apple Core Location technologies and we also provide iBeacons compatibility.

## Versioning

SDK is written using Swift 4.

Alps SDK requires iOS 10+.

## Installation

Alps is available through [CocoaPods](http://cocoapods.org), simply add the following
line to your Podfile:

    pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git'
    
### Set up APNS: Certificates for push notifications

Alps iOS SDK uses Apple Push Notification Service (APNS) to deliver notifications to your iOS users.

In order to get the certificates and upload them to our portal.

    **A membership in the Apple iOS developer program is required.**
    
#### 1. Enabling the Push Notification Service via Xcode

First, go to App Settings -> General and change Bundle Identifier to something unique.

Right below this, select your development Team. **This must be a paid developer account**.

After that, you need to create an App ID in your developer account that has the push notification entitlement enabled. Xcode has a simple way to do this. Go to App Settings -> Capabilities and flip the switch for Push Notifications to On.

![apns capabilities switch](https://github.com/matchmore/alps-ios-sdk/blob/feature/readmeApns/assets/apns1.png)

Note: If any issues occur, visit the Apple Developer Center. You may simply need to agree to a new developer license.

At this point, you should have the App ID created and the push notifications entitlement should be added to your project. You can log into the Apple Developer Center and verify this.

![verification apns activated](https://github.com/matchmore/alps-ios-sdk/blob/feature/readmeApns/assets/apns2.png)

#### 2. Enable Remote Push Notifications on your App ID

Sign in to your account in the **Apple developer center**, and then go to Certificates, Identifiers & Profiles

Go to Identifiers -> App IDs. If you followed previous instructions, you should be able to see the App ID of your application( create it if you don't see it). Click on your application and ensure that the Push Notifications service is enabled.

![apns capabilities switch](https://github.com/matchmore/alps-ios-sdk/blob/feature/readmeApns/assets/apns3.png)

Click on the Development or Production certificate button and follow the steps. We recommend you for a Production push certificate. It works for most general cases and is the required certificate for Apple store.

##### Difference between Development and Production certificate

The choice of APNs host depends on which kinds of iOS app you wish to send push notifications to. There are two kinds of iOS app:

    Published apps. These are published to the App Store and installed from there. These apps go through the usual App Store publication process, such as code-signing.
    
    Development apps. These are “everything else”, such as apps installed from Xcode, or through private app publication systems.
    
**Warning**
Do not submit Apps to Apple with Development certificates.

#### 3. Exporting certificates

After completing the steps to generate a Development SSL or Production SSL certificat and downloading the certificate.

From Finder, double-click the ~/certificate.cer file, or run open ~/certificate.cer. This will open Keychain Access. The certificate should now be added to the list under “My Certificates”.

Right click on the certificate, and select "Export ....". Select the p12 format and create a password for the file, do not lose this password as you will need it a next step.
**For now : Leave this password blank.**

Upload the generated certificate to Matchmore Portal.

#### 4. Enable Push Notification in Application

When you initiate an `AlpsManager` , the SDK will automatically register your app for remote push notification.
But, you have to implement `didRegisterForRemoteNotificationsWithDeviceToken`  appDelegate callback.
It will allow Alps SDK to receive the push token, and handle the error.

Add these lines of code to your appDelegate.
```swift
// ...

// Called when APNs has assigned the device a unique token
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Convert token to string
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})

    // Device token to your console.
    NSLog("APNs device token: \(deviceTokenString)")

    // Persist it in your backend in case it's new
    alps.remoteNotificationManager.registerDeviceToken(deviceToken: deviceToken)
}

// Called when APNs failed to register the device for push notifications
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // Print the error to console (you should alert the user that registration failed)
    NSLog("APNs registration failed: \(error)")
}

// ...
```

You can now start sending notifications to your users using Alps SDK.

## Technical overview

The `AlpsManager` class is built as such that it provides you all the functions you need to use our SDK.

Features of Alps SDK are divided into two parts: Asynchronous calls and dynamic calls.

### Asynchronous calls

All the asynchronous functions calls our cloud service and return a completion for you.

### Dynamic calls

Everytime you call an asynchronous function and it succeeds, our SDK stores it. To gain speed, we allow you to get access(read only) to these stored values.

## Usage

Please refer to documentation "tutorial" to get a full explanation on this example:

Setup application API key, get it for free from [http://dev.matchmore.com/](http://dev.matchmore.com/).
```swift
let alpsManager = AlpsManager(apiKey: "YOUR_API_KEY")
```

Create first device, publication and subscription.
```swift
alpsManager.createMainDevice { _ in
    let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: ["test": "true"])
    alpsManager.createPublication(publication: publication, completion: { _ in
        let subscription = Subscription(topic: "Test Topic", range: 20, duration: 100, selector: "test = 'true'")
        alpsManager.createSubscription(subscription: subscription, completion: { _ in
            print("We're all good! 🏔")
        })
    })                    
}
```

Create a AlpsManagerDelegate that has `OnMatchClojure`.
```swift
class MatchDelegate: AlpsManagerDelegate {
    var onMatch: OnMatchClojure
    init(_ onMatch: @escaping OnMatchClojure) {
        self.onMatch = onMatch
    }
}

let matchDelegate = MatchDelegate { matches, _ in print(matches) }
```

Start listening for main device matches.
```swift
if let mainDevice = alpsManager.mobileDevices.main {
    alpsManager.delegates += matchDelegate
    alpsManager.matchMonitor.startMonitoringFor(device: mainDevice)
}
```

## Example

in `AlpsSDK/Example/` you will find working simple example.

## Documentation

See the [http://dev.matchmore.com/documentation/api](http://dev.matchmore.com/documentation/api) or consult our website for further information [http://dev.matchmore.com/](http://dev.matchmore.com/)

## Authors

- @tharpa, rk@matchmore.com
- @wenjdu, jean-marc.du@matchmore.com
- @maciejburda, maciej.burda@matchmore.com


## License

Alps is available under the MIT license. See the LICENSE file for more info.
