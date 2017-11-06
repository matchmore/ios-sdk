//
//  MulticastDelegate.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 06/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

class MulticastDelegate<T: AnyObject> {
    private let delegates: NSHashTable<T> = NSHashTable.weakObjects()
    
    func add(delegate: T) {
        delegates.add(delegate)
    }
    
    func remove(delegate: T) {
        delegates.remove(delegate)
    }
    
    func invoke(invocation: (T) -> Void) {
        delegates.allObjects.forEach {
            invocation($0)
        }
    }
}

func += <T> (left: MulticastDelegate<T>, right: T) {
    left.add(delegate: right)
}

func -= <T> (left: MulticastDelegate<T>, right: T) {
    left.remove(delegate: right)
}
