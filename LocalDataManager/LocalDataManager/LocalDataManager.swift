//
//  LocalDataManager.swift
//  LocalDataManager
//
//  Created by Muthuraj Muthulingam on 29/01/18.
//  Copyright © 2018 Muthu. All rights reserved.
//

import UIKit

public protocol Storable {
    var data:Data {get set}
    var codableData:Codable? {get set}
    var securableData:Securable? {get set}
    var isCodable:Bool {get set}
    var isSecureData:Bool {get set}
    var key:String {get set}
    var mode:Mode {get set}
}

public protocol Securable {
    var username:String {get set}
    var password:String {get set}
    var userID:String {get set}
}

public class LocalDataManager: NSObject {

}

//MARK: - Public Methods
extension LocalDataManager {
    public func store(data:Storable) -> Bool {
        var status = false
        switch data.mode {
        case .documentDirectory:
            status = store(dataToDocumentDirectory: data.data, withFileName: data.key)
        case .secured:
            // handle Secured storage
            guard let securableData = data.securableData else { return false }
            fallthrough
        case .serialization:
            // handle Keyed Archive
            guard let codableData = data.codableData else { return false }
            NSKeyedArchiver.store(data: codableData)
            fallthrough
        case .userDefaults:
            status = UserDefaults.standard.store(value: data, ForKey: data.key)
        }
        return status
    }
}
