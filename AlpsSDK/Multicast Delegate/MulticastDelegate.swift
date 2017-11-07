//
//  MulticastDelegate.swift
//  AlpsSDK
//
//  Created by Maciej Burda on 06/11/2017.
//  Copyright © 2017 Alps. All rights reserved.
//

import Foundation

class MulticastDelegate<T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    public var isEmpty: Bool {
        return delegates.count == 0
    }
    
    func add(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(_ delegate: T) {
        delegates.remove(delegate as AnyObject)
    }
    
    func invoke(_ invocation: (T) -> Void) {
        delegates.allObjects.forEach {
            // swiftlint:disable:next force_cast
            invocation($0 as! T)
        }
    }
}

func += <T> (left: MulticastDelegate<T>, right: T) {
    left.add(right)
}

func -= <T> (left: MulticastDelegate<T>, right: T) {
    left.remove(right)
}
