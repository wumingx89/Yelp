//
//  CheckCell.swift
//  Yelp
//
//  Created by Wuming Xie on 9/21/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

class CheckCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var settingLabel: UILabel!
    
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
    
    func didTap() {
        selectActionHandler()
    }
}
