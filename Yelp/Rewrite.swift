//
//  Rewrite.swift
//  Yelp
//
//  Created by Wuming Xie on 9/22/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import Foundation

class Rewrite {
    struct SectionStruct {
        let title: String
        let expanded: Bool
        let cells: [Cell]
        var selected: Int
    }
    
    struct Cell {
        let setting: String
        let cellType: CellType
        
        init(setting: String, cellType: CellType) {
            self.setting = setting
            self.cellType = cellType
        }
    }
    
    let popularCells = [Cell.init(setting: "Offering a deal", cellType: .switchCell)]
    let popularSection = SectionStruct(title: "Popular", expanded: true, cells: [], selected: 0)
    
    let distanceCells = [
}
