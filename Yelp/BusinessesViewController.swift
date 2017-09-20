//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

// MARK:- BusinessViewController
class BusinessesViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var businessesTable: UITableView!
    
    var businesses: [Business]!
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessesTable.delegate = self
        businessesTable.dataSource = self
        businessesTable.rowHeight = UITableViewAutomaticDimension
        businessesTable.estimatedRowHeight = 100
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.businessesTable.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.filtersVCDelegate = self
    }
    
}

// MARK:- Table view delegate/data source extension
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = businessesTable.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        return cell
    }
}

// MARK:- FiltersViewControllerDelegate extension
extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        
        let categories = filters["categories"] as? [String]
        Business.searchWithTerm(
        term: "Restaurants",
        sort: nil,
        categories: categories,
        deals: nil) { (businesses, error) in
            self.businesses = businesses
            self.businessesTable.reloadData()
        }
    }
}
