//
//  Reachability.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import Reachability

protocol NetworkStatusChecking: class {
    typealias NetworkStatucChangedCallback = () -> ()
    
    init(urlString: String)
    var whenReachable: NetworkStatucChangedCallback? { get set }
    var whenUnreachable: NetworkStatucChangedCallback? { get set }
}

class NetworkStatusChecker: NetworkStatusChecking {
    required init(urlString: String) {
        self.reachability = Reachability(hostname: urlString)!
    }
    
    var whenReachable: NetworkStatusChecking.NetworkStatucChangedCallback? {
        didSet {
            reachability.whenReachable = { [weak self] _ in
                self?.whenReachable?()
            }
        }
    }
    
    var whenUnreachable: NetworkStatusChecking.NetworkStatucChangedCallback? {
        didSet {
            reachability.whenUnreachable = { [weak self] _ in
                self?.whenUnreachable?()
            }
        }
    }
    
    private let reachability: Reachability
}
