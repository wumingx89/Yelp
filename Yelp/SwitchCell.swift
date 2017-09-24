//
//  SwitchCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class SwitchCell: FilterCell {

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    
    var switchToggleHandler = { () in }
    var code: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func toggleAttribute() {
        filters.toggleAttribute(onSwitch.isOn, code: code)
    }
    
    func toggleCategory() {
        filters.toggleCategory(row: indexPath.row, isOn: onSwitch.isOn)
    }
    
    func toggleOpenNow() {
        filters.openNow = onSwitch.isOn
    }
    
    override func filterWasSet() {
        // Remove any targets on the switch
        onSwitch.removeTarget(nil, action: nil, for: .valueChanged)
        
        // Set up cell
        let data = FiltersViewController.tableStructure[indexPath.section].data[indexPath.row]
        switchLabel.text = data["name"]
        code = data["code"]!
        let isOn: Bool
        switch code {
        case "deals", "hot_and_new":
            isOn = filters.attributes.contains(code)
            onSwitch.addTarget(self, action: #selector(toggleAttribute), for: .valueChanged)
        case "open_now":
            isOn = filters.openNow
            onSwitch.addTarget(self, action: #selector(toggleOpenNow), for: .valueChanged)
        default:
            isOn = filters.categories.contains(code)
            onSwitch.addTarget(self, action: #selector(toggleCategory), for: .valueChanged)
        }
        onSwitch.isOn = isOn
    }
}
