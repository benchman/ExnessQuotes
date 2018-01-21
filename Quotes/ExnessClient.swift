//
//  ExnessClient.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import Starscream
import ObjectMapper

class ExnessClient: QuotesClient {
    required init(url: URL, delegate: QuotesClientDelegate) {
        socket = WebSocket(url: url)
        self.delegate = delegate
    }
    
    func connect(callback: @escaping ConnectCallback) {
        connectCallback = callback
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func subscibe(pairs: [Pairs], callback: @escaping SubsciptionCallback) {
        subscriptionCallback = callback
        let message = "SUBSCRIBE: \(pairsString(pairs))"
        socket.write(string: message)
    }
    
    func unsubscribe(pairs: [Pairs], callback: @escaping SubsciptionCallback) {
        subscriptionCallback = callback
        let message = "UNSUBSCRIBE: \(pairsString(pairs))"
        socket.write(string: message)
    }
    
    private let socket: WebSocket
    private let delegate: QuotesClientDelegate
    private var connectCallback: ConnectCallback?
    private var subscriptionCallback: SubsciptionCallback?
    
    private func pairsString(_ pairs: [Pairs]) -> String {
        return pairs.map { $0.rawValue }.joined(separator: ",")
    }
}

extension ExnessClient: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        connectCallback?(nil)
        connectCallback = nil
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if connectCallback != nil {
            connectCallback?(error)
            connectCallback = nil
        }
        else {
            delegate.connectionLost(error: error)
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let subscription = SubsciptionResponse(JSONString: text) {
            subscriptionCallback?(subscription, nil)
        }
        else if let tick = TickResponse(JSONString: text) {
            delegate.ticksUpdated(ticks: tick.ticks)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}
