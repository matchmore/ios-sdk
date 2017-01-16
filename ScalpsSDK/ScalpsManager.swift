/**
 * ScalpsManager
 */

import Foundation
import CoreLocation
import Scalps

enum ScalpsManagerError: Error {
    case userNotIntialized
    case deviceNotInitialized
}

open class ScalpsManager: ScalpsSDK {
    let defaultHeaders = [
        // FIXME: pass both keys on ScalpsManager creation
        "api-key": "833ec460-c09d-11e6-9bb0-cfb02086c30d",
        "Content-Type": "application/json; charset=UTF-8",
        "Accept": "application/json",
        "user-agent": "\(UIDevice().systemName) \(UIDevice().systemVersion)",
    ]

    let headers: [String: String]

    // XXX: this has to come from a configuration
    let scalpsEndpoint = "http://localhost:9000"

    // Put setup code here. This method is called before the invocation of each test method in t
    let apiKey: String
    let locationManager: LocationManager

    // FIXME: add the world id when it's there
    // var world: World
    var users: [User] = []
    var scalpsUser: ScalpsUser?
    var devices: [Device] = []
    var scalpsDevice: ScalpsDevice?
    var locations: [DeviceLocation] = []
    var publications: [Publication] = []
    var subscriptions: [Subscription] = []

    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, clLocationManager: CLLocationManager())
    }

    public init(apiKey: String, clLocationManager: CLLocationManager) {
        self.apiKey = apiKey
        self.locationManager = LocationManager(clLocationManager)
        headers = defaultHeaders.merged(with: ["api-key": apiKey])
        ScalpsAPI.basePath = scalpsEndpoint
        ScalpsAPI.customHeaders = headers
    }

    // func canThrowErrors() throws -> String
    public func createUser(_ userName: String, completion: @escaping (_ user: User?) -> Void) {
        let userCompletion = completion
        // XXX: Old version using unbacked user ;-)
        // let userTemplate = User(name: userName)
        // let _ = Scalps.UsersAPI.createUser(user: userTemplate, completion: {
        let _ = Scalps.UsersAPI.createUser(name: userName, completion: {
            (user, error) -> Void in
            if let u = user {
                self.users.append(u)
                self.scalpsUser = ScalpsUser(manager: self, user: self.users[0])
            }
            userCompletion(user)
        })
    }

    public func createDevice(_ device: Device, completion: @escaping (_ device: Device?) -> Void) { // throws {
        let userCompletion = completion
        if let u = scalpsUser {
            let _ = Scalps.UserAPI.createDevice(userId: u.id(), device: device, completion: {
                (device, error) -> Void in
                if let d = device {
                    self.devices.append(d)
                    self.scalpsDevice = ScalpsDevice(manager: self, user: u.user, device: self.devices[0])
                }
                userCompletion(device)
            })} else {
            // XXX: error handling using exceptions?
            print("Scalps user hasn't been initialized yet!")
            // throw ScalpsManagerError.userNotIntialized
        }
    }

    public func createPublication(_ publication: Publication, for user: User, on device: Device,
                                  completion: @escaping (_ publication: Publication?) -> Void) {
        let userCompletion = completion
        let publicationTemplate = publication

        let _ = Scalps.DeviceAPI.createPublication(userId: user.userId!, deviceId: device.deviceId!,
                                                   publication: publicationTemplate) {
            (publication, error) -> Void in

            if let p = publication {
                self.publications.append(p)
            }

            userCompletion(publication)
        }
    }

    public func createSubscription(_ subscription: Subscription, for user: User, on device: Device,
                                   completion: @escaping (_ subscription: Subscription?) -> Void) {
        let userCompletion = completion
        let subscriptionTemplate = subscription

        let _ = Scalps.DeviceAPI.createSubscription(userId: user.userId!, deviceId: device.deviceId!,
                                                    subscription: subscriptionTemplate) {
                                                        (subscription, error) -> Void in

                                                        if let p = subscription {
                                                            self.subscriptions.append(p)
                                                        }
                                                        userCompletion(subscription)
        }
    }

    public func updateLocation(_ location: DeviceLocation, for user: User, on device: Device,
                               completion: @escaping (_ location: DeviceLocation?) -> Void) {
        let userCompletion = completion

        let _ = Scalps.DeviceAPI.createLocation(userId: user.userId!, deviceId: device.deviceId!,
                                                location: location) {
                                                    (location, error) -> Void in

                                                    if let l = location {
                                                        self.locations.append(l)
                                                    }
                                                    userCompletion(location)
        }
    }

    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
