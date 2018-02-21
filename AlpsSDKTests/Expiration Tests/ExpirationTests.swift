//
//  ExpirationTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 13/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import AlpsSDK

class ExpirationTests: QuickSpec {
    
    class ExpiringObject: Expirable {
        var name: String?
        var duration: Double?
        var createdAt: Int64?
    }
    
    override func spec() {
        context ("expiration") {
            let fastExpiration = ExpiringObject()
            fit ("fast") {
                fastExpiration.name = "fast"
                fastExpiration.createdAt = Date().nowTimeInterval()
                fastExpiration.duration = 1
                expect(fastExpiration.isExpired).to(equal(false))
            }
            let noCreatedAt = ExpiringObject()
            fit ("no created at") {
                noCreatedAt.duration = 20
                expect(noCreatedAt.isExpired).to(equal(true))
            }
            
            let noDuration = ExpiringObject()
            fit ("no duration") {
                noDuration.createdAt = Date().nowTimeInterval()
                expect(noDuration.isExpired).to(equal(true))
            }
            
            let empty = ExpiringObject()
            fit ("empty") {
                expect(empty.isExpired).to(equal(true))
            }
            
            let longExpiration = ExpiringObject()
            fit ("long") {
                longExpiration.name = "long"
                longExpiration.createdAt = Date().nowTimeInterval()
                longExpiration.duration = 1000
                expect(longExpiration.isExpired).to(equal(false))
            }
            
            let objects: [ExpiringObject] = [fastExpiration, noCreatedAt, noDuration, empty, longExpiration]
            fit ("collection") {
                let withoutExpired = objects.withoutExpired
                expect(withoutExpired.count).to(equal(2))
                expect(withoutExpired.first?.name).to(equal("fast"))
                expect(withoutExpired.last?.name).to(equal("long"))
            }
            
            fit ("collection after expiration") {
                waitUntil(timeout: TestsConfig.kWaitTimeInterval) { done in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        done()
                    }
                }
                let withoutExpired = objects.withoutExpired
                expect(withoutExpired.count).to(equal(1))
                expect(withoutExpired.first?.name).to(equal("long"))
            }
        }
    }
}
