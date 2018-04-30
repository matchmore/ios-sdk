//
//  PersistancyManager.swift
//  Matchmore
//
//  Created by Maciej Burda on 02/11/2017.
//  Copyright © 2018 Matchmore SA. All rights reserved.
//

import Foundation

class PersistenceManager {
    private class func getDocumentsDirectory() -> URL {
        // swiftlint:disable:next force_try
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }

    class func save<T>(object: T?, to file: String) -> Bool {
        guard let object = object else { return PersistenceManager.delete(file: file) }
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        let fullPath = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try data.write(to: fullPath)
        } catch let error {
            print(error)
            return false
        }
        return true
    }

    class func read<T>(type _: T.Type, from file: String) -> T? {
        let fullPath = getDocumentsDirectory().appendingPathComponent(file)
        guard let readObject = NSKeyedUnarchiver.unarchiveObject(withFile: fullPath.path) as? T else { return nil }
        return readObject
    }

    class func delete(file: String) -> Bool {
        let fullPath = getDocumentsDirectory().appendingPathComponent(file)
        do {
            try FileManager.default.removeItem(at: fullPath)
        } catch {
            return false
        }
        return true
    }
}
