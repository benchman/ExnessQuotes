//
//  QuoteCell.swift
//  Quotes
//
//  Created by Aleksey Nemychenkov on 21/01/2018.
//  Copyright © 2018 Aleksey Nemychenkov. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bidAskLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func reset() {
        symbolLabel.text = nil
        bidAskLabel.text = nil
        spreadLabel.text = nil
    }
}
