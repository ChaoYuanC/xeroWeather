//
//  CityViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import ObjectiveC
import CoreData
import Foundation
import Dispatch

protocol CityViewControllerDelegate: class {
    func selectedCity(_ city: City)
}


class CityViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    weak var delegate: CityViewControllerDelegate?
    
    fileprivate let citySearchCellIdentifier = "CitySearchTableViewCell"
    fileprivate var isSearchMode = false
    
    fileprivate lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CityEntity)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "country", ascending: true), NSSortDescriptor(key: "city", ascending: true)]
        
        let appdelegate = AppDelegate().sharedInstance()
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: appdelegate.contextManager.objectContextInstance,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
    
        controller.delegate = self
        
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: self.citySearchCellIdentifier, bundle: nil), forCellReuseIdentifier: self.citySearchCellIdentifier)
        
        if !isSearchMode {
            self.fetchFavCities()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func cityWithIndexPath(_ indexPath: IndexPath) -> City? {
        guard let cities = self.frc.sections?[indexPath.section].objects as? [City] else {
            return nil
        }
        return cities[indexPath.row]
    }
    
    fileprivate func fetchFavCities() {
        let predicate = NSPredicate(format: "(isFav == %@)", NSNumber(value: true))
        self.frc.fetchRequest.predicate = predicate
        do {
            try self.frc.performFetch()
            self.tableView.reloadData()
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
        }
    }

}

extension CityViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
        tableView.endUpdates()
    }
}

extension CityViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.frc.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = self.frc.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.citySearchCellIdentifier
            ) as? CitySearchTableViewCell else {
            return UITableViewCell()
        }
        guard let city = self.cityWithIndexPath(indexPath) else {
            return UITableViewCell()
        }
        cell.setup(city)
        return cell 
    }
}

extension CityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let city = self.cityWithIndexPath(indexPath) else {
            return
        }
        if self.isSearchMode {
            CityManager.sharedInstance.setFavCity(city.id, true, { (success) in
                self.searchBar.resignFirstResponder()
                self.searchBar.text = nil
                self.fetchFavCities()
            })
        } else {
            self.delegate?.selectedCity(city)
            self.dismiss(animated: true, completion: nil)
        }
    }
}


private var searchTimerAssociationKey: UInt8 = 0
extension CityViewController: UISearchBarDelegate {
    var searchTimer: Timer? {
        get {
            return objc_getAssociatedObject(self, &searchTimerAssociationKey) as? Timer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &searchTimerAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearchMode = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if self.tableView.visibleCells.count == 0 {
            self.fetchFavCities()
            self.isSearchMode = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
        
        self.searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            self.searchCity()
        })
    }
    
    @objc func searchCity() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
        
        if let searchText = self.searchBar.text {
            let predicate = NSPredicate(format: "(city contains[cd] %@)", searchText)
            self.frc.fetchRequest.predicate = predicate
            do {
                try self.frc.performFetch()
                self.tableView.reloadData()
            } catch let error as NSError {
                print("Error: \(error.localizedDescription)")
            }

        } else {
            // show saved cities
        }

    }
}

