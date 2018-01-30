//
//  DataHelper.swift
//  LocalDataManager
//
//  Created by Muthuraj Muthulingam on 29/01/18.
//  Copyright © 2018 Muthu. All rights reserved.
//

import Foundation
import Key

//MARK: - User Defaults Helper methods
extension UserDefaults {
    func store(value:Any?,ForKey key:String) -> Bool {
        self.set(value, forKey: key)
        synchronize()
        return true
    }
    
    func get(ValueForKey key:String) -> Any? {
        return value(forKey:key)
    }
}

// MARK: - Document Directory
extension LocalDataManager {
    func store(dataToDocumentDirectory data:Data, withFileName name:String) -> Bool {
        var result = false
        guard let fileURL = getDocumentPath(ForName: name) else { return result }
        do {
            try data.write(to: fileURL, options: .atomic)
            result = true
        } catch { }
        return result
    }
    
    func get(dataFromDocumentDirectoryWithName name:String) -> Data? {
        guard let fileURL = getDocumentPath(ForName: name) else { return nil }
        var data:Data? = nil
        do {
            data = try Data(contentsOf: fileURL, options: .alwaysMapped)
        } catch {}
        return data
    }
    
    private func getDocumentPath(ForName name:String) -> URL? {
        var url:URL? = nil
        do {
            let directory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            url = directory.appendingPathComponent(name)
        } catch {
        }
        return url
    }
}

//MARK: - Keyed Archiver/unarcheiver
extension NSKeyedArchiver {
    class func store(data:Codable) {
        NSKeyedArchiver.archivedData(withRootObject: data)
    }
    
    class func retrive(ObjectFromArchivedData data:Data) -> Any? {
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}

//MARK: - Keychain Helper

//MARK: - Helper
public enum Mode {
    case documentDirectory
    case userDefaults
    case serialization
    case secured
}
