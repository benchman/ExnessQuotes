//
//  QoutesClient.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

protocol QuotesClientDelegate {
    func ticksUpdated(ticks: [Tick])
    func connectionLost(error: Error?)
}

typealias ConnectCallback = (Error?) -> ()
typealias SubsciptionCallback = (SubsciptionResponse?, Error?) -> ()

protocol QuotesClient {
    init(url: URL, delegate: QuotesClientDelegate)
    func connect(callback: @escaping ConnectCallback)
    func disconnect()
    func subscibe(pairs: [Pairs], callback: @escaping SubsciptionCallback)
}
