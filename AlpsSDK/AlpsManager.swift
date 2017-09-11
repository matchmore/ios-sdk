/**
 * AlpsManager
 */

import Foundation
import CoreLocation
import Alps

enum AlpsManagerError: Error {
    case userNotIntialized
    case deviceNotInitialized
}

open class AlpsManager: AlpsSDK {


    
    let defaultHeaders = [
      // FIXME: pass both keys on AlpsManager creation
      "api-key": "833ec460-c09d-11e6-9bb0-cfb02086c30d",
      "Content-Type": "application/json; charset=UTF-8",
      "Accept": "application/json",
      "user-agent": "\(UIDevice().systemName) \(UIDevice().systemVersion)",
    ]

    let headers: [String: String]

    // XXX: this has to come from a configuration
    let alpsEndpoint = "https://api.matchmore.io/v4"
    // let alpsEndpoint = "http://localhost:9000"
    
    // Put setup code here. This method is called before the invocation of each test method in t
    let apiKey: String
    var locationManager: LocationManager? = nil
    var matchMonitor: MatchMonitor? = nil
    
    // DEVELOP: Beacons
    var beaconManager: BeaconManager? = nil

    // FIXME: add the world id when it's there
    // var world: World
    var users: [User] = []
    var alpsUser: AlpsUser?
    var devices: [Device] = []
    var alpsDevice: AlpsDevice?
    var locations: [String: Location] = [:]
    var publications: [Publication] = []
    var subscriptions: [Subscription] = []
    
    // DEVELOP: Beacons
    // depending on the case beacons will have different class in his array
    // Variant 1 is enum => Device with DeviceType
    // Variant 2 is sub-classes => BeaconDevice
    // Variant 3 is protocol => BeaconDevice
    var beacons: [IBeaconDevice] = []
    
    public convenience init(apiKey: String) {
        self.init(apiKey: apiKey, clLocationManager: CLLocationManager())
    }

    public init(apiKey: String, clLocationManager: CLLocationManager) {
        self.apiKey = apiKey
        self.headers = defaultHeaders.merged(with: ["api-key": apiKey])
        self.locationManager = LocationManager(alpsManager: self, locationManager: clLocationManager)
        self.matchMonitor = MatchMonitor(alpsManager: self)
        
        
        // DEVELOP: Beacons
        self.beaconManager = BeaconManager(alpsManager: self)
        if let bu = beaconManager{
//            self.beacons = bu.getBeacons()
            print("BEacon user 's beacon \(beacons)")
        }else{
            print("None beaconUser found.")
        }

        AlpsAPI.basePath = alpsEndpoint
        AlpsAPI.customHeaders = headers
    }

    public func createUser(_ userName: String, completion: @escaping (_ user: User?) -> Void) {
        let userCompletion = completion
        let user = User.init(name: userName)
        let _ = Alps.UsersAPI.createUser(user: user) {
            (user, error) -> Void in
            if let u = user {
                self.users.append(u)
                self.alpsUser = AlpsUser(manager: self, user: self.users[0])
            }
            userCompletion(user)
        }
    }

//    public func createDevice(name: String, platform: String, deviceToken: String,
//                             latitude: Double, longitude: Double, altitude: Double,
//                             horizontalAccuracy: Double, verticalAccuracy: Double,
//                             completion: @escaping (_ device: Device?) -> Void) {
//        let userCompletion = completion
//        if let u = alpsUser {
//            let _ = Alps.UserAPI.createDevice(userId: u.user.userId!, name: name, platform: platform,
//                                              deviceToken: deviceToken, latitude: latitude, longitude: longitude,
//                                              altitude: altitude, horizontalAccuracy: horizontalAccuracy,
//                                              verticalAccuracy: verticalAccuracy) {
//                (device, error) -> Void in
//                if let d = device {
//                    self.devices.append(d)
//                    self.alpsDevice = AlpsDevice(manager: self, user: u.user, device: self.devices[0])
//                }
//                userCompletion(device)
//            }
//        } else {
//            // XXX: error handling using exceptions?
//            print("Alps user hasn't been initialized yet!")
//            // throw AlpsManagerError.userNotIntialized
//        }
//    }
    
    public func createMobileDevice(name: String, platform: String, deviceToken: String,
                             latitude: Double, longitude: Double, altitude: Double,
                             horizontalAccuracy: Double, verticalAccuracy: Double,
                             completion: @escaping (_ device: MobileDevice?) -> Void) {
        let userCompletion = completion
        if let u = alpsUser {
            let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
            let mobileDevice = MobileDevice.init(name: name, platform: platform, deviceToken: deviceToken, location: location)
            if let userId = u.user.id {
                let _ = Alps.UserAPI.createDevice(userId: userId, device: mobileDevice) {
                                                    (mobileDevice, error) -> Void in
                                                if mobileDevice is MobileDevice{
                                                    if let d = mobileDevice as? MobileDevice {
                                                        self.devices.append(d)
                                                        self.alpsDevice = AlpsDevice(manager: self, user: u.user, device: self.devices[0])
                                                    }
                                                    userCompletion(mobileDevice as? MobileDevice)
                    }
                }
            } else {
                print("Error forcing userId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }
    }
    
    public func createPinDevice(name: String, latitude: Double, longitude: Double, altitude: Double,
                         horizontalAccuracy: Double, verticalAccuracy: Double,
                         completion: @escaping (_ device: PinDevice?) -> Void) {
        let userCompletion = completion
        if let u = alpsUser {
            let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
            let pinDevice = PinDevice.init(name: name, location: location)
            if let userId = u.user.id {
                let _ = Alps.UserAPI.createDevice(userId: userId, device: pinDevice) {
                    (pinDevice, error) -> Void in
                    if pinDevice is PinDevice{
                        if let d = pinDevice as? PinDevice {
                            self.devices.append(d)
                        }
                        userCompletion(pinDevice as? PinDevice)
                    }
                }
            } else {
                print("Error forcing userId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }
    }
    
    public func createIBeaconDevice(name: String, proximityUUID: String, major: NSNumber, minor: NSNumber,
                                    completion: @escaping (_ device: IBeaconDevice?) -> Void) {
        let userCompletion = completion
        if let u = alpsUser {
            let iBeaconDevice = IBeaconDevice.init(name: name, proximityUUID: proximityUUID, major: major, minor: minor)
            if let userId = u.user.id {
                let _ = Alps.UserAPI.createDevice(userId: userId, device: iBeaconDevice) {
                    (iBeaconDevice, error) -> Void in
                    if iBeaconDevice is IBeaconDevice{
                        if let d = iBeaconDevice as? IBeaconDevice {
                            self.devices.append(d)
                        }
                        userCompletion(iBeaconDevice as? IBeaconDevice)
                    }
                }
            } else {
                print("Error forcing userId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }
    }

    public func createPublication(userId: String, deviceId: String, topic: String, range: Double, duration: Double, properties: [String:String],
                                  completion: @escaping (_ publication: Publication?) -> Void) {
        let userCompletion = completion
        let publication = Publication.init(deviceId: deviceId, topic: topic, range: range, duration: duration, properties: properties)
        let _ = Alps.DeviceAPI.createPublication(userId: userId, deviceId: deviceId,
                                                 publication: publication) {
            (publication, error) -> Void in

                                                    if let p = publication {
                                                        self.publications.append(p)
                                                    }
            userCompletion(publication)
        }
    }

    public func createPublication(topic: String, range: Double, duration: Double, properties: [String: String],
                                  completion: @escaping (_ publication: Publication?) -> Void) {
        let userCompletion = completion
        
        if let u = alpsUser, let d = alpsDevice {
            if let userId = u.user.id, let deviceId = d.device.id{
                let publication = Publication.init(deviceId: deviceId, topic: topic, range: range, duration: duration, properties: properties)
                let _ = Alps.DeviceAPI.createPublication(userId: userId, deviceId: deviceId,
                                                         publication: publication) {
                    (publication, error) -> Void in

                    if let p = publication {
                        self.publications.append(p)
                    }

                    userCompletion(publication)
                }
            } else {
                print("Error forcing userId or/and deviceId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user and/or device hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }
    }


    public func createSubscription(userId: String, deviceId: String, topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void) {
        let userCompletion = completion
        let subscription = Subscription.init(deviceId: deviceId, topic: topic, range: range, duration: duration, selector: selector)
        let _ = Alps.DeviceAPI.createSubscription(userId: userId, deviceId: deviceId,
                                                  subscription: subscription) {
            (subscription, error) -> Void in
            userCompletion(subscription)
        }
    }

    public func createSubscription(topic: String, selector: String, range: Double, duration: Double,
                                   completion: @escaping (_ subscription: Subscription?) -> Void) {
        let userCompletion = completion

        if let u = alpsUser, let d = alpsDevice {
            if let userId = u.user.id, let deviceId = d.device.id{
                let subscription = Subscription.init(deviceId: deviceId, topic: topic, range: range, duration: duration, selector: selector)
                let _ = Alps.DeviceAPI.createSubscription(userId: userId, deviceId: deviceId,
                                                          subscription: subscription) {
                    (subscription, error) -> Void in

                    if let p = subscription {
                        self.subscriptions.append(p)
                    }

                    userCompletion(subscription)
                }
            }else{
                print("Error forcing userId or/and deviceId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user and/or device hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }
    }

    public func updateLocation(userId:String, deviceId: String, latitude: Double, longitude: Double, altitude: Double,
                               horizontalAccuracy: Double, verticalAccuracy: Double,
                               completion: @escaping (_ location: Location?) -> Void) {
        let userCompletion = completion
        let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
        let _ = Alps.DeviceAPI.createLocation(userId: userId, deviceId: deviceId,
                                              location: location) {
            (location, error) -> Void in
            userCompletion(location)
        }
    }

    public func updateLocation(latitude: Double, longitude: Double, altitude: Double,
                               horizontalAccuracy: Double, verticalAccuracy: Double,
                               completion: @escaping (_ location: Location?) -> Void) {
        let userCompletion = completion

        if let u = alpsUser, let d = alpsDevice {
            let location = Location.init(latitude: latitude, longitude: longitude, altitude: altitude, horizontalAccuracy: horizontalAccuracy, verticalAccuracy: verticalAccuracy)
            if let userId = u.user.id, let deviceId = d.device.id{
                let _ = Alps.DeviceAPI.createLocation(userId: userId, deviceId: deviceId,
                                                      location: location) {
                    (location, error) -> Void in

                        if let l = location {
                            self.locations[deviceId] = l
                        }
                        userCompletion(location)
                }
            } else {
                print("Alps user and/or device has no id !")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user and/or device hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }

    }

    public func getAllMatches(userId: String, deviceId:String, completion: @escaping (_ matches: Matches) -> Void) {
        let userCompletion = completion

        let _ = Alps.DeviceAPI.getMatches(userId: userId, deviceId: deviceId) {
            (matches, error) -> Void in

            if let ms = matches {
                userCompletion(ms)
            }
        }
    }

    public func getAllMatches(completion: @escaping (_ matches: Matches) -> Void) {
        let userCompletion = completion

        if let u = alpsUser, let d = alpsDevice {
            if let userId = u.user.id, let deviceId = d.device.id {
                let _ = Alps.DeviceAPI.getMatches(userId: userId, deviceId: deviceId) {
                    (matches, error) -> Void in

                    if let ms = matches {
                        // self.matches.append(ms)
                        userCompletion(ms)
                    }
                }
            } else {
                print("Error forcing userId or/and deviceId is nil.")
            }
        } else {
            // XXX: error handling using exceptions?
            print("Alps user and/or device hasn't been initialized yet!")
            // throw AlpsManagerError.userNotIntialized
        }

    }

    public func onMatch(completion: @escaping (_ match: Match) -> Void) {
        if let mm = matchMonitor {
            mm.onMatch(completion: completion)
        }
    }



    public func getUser(_ userId: String, completion: @escaping (_ user: User) -> Void) {
        let _ = Alps.UserAPI.getUser(userId: userId) {
            (user, error) -> Void in

            if let u = user {
                completion(u[0])
            }else {
                // XXX: error handling using exceptions?
                print("Alps.user doesn't exist!")
                // throw Alps.anagerError.userNotIntialized
            }
        }
    }

    public func getUser(completion: @escaping (_ user: User) -> Void)  {
        if let u = alpsUser {
            completion(u.user)
        } else {
            print("Alps user doesn't exist!")
            //            // throw AlpsManagerError.userNotIntialized
        }
    }

    public func getDevice(_ deviceId: String, completion: @escaping (_ device: Device) -> Void) {

        if let u = alpsUser, let d = alpsDevice {
            if let userId = u.user.id, let deviceId = d.device.id {
                let _ = Alps.UserAPI.getDevice(userId: userId, deviceId: deviceId) {
                    (device, error) -> Void in

                }
                // XXX: ignore the returned device for now
                completion(d.device)
            }
        } else {
            print("Error forcing userId or/and deviceId is nil.")
        }
    }

    public func getDevice(completion: @escaping (_ device: Device) -> Void)  {
        if let u = alpsUser, let d = alpsDevice {
            if let userId = u.user.id, let deviceId = d.device.id {
                let _ = Alps.UserAPI.getDevice(userId: userId, deviceId: deviceId) {
                    (device, error) -> Void in

                }

                // XXX: ignore the returned device for now
                completion(d.device)
            }
        } else {
            print("Error forcing userId or/and deviceId is nil.")
        }
    }

    public func getPublication(_ userId:String, deviceId:String, publicationId: String, completion: @escaping (_ publication: Publication) -> Void) {
        let _ = Alps.PublicationAPI.getPublication(userId: userId, deviceId: deviceId, publicationId: publicationId) {
            (publication, error) -> Void in
            if let p = publication {
                completion(p)
            }else {
                print("This publication doesn't exist!")
            }
        }
    }

    public func deletePublication(_ userId:String, deviceId:String, publicationId: String, completion: @escaping () -> Void) {
        let _ = Alps.PublicationAPI.deletePublication(userId: userId, deviceId: deviceId, publicationId: publicationId) {
            (error) -> Void in
            if let e = error {
                print("Impossible to delete the publication!")
            }else {
                completion()
            }
        }
    }

    public func getAllPublications(completion: @escaping (_ publications: [Publication]) -> Void) {
        if let u = alpsUser, let d = alpsDevice {
            // let _ = Alps.DeviceAPI.getPublications
            //                (publications, error) -> Void in
            //
            //            }

            // XXX: ignore the returned device for now
            completion(publications)
        }
    }

    public func getAllSubscriptions(completion: @escaping (_ subscriptions: [Subscription]) -> Void)  {
        if let u = alpsUser, let d = alpsDevice {
            // let _ = Alps.DeviceAPI.getPublications
            //                (publications, error) -> Void in
            //
            //            }

            // XXX: ignore the returned device for now
            completion(subscriptions)
        }
    }

    public func getAllPublicationsForDevice(_ userId:String, deviceId: String, completion: @escaping (_ publications: [Publication]) -> Void) {
        let _ = Alps.PublicationAPI.getPublications(userId: userId, deviceId: deviceId) {
            (publications, error) -> Void in
            if let p = publications{
                completion(p)
            }else {
                print("Can't find publications for this device")
            }
        }
    }

    public func getSubscription(_ userId:String, deviceId: String, subscriptionId: String, completion: @escaping (_ subscription: Subscription) -> Void) {
        let _ = Alps.SubscriptionAPI.getSubscription(userId: userId, deviceId: deviceId, subscriptionId: subscriptionId) {
            (subscription, error) -> Void in
            if let s = subscription {
                completion(s)
            }else {
                print("This subscription doesn't exist!")
            }
        }
    }

    public func deleteSubscription(_ userId:String, deviceId:String, subscriptionId: String, completion: @escaping () -> Void) {
        let _ = Alps.SubscriptionAPI.deleteSubscription(userId: userId, deviceId: deviceId, subscriptionId: subscriptionId) {
            (error) -> Void in
            if let e = error {
                print("Impossible to delete the subscription!")
            }else {
                completion()
            }
        }
    }

    public func getAllSubscriptionsForDevice(_ userId:String, deviceId: String, completion: @escaping (_ subscriptions: [Subscription]) -> Void) {
        let _ = Alps.SubscriptionAPI.getSubscriptions(userId: userId, deviceId: deviceId) {
            (subscriptions, error) -> Void in
            if let s = subscriptions{
                completion(s)
            }else {
                print("Can't find subscriptions for this device")
            }
        }
    }

    public func onLocationUpdate(completion: @escaping ((_ location: CLLocation) -> Void)) {
        if let lm = locationManager {
            lm.onLocationUpdate(completion: completion)
        }
    }

    public func startMonitoringMatches() {
        if let mm = matchMonitor {
            mm.startMonitoringMatches()
        }
    }

    public func stopMonitoringMatches() {
        if let mm = matchMonitor {
            mm.stopMonitoringMatches()
        }
    }

    public func startUpdatingLocation() {
        locationManager?.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    //DEVELOP: Beacons
    public func getUuid() -> [UUID]{
        var uuids : [UUID] = []
        for beacon in beacons{
            let uuid = beacon.proximityUUID
            if !uuids.contains(UUID.init(uuidString: uuid!)!){
                uuids.append(UUID.init(uuidString: uuid!)!)
            }
        }
        return uuids
    }
    
    public func getClosestOnBeaconUpdate(completion: @escaping ((_ beacon: CLBeacon) -> Void)) {
        if let lm = locationManager {
            lm.getClosestOnBeaconUpdate(completion: completion)
        }
    }
    
    public func getAllOnBeaconUpdate(completion: @escaping ((_ beacon: [CLBeacon]) -> Void)) {
        if let lm = locationManager {
            lm.getAllOnBeaconUpdate(completion: completion)
        }
    }
    
    public func startRangingBeacons(forUuid: UUID, identifier: String){
        locationManager?.startRanging(forUuid: forUuid, identifier: identifier)
    }
    
    public func stopRangingBeacons(forUuid: UUID){
        locationManager?.stopRanging(forUuid: forUuid)
    }
    
    public func startBeaconsProximityEvent(forCLProximity: CLProximity){
        locationManager?.startBeaconsProximityEvent(forCLProximity: forCLProximity)
    }
    
    public func stopBeaconsProximityEvent(forCLProximity: CLProximity){
        locationManager?.stopBeaconsProximityEvent(forCLProximity: forCLProximity)
    }
    
    // Default time to refresh is 60 seconds(= 60'000 milliseconds)
    public func setRefreshTimerForProximityEvent(refreshEveryInMilliseconds: Int){
        locationManager?.refreshTimer = refreshEveryInMilliseconds
    }
    
    //TOSUPPRESS: function just here in needs
    public func fixBeacons(beacons: [IBeaconDevice]){
        self.beacons = beacons
    }
    
    public func addBeacon(beacon: IBeaconDevice){
        self.beacons.append(beacon)
    }
}
