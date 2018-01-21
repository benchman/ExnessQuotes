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
    
    private let quotesClient: QuotesClient
    private var pairs: [Pairs] = Pairs.all
    
    private func subscribe() {
        quotesClient.subscibe(pairs: pairs)
    }
}

private func mapped(_ ticks: [Tick]) -> [TickViewData] {
    return ticks.map { tick -> TickViewData in
        let symbol = tick.pair.displayedTitle
        let bidAsk = tick.bid! + " / " + tick.ask!
        let spread = tick.spread!
        return TickViewData(symbol: symbol, bidAsk: bidAsk, spread: spread)
    }
}

extension QuotesPresenter: QuotesClientDelegate {
    func connected() {
        subscribe()
    }
    
    func subscriptionUpdated(subscriprion: SubsciptionResponse) {
        view?.hideLoader()
        view?.showTicks(ticks: mapped(subscriprion.ticks))
    }
    
    func ticksUpdated(ticks: [Tick]) {
        view?.showTicks(ticks: mapped(ticks))
    }
    
    func errorHappened(error: Error) {
        view?.hideLoader()
        view?.showError(error)
    }
}
