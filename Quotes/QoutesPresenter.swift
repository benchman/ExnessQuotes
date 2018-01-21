//
//  QoutesPresenter.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

class QuotesPresenter {
    init(qoutesClient: QuotesClient) {
        self.quotesClient = qoutesClient
        qoutesClient.delegate = self
    }
    
    weak var view: QuotesView?
    
    func connect() {
        self.view?.showLoader()
        quotesClient.connect()
    }
    
    func numberOfQuotes() -> Int {
        return quotes.count
    }
    
    func quote(at index: Int) -> QuoteViewData {
        return quotes[index]
    }
    
    func updatePairs(_ pairs: [Pairs]) {
        let old = pairs
        quotesClient.unsubscribe(pairs: old)
        self.pairs = pairs
    }
    
    private let quotesClient: QuotesClient
    private var pairs: [Pairs] = Pairs.all
    private var quotes: [QuoteViewData] = []
    private var unsubscribing: Bool = false
    
    private func subscribe() {
        quotesClient.subscibe(pairs: pairs)
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
    
    func subscriptionUpdated(subscriprion: SubsciptionResponse) {
        if unsubscribing {
            unsubscribing = false
            subscribe()
        }
        update(ticks: subscriprion.ticks)
        view?.hideLoader()
        view?.updateQuotes()
    }
    
    func ticksUpdated(ticks: [Tick]) {
        view?.updateQuotes()
    }
    
    func errorHappened(error: Error) {
        view?.hideLoader()
        view?.showError(error)
    }
}
