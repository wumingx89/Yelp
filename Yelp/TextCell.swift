//
//  PriceCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/24/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class TextCell: FilterCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var selectionHandler = { () in }

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }

    func didTap() {
        selectionHandler()
    }
}
