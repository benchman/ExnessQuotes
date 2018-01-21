//
//  Tick.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import ObjectMapper

struct Tick: Mappable {
    var pair: Pairs!
    var bid: String!
    var ask: String!
    var spread: String!
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        pair <- map["s"]
        bid <- map["b"]
        ask <- map["a"]
        spread <- map["spr"]
    }
}
