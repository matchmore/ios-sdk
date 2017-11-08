# Alps iOS SDK

`AlpsSDK` is a contextualized publish/subscribe model which can be used to model any geolocated or proximity based mobile application. Save time and make development easier by using our SDK. We are built on Apple Core Location technologies and we also provide iBeacons compatibility.

## Versioning

SDK is written using Swift 4.

Alps SDK requires iOS 10+.

## Installation

Alps is available through [CocoaPods](http://cocoapods.org), simply add the following
line to your Podfile:

    pod 'AlpsSDK', :git => 'https://github.com/MatchMore/alps-ios-sdk.git'

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
    let publication = Publication(topic: "Test Topic", range: 20, duration: 100, properties: properties)
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
guard let mainDevice = alpsManager.mobileDevices.main else { return }
alpsManager.delegates += matchDelegate
alpsManager.matchMonitor.startMonitoringFor(device: alpsManager.mobileDevices.main)
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
