//
//  SubscriptionResponse.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import ObjectMapper

struct SubsciptionResponse: Mappable {
    var count: Int!
    var ticks: [Tick]!
    
    init?(map: Map) {
        if map.JSON["subscribed_count"] == nil {
            return nil
        }
    }
    
    mutating func mapping(map: Map) {
        count <- map["subscribed_count"]
        ticks <- map["subscribed_list.ticks"]
    }
}
