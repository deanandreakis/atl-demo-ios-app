//
//  FeedViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 8/31/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit

class FeedViewController: UITableViewController, TripCustomCellDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib (nibName: "TripCustomCell", bundle: nil), forCellReuseIdentifier: "tripCell")
        tableView.register(UINib (nibName: "ScheduleSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "ScheduleSectionHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(HomeViewController.isAirportEmployee())
        {
            self.navigationItem.title = "Requests"
            self.navigationController?.isNavigationBarHidden = false
        }
        else{
            self.navigationItem.title = ""
            self.navigationController?.isNavigationBarHidden = true
        }
        
            self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: - TripCustomCellDelegate
    
    func moreButtonSelected() {
        let alertController = UIAlertController(title: "Options", message: "Please Choose An Option", preferredStyle: .actionSheet)
        
        let navigationButton = UIAlertAction(title: "Accept Request", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "NavigationSegue2", sender: self)
        })
        
        let messageButton = UIAlertAction(title: "Send Message to Requestor", style: .default, handler: { (action) -> Void in
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        
        })
        
        
        alertController.addAction(navigationButton)
        alertController.addAction(messageButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if(HomeViewController.isAirportEmployee())
        {
            return 2
        }
        else
        {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "ScheduleSectionHeaderView")
        let header = cell as! ScheduleSectionHeaderView
        
        switch section {
        case 0:
            header.sectionLabel.text = "Open Requests"
        case 1:
            header.sectionLabel.text = "Completed Requests"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureCell(cell as! TripCustomCell, forRowAt: indexPath)
    }
    
    func configureCell(_ cell: TripCustomCell, forRowAt indexPath: IndexPath) {
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.isUserInteractionEnabled = true
        cell.VerticalMoreButton.isHidden = false
        cell.AssistanceImageView.isHidden = false
        cell.DepartArriveCityLabel.text = "Wheelchair Assistance - T5"
        cell.GateBoardDescriptioLabel.text = "Tuesday, April 25, - 2:25 PM"
        cell.AssistanceImageView.image = UIImage(named:"wheelchair")
        cell.GrayGreenDotImageView.isHidden = true
        
        if(indexPath.section == 1) {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
    }
    
    
}
