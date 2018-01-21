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
    weak var delegate: QuotesClientDelegate?
    
    required init(urlString: String) {
        let url = URL(string: urlString)!
        socket = WebSocket(url: url)
        socket.delegate = self
//        socket.event.open = { [weak self] in
//            DispatchQueue.main.async {
//                self?.delegate?.connected()
//            }
//        }
//
//        socket.event.close = { [weak self] (code, reason, wasClean) in
//            print("code \(code)")
//        }
//
//        socket.event.error = { [weak self] error in
//            DispatchQueue.main.async {
//                self?.delegate?.errorHappened(error: error)
//            }
//        }
//
//        socket.event.message = { [weak self] data in
//            DispatchQueue.main.async {
//                let message = data as! String
//                print("message \(message)")
//                if let subscription = SubsciptionResponse(JSONString: message) {
//                    self?.delegate?.subscriptionUpdated(subscriprion: subscription)
//                }
//                else if let tick = TickResponse(JSONString: message) {
//                    self?.delegate?.ticksUpdated(ticks: tick.ticks)
//                }
//            }
//        }
//
//        socket.event.pong = { [weak self] pong in
//            print("pong \(pong)")
//        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func subscibe(pairs: [Pairs]) {
        let message = "SUBSCRIBE: \(pairsString(pairs))"
        socket.write(string: message)
    }
    
    func unsubscribe(pairs: [Pairs]) {
        let message = "UNSUBSCRIBE: \(pairsString(pairs))"
        socket.write(string: message)
    }
    
    private let socket: WebSocket

    private func pairsString(_ pairs: [Pairs]) -> String {
        return pairs.map { $0.rawValue }.joined(separator: ",")
    }
    
    deinit {
        socket.disconnect()
    }
}

extension ExnessClient: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        delegate?.connected()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        let errorToShow = error != nil ? error! : AppError.serverUnreachable
        delegate?.errorHappened(error: errorToShow)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print(text)
        if let subscription = SubsciptionResponse(JSONString: text) {
            delegate?.subscriptionUpdated(subscriprion: subscription)
        }
        else if let tick = TickResponse(JSONString: text) {
            delegate?.ticksUpdated(ticks: tick.ticks)
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("data received")
    }
}
