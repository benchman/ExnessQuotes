//
//  QoutesPresenter.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

protocol QuotesPresenting {
    init(qoutesClient: QuotesClient, prefs: PrefsStroring, networkChecker: NetworkStatusChecking)
    var view: QuotesView? { get set }
    func connect()
    func disconnect()
    func numberOfQuotes() -> Int
    func quote(at index: Int) -> QuoteViewData
    func updatePairs(_ pairs: [Pairs])
    func delete(at index: Int)
    func pairsListPresenter() -> PairsListPresenting
    func appSuspended()
    func appResumed()
}

class QuotesPresenter: QuotesPresenting {
    required init(qoutesClient: QuotesClient, prefs: PrefsStroring, networkChecker: NetworkStatusChecking) {
        self.quotesClient = qoutesClient
        self.prefs = prefs
        pairs = prefs.loadPairs()
        self.networkChecker = networkChecker
        
        networkChecker.whenReachable = { [weak self] in
            self?.connect()
        }
    }
    
    weak var view: QuotesView?
    
    func connect() {
        if isConnected {
           return
        }
        isConnected = true
        networkChecker.stop()
        self.view?.showLoader()
        quotesClient.delegate = self
        quotesClient.connect()
    }
    
    func disconnect() {
        isConnected = false
        quotesClient.delegate = nil
        quotesClient.disconnect()
    }
    
    func numberOfQuotes() -> Int {
        return quotes.count
    }
    
    func quote(at index: Int) -> QuoteViewData {
        return quotes[index]
    }
    
    func updatePairs(_ pairs: [Pairs]) {
        view?.showLoader()
        prefs.savePairs(pairs)
        let old = self.pairs
        quotesClient.unsubscribe(pairs: old) { [weak self] _ in
            self?.pairs = pairs
            self?.subscribe()
        }
    }
    
    func delete(at index: Int) {
        let pair = pairs.remove(at: index)
        prefs.savePairs(pairs)
        quotes.remove(at: index)
        quotesClient.unsubscribe(pairs: [pair]) { _ in }
    }
    
    func pairsListPresenter() -> PairsListPresenting {
        return PairsListPresenter(pairs: pairs)
    }
    
    func appSuspended() {
        disconnect()
    }
    
    func appResumed() {
        connect()
    }
    
    private let quotesClient: QuotesClient
    private let prefs: PrefsStroring
    private var pairs: [Pairs] = Pairs.all
    private var quotes: [QuoteViewData] = []
    private var isConnected: Bool = false
    private var networkChecker: NetworkStatusChecking
    
    private func subscribe() {
        quotesClient.subscibe(pairs: pairs) { [weak self] subscription in
            self?.update(ticks: subscription.ticks)
            self?.view?.hideLoader()
            self?.view?.updateQuotes()
        }
    }
    
    private func update(ticks: [Tick]) {
        let ordered = reorder(ticks: ticks)
        quotes = mapped(ordered)
    }
    
    private func reorder(ticks: [Tick]) -> [Tick] {
        var ordered: [Tick] = []
        for pair in pairs {
            if let index = ticks.index(where: { $0.pair == pair }) {
                ordered.append(ticks[index])
            }
        }
        return ordered
    }
}

private func mapped(_ ticks: [Tick]) -> [QuoteViewData] {
    return ticks.map { tick -> QuoteViewData in
        let symbol = tick.pair.displayedTitle
        let bidAsk = String(tick.bid) + " / " + String(tick.ask)
        let spread = String(tick.spread)
        return QuoteViewData(symbol: symbol, bidAsk: bidAsk, spread: spread)
    }
}

extension QuotesPresenter: QuotesClientDelegate {
    func connected() {
        subscribe()
    }
    
    func ticksUpdated(ticks: [Tick]) {
        view?.updateQuotes()
    }
    
    func errorHappened(error: Error) {
        view?.hideLoader()
        view?.showError(error)
        disconnect()
        if networkChecker.isReachable {
            connect()
        }
        else {
            networkChecker.start()
        }
    }
}
