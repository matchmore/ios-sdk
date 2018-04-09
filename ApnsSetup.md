### Set up APNS: Certificates for push notifications

Matchmore iOS SDK uses Apple Push Notification Service (APNS) to deliver notifications to your iOS users.

In order to get the certificates and upload them to our portal.

    **A membership in the Apple iOS developer program is required.**

#### 1. Enabling the Push Notification Service via Xcode

First, go to App Settings -> General and change Bundle Identifier to something unique.

Right below this, select your development Team. **This must be a paid developer account**.

After that, you need to create an App ID in your developer account that has the push notification entitlement enabled. Xcode has a simple way to do this. Go to App Settings -> Capabilities and flip the switch for Push Notifications to On.

![apns capabilities switch](https://github.com/matchmore/alps-ios-sdk/blob/master/assets/apns1.png)

Note: If any issues occur, visit the Apple Developer Center. You may simply need to agree to a new developer license.

At this point, you should have the App ID created and the push notifications entitlement should be added to your project. You can log into the Apple Developer Center and verify this.

![verification apns activated](https://github.com/matchmore/alps-ios-sdk/blob/master/assets/apns2.png)

#### 2. Enable Remote Push Notifications on your App ID

Sign in to your account in the **Apple developer center**, and then go to Certificates, Identifiers & Profiles

Go to Identifiers -> App IDs. If you followed previous instructions, you should be able to see the App ID of your application( create it if you don't see it). Click on your application and ensure that the Push Notifications service is enabled.

![apns capabilities switch](https://github.com/matchmore/alps-ios-sdk/blob/master/assets/apns3.png)

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

Add the following lines to your appDelegate.

```swift
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // Convert token to string
    let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    Matchmore.registerDeviceToken(deviceToken: deviceTokenString)
    createApnsSubscription()
}

func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
    Matchmore.processPushNotification(pushNotification: userInfo)
}
```

You can now start sending notifications to your users using Matchmore SDK.
