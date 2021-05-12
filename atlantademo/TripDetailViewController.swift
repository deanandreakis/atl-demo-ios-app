//
//  TripDetailViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 9/2/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit
import Foundation

class TripDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TripCustomCellDelegate, AssistanceDelegate {
    
    

    @IBOutlet weak var tripInfoView: UIView!
    @IBOutlet weak var tripTableView: UITableView!
    @IBOutlet weak var tripHeaderNavigationItem: UINavigationItem!
    var prevIndexPath: IndexPath?
    var timer = Timer()  //the timer we will use to simulate the steps thru the trip
    var optionsTimer = Timer()
    var indexPath : IndexPath = []
    var iteration = 0
    var trip: Trip?
    var assistanceStatus: AssistanceTypeEnum = .None
    
    // MARK - Timer
    func runTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { (Timer) in
            if(self.iteration > 0)
            {
                self.tripTableView.deleteRows(at: [self.indexPath], with: .left)
            }
            self.tripTableView.selectRow(at: self.indexPath, animated: true, scrollPosition: UITableViewScrollPosition.top)
            self.tripTableView.delegate!.tableView!(self.tripTableView, didSelectRowAt: self.indexPath)
            
            var x = 1
            if (self.trip!.intermediateStop?.anyObject() as? IntermediateStop == nil)
            {
                x = 0
            }
            if(self.iteration <= x) {
                self.iteration = self.iteration + 1
                self.timer.invalidate()
                self.runTimer()
            }
            else {
                self.timer.invalidate()
                self.runOptionsTimer()
            }
        })
    }
    
    func runOptionsTimer() {
        optionsTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { (Timer) in
                self.moreButtonSelected()
                self.optionsTimer.invalidate()
        })
    }
    
    @IBAction func helpAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripInfoView.addSubview(Bundle.loadView(fromNib: "TripHeaderView", withType: TripHeaderView.self))
        tripTableView.register(UINib (nibName: "TripCustomCell", bundle: nil), forCellReuseIdentifier: "tripCell")
        tripTableView.register(UINib (nibName: "TripSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TripSectionHeaderView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setup the header view
        let header = (tripInfoView.subviews.first as! TripHeaderView)
        header.TripStart.text = (trip?.origin!)!
        header.TripEnd.text = (trip?.finalDestination!)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        header.TripDate.text = dateFormatter.string(from: (trip?.departureDate!)! as Date)
        header.TripConfNumber.text = "Delta Conf. # " + (trip?.confirmationNumber!)!
        
        //determine if the timer runs
        indexPath = IndexPath.init(row: 0, section: 0)
        iteration = 0
        if(tripTableView.numberOfRows(inSection: 0) == 3)
        {
            runTimer()
        }
        else if (trip!.intermediateStop?.anyObject() as? IntermediateStop == nil)
        {
            if(tripTableView.numberOfRows(inSection: 0) == 2)
            {
                runTimer()
            }
        }
        
        //check if assistance was requested
        if(assistanceStatus != .None) {
            let assistanceCell = (tripTableView.cellForRow(at: indexPath) as! TripCustomCell)
            updateAssistanceCell(assistanceCell, forRowAt: indexPath)
            showAssistanceAlerts()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.optionsTimer.invalidate()
        self.assistanceStatus = .None
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAssistanceAlerts()
    {
        let alertController = UIAlertController(title: "Request Update", message: "Your request for assistance has been received and assigned to an airport staff member. Estimated arrival time: 7 minutes", preferredStyle: .alert)
        let alertControllerFinal = UIAlertController(title: "Request Update", message: "Your assistance is arriving", preferredStyle: .alert)
        
        let okButton1 = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            self.navigationController!.present(alertControllerFinal, animated: true, completion: nil)
        })
        
        let okButton2 = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(okButton1)
        alertControllerFinal.addAction(okButton2)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func updateAssistanceCell(_ cell: TripCustomCell, forRowAt indexPath: IndexPath) {
        if assistanceStatus != .None { cell.AssistanceImageView.isHidden = false}
        if assistanceStatus == .Wheelchair { cell.AssistanceImageView.image = UIImage(named:"wheelchair")}
        else if assistanceStatus == .Firstaid { cell.AssistanceImageView.image = UIImage(named:"firstaid")}
        else if assistanceStatus == .Concierge { cell.AssistanceImageView.image = UIImage(named:"diamond")}
    }
    
    //MARK - AssistanceDelegate
    func assistanceRequest(request: AssistanceTypeEnum) {
        self.assistanceStatus = request
        //put the appropriate image on the table cell
        //enable the last two alerts to popup simulating the request updates
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AssistanceSegue" {
            let controller = segue.destination as! AssistanceViewController
            controller.delegate = self
            if let stop : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
            {
                controller.finalArrivalGate = stop.arrivalGate!
            }
            else
            {
                controller.finalArrivalGate = trip?.finalArrivalGate
            }
        }
    }
    
    // MARK: - TripCustomCellDelegate
    func moreButtonSelected() {
        let alertController = UIAlertController(title: "Options", message: "Please Choose An Option", preferredStyle: .actionSheet)
        
        let navigationButton = UIAlertAction(title: "Navigation", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "NavigationSegue", sender: self)
        })
        
        let assistanceButton = UIAlertAction(title: "Special Assistance", style: .default, handler: { (action) -> Void in
            self.performSegue(withIdentifier: "AssistanceSegue", sender: self)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        })
        
        
        alertController.addAction(navigationButton)
        alertController.addAction(assistanceButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let _ : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let _ : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
            {
                return 3 - iteration
            }
            else{
                return 2 - iteration
            }
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tripTableView.dequeueReusableHeaderFooterView(withIdentifier: "TripSectionHeaderView")
        let header = cell as! TripSectionHeaderView

        switch section {
        case 0:
            header.FlightNumber.text = "    " + (trip?.departureFlightAirlineName)! + " " + (trip?.departureFlightNumber)!
            header.SeatAssignment.text = "Seat " +  (trip?.departureFlightSeatAssignment)!
        case 1:
            let stop : IntermediateStop = trip!.intermediateStop?.anyObject() as! IntermediateStop
            header.FlightNumber.text = "    " + stop.departureFlightAirlineName! + " " + stop.departureFlightNumber!
            let mainText = "Choose Seat"
            let range = (mainText as NSString).range(of: mainText)
            let attributedString = NSMutableAttributedString(string:mainText)
            attributedString.setAttributes([NSAttributedStringKey.foregroundColor : UIColor(red:192/255.0, green:25/255.0,blue:51/255.0,alpha:1.0)], range: range)
            header.SeatAssignment.attributedText = attributedString
        default:
            header.FlightNumber.text = ""
            header.SeatAssignment.text = ""
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cell = tripTableView.dequeueReusableHeaderFooterView(withIdentifier: "TripSectionHeaderView")
        let header = cell as! TripSectionHeaderView
        return header.frame.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //these transitions in the final app will be driven by location but for
        //now allow the user to select the rows to see how the UI looks
        tripHeaderNavigationItem.title = "Trip In Progress"
        let cell = (tableView.cellForRow(at: indexPath) as! TripCustomCell)
        cell.VerticalMoreButton.isHidden = false
        cell.GrayGreenDotImageView.image = UIImage(named:"OvalGreen")
        
        if(cell.DepartArriveCityLabel.text?.contains("Depart"))! {
            cell.GateBoardDescriptioLabel.text = "1:55 PM - Gate " + (trip?.departureGate)! + "  ON TIME  Boarding"
        }
        if let stop : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
        {
            if(cell.DepartArriveCityLabel.text?.contains("Arrive"))! {
                cell.GateBoardDescriptioLabel.text = "2:25 PM - Gate " + stop.arrivalGate! + "    3 MIN EARLY"
            }
            else if(cell.DepartArriveCityLabel.text?.contains("Gate"))! {
                cell.GateBoardDescriptioLabel.text = "Gate " + stop.arrivalGate! +  " - Gate " + stop.departureGate! + "    17 mins"
            }
        }
        else
        {
            if(cell.DepartArriveCityLabel.text?.contains("Arrive"))! {
                cell.GateBoardDescriptioLabel.text = "2:25 PM - Gate " + (trip?.finalArrivalGate)! + "    3 MIN EARLY"
            }
            else if(cell.DepartArriveCityLabel.text?.contains("Gate"))! {
                cell.GateBoardDescriptioLabel.text = "Gate " + (trip?.finalArrivalGate)! +  " - Gate " + (trip?.departureGate)! + "    17 mins"
            }
        }
        
        //clear out the previous cell
        if(prevIndexPath != nil && prevIndexPath != indexPath) {
            let prevCell = (tableView.cellForRow(at: prevIndexPath!) as! TripCustomCell)
            prevCell.VerticalMoreButton.isHidden = true
            prevCell.GrayGreenDotImageView.image = UIImage(named:"OvalGray")
            if(prevCell.DepartArriveCityLabel.text?.contains("Depart"))! {
                prevCell.GateBoardDescriptioLabel.text = "1:55 PM"
            }
            else if(prevCell.DepartArriveCityLabel.text?.contains("Arrive"))! {
                prevCell.GateBoardDescriptioLabel.text = "2:25 PM - Gate ???"
            }
            else if(prevCell.DepartArriveCityLabel.text?.contains("Gate"))! {
                if let stop : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
                {
                    prevCell.GateBoardDescriptioLabel.text = "Gate " + stop.arrivalGate! + " - Gate ???"
                }
                else
                {
                    prevCell.GateBoardDescriptioLabel.text = "Gate " + (trip?.finalArrivalGate)! + " - Gate ???"
                }
            }
        }
        prevIndexPath = indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        configureCell(cell as! TripCustomCell, forRowAt: indexPath)
    }
    
    func configureCell(_ cell: TripCustomCell, forRowAt indexPath: IndexPath) {
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        cell.isUserInteractionEnabled = false
        cell.VerticalMoreButton.isHidden = true
        cell.AssistanceImageView.isHidden = true
        let header = (tripInfoView.subviews.first as! TripHeaderView)
        if let stop : IntermediateStop = trip!.intermediateStop?.anyObject() as? IntermediateStop
        {
            if(indexPath.section == 0) {
                switch indexPath.row {
                case 0:
                    cell.DepartArriveCityLabel.text = "Depart: " + header.TripStart.text!
                    cell.GateBoardDescriptioLabel.text = "1:55 PM"
                    if assistanceStatus != .None { cell.AssistanceImageView.isHidden = false}
                    if assistanceStatus == .Wheelchair { cell.AssistanceImageView.image = UIImage(named:"wheelchair")}
                    else if assistanceStatus == .Firstaid { cell.AssistanceImageView.image = UIImage(named:"firstaid")}
                    else if assistanceStatus == .Concierge { cell.AssistanceImageView.image = UIImage(named:"diamond")}
                    
                case 1:
                    cell.DepartArriveCityLabel.text = "Arrive: " + stop.arrivalName!
                    cell.GateBoardDescriptioLabel.text = "2:25 PM - Gate ???"
                case 2:
                    cell.DepartArriveCityLabel.text = "Gate Change"
                    cell.GateBoardDescriptioLabel.text = ""
                default:
                    cell.DepartArriveCityLabel.text = ""
                    cell.GateBoardDescriptioLabel.text = ""
                }
            }
            else if(indexPath.section == 1) {
                switch indexPath.row {
                case 0:
                    cell.DepartArriveCityLabel.text = "Depart: " + stop.arrivalName!
                    cell.GateBoardDescriptioLabel.text = "3:20 PM"
                case 1:
                    cell.DepartArriveCityLabel.text = "Arrive: " + header.TripEnd.text!
                    cell.GateBoardDescriptioLabel.text = "6:15 PM"
                default:
                    cell.DepartArriveCityLabel.text = ""
                    cell.GateBoardDescriptioLabel.text = ""
                }
            }
        }
        else{
            if(indexPath.section == 0) {
                switch indexPath.row {
                case 0:
                    cell.DepartArriveCityLabel.text = "Depart: " + header.TripStart.text!
                    cell.GateBoardDescriptioLabel.text = "1:55 PM"
                    if assistanceStatus != .None { cell.AssistanceImageView.isHidden = false}
                    if assistanceStatus == .Wheelchair { cell.AssistanceImageView.image = UIImage(named:"wheelchair")}
                    else if assistanceStatus == .Firstaid { cell.AssistanceImageView.image = UIImage(named:"firstaid")}
                    else if assistanceStatus == .Concierge { cell.AssistanceImageView.image = UIImage(named:"diamond")}
                case 1:
                    cell.DepartArriveCityLabel.text = "Arrive: " + header.TripEnd.text!
                    cell.GateBoardDescriptioLabel.text = "2:25 PM - Gate ???"
                case 2:
                    cell.DepartArriveCityLabel.text = "Gate Change"
                    cell.GateBoardDescriptioLabel.text = ""
                default:
                    cell.DepartArriveCityLabel.text = ""
                    cell.GateBoardDescriptioLabel.text = ""
                }
            }
        }
    }
}

extension Bundle {
    
    static func loadView<T>(fromNib name: String, withType type: T.Type) -> T {
        if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T {
            return view
        }
        
        fatalError("Could not load view with type " + String(describing: type))
    }
}
