//
//  DictionaryExtension.swift
//  YSCTW
//
//  Created by Max Zimmermann on 21.06.17.
//  Copyright © 2017 MZ. All rights reserved.
//

import Foundation

//https://stackoverflow.com/questions/27044095/swift-how-to-remove-a-null-value-from-dictionary

extension Dictionary {
    
    /// An immutable version of update. Returns a new dictionary containing self's values and the key/value passed in.
    func updatedValue(_ value: Value, forKey key: Key) -> Dictionary<Key, Value> {
        var result = self
        result[key] = value
        return result
    }
    
    var nullsRemoved: [Key: Value] {
        let tup = filter { !($0.1 is NSNull) }
        //TODO
        return tup
//        return tup.reduce([Key: Value]()) { $0.0.updatedValue($0.1.value, forKey: $0.1.key) }
    }
}
