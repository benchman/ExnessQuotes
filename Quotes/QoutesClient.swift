//
//  QoutesClient.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

protocol QuotesClientDelegate: class {
    func connected()
    func subscriptionUpdated(subscriprion: SubsciptionResponse)
    func ticksUpdated(ticks: [Tick])
    func errorHappened(error: Error)
}

protocol QuotesClient: class {
    init(urlString: String)
    var delegate: QuotesClientDelegate? { get set }
    func connect()
    func disconnect()
    func subscibe(pairs: [Pairs])
    func unsubscribe(pairs: [Pairs])
}
