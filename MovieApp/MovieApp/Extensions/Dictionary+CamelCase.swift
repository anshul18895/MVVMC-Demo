//
//  Dictionary+CamelCase.swift
//  MovieApp
//
//  Created by Anshul Shah on 12/11/18.
//  Copyright © 2018 Anshul Shah. All rights reserved.
//

import Foundation



extension Dictionary {
    // Tested against ["ab_dsfdsac_dsd_f":"ab_dsfdsac_dsd_f", "__abc_a":"__abc_a", "abc":["ab_dsfdsac_dsd_f":"ab_dsfdsac_dsd_f", "__abc_a":"__abc_a", "ABc_def_De":1, "bc_def_De":UIColor.blue]]
    
    /// Underscore Keys to lowerCamelCase keys recursively.
    var keysToCamelCase: Dictionary {
        
        let keys = Array(self.keys)
        let values = Array(self.values)
        var dict: Dictionary = [:]
        
        keys.enumerated().forEach { (index, key) in
            
            var value = values[index]
            var keyCamelCased:Key = key
            
            if let v = value as? Dictionary, let v1 = v.keysToCamelCase as? Value {
                value = v1
            }
            
            if let k = key as? String, let k1 = k.underscoreToCamelCase as? Key {
                keyCamelCased = k1
            }
            
            dict[keyCamelCased] = value
        }
        
        return dict
    }
}
