//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Wuming Xie on 9/19/17.
//  Copyright © 2017 Wuming Xie. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String: Any])
}

// MARK:- FiltersViewController
class FiltersViewController: UIViewController {

    @IBOutlet weak var filtersTable: UITableView!
    
    // MARK: Delegates
    weak var filtersVCDelegate: FiltersViewControllerDelegate?
    
    var categories: [[String: String]]!
    var switchStates: [Int: Bool] = [:]
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        filtersTable.delegate = self
        filtersTable.dataSource = self
        
        categories = Constants.yelpCategories
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
        let filters = [String: Int]()
        let selected = [String]()
        for (row, isOn) in switchStates {
            if isOn {
                selected.append(categories[row]["code"])
            }
        }
        filtersVCDelegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- Table view delegate/datasource extension
extension FiltersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filtersTable.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as? SwitchCell else {
            return SwitchCell()
        }
        
        cell.category = categories[indexPath.row]
        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
        cell.delegate = self
        
        return cell
    }
}

// MARK:- SwitchCell delegate extension
extension FiltersViewController: SwitchCellDelegate {
    func switchCell(_ switchCell: SwitchCell, didChangeValue value: Bool) {
        if let indexPath = filtersTable.indexPath(for: switchCell) {
            print(indexPath.row)
            switchStates[indexPath.row] = value
        }
    }
}
