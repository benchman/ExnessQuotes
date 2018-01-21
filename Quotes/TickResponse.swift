//
//  TickResponse.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import ObjectMapper

struct TickResponse: Mappable {
    var ticks: [Tick]!
    
    init?(map: Map) {
        if map.JSON["ticks"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        ticks <- map["ticks"]
    }
}
