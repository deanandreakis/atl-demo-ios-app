//
//  AssistanceViewController.swift
//  atlantademo
//
//  Created by Dean Andreakis on 11/12/17.
//  Copyright © 2017 gisi. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AssistanceViewController: UIViewController
{
    @IBOutlet weak var gateLabel: UILabel!
    @IBOutlet weak var diamondButton: UIButton!
    @IBOutlet weak var diamondImageView: UIImageView!
    var finalArrivalGate:String?
    weak var delegate: AssistanceDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        if finalArrivalGate != nil {
            gateLabel.text = "Arrive: Gate " + finalArrivalGate!
        }
        else{
            gateLabel.text = "Arrived"
        }
        if(!isTravelerMedallionMember())
        {
            diamondButton.isEnabled = false
            diamondButton.isHidden = true
            diamondImageView.isHidden = true
        }
    }
    
    @IBAction func wheelchairButtonSelected(_ sender: Any) {
        let alertController = UIAlertController(title: "Submit Request", message: "Would you like to request a wheelchair at your current location?", preferredStyle: .alert)
        let alertControllerFinal = UIAlertController(title: "Request Submitted", message: "You will receive notifications when your request is received and during transit.", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.delegate?.assistanceRequest(request:.Wheelchair)
            self.navigationController!.present(alertControllerFinal, animated: true, completion: nil)
        })
        
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            
        })
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertControllerFinal.addAction(okButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func firstaidButtonSelected(_ sender: Any) {
        let alertController = UIAlertController(title: "Submit Request", message: "Would you like to request medical assistance at your current location?", preferredStyle: .alert)
        let alertControllerFinal = UIAlertController(title: "Request Submitted", message: "You will receive notifications when your request is received and during transit.", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.delegate?.assistanceRequest(request:.Firstaid)
            self.navigationController!.present(alertControllerFinal, animated: true, completion: nil)
        })
        
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            
        })
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertControllerFinal.addAction(okButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func diamondButtonSelected(_ sender: Any) {
        let alertController = UIAlertController(title: "Submit Request", message: "Would you like to request a Medallion Concierge at your current location?", preferredStyle: .alert)
        let alertControllerFinal = UIAlertController(title: "Request Submitted", message: "You will receive notifications when your request is received and during transit.", preferredStyle: .alert)
        
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            self.delegate?.assistanceRequest(request:.Concierge)
            self.navigationController!.present(alertControllerFinal, animated: true, completion: nil)
        })
        
        let noButton = UIAlertAction(title: "No", style: .cancel, handler: { (action) -> Void in
            
        })
        
        let okButton = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            
        })
        
        alertController.addAction(yesButton)
        alertController.addAction(noButton)
        alertControllerFinal.addAction(okButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
    func isTravelerMedallionMember()->Bool
    {
        var retVal : Bool = false
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<Traveler>(entityName: "Traveler")
        do {
            let results =  try managedContext.fetch(request)
            let currentTraveler =  results.first
            if(currentTraveler?.rewardStatus?.contains("Medallion"))! {
                retVal = true
            } else {
                retVal = false
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return retVal
    }
}

protocol AssistanceDelegate : class
{
    func assistanceRequest(request:AssistanceTypeEnum)
}
