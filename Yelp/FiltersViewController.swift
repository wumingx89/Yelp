//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(
        _ filtersViewController: FiltersViewController,
        didUpdateFilters filters: [String: Any]
    )
}

//struct SectionStruct {
//    let title: String
//    let expanded: Bool
//    let cells: [Cell]
//    var selected: Int
//}
//
//struct Cell {
//    let setting: String
//    let cellType: CellType
//}

// MARK:- FiltersViewController
class FiltersViewController: UIViewController {

    @IBOutlet weak var filtersTable: UITableView!
    
    //let popularSection = SectionStruct(title: "Popular", expanded: true, cells: [], selected: 0)
    
    // MARK: Delegates
    weak var filtersVCDelegate: FiltersViewControllerDelegate?
    
    var filters: YelpFilters!
    
    var categories: [[String: String]]!
    var switchStates: [Int: Bool] = [:]
    
    fileprivate var expandedSections = Set<Section>()
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filters = YelpFilters()
        categories = Constants.yelpCategories
        
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
        var filters = [String: AnyObject]()
        var selected = [String]()
        for (row, isOn) in switchStates {
            if isOn {
                selected.append(categories[row]["code"]!)
            }
        }
        
        if selected.count > 0 {
            filters["categories"] = selected as AnyObject
        }
        filtersVCDelegate?.filtersViewController?(self, didUpdateFilters: filters)
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- Table view delegate/datasource extension
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch Section.sectionFromIndex(section) {
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
        return Section.sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionType = Section.sectionFromIndex(section)
        switch sectionType {
        case .popular:
            return 1
        case .sort, .distance:
            return expandedSections.contains(sectionType) ? 3 : 1
        case .categories:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let normalCell = UITableViewCell()
        
        let sectionType = Section.sectionFromIndex(indexPath.section)
        let cell = filtersTable.dequeueReusableCell(
            withIdentifier: Section.getCellIdentifier(for: sectionType),
            for: indexPath
        )
        
        switch sectionType {
        case .popular:
            guard let popularCell = cell as? SwitchCell else {
                return normalCell
            }
            popularCell.switchLabel.text = "Offering a deal"
            popularCell.onSwitch.isOn = false
            popularCell.toggleSwitchHandler = { (isOn: Bool) in
                print(isOn)
            }
        case .categories:
            guard let categoryCell = cell as? SwitchCell else {
                return normalCell
            }
            categoryCell.switchLabel.text = "Afghan"
            categoryCell.onSwitch.isOn = false
            categoryCell.toggleSwitchHandler = { (isOn: Bool) in
                print(isOn)
            }
        case .sort, .distance:
            guard let cell = cell as? CheckCell else {
                return normalCell
            }
            cell.settingLabel.text = "Best Match"
            cell.selectActionHandler = {
                if self.expandedSections.contains(sectionType) {
                    self.expandedSections.remove(sectionType)
                } else {
                    self.expandedSections.insert(sectionType)
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

extension FiltersViewController {
    fileprivate enum Section: String {
        case popular = "Most Popular"
        case distance = "Distance"
        case sort = "Sort by"
        case categories = "Categories"
        
        static let sections = [popular, distance, sort, categories]
        
        static func sectionFromIndex(_ section: Int) -> Section {
            return sections[section]
        }
        
        static func getCellIdentifier(for section: Section) -> String {
            switch section {
            case .popular, .categories:
                return "SwitchCell"
            default:
                return "CheckCell"
            }
        }
    }
}
