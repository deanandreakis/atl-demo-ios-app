//
//  ViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 8/28/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, LoginScreenViewDelegate {
    
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var memberStatusLabel: UILabel!
    @IBOutlet weak var milesAndMemberNumberLabel: UILabel!
    var loginView: LoginScreenView?
    let loginTag: Int = 100
    static private var _isAirportEmployee = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoginView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func isAirportEmployee()->Bool {
        return _isAirportEmployee
    }
    
    func setupLoginView()
    {
        loginView = Bundle.loadView(fromNib: "LoginScreenView", withType: LoginScreenView.self)
        loginView?.tag = loginTag
        loginView?.userNameTextField?.loadDropdownData(data: ["John Smith", "Jenny Jones", "Ernst J. Friedlander", "Jane Doe"])
        loginView?.delegate = self
        loginView?.frame = CGRect(0,
                                  0,
                                  (self.tabBarController?.view.frame.size.width)!,
                                  (self.tabBarController?.view.frame.size.height)!)
        self.tabBarController?.view.addSubview(loginView!)
    }
    
    @IBAction func logoutButtonSelected(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        appDelegate.resetAllRecords(in: "Traveler")
        appDelegate.resetAllRecords(in: "AirportEmployee")
        HomeViewController._isAirportEmployee = false
        setupLoginView()
    }
    
    func getTravelerInfo()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Traveler>(entityName: "Traveler")
        do {
            let results =  try managedContext.fetch(request)
            let currentTraveler =  results.first
            
            let attributedString = NSMutableAttributedString(string:(currentTraveler?.name!)!)
            nameLabel.attributedText = attributedString
            
            let attributedRewardString = NSMutableAttributedString(string:(currentTraveler?.rewardStatus!)!)
            memberStatusLabel.attributedText = attributedRewardString
            
            let attributedRewardCardString = NSMutableAttributedString(string:((currentTraveler?.rewardCardID!)! + " " + (currentTraveler?.numberOfMiles.withCommas())! + " miles"))
            milesAndMemberNumberLabel.attributedText = attributedRewardCardString
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    func getAirportEmployeeInfo()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<AirportEmployee>(entityName: "AirportEmployee")
        do {
            let results =  try managedContext.fetch(request)
            let currentEmployee =  results.first
            
            let attributedString = NSMutableAttributedString(string:(currentEmployee?.name!)!)
            nameLabel.attributedText = attributedString
            
            let attributedRewardString = NSMutableAttributedString(string:"")
            memberStatusLabel.attributedText = attributedRewardString
            
            let attributedRewardCardString = NSMutableAttributedString(string:"")
            milesAndMemberNumberLabel.attributedText = attributedRewardCardString
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK - LoginScreenViewDelegate
    func loginButtonSelected(username: String?) {
        if username != nil {
            if(username == "John Smith") {
                Traveler.loadTravelerData(filename: "johnsmith")
                getTravelerInfo()
            }
            else if(username == "Jenny Jones") {
                Traveler.loadTravelerData(filename: "jenny")
                getTravelerInfo()
            }
            else if(username == "Ernst J. Friedlander") {
                AirportEmployee.loadAirportEmployeeData(filename: "ernst")
                getAirportEmployeeInfo()
                HomeViewController._isAirportEmployee = true
                let alertTitle = "Wheelchair Request"
                let alertControllerOptions = UIAlertController(title: alertTitle, message: "Passenger has requested wheelchair assistance at gate T5", preferredStyle: .actionSheet)
                alertControllerOptions.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
                self.tabBarController!.present(alertControllerOptions, animated: true, completion: nil)
            }
            else if(username == "Jane Doe") {
                Traveler.loadTravelerData(filename: "jane")
                getTravelerInfo()
            }
            if let viewWithTag = self.tabBarController?.view.viewWithTag(loginTag) {
                viewWithTag.removeFromSuperview()
            }
        }
    }


}

extension Int32 {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
