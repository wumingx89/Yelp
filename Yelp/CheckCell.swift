//
//  CheckCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/21/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class CheckCell: FilterCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    
    var selectActionHandler = { () in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func filterWasSet() {
        let data: [String: String]!
        let selectedRow = FiltersViewController.tableStructure[indexPath.section].selected[0]
        selectionImage.image = nil
        if FiltersViewController.tableStructure[indexPath.section].expanded {
            data = FiltersViewController.tableStructure[indexPath.section].data[indexPath.row]
            if indexPath.row == selectedRow {
                selectionImage.image = #imageLiteral(resourceName: "check")
                selectionImage.tintColor = Constants.yelpBlue
            }
        } else {
            data = FiltersViewController.tableStructure[indexPath.section].data[selectedRow]
            selectionImage.image = #imageLiteral(resourceName: "arrow_down")
            selectionImage.tintColor = Constants.yelpMediumGrey
        }
        settingLabel.text = data["name"]
    }
    
    func didTap() {
        selectActionHandler()
    }
}
