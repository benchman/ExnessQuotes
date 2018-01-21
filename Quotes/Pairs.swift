//
//  Pairs.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

enum Pairs: String {
    case EURUSD, EURGBP, USDJPY, GBPUSD, USDCHF, USDCAD, AUDUSD, EURJPY, EURCHF
    
    static var all: [Pairs] = [.EURUSD, .EURGBP, .USDJPY, .GBPUSD, .USDCHF, .USDCAD, .AUDUSD, .EURJPY, .EURCHF]
    
    var displayedTitle: String {
        let first = rawValue.prefix(3)
        let last = rawValue.suffix(3)
        return "\(first)/\(last)"
    }
}
