//
//  PrefsStorage.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

protocol PrefsStroring {
    func savePairs(_ pairs: [Pairs])
    func loadPairs() -> [Pairs]
}

class PrefsStorage: PrefsStroring {
    func savePairs(_ pairs: [Pairs]) {
        let strings = pairs.map { $0.rawValue }
        UserDefaults.standard.set(strings, forKey: "pairs")
    }
    
    func loadPairs() -> [Pairs] {
        if let strings = UserDefaults.standard.value(forKey: "pairs") as? [String] {
            let pairs = strings.map { Pairs(rawValue: $0)! }
            return pairs
        }
        else {
            return Pairs.all
        }
    }
}
