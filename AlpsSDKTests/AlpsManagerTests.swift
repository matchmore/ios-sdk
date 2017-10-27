//
//  AlpsManagerTests.swift
//  AlpsSDKTests
//
//  Created by Maciej Burda on 27/10/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import Alps
@testable import AlpsSDK

final class AlpsManagerTests: QuickSpec {
    
    let kWaitTimeInterval = 10.0
    
    override func spec() {
        let alpsManager = AlpsManager(apiKey: "c9b9601d-55b9-4057-8331-f1e2c72d308d",
                                      baseUrl: "http://localhost:9000/v4")
        context("Alps Manager") {
            fit ("create main device") {
                alpsManager.createMainDevice()
                expect(alpsManager.mainDevice).toEventuallyNot(beNil())
            }
            
            fit ("create a publication") {
                
            }
            
            fit ("create a subscription") {
                
            }
            
            fit ("get a match") {
//                alpsManager.matchMonitor.
            }
            
        }
        
    }
}
