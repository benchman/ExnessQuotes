//
//  ExnessClient.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation
import PocketSocket
import ObjectMapper

class ExnessClient: NSObject, QuotesClient {
    weak var delegate: QuotesClientDelegate?
    
    required init(urlString: String) {
        self.urlString = urlString
        super.init()
    }
    
    func connect() {
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        socket = PSWebSocket.clientSocket(with: request)
        socket?.delegate = self
        socket?.open()
    }
    
    func disconnect() {
        socket?.close()
        socket?.delegate = nil
        socket = nil
    }
    
    func subscibe(pairs: [Pairs]) {
        let message = "SUBSCRIBE: \(pairsString(pairs))"
        print(message)
        socket?.send(message)
    }
    
    func unsubscribe(pairs: [Pairs]) {
        let message = "UNSUBSCRIBE: \(pairsString(pairs))"
        print(message)
        socket?.send(message)
    }
    
    private var socket: PSWebSocket?
    private let urlString: String

    private func pairsString(_ pairs: [Pairs]) -> String {
        if pairs.isEmpty {
            return "undefined"
        }
        else {
            return pairs.map { $0.rawValue }.joined(separator: ",")
        }
    }
    
    deinit {
        socket?.close()
    }
}

extension ExnessClient: PSWebSocketDelegate {
    func webSocketDidOpen(_ webSocket: PSWebSocket!) {
        delegate?.connected()
    }
    
    func webSocket(_ webSocket: PSWebSocket!, didFailWithError error: Error!) {
        delegate?.errorHappened(error: error)
    }
    
    func webSocket(_ webSocket: PSWebSocket!, didReceiveMessage message: Any!) {
        let text = message as! String
        print(text)
        if let subscription = SubsciptionResponse(JSONString: text) {
            delegate?.subscriptionUpdated(subscriprion: subscription)
        }
        else if let tick = TickResponse(JSONString: text) {
            delegate?.ticksUpdated(ticks: tick.ticks)
        }
    }
    
    func webSocket(_ webSocket: PSWebSocket!, didCloseWithCode code: Int, reason: String!, wasClean: Bool) {
        let error = AppError.serverUnreachable
        delegate?.errorHappened(error: error)
    }
}
