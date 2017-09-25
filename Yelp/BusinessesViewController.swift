//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD

// MARK:- BusinessViewController
class BusinessesViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var businessesTable: UITableView!
    @IBOutlet weak var mapView: MKMapView!

    fileprivate var showMap = false
    fileprivate var searchBar: UISearchBar!
    fileprivate var loadMoreView: InfiniteScrollActivityView!
    fileprivate var isMoreDataLoading = false
    fileprivate var locationManager = CLLocationManager()
    
    var businesses: [Business]!
    var filters = YelpFilters()
    
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
        
        // Initialize views
        setupSearchBar()
        setupTable()
        setupMap()
        
        // Infinite scroll view setup
        loadMoreView = InfiniteScrollActivityView(frame: getInfiniteScrollFrame())
        businessesTable.contentInset.bottom += InfiniteScrollActivityView.defaultHeight
        
        newSearch()
    }
    
    @IBAction func switchView(_ sender: UIBarButtonItem) {
        let fromView: UIView = mapView.isHidden ? businessesTable : mapView
        let toView: UIView = mapView.isHidden ? mapView : businessesTable
        UIView.transition(
            from: fromView,
            to: toView, duration: 1.0,
            options: [.transitionFlipFromRight, .showHideTransitionViews],
            completion: nil
        )
        sender.title = mapView.isHidden ? "Map" : "List"
        
        if businessesTable.isHidden {
            showBusinessesOnMap()
        }
    }
    
    func showBusinessesOnMap() {
        var index = 1
        for business in businesses {
            addBusinessToMap(business, at: index)
            index += 1
        }
    }
    
    func addBusinessToMap(_ business: Business, at index: Int) {
        if let lat = business.coordinates["latitude"], let lon = business.coordinates["longitude"] {
            let annotation = MKPointAnnotation()
            annotation.title = "\(index). \(business.name ?? "")"
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "filtersSegue":
            let navigationController = segue.destination as! UINavigationController
            let filtersViewController = navigationController.topViewController as! FiltersViewController
            filtersViewController.filtersVCDelegate = self
            filtersViewController.filters = YelpFilters(filters)
        default:
            break
        }
    }
    
    fileprivate func newSearch() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        YelpFusionClient.shared.search(filters: filters, offset: nil) { (businesses, error) in
            self.businesses = businesses ?? [Business]()
            self.businessesTable.reloadData()
            self.businessesTable.contentOffset = CGPoint(x: 0, y: -self.businessesTable.contentInset.top)
            if let error = error {
                print(error.localizedDescription)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    fileprivate func searchExisting() {
        YelpFusionClient.shared.search(filters: filters, offset: businesses.count) { (businesses, error) in
            self.loadMoreView.stopAnimating()
            if let businesses = businesses {
                self.businesses.append(contentsOf: businesses)
                self.businessesTable.reloadData()
            } else if let error = error {
                print(error.localizedDescription)
            }
            self.isMoreDataLoading = false
        }
    }
    
    fileprivate func setupMap() {
        mapView.isHidden = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.desiredAccuracy = 200
        locationManager.requestWhenInUseAuthorization()
    }
    
    fileprivate func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
    }
}

// MARK:- Location manager and map view delegate
extension BusinessesViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation?.title!?.lowercased() != "current location" {
            performSegue(withIdentifier: "mapToDetailsSegue", sender: view.annotation)
        }
    }
}

// MARK:- Table view delegate/data source extension
extension BusinessesViewController: UITableViewDataSource, UITableViewDelegate {
    fileprivate func setupTable() {
        // Initialize table view
        businessesTable.delegate = self
        businessesTable.dataSource = self
        businessesTable.rowHeight = UITableViewAutomaticDimension
        businessesTable.estimatedRowHeight = 100
    }
    
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
    fileprivate func setupSearchBar() {
        // Initialize search bar
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }
    
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
        let searchText = searchBar.text?.trimmingCharacters(in: CharacterSet.whitespaces) ?? ""
        
        if filters.searchString != searchText {
            filters.searchString = searchText
            newSearch()
        }
    }
}

// MARK:- ScrollView delegate
extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isMoreDataLoading {
            let scrollViewContentHeight = businessesTable.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - businessesTable.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && businessesTable.isDragging {
                isMoreDataLoading = true
                loadMoreView.frame = getInfiniteScrollFrame()
                loadMoreView.startAnimating()
                searchExisting()
            }
        }
    }
    
    func updateInfiniteScrollView() {
        loadMoreView.frame = getInfiniteScrollFrame()
        loadMoreView.stopAnimating()
    }
}

// MARK:- FiltersViewControllerDelegate extension
extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(_ filtersViewController: FiltersViewController, didUpdateFilters filters: YelpFilters) {
        self.filters = filters
        newSearch()
    }
}
