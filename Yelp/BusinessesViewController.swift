//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MBProgressHUD

// MARK:- BusinessViewController
class BusinessesViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var businessesTable: UITableView!
    
    fileprivate var searchBar: UISearchBar!
    fileprivate var loadMoreView: InfiniteScrollActivityView!
    fileprivate var isMoreDataLoading = false
    
    var businesses: [Business]!
    
    fileprivate func getInfiniteScrollFrame() -> CGRect {
        return CGRect(
            x: 0,
            y: businessesTable.contentSize.height,
            width: businessesTable.bounds.size.width,
            height: InfiniteScrollActivityView.defaultHeight
        )
    }
    
    // MARK: Life cycle functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Initialize table view
        businessesTable.delegate = self
        businessesTable.dataSource = self
        businessesTable.rowHeight = UITableViewAutomaticDimension
        businessesTable.estimatedRowHeight = 100
        
        // Infinite scroll view setup
        loadMoreView = InfiniteScrollActivityView(frame: getInfiniteScrollFrame())
        businessesTable.contentInset.bottom += InfiniteScrollActivityView.defaultHeight
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.businessesTable.reloadData()
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            MBProgressHUD.hide(for: self.view, animated: true)
            
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
        if let navigationController = segue.destination as? UINavigationController {
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.filtersVCDelegate = self
        }
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
        
        cell.setCell(business: businesses[indexPath.row], number: indexPath.row)
        return cell
    }
}

// MARK:- Search bar methods
extension BusinessesViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

// MARK:- ScrollView delegate
extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = businessesTable.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessesTable.bounds.size.height
            
            print("offset: \(scrollView.contentOffset.y) vs threshold: \(scrollOffsetThreshold)")
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && businessesTable.isDragging {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                self.loadMoreView.frame = CGRect(
                    x: 0,
                    y: scrollOffsetThreshold,
                    width: scrollView.bounds.width,
                    height: InfiniteScrollActivityView.defaultHeight
                )
                self.loadMoreView.startAnimating()
            }
        }
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
