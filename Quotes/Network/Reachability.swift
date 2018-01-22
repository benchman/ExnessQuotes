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
    var isReachable: Bool { get }
    func start()
    func stop()
    var whenReachable: NetworkStatucChangedCallback? { get set }
    var whenUnreachable: NetworkStatucChangedCallback? { get set }
}

class NetworkStatusChecker: NetworkStatusChecking {
    init() {
        self.reachability = Reachability(hostname: "http://apple.com")!
        reachability.whenReachable = { [weak self] _ in
            self?.whenReachable?()
        }
        
        reachability.whenUnreachable = { [weak self] _ in
            self?.whenUnreachable?()
        }
    }
    
    var isReachable: Bool {
        return reachability.connection != .none
    }
    
    func start() {
        try? reachability.startNotifier()
    }
    
    func stop() {
        reachability.stopNotifier()
    }
    
    var whenReachable: NetworkStatusChecking.NetworkStatucChangedCallback?
    
    var whenUnreachable: NetworkStatusChecking.NetworkStatucChangedCallback?
    
    private let reachability: Reachability
}
