//
//  ScheduleViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 8/31/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit
import CoreData

class ScheduleViewController: UITableViewController {
    
    var tripDetailViewController: TripDetailViewController? = nil
    var managedContext: NSManagedObjectContext
    
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = (appDelegate?.persistentContainer.viewContext)!
        super.init(coder: aDecoder)
    }
    
    
    lazy var fetchedResultsController:
        NSFetchedResultsController<Trip> = {
            let fetchRequest: NSFetchRequest<Trip> = Trip.fetchRequest()
            let sort = NSSortDescriptor(key: #keyPath(Trip.completedTrip),
                                        ascending: true)
            fetchRequest.sortDescriptors = [sort]
            let fetchedResultsController = NSFetchedResultsController(
                fetchRequest: fetchRequest,
                managedObjectContext: managedContext,
                sectionNameKeyPath: #keyPath(Trip.completedTrip),
                cacheName: nil)
            return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib (nibName: "ScheduleCustomCell", bundle: nil), forCellReuseIdentifier: "schedCell")
        tableView.register(UINib (nibName: "ScheduleSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ScheduleSectionHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if tableView.indexPathForSelectedRow != nil {
                let controller = segue.destination as! TripDetailViewController
                let trip = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!)
                controller.trip = trip
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0 }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo =
            fetchedResultsController.sections?[section] else {
                return 0 }
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScheduleSectionHeaderView")
        let header = cell as! ScheduleSectionHeaderView
        
        switch section {
        case 0:
            header.sectionLabel.text = "Scheduled Trips"
        case 1:
            header.sectionLabel.text = "Completed Trips"
        default:
            header.sectionLabel.text = ""
        }
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScheduleSectionHeaderView")
        let header = cell as! ScheduleSectionHeaderView
        return header.frame.height
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedCell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            self.performSegue(withIdentifier: "showDetail", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureCell(cell as! ScheduleCustomCell, forRowAt: indexPath)
    }
    
    func configureCell(_ cell: ScheduleCustomCell, forRowAt indexPath: IndexPath) {
        
        let trip = fetchedResultsController.object(at: indexPath)
        
        cell.tripStart.text = trip.origin
        cell.tripEnd.text = trip.finalDestination
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        cell.tripDate.text = dateFormatter.string(from: trip.departureDate! as Date)
        cell.tripConfNumber.text = "Delta Conf. # " + trip.confirmationNumber!
        
        if(indexPath.section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
}
