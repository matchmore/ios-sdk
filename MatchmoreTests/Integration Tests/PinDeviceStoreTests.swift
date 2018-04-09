//
//  PinDeviceStoreTests.swift
//  MatchmoreTests
//
//  Created by Maciej Burda on 18/10/2017.
//  Copyright © 2017 Matchmore. All rights reserved.
//

import Foundation
@testable import Matchmore
import Nimble
import Quick

class PinDeviceStoreTests: QuickSpec {
    override func spec() {
        TestsConfig.configure()

        let pinDeviceStore = Matchmore.pinDevices
        var createdPinDeviceId: String = ""
        var errorResponse: ErrorResponse?

        context("pin device") {
            beforeEach {
                errorResponse = nil
            }
            fit("create") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    let pinDevice = PinDevice(
                        name: "Test Pin",
                        location: Location(
                            latitude: 12,
                            longitude: 12,
                            altitude: 12,
                            horizontalAccuracy: 10,
                            verticalAccuracy: 10
                        )
                    )
                    pinDeviceStore.create(item: pinDevice,
                                          completion: { result in
                                              switch result {
                                              case let .success(pinDevice):
                                                  createdPinDeviceId = pinDevice.id ?? ""
                                              case let .failure(error):
                                                  errorResponse = error
                                              }
                                              done()
                    })
                }
                expect(pinDeviceStore.items.first).toEventuallyNot(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }

            var readPinDevice: PinDevice?
            fit("read") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    pinDeviceStore.find(byId: createdPinDeviceId,
                                        completion: { result in
                                            readPinDevice = result
                                            done()
                    })
                }
                expect(readPinDevice).toEventuallyNot(beNil())
            }

            fit("delete") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    if let readPinDevice = readPinDevice {
                        pinDeviceStore.delete(item: readPinDevice,
                                              completion: { error in
                                                  errorResponse = error
                                                  done()
                        })
                    } else { done() }
                }
                expect(pinDeviceStore.items.first).toEventually(beNil())
                expect(errorResponse?.message).toEventually(beNil())
            }
        }
    }
}
