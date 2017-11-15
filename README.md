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

If you already know how to enable APNS, don't forget to upload the certificate in our portal.

Also, you need to add the following lines to your project `AppDelegate`.

These callbacks allow the SDK to get the device token.

```swift
// ...

// Called when APNs has assigned the device a unique token
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Convert token to string
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    // Pass Device Token to AlpsManager
    // Note : You need to initiate AlpsManager first.
    alps.remoteNotificationManager.registerDeviceToken(deviceToken: deviceTokenString)
}

// Called when APNs failed to register the device for push notifications
func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    // Print the error to console (you should alert the user that registration failed)
    NSLog("APNs registration failed: \(error)")
}

// ...
```

Else, you can find help on [how to setup APNS](https://github.com/matchmore/alps-ios-sdk/blob/feature/readmeApns/ApnsSetup.md).

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
