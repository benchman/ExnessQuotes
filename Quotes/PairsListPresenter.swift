//
//  PairsListPresenter.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import Foundation

struct SelectedPair {
    let pair: Pairs
    var selected: Bool
}

class PairsListPresenter {
    init(pairs: [Pairs]) {
        setInitialPairs(pairs: pairs)
    }
    
    func numberOfPairs() -> Int {
        return pairs.count
    }
    
    func pair(at index: Int) -> SelectedPair {
        return pairs[index]
    }
    
    func update(at index: Int) {
        let selected = pairs[index].selected
        pairs[index].selected = !selected
    }
    
    func selectedPairs() -> [Pairs] {
        let selected = pairs.filter { $0.selected }
        return selected.map { $0.pair }
    }
    
    private func setInitialPairs(pairs: [Pairs]) {
        for pair in Pairs.all {
            let selected = pairs.contains(pair)
            let new = SelectedPair(pair: pair, selected: selected)
            self.pairs.append(new)
        }
    }
    
    private var pairs: [SelectedPair] = []
}
