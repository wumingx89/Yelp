//
//  SwitchCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

@objc protocol SwitchCellDelegate {
    @objc optional func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool)
}

class SwitchCell: UITableViewCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    weak var delegate: SwitchCellDelegate?
    
    var category: [String: String]! {
        didSet {
            switchLabel.text = category["name"]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        onSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func switchValueChanged() {
        delegate?.switchCell?(self, didChangeValue: onSwitch.isOn)
    }
}
