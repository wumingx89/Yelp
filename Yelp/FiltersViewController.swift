//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate: class {
    func filtersViewController(
        _ filtersViewController: FiltersViewController,
        didUpdateFilters filters: YelpFilters
    )
}

struct SectionStruct {
    let title: String
    let expandable: Bool
    var expanded: Bool
    let cellType: CellType
    var selected: [Int]
    let data: [[String: String]]
    
    static func expandable(title: String, cellType: CellType, data: [[String: String]], selected: [Int] = [0]) -> SectionStruct {
        return SectionStruct(title: title, expandable: true, expanded: false, cellType: cellType, selected: selected, data: data)
    }
    
    static func normal(title: String, cellType: CellType, data: [[String: String]]) -> SectionStruct {
        return SectionStruct(title: title, expandable: false, expanded: false, cellType: cellType, selected: [], data: data)
    }
}

// MARK:- FiltersViewController
class FiltersViewController: UIViewController {

    @IBOutlet weak var filtersTable: UITableView!
    
    static var tableStructure = [
        SectionStruct.normal(title: "Most Popular", cellType: .switchCell, data: Constants.popular),
        SectionStruct.expandable(title: "Distance", cellType: .checkCell, data: Constants.distances),
        SectionStruct.expandable(title: "Sort", cellType: .checkCell, data: Constants.sortModes),
        SectionStruct.expandable(title: "Categories", cellType: .switchCell, data: Constants.yelpCategories, selected: [0, 1, 2])
    ]
    
    // MARK: Delegates
    weak var filtersVCDelegate: FiltersViewControllerDelegate?
    
    var filters: YelpFilters!
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func onCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearch(_ sender: UIBarButtonItem) {
        filtersVCDelegate?.filtersViewController(self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Table view delegate/datasource extension
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return FiltersViewController.tableStructure.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch FiltersViewController.tableStructure[section].title {
        case "":
            return 0.0
        default:
            return 45.0
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FiltersViewController.tableStructure[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = FiltersViewController.tableStructure[section]
        if section.expandable && !section.expanded {
            return section.selected.count
        }
        
        return section.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = FiltersViewController.tableStructure[indexPath.section].cellType
        guard let cell = filtersTable.dequeueReusableCell(withIdentifier: cellType.rawValue, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        
        cell.indexPath = indexPath
        cell.filters = filters
        
        if cellType == .checkCell {
            let switchCell = cell as! CheckCell
            switchCell.selectActionHandler = { [unowned self] in
                let expanded = FiltersViewController.tableStructure[indexPath.section].expanded
                FiltersViewController.tableStructure[indexPath.section].expanded = !expanded
                
                if expanded {
                    FiltersViewController.tableStructure[indexPath.section].selected[0] = indexPath.row
                    switch FiltersViewController.tableStructure[indexPath.section].title {
                    case "Distance":
                        self.filters.distance = indexPath.row
                    case "Sort":
                        self.filters.sort = indexPath.row
                    default:
                        break
                    }
                }
                
                self.filtersTable.reloadSections(IndexSet.init(integer: indexPath.section), with: .fade)
            }
        }
        
        return cell
    }
    
    fileprivate func tableViewSetup() {
        filtersTable.delegate = self
        filtersTable.dataSource = self
        filtersTable.rowHeight = UITableViewAutomaticDimension
        filtersTable.estimatedRowHeight = 32
    }
}
